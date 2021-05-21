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
        ZStack {
            VStack {
                Group {
                    TextField("제목을 입력해주세요.", text: $viewModel.titleText)
                    TextField("가수를 입력해주세요.", text: $viewModel.singerText)
                    TextField("노래번호를 입력해주세요.", text: $viewModel.noText)
                }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal)
                List {
                    ForEach(viewModel.songList, id: \.self) { song in
                        SongListCellView(song: song)
                            .onAppear {
                                guard song.no == viewModel.songList.last?.no else { return }
                                viewModel.loadNextPage = true
                            }
                    }
                    if viewModel.isFooterLoading {
                        SwiftUIX.ActivityIndicator()
                    }
                }
            }
            if viewModel.isLoading {
                SwiftUIX.ActivityIndicator()
            }
        }
    }
}

struct SearchListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListContainerView()
    }
}
