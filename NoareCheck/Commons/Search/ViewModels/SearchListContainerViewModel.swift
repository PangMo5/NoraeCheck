//
//  SearchListContainerViewModel.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import Combine
import CombineExt
import CombineMoya
import Foundation
import Moya

final class SearchListContainerViewModel: ObservableObject {
    fileprivate var provider = MoyaProvider<KaraokeAPI>()

    @Published
    var songList = [Song]()

    var shouldLoadNextPage = CurrentValueSubject<Bool, Never>(false)
    var page = 1
    @Published
    var loadNextPage = false
    @Published
    var isLoading = false
    @Published
    var isFooterLoading = false
    @Published
    var isEmptyResult = false

    @Published
    var noText = ""
    @Published
    var titleText = ""
    @Published
    var singerText = ""
    @Published
    var selectedBrand = 0

    var cancellables = Set<AnyCancellable>()

    init() {
        refresh()

        Publishers.CombineLatest4($noText, $titleText, $singerText,
                                  $selectedBrand.compactMap { AppAssets.shared.brandList.value[safe: $0] })
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink(receiveValue: requestSearch)
            .store(in: &cancellables)

        $loadNextPage
            .withLatestFrom(Publishers
                .CombineLatest4($noText, $titleText, $singerText, $selectedBrand.compactMap { AppAssets.shared.brandList.value[safe: $0] }),
                $isFooterLoading)
            .sink(receiveValue: { args, isFooterLoading in
                let (no, title, singer, brand) = args
                self.loadNextPage(no: no, title: title, singer: singer, brand: brand, isFooterLoading: isFooterLoading)
            })
            .store(in: &cancellables)

        $songList
            .dropFirst()
            .subscribe(on: DispatchQueue.global())
            .map(\.isEmpty)
            .receive(on: DispatchQueue.main)
            .assign(to: \.isEmptyResult, on: self)
            .store(in: &cancellables)
    }

    func refresh() {}

    func requestSearch(no: String, title: String, singer: String, brand: Brand) {
        guard no.isNotEmpty || title.isNotEmpty || singer.isNotEmpty else {
            songList = []
            return
        }
        isLoading = true
        page = 1
        provider.requestPublisher(.search(no: no.int, title: title, singer: singer, brand: brand, page: page))
            .mapForNC([Song].self, shouldLoadNextPage: shouldLoadNextPage)
            .replaceError(with: [])
            .sink(receiveCompletion: { _ in
                self.isLoading = false
            }, receiveValue: { data in
                self.songList = data
            })
            .store(in: &cancellables)
    }

    func loadNextPage(no: String, title: String, singer: String, brand: Brand, isFooterLoading: Bool) {
        guard !isFooterLoading,
              shouldLoadNextPage.value else { return }
        self.isFooterLoading = true
        page += 1

        provider.requestPublisher(.search(no: no.int, title: title, singer: singer, brand: brand, page: page))
            .mapForNC([Song].self, shouldLoadNextPage: shouldLoadNextPage)
            .replaceError(with: [])
            .sink(receiveCompletion: { _ in
                self.isFooterLoading = false
            }, receiveValue: { itemList in
                self.songList += itemList
            })
            .store(in: &cancellables)
    }
}
