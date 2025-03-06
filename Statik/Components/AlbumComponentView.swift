//
//  AlbumComponentView.swift
//  Statik
//
//  Created by Luca on 06/03/25.
//

import SwiftUI

struct AlbumComponentView: View {
    
    @Binding var album: Album
    @State var imageSize: CGFloat = 65
    @State private var isTitleTwoLines: Bool = false
    @State private var starSize: CGFloat = 17
    @State private var editable = false
    private let singleLineHeight: CGFloat = 24
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(alignment: .top, spacing: 12) {
                
                ImageComponent(album: $album, imageSize: $imageSize)
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        GeometryReader { geometry in
                            VStack(alignment: .leading, spacing: 4) {
                                Text(album.name)
                                    .font(.system(size: 20, weight: .bold))
                                    .multilineTextAlignment(.leading)
                                    .fixedSize(horizontal: false, vertical: true)
                                    .background(
                                        GeometryReader { titleGeometry in
                                            Color.clear.preference(
                                                key: TitleHeightKey.self,
                                                value: titleGeometry.size.height
                                            )
                                        }
                                    )
                            }
                            .onPreferenceChange(TitleHeightKey.self) { newHeight in
                                isTitleTwoLines = newHeight > singleLineHeight
                            }
                        }
                        .frame(height: isTitleTwoLines ? 48 : singleLineHeight) // Adjust height as needed
                        
                        
                    }
                    
                    // Artist and optional rating/like button
                    HStack {
                        Text(album.artist)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        RatingView(
                            rating: Binding(
                                get: { album.grade },
                                set: { album.grade = $0 }
                            ),
                            starSize: $starSize,
                            editable: .constant(false)
                        ).allowsHitTesting(false)
                        
                        if album.isLiked {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.systemRed)
                        }
                        
                    }
                    
                    if !isTitleTwoLines {
                        if !album.review.isEmpty {
                            Text(album.review)
                                .font(.system(size: 12))
                                .foregroundColor(.gray)
                                .lineLimit(2)
                        }
                    }
                }
                
                Spacer()
            }
            
            if isTitleTwoLines {
                if !album.review.isEmpty {
                    Text(album.review)
                        .font(.system(size: 12))
                        .foregroundColor(.gray)
                        .lineLimit(2)
                }
            }
            
        }.padding(.vertical, 8)
    }
}

// MARK: - PreferenceKey for Title Height
struct TitleHeightKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = nextValue()
    }
}

#Preview {
    struct Preview: View {
        @State var album = Album(name: "Reading, Writing and Arithmetic and poop", artist: "The Smiths", year: "1985", review: "berry gud", isLiked: true, grade: 4.5, dateLogged: Date())
        var body: some View {
            AlbumComponentView(album: $album)
        }
    }
    
    return Preview()
}
