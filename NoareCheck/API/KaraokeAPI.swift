//
//  KaraokeAPI.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import Foundation
import Moya

enum KaraokeAPI {
    case brand
    case songListForTitle(title: String, brand: Brand)
}

extension KaraokeAPI: TargetType {
    var baseURL: URL {
        ServerEnvironment.shared.baseURL
    }

    var path: String {
        switch self {
        case .brand:
            return "/brand.json"
        case let .songListForTitle(title, _):
            return "/song/\(title).json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .brand, .songListForTitle:
            return .get
        }
    }

    var sampleData: Data {
        "{".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case let .songListForTitle(_, brand):
            var parameters = [String: Any]()
            parameters["brand"] = brand
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .brand:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        nil
    }
}
