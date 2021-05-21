//
//  Song.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import Foundation
import Kodable

struct Song: Codable, Hashable {
    var no: String?
    var brand: Brand?
    var title: String?
    var singer: String?
    var composer: String?
    var lyricist: String?
    @CodableDate(.format("yyyy-MM-dd")) var release: Date?
}

extension Song {
    static func == (lhs: Song, rhs: Song) -> Bool {
        lhs.no == rhs.no && lhs.brand == rhs.brand
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(no)
        hasher.combine(brand)
    }
}
