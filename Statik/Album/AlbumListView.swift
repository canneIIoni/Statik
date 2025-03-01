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
                                    .frame(width: 65, height: 65)
                                    .scaledToFill()
                            } else {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.3))
                                    .frame(width: 65, height: 65)
                                    .overlay(Text("No Image").foregroundColor(.gray))
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
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.backgroundColorDark, Color.background]), // Adjust colors here
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
            )
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Statik")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(.systemRed)
                }
                
                ToolbarItem(placement: .topBarTrailing) {
                    NavigationLink(destination: AlbumCreationView()) {
                        Image(systemName: "plus")
                    }
//                    Button(action: addSampleAlbum) {
//                        Image(systemName: "plus")
//                    }
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
            Song(title: "Song 1", isLiked: true, grade: 5, review: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. ", trackNumber: 1),
            Song(title: "Song 2", isLiked: false, grade: 3, review: "Not bad.", trackNumber: 2),
            Song(title: "Song 3", isLiked: false, grade: 3, review: "bibibii bad.", trackNumber: 3),
            Song(title: "Song 4", isLiked: false, grade: 3, review: "Nowdgsdt bad.", trackNumber: 4),
            Song(title: "Song 5", isLiked: false, grade: 3, review: " bad.",trackNumber: 5),
            Song(title: "Song 6", isLiked: false, grade: 3, review: "xcbx d bad.", trackNumber: 6),
            Song(title: "Song 7", isLiked: false, grade: 3, review: "fbajbfbwdfbfd bad.", trackNumber: 7)
        ])
        modelContext.insert(sampleAlbum)
        try? modelContext.save()
    }
}

#Preview {
    AlbumListView()
        .modelContainer(for: Album.self, inMemory: true) // In-memory for preview
}

