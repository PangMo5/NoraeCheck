//
//  SplashView.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import SwiftUI

struct SplashView: View {
    
    @ObservedObject
    var viewModel = SplashViewModel()

    var body: some View {
        if viewModel.isSplashing {
            Text("Noare Check")
                .padding()
        } else {
            MainTabView()
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
