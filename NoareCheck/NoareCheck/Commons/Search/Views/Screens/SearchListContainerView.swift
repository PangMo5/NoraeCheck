//
//  SearchListContainerView.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import SwiftUI
import SwiftUIX

struct SearchListContainerView: View {
    @ObservedObject
    var viewModel = SearchListContainerViewModel()

    var body: some View {
        VStack {
            TextField("검색어를 입력해주세요.", text: $viewModel.searchText)
            List(viewModel.songList, id: \.self) { song in
                SongListCellView(song: song)
            }
        }
    }
}

struct SearchListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListContainerView()
    }
}
