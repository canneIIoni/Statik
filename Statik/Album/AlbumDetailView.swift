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
                        Text("Album · \(album.year ?? "Unknown Year")")
                            .font(.caption)
                            .foregroundStyle(.secondaryText)
                        
                        Text(album.name)
                            .font(.system(size: 25, weight: .bold))
                            .layoutPriority(1)
                        
                        Text(album.artist)
                            .font(.system(size: 16))
                        
                        if album.isSaved {
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
                        }
                        
                        Spacer()
                    }
                        .padding(.top, 5).padding(.leading, 10)
                    
                    Spacer()
                }.padding(.top, 20)
                
                HStack {
                    VStack(alignment: .leading) {
                        if album.isLogged {
                            Text("Date Logged: \(returnDate(album.dateLogged ?? Date()))")
                                .font(.system(size: 14))
                                .foregroundStyle(.secondaryText)
                                .padding(.bottom, 5)
                        }
                        Text(album.review)
                            .font(.system(size: 14))
                            .foregroundStyle(.secondaryText)
                    }
                    Spacer()
                }
                
                VStack(alignment: .leading) {
                    ForEach(album.songs.sorted { $0.trackNumber < $1.trackNumber }) { song in
                        if album.isSaved {
                            NavigationLink(destination: SongDetailView(song: song, album: $album)) {
                                SongComponentView(song: .constant(song), artist: .constant($album.wrappedValue.artist), smallStarSize: .constant(17))
                                    .padding(.vertical, 8)
                            }
                        } else {
                            SearchedSongComponentView(song: .constant(song), artist: .constant($album.wrappedValue.artist))
                                .padding(.vertical, 8)
                        }
                        
                        Divider()
                    }
                }
                .padding(.trailing)
            }.padding(.leading, 15)

        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                if album.isSaved {
                    NavigationLink(destination: AlbumReviewView(album: $album)) {
                        Text("Log")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.systemRed)
                    }
                } else {
                    Button {
                        album.dateLogged = Date()
                        album.isLogged = true
                        album.isSaved = true
                        modelContext.insert(album)
                        try? modelContext.save()
                    } label: {
                        Text("Save")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.systemRed)
                    }
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
    
    func returnDate (_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        return dateFormatter.string(from: album.dateLogged ?? Date())
    }
}
