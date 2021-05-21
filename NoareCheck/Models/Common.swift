//
//  Common.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/21.
//

import Foundation

struct Common<C>: Codable where C: Codable {
    var total: Total?
    var page: Int?
    var offset: Int?
    var limit: Int?
    var data: C?
}

extension Common {
    struct Total: Codable {
        var row: Int?
        var page: Int?
    }
}
