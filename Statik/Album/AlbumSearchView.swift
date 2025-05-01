//
//  AlbumSearchView.swift
//  Statik
//
//  Created by Luca on 01/05/25.
//

import SwiftUI

struct AlbumSearchView: View {
    @State private var searchText = ""
    @State private var searchResults: [DiscogsSearchResult] = []
    @State private var isSearching = false
    private let discogsService = DiscogsService()

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    TextField("Search Discogs albums...", text: $searchText)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.backgroundColorDark))
                        .onSubmit {
                            searchAlbums()
                        }

                    Button(action: searchAlbums) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.horizontal)

                if isSearching {
                    ProgressView()
                        .padding()
                }

                List {
                    ForEach(searchResults) { result in
                        VStack(alignment: .leading) {
                            AlbumComponentView(album: .constant(dummyAlbum(from: result)))
                        }
                        .padding(.vertical, 8)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                    }
                }
                .scrollContentBackground(.hidden)
                .listStyle(.plain)
            }
            .navigationTitle("Search Discogs")
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.backgroundColorDark, Color.background]),
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
            )
        }
    }

    private func searchAlbums() {
        guard !searchText.isEmpty else { return }
        isSearching = true
        print("Searching for: \(searchText)")  // Debug print

        discogsService.searchAlbums(query: searchText) { result in
            isSearching = false
            switch result {
            case .success(let albums):
                print("Found \(albums.count) results")
                self.searchResults = albums
            case .failure(let error):
                print("Search failed: \(error)")
            }
        }
    }

    private func dummyAlbum(from result: DiscogsSearchResult) -> Album {
        Album(
            name: result.name,
            artist: result.artistName,
            year: result.year.map { String($0) } ?? "",
            review: "",
            isLiked: false,
            grade: 0.0,
            image: nil,
            songs: [],
            dateLogged: Date()
        )
    }
}

#Preview {
    AlbumSearchView()
}

