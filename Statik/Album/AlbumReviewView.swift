//
//  AlbumReviewView.swift
//  Statik
//
//  Created by Luca on 28/02/25.
//

import SwiftUI

struct AlbumReviewView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @State var album: Album
    @State private var starSize: CGFloat = 37
    @State private var starEditable: Bool = true
    @State private var review: String = ""
    @State private var rating: Double = 0
    
    var body: some View {
        VStack {
            HStack {
                if let image = album.albumImage {
                    Image(uiImage: image)
                        .resizable()
                        .frame(width: 65, height: 65)
                        .scaledToFill()
                } else {
                    Rectangle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 65, height: 65)
                        .overlay(Text("No Image").foregroundColor(.gray))
                }
                VStack(alignment: .leading) {
                    Text("Album · \(album.year)")
                        .font(.caption)
                        .foregroundStyle(.secondaryText)
                    Text(album.name)
                        .font(.title2)
                        .bold()
                    Text(album.artist)
                        .font(.system(size: 16))
                    Spacer()
                }.frame(height: 65)
                
                Spacer()
            }
            .padding(.bottom)
            
            Divider().padding(.bottom)

            HStack {
                VStack(alignment: .leading) {
                    Text("Rating")
                        .font(.system(size: 16, weight: .bold))
                    RatingView(rating: $album.grade, starSize: $starSize, editable: $starEditable)
                }.padding(.bottom)
                
                Spacer()
                
                VStack(alignment: .center) {
                    if album.isLiked {
                        Text("Liked").font(.system(size: 16, weight: .bold))
                    } else {
                        Text("Like").font(.system(size: 16, weight: .bold))
                    }
                    Button(action: toggleLike) {
                        Image(systemName: album.isLiked ? "heart.circle.fill" : "heart.circle")
                            .foregroundColor(.systemRed)
                            .font(.system(size: 37, weight: .bold))
                    }.offset(y: 4)
                }.padding(.bottom)
                    
            }
            
            Divider().padding(.bottom)
            
            HStack {
                Text("Review")
                    .font(.system(size: 16, weight: .bold))
                Spacer()
            }

            TextField("", text: $review, prompt: Text("Write a review..."), axis: .vertical)
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.backgroundColorDark))
                .lineLimit(6, reservesSpace: true)
                

            Spacer()
        }
        .padding()
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    album.grade = rating
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.secondaryText)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    album.review = review
                    dismiss()
                } label: {
                    Text("Save")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundStyle(.systemRed)
                }
            }
            
        }.background(
            LinearGradient(
                gradient: Gradient(colors: [Color.backgroundColorDark, Color.background]), // Adjust colors here
                startPoint: .top,
                endPoint: .center
            )
            .ignoresSafeArea()
        )
        .onDisappear {
            album.review = review
            album.grade = rating
            try? modelContext.save()
        }
        .onAppear {
            review = album.review.isEmpty ? "" : album.review
            rating = album.grade
        }
    }

    private func toggleLike() {
        album.isLiked.toggle()
    }
}
