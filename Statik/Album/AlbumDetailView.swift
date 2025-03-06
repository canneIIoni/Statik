//
//  AlbumDetailView.swift
//  Statik
//
//  Created by Luca on 28/02/25.
//


import SwiftUI

struct AlbumDetailView: View {
    @Environment(\.modelContext) private var modelContext
    @State var album: Album
    @State private var starSize: CGFloat = 25
    @State private var smallStarSize: CGFloat = 17
    @State private var starEditable: Bool = false
    @State private var imageSize: CGFloat = 147

    var body: some View {
        ScrollView {
            VStack {
                HStack {
                    
                    ImageComponent(album: $album, imageSize: $imageSize)

                    VStack(alignment: .leading) {
                        Text("Album · \(album.year)")
                            .font(.caption)
                            .foregroundStyle(.secondaryText)

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

                VStack(alignment: .leading) {
                    ForEach(album.songs.sorted { $0.trackNumber < $1.trackNumber }) { song in
                        NavigationLink(destination: SongDetailView(song: song, album: $album)) {
                            SongComponentView(song: .constant(song), smallStarSize: .constant(17))
                        }
                        .padding(.vertical, 8)
                        Divider()
                    }
                }
                .padding(.trailing)
            }.padding(.leading, 15)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: AlbumReviewView(album: $album)) {
                    Text("Log")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.systemRed)
                }
            }
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

