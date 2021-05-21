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

    var brandMenu: some View {
        Group {
            ForEach(AppAssets.shared.brandList.value, id: \.self) { item in
                Button(action: {
                    viewModel.selectedBrand = AppAssets.shared.brandList.value.firstIndex(of: item) ?? 0
                }) {
                    Text(item.uppercased())
                }
            }
        }
    }

    var searchHeaderView: some View {
        VStack(spacing: 8) {
            Group {
                HStack(spacing: 0) {
                    TextField("제목을 입력해주세요.", text: $viewModel.titleText)
                    if viewModel.titleText.isNotEmpty {
                        Image(systemName: "xmark.circle")
                            .onTapGesture {
                                viewModel.titleText = ""
                            }
                            .padding(.leading, 8)
                    }
                }
                HStack(spacing: 0) {
                    TextField("가수를 입력해주세요.", text: $viewModel.singerText)
                    if viewModel.singerText.isNotEmpty {
                        Image(systemName: "xmark.circle")
                            .onTapGesture {
                                viewModel.singerText = ""
                            }
                            .padding(.leading, 8)
                    }
                }
                HStack(spacing: 0) {
                    TextField("노래번호를 입력해주세요.", text: $viewModel.noText)
                    if viewModel.noText.isNotEmpty {
                        Image(systemName: "xmark.circle")
                            .onTapGesture {
                                viewModel.noText = ""
                            }
                            .padding(.leading, 8)
                    }
                }
            }
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        .padding()
    }

    var body: some View {
        ZStack {
            List {
                searchHeaderView
                    .listRowInsets(.zero)
                ForEach(viewModel.songList, id: \.self) { song in
                    SongListCellView(song: song)
                        .onAppear {
                            guard song.no == viewModel.songList.last?.no else { return }
                            viewModel.loadNextPage = true
                        }
                }
                if viewModel.isFooterLoading {
                    SwiftUIX.ActivityIndicator()
                        .frame(minWidth: 0, maxWidth: .infinity, alignment: .center)
                }
            }
            .listStyle(PlainListStyle())
            if viewModel.isLoading {
                SwiftUIX.ActivityIndicator()
            }
            if viewModel.isEmptyResult {
                VStack(spacing: 16) {
                    Image(systemName: "questionmark.square.dashed")
                        .font(.largeTitle)
                    Text("검색 결과가 없습니다.")
                }
            }
        }
        .navigationTitle("검색")
        .navigationBarItems(leading:
            Image(systemName: "gear"),
            trailing:
            Text(AppAssets.shared.brandList.value[safe: viewModel.selectedBrand]?.uppercased() ?? "")
                .frame(width: 150, alignment: .trailing)
                .menuOnPress {
                    brandMenu
                })
    }
}

struct SearchListContainerView_Previews: PreviewProvider {
    static var previews: some View {
        SearchListContainerView()
    }
}
