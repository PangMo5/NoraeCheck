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
    case search(no: Int? = nil, title: String? = nil, singer: String? = nil, brand: Brand, page: Int)
}

extension KaraokeAPI: TargetType {
    var baseURL: URL {
        ServerEnvironment.shared.baseURL
    }

    var path: String {
        switch self {
        case .brand:
            return "/brand.json"
        case .search:
            return "/search.json"
        }
    }

    var method: Moya.Method {
        switch self {
        case .brand, .search:
            return .get
        }
    }

    var sampleData: Data {
        "{".data(using: .utf8)!
    }

    var task: Task {
        switch self {
        case let .search(no, title, singer, brand, page):
            var parameters = [String: Any]()
            parameters["no"] = no
            parameters["title"] = title
            parameters["singer"] = singer
            parameters["brand"] = brand
            parameters["page"] = page
            return .requestParameters(parameters: parameters, encoding: URLEncoding.default)
        case .brand:
            return .requestPlain
        }
    }

    var headers: [String: String]? {
        nil
    }
}
