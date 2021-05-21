//
//  MainTabView.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/21.
//

import Foundation
import SwiftUI

struct MainTabView: View {
    @State
    var selection = 1

    var body: some View {
        TabView(selection: $selection,
                content: {
                    NavigationView {
                        SearchListContainerView()
                    }
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("검색")
                    }.tag(1)
                    Text("Tab Content 2")
                        .tabItem {
                            Image(systemName: "calendar")
                            Text("둘러보기")
                        }.tag(2)
                })
    }
}
