//
//  SongComponentView.swift
//  Statik
//
//  Created by Luca on 06/03/25.
//

import SwiftUI

struct SongComponentView: View {
    
    @Binding var song: Song
    @Binding var smallStarSize: CGFloat
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("\(song.title) ·")
                        .font(.system(size: 20))
                    RatingView(
                        rating: Binding(
                            get: { song.grade },
                            set: { song.grade = $0 }
                        ),
                        starSize: $smallStarSize,
                        editable: .constant(false)
                    ).allowsHitTesting(false)
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
                Image(systemName: "heart.circle.fill")
                    .foregroundColor(.systemRed)
            }
            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundColor(.secondary).opacity(0.5)
        }
    }
}


