//
//  SongDetailView.swift
//  Statik
//
//  Created by Luca on 28/02/25.
//


import SwiftUI

struct SongDetailView: View {
    @State var song: Song
    @Binding var album: Album
    @State private var starSize: CGFloat = 20
    @State private var starEditable: Bool = true

    var body: some View {
        VStack {
            HStack {
                Text(song.title)
                    .font(.title2)
                    .bold()
                Spacer()
                Button(action: toggleLike) {
                    Image(systemName: song.isLiked ? "heart.fill" : "heart")
                        .foregroundColor(.systemRed)
                        .font(.title2)
                }
            }
            .padding()

            HStack {
                Text("Rating:")
                RatingView(rating: $song.grade, starSize: $starSize, editable: $starEditable)
            }

            TextField("Write a review...", text: $song.review)
                .textFieldStyle(.roundedBorder)
                .padding()

            Spacer()
        }
        .padding()
        .navigationTitle(song.title)
        .onDisappear {
            if let index = album.songs.firstIndex(where: { $0.id == song.id }) {
                album.songs[index] = song
            }
        }
    }

    private func toggleLike() {
        song.isLiked.toggle()
    }
}
