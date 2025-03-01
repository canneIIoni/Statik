//
//  AlbumCreationView.swift
//  Statik
//
//  Created by Luca on 01/03/25.
//

import SwiftUI
import PhotosUI

struct AlbumCreationView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @State private var selectedItem: PhotosPickerItem? = nil
    @State private var selectedImage: UIImage? = nil
    @State private var songs: [Song] = []
    @State private var name: String = ""
    @State private var artist: String = ""
    @State private var year: String = ""
    
    var body: some View {
        
        NavigationStack {
            VStack(alignment: .leading) {
                HStack {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let image = selectedImage {
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
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let image = UIImage(data: data) {
                                selectedImage = image
                                try? modelContext.save()
                            }
                        }
                    }
                    
                    VStack(alignment: .leading) {
                        
                        if year == "" {
                            Text("Album · Year")
                                .font(.caption)
                                .foregroundStyle(.secondaryText)
                        } else {
                            Text("Album · \(year)")
                        }
                        
                        if name == "" {
                            Text("Album name")
                                .font(.system(size: 25, weight: .bold))
                        } else {
                            Text(name)
                                .font(.system(size: 25, weight: .bold))
                        }
                        
                        if artist == "" {
                            Text("Artist")
                                .font(.system(size: 16))
                        } else {
                            Text(artist)
                                .font(.system(size: 16))
                        }
                        
                        
                        Spacer()
                    }.frame(height: 150)
                        .padding(.top, 5).padding(.leading, 10)
                    
                    
                }.padding(.top, 20).padding(.bottom, 40)
                    .font(.system(size: 25, weight: .bold))
                
                Text("Rating")
                    .font(.system(size: 16, weight: .bold))
                
                TextField("", text: $name, prompt: Text("Album name"), axis: .vertical)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.backgroundColorDark))
                    .lineLimit(1, reservesSpace: true)
                Spacer()
                
                Spacer()
            }.padding()
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.backgroundColorDark, Color.background]), // Adjust colors here
                        startPoint: .top,
                        endPoint: .center
                    )
                    .ignoresSafeArea()
                )
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Text("Cancel")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.secondaryText)
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            addAlbum()
                            dismiss()
                        } label: {
                            Text("Save")
                                .font(.system(size: 18, weight: .bold))
                                .foregroundStyle(.systemRed)
                        }
                    }
                }
        }
    }
    
    private func addAlbum(){
        let album = Album(name: name, artist: artist, year: year, review: "", isLiked: false, grade: 0.0, image: selectedImage, songs: songs)
        modelContext.insert(album)
        try? modelContext.save()
    }
    
}

#Preview {
    AlbumCreationView()
    
}
