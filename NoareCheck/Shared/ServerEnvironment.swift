//
//  ServerEnvironment.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import Foundation

final class ServerEnvironment {
    
    static let shared = ServerEnvironment()
    
    var baseURL: URL {
        URL(string: "https://api.manana.kr/v2/karaoke")!
    }
}
