//
//  AlbumDetailView.swift
//  Statik
//
//  Created by Luca on 28/02/25.
//


import SwiftUI
import PhotosUI

struct AlbumDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State var album: Album
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var starSize: CGFloat = 25
    @State private var smallStarSize: CGFloat = 17
    @State private var starEditable: Bool = false

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    
                    if let image = album.albumImage {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 147, height: 147)
                            .scaledToFill()
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 147, height: 147)
                            .overlay(Text("No Image").foregroundColor(.gray))
                    }

                    VStack(alignment: .leading) {
                        Text("Album · \(album.year)")
                            .font(.caption)

                        Text(album.name)
                            .font(.system(size: 25, weight: .bold))

                        Text(album.artist)
                            .font(.system(size: 16))

                        HStack {
                            RatingView(rating: $album.grade, starSize: $starSize, editable: $starEditable)
                            if album.isLiked {
                                Image(systemName: "heart.circle.fill")
                                    .resizable()
                                    .foregroundColor(.systemRed)
                                    .scaledToFit()
                                    .frame(width: starSize, height: starSize)
                            } else {
                                Image(systemName: "heart.circle")
                                    .resizable()
                                    .foregroundColor(.systemRed)
                                    .scaledToFit()
                                    .frame(width: starSize, height: starSize)
                            }
                        }.padding(.top)

                        Spacer()
                    }.frame(height: 150)
                        .padding(.top, 5).padding(.leading, 10)

                    Spacer()
                }.padding(.top, 20)
                
                HStack {
                    Text(album.review)
                        .font(.system(size: 14))
                        .foregroundStyle(.secondaryText)
                    Spacer()
                }

                PhotosPicker(selection: $selectedItem, matching: .images) {
                    Text("Select Album Cover")
                }
                .padding()
                .onChange(of: selectedItem) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            selectedImage = image
                            album.imageData = image.jpegData(compressionQuality: 0.8)
                            try? modelContext.save()
                        }
                    }
                }
                

                VStack(alignment: .leading) {
                    ForEach(album.songs) { song in
                        NavigationLink(destination: SongDetailView(song: song, album: $album)) {
                            HStack {
                                VStack(alignment: .leading) {
                                    HStack {
                                        Text("\(song.title) ·")
                                            .font(.system(size: 20))
                                        RatingView(
                                            rating: Binding(
                                                get: { song.grade },  // Get the song's grade
                                                set: { song.grade = $0 } // Update the grade
                                            ),
                                            starSize: $smallStarSize,
                                            editable: .constant(false) // Make it non-editable
                                        )
                                    }
                                    if !song.review.isEmpty {
                                        Text("“\(song.review)”")
                                            .font(.system(size: 14))
                                            .foregroundColor(.secondaryText)
                                            .multilineTextAlignment(.leading)
                                    }
                                    
                                }
                                Spacer()
                                if song.isLiked {
                                    Image(systemName: "heart.fill")
                                        .foregroundColor(.systemRed)
                                }
                            }
                        }
                        .padding(.vertical, 8) // Add spacing between items
                        Divider() // Optional: Adds a subtle separator
                    }
                }
                .padding(.trailing)
            }.padding(.leading, 15)
        }
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color.backgroundColorDark, Color.background]), // Adjust colors here
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
        )
        .onDisappear {
            try? modelContext.save()
        }
    }
}

