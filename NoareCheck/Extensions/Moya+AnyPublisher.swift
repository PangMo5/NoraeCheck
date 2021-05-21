//
//  Moya+AnyPublisher.swift
//  GangnamSister
//
//  Created by PangMo5 on 2021/01/06.
//  Copyright © 2021 healingpaper. All rights reserved.
//

import Combine
import CombineExt
import Foundation
import Moya

enum NetworkResponseError: CustomNSError {
    case serverError(reason: String)
    case emptyData

    var errorCode: Int {
        switch self {
        case .serverError:
            return 0
        case .emptyData:
            return -1
        }
    }

    var errorUserInfo: [String: Any] {
        switch self {
        case let .serverError(reason):
            return [NSLocalizedDescriptionKey: reason]
        case .emptyData:
            return [NSLocalizedDescriptionKey: "알 수 없는 오류가 발생했습니다."]
        }
    }
}

extension AnyPublisher where Failure == MoyaError {
    // Workaround for a lot of things, actually. We don't have Publishers.Once, flatMap
    // that can throw and a lot more. So this monster was created because of that. Sorry.
    private func unwrapThrowable<T>(throwable: @escaping (Output) throws -> T) -> AnyPublisher<T, MoyaError> {
        tryMap { element in
            try throwable(element)
        }
        .mapError { error -> MoyaError in
            if let moyaError = error as? MoyaError {
                return moyaError
            } else {
                return .underlying(error, nil)
            }
        }
        .eraseToAnyPublisher()
    }
}

extension AnyPublisher where Output == Response, Failure == MoyaError {
    func mapForNC<C: Codable>(_ type: C.Type,
                              atKeyPath keyPath: String? = nil,
                              using decoder: JSONDecoder = JSONDecoder(),
                              failsOnEmptyData: Bool = true,
                              errorMesaageShowing: Bool = true,
                              shouldLoadNextPage: CurrentValueSubject<Bool, Never>? = nil) -> AnyPublisher<C, MoyaError>
    {
        unwrapThrowable { response in
            let cdData = try response.map(Common<C>.self, atKeyPath: keyPath, using: decoder,
                                          failsOnEmptyData: failsOnEmptyData)

            shouldLoadNextPage?.send((cdData.total?.page ?? 0) > (cdData.page ?? 0))
            guard let data = cdData.data else {
                Toast.showToast(message: "알 수 없는 오류가 발생했습니다.", toastType: .error, displayDuration: 5)
                throw NetworkResponseError.emptyData
            }
            return data
        }
    }
}
