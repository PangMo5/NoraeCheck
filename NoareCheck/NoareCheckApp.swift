//
//  NoareCheckApp.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import SwiftUI

@main
struct NoareCheckApp: App {
    init() {
        UIScrollView.appearance().keyboardDismissMode = .onDrag
    }

    var body: some Scene {
        WindowGroup {
            SplashView()
                .accentColor(.pink)
        }
    }
}
