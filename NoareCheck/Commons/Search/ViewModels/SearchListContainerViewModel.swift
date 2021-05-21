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

    @Published
    var searchText = ""

    @Published
    var selectedBrand = AppAssets.shared.brandList.value.first

    var cancellables = Set<AnyCancellable>()

    init() {
        refresh()

        Publishers.CombineLatest($searchText.dropFirst(), $selectedBrand.compactMap { $0 })
            .debounce(for: 0.25, scheduler: DispatchQueue.main)
            .sink(receiveValue: requestSongList(title:brand:))
            .store(in: &cancellables)
    }

    func refresh() {}

    func requestSongList(title: String, brand: Brand) {
        provider.requestPublisher(.songListForTitle(title: title, brand: brand))
            .map([Song].self)
            .print()
            .replaceError(with: [])
            .assign(to: \.songList, on: self)
            .store(in: &cancellables)
    }
}
