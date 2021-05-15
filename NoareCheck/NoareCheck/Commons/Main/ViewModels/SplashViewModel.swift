//
//  SplashViewModel.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import Combine
import Foundation

final class SplashViewModel: ObservableObject {
    fileprivate var cancallables = Set<AnyCancellable>()
    @Published
    var isSplashing = true

    init() {
        AppAssets.shared.brandList
            .map(\.isEmpty)
            .assign(to: \.isSplashing, on: self)
            .store(in: &cancallables)

        refresh()
    }

    func refresh() {
        AppAssets.shared.refresh()
    }
}
