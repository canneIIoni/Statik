//
//  AlbumSearchView.swift
//  Statik
//
//  Created by Luca on 01/05/25.
//

import SwiftUI

struct AlbumSearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var searchResults: [DiscogsSearchResult] = []
    @State private var isSearching = false
    private let discogsService = DiscogsService()
    
    @State private var selectedAlbum: Album?
    @State private var showDetail = false

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
                            AlbumComponentView(
                                album: .constant(dummyAlbum(from: result)),
                                remoteImageURL: result.thumb ?? result.cover_image
                            )
                            .onTapGesture {
                                fetchDiscogsAlbum(id: result.id)
                            }
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

            // Corrected NavigationLink
            NavigationLink(
                destination: selectedAlbum.map { album in
                    AlbumDetailView(album: album)
                },
                isActive: $showDetail,
                label: { EmptyView() }
            )
            .hidden() // Hidden but still functional
            
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
            year: result.year ?? "Unknown Year",
            review: "",
            isLiked: false,
            grade: 0.0,
            image: nil,
            songs: [],
            dateLogged: Date()
        )
    }
    
    private func fetchDiscogsAlbum(id: Int) {
        isSearching = true

        discogsService.fetchMasterRelease(id: id) { result in
            isSearching = false

            switch result {
            case .success(let master):
                Task {
                    var albumImage: UIImage? = nil
                    if let imageURL = master.images?.first(where: { $0.type == "primary" })?.uri,
                       let url = URL(string: imageURL) {
                        do {
                            let (data, _) = try await URLSession.shared.data(from: url)
                            albumImage = UIImage(data: data)
                        } catch {
                            print("❌ Failed to load image: \(error)")
                        }
                    }

                    let songs = master.tracklist.enumerated().map { index, track in
                        Song(title: track.title, isLiked: false, grade: 0.0, review: "", trackNumber: index + 1)
                    }

                    let album = Album(
                        name: master.title,
                        artist: master.artists.first?.name ?? "Unknown Artist",
                        year: "\(master.year)",
                        review: "",
                        isLiked: false,
                        grade: 0.0,
                        image: albumImage,
                        songs: songs,
                        dateLogged: Date()
                    )

                    selectedAlbum = album
                    showDetail = true
                }

            case .failure(let error):
                print("❌ Failed to fetch album: \(error)")
            }
        }
    }
}

#Preview {
    AlbumSearchView()
}

