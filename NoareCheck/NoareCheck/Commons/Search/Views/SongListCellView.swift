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
        VStack {
            Text(song.title)
        }
    }
}
