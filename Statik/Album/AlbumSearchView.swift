//
//  AlbumSearchView.swift
//  Statik
//
//  Created by Luca on 01/05/25.
//

import SwiftUI
import Combine

class AlbumSearchViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var searchResults: [DiscogsSearchResult] = []
    @Published var isSearching = false

    let discogsService = DiscogsService()
    private var cancellables = Set<AnyCancellable>()

    init() {
        $searchText
            .debounce(for: .milliseconds(200), scheduler: RunLoop.main)
            .removeDuplicates()
            .sink { [weak self] text in
                guard let self = self else { return }
                self.performSearch(for: text)
            }
            .store(in: &cancellables)
    }

    func performSearch(for text: String) {
        let trimmed = text.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            searchResults = []
            return
        }

        isSearching = true
        discogsService.searchAlbums(query: trimmed) { result in
            DispatchQueue.main.async {
                self.isSearching = false
                switch result {
                case .success(let albums):
                    self.searchResults = albums
                case .failure(let error):
                    print("Search failed: \(error)")
                    self.searchResults = []
                }
            }
        }
    }
}

struct AlbumSearchView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = AlbumSearchViewModel()

    @State private var selectedAlbum: Album?
    @State private var showDetail = false

    var body: some View {
        NavigationStack {
            VStack {
                HStack {
                    Text("Search Albums")
                        .font(.system(size: 25, weight: .bold))
                        .padding(.vertical)
                        .padding(.leading)
                    Spacer()
                }
                HStack {
                    TextField("Search Discogs albums...", text: $viewModel.searchText)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.backgroundColorDark))

                }
                .padding(.horizontal)

                if viewModel.isSearching {
                    ProgressView()
                        .padding()
                }

                List {
                    ForEach(viewModel.searchResults) { result in
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
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Text("Statik")
                        .font(.system(size: 25, weight: .bold))
                        .foregroundStyle(.systemRed)
                }
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.backgroundColorDark, Color.background]),
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
            )

            NavigationLink(
                destination: selectedAlbum.map { album in
                    AlbumDetailView(album: album)
                },
                isActive: $showDetail,
                label: { EmptyView() }
            )
            .hidden()
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
        viewModel.isSearching = true
        selectedAlbum = nil // 👈 Force reset so NavigationLink detects a change

        viewModel.discogsService.fetchMasterRelease(id: id) { result in
            DispatchQueue.main.async {
                viewModel.isSearching = false

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
}

#Preview {
    AlbumSearchView()
}
