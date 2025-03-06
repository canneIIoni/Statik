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
    @State private var starSize: CGFloat = 25
    @State private var starEditable: Bool = false

    var body: some View {
        NavigationStack {
            ZStack {
                LinearGradient(
                    gradient: Gradient(colors: [Color.backgroundColorDark, Color.background]), // Adjust colors here
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()

                VStack(alignment: .leading) {
                    Text("Logged Albums")
                        .font(.system(size: 25, weight: .bold))
                        .padding(.vertical)
                        .padding(.leading)
            
                    List {
                        ForEach(albums) { album in
                            NavigationLink(destination: AlbumDetailView(album: album)) {
                                AlbumComponentView(album: .constant(album))
                            }
                            .listRowSeparator(.hidden)
                            .listRowBackground(Color.clear)
                        }
                        .onDelete(perform: deleteAlbum) // Enables swipe-to-delete
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(.plain)
                }
            
            }
            .navigationTitle("")
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

}

#Preview {
    AlbumListView()
        .modelContainer(for: Album.self, inMemory: true) // In-memory for preview
}
