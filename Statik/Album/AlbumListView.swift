//
//  AlbumListView.swift
//  Statik
//
//  Created by Luca on 28/02/25.
//


import SwiftUI
import SwiftData

struct AlbumListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query private var albums: [Album] // Automatically fetches from SwiftData

    var body: some View {
        NavigationStack {
            List {
                ForEach(albums) { album in
                    NavigationLink(destination: AlbumDetailView(album: album)) {
                        HStack {
                            if let image = album.albumImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 50, height: 50)
                                    .clipShape(RoundedRectangle(cornerRadius: 5))
                            }

                            VStack(alignment: .leading) {
                                Text(album.name)
                                    .font(.headline)
                                Text(album.artist)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }

                            Spacer()

                            if album.isLiked {
                                Image(systemName: "heart.fill")
                                    .foregroundColor(.systemRed)
                            }
                        }
                    }
                }
            }
            .navigationTitle("")
            .toolbar {
                Button(action: addSampleAlbum) {
                    Image(systemName: "plus")
                }
            }
        }
    }

    private func deleteAlbum(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(albums[index])
        }
        try? modelContext.save()
    }

    private func addSampleAlbum() {
        let sampleAlbum = Album(name: "Sample Album", artist: "Sample Artist", year: "2024", review: "Great album!", isLiked: true, grade: 4, songs: [
            Song(title: "Song 1", isLiked: true, grade: 5, review: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. "),
            Song(title: "Song 2", isLiked: false, grade: 3, review: "Not bad.")
        ])
        modelContext.insert(sampleAlbum)
        try? modelContext.save()
    }
}

#Preview {
    AlbumListView()
        .modelContainer(for: Album.self, inMemory: true) // In-memory for preview
}

