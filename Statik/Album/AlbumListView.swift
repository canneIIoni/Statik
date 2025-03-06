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
    @State private var sortOption: SortOption = .dateLogged // Default sorting by date

    enum SortOption: String, CaseIterable, Identifiable {
        case alphabetical = "Alphabetical"
        case dateLogged = "Date Logged"

        var id: String { self.rawValue }
    }

    var sortedAlbums: [Album] {
        switch sortOption {
        case .alphabetical:
            return albums.sorted { $0.name.localizedCompare($1.name) == .orderedAscending }
        case .dateLogged:
            return albums.sorted { $0.dateLogged ?? Date() > $1.dateLogged ?? Date() }
        }
    }

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

                    Picker("Sort by", selection: $sortOption) {
                        ForEach(SortOption.allCases) { option in
                            Text(option.rawValue).tag(option)
                        }
                    }
                    .pickerStyle(.segmented)
                    .padding(.horizontal)

                    List {
                        ForEach(sortedAlbums) { album in
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
