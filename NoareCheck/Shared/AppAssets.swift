//
//  AppAssets.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import Combine
import CombineMoya
import Foundation
import Moya

final class AppAssets {
    static let shared = AppAssets()

    fileprivate var cancellables = Set<AnyCancellable>()
    fileprivate var provider = MoyaProvider<KaraokeAPI>()

    var brandList = CurrentValueSubject<[Brand], Never>([])

    func refresh() {
        provider.requestPublisher(.brand)
            .mapForNC([Brand].self)
            .catch { error -> AnyPublisher<[Brand], Never> in
                Toast.showToast(message: error.localizedDescription)
                return Just([])
                    .eraseToAnyPublisher()
            }
            .sink(receiveValue: { [weak self] response in
                self?.brandList.send(response)
            })
            .store(in: &cancellables)
    }
}
