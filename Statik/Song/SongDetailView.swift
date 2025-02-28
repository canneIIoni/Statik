//
//  SongDetailView.swift
//  Statik
//
//  Created by Luca on 28/02/25.
//


import SwiftUI

struct SongDetailView: View {
    @Environment(\.dismiss) private var dismiss
    @State var song: Song
    @Binding var album: Album
    @State private var starSize: CGFloat = 20
    @State private var starEditable: Bool = true
    @State private var review: String = ""

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

            TextField("", text: $review, prompt: Text("Write a review..."))
                .textFieldStyle(.roundedBorder)
                .padding()

            Spacer()
        }
        .padding()
        .navigationTitle(song.title)
        .navigationBarBackButtonHidden(true)
        .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Cancel") {
                            dismiss() // 🔹 Dismiss view without saving
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Save") {
                            song.review = review
                            dismiss()
                        }
                    }
                    
        }.onDisappear {
            if let index = album.songs.firstIndex(where: { $0.id == song.id }) {
                album.songs[index] = song
            }
        }
        .onAppear {
                review = song.review.isEmpty ? "" : song.review
            }
    }

    private func toggleLike() {
        song.isLiked.toggle()
    }
}
