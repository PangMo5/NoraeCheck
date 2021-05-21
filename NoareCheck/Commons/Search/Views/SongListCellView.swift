//
//  SongListCellView.swift
//  NoareCheck
//
//  Created by PangMo5 on 2021/05/15.
//

import Foundation
import SwiftUI
import SwiftUIX

struct SongListCellView: View {
    var song: Song

    var body: some View {
        HStack(spacing: 16) {
            Text(song.no ?? "")
                .font(.system(size: 20, weight: .bold, design: .rounded))
            VStack(alignment: .leading) {
                Text(song.title ?? "")
                    .font(.body)
                Text(song.singer ?? "")
                    .foregroundColor(.gray)
                    .font(.body)
            }
        }
        .padding(.vertical)
    }
}
