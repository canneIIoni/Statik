//
//  SearchedSongComponentView.swift
//  Statik
//
//  Created by Luca on 01/05/25.
//


import SwiftUI

struct SearchedSongComponentView: View {
    
    @Binding var song: Song
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack(alignment: .bottom) {
                    Text("\(song.title) ·")
                        .font(.system(size: 20))
                        .multilineTextAlignment(.leading)
                }
            }
            Spacer()
        }
    }
}


