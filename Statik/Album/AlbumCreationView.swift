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
    @State private var year: String = "\(Calendar.current.component(.year, from: Date()))" // Default to current year
    @State private var isAddingSong: Bool = false
    @State private var imageSize: CGFloat = 147
    
    let years: [String] = (1900...Calendar.current.component(.year, from: Date())).map { "\($0)" }
    
    var body: some View {
        NavigationStack {
            ScrollView {
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
                            Text("Album · \(year)")
                                .font(.caption)
                                .foregroundStyle(.secondaryText)
                            
                            Text(name.isEmpty ? "Album Title" : name)
                                .font(.system(size: 25, weight: .bold))
                            
                            Text(artist.isEmpty ? "Artist" : artist)
                                .font(.system(size: 16))
                            
                            Spacer()
                        }
                        .frame(height: 150)
                        .padding(.top, 5)
                        .padding(.leading, 10)
                    }
                    .padding(.top, 20)
                    .padding(.bottom, 30)
                    
                    Text("Album Title").font(.system(size: 16, weight: .bold))
                    TextField("", text: $name, prompt: Text("Album Title"), axis: .vertical)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.backgroundColorDark))
                        .lineLimit(1, reservesSpace: true)
                        .padding(.bottom)
                    
                    Text("Artist").font(.system(size: 16, weight: .bold))
                    TextField("", text: $artist, prompt: Text("Artist"), axis: .vertical)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.backgroundColorDark))
                        .lineLimit(1, reservesSpace: true)
                        .padding(.bottom)
                    
                    Text("Year").font(.system(size: 16, weight: .bold))
                    Picker("Select Year", selection: $year) {
                        ForEach(years, id: \.self) { year in
                            Text(year).tag(year)
                        }
                    }
                    .pickerStyle(.wheel)
                    .frame(height: 120)
                    
                    // Section for Adding Songs
                    
                    HStack {
                        Text("Songs").font(.system(size: 16, weight: .bold))
                        Spacer()
                        Button(action: { isAddingSong = true }) {
                            Image(systemName: "plus")
                                .font(.system(size: 18, weight: .bold))
                        }
                    }.padding(.vertical)
                    
                    
                    if songs.isEmpty {
                        Text("No songs added").foregroundColor(.gray)
                    } else {
                        ZStack {
                            Color.clear // Ensures the background is transparent
                            List {
                                ForEach(songs.sorted { $0.trackNumber < $1.trackNumber }) { song in
                                    HStack {
                                        Text("\(song.trackNumber). \(song.title)")
                                            .font(.system(size: 16))
                                        Spacer()
                                        Image(systemName: song.isLiked ? "heart.fill" : "heart")
                                            .foregroundColor(song.isLiked ? .red : .gray)
                                    }
                                    .listRowSeparator(.hidden)
                                    .listRowBackground(Color.clear)
                                }
                                .onDelete(perform: deleteSong)
                            }
                            .frame(height: min(CGFloat(songs.count) * 44, 300)) // Adjust height to fit content
                            .listStyle(.plain)
                            .background(Color.clear)
                            .scrollContentBackground(.hidden)                         }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.backgroundColorDark, Color.background]),
                    startPoint: .top,
                    endPoint: .center
                )
                .ignoresSafeArea()
            )
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button { dismiss() } label: {
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
            .onTapGesture {
                hideKeyboard()
            }
            .sheet(isPresented: $isAddingSong) {
                AddSongView { newSong in
                    songs.append(newSong)
                }
            }
        }
    }
    
    private func addAlbum() {
        let album = Album(name: name, artist: artist, year: year, review: "", isLiked: false, grade: 0.0, image: selectedImage, songs: songs)
        modelContext.insert(album)
        try? modelContext.save()
    }
    
    private func deleteSong(at offsets: IndexSet) {
        for index in offsets {
            let songToDelete = songs[index] // Get the song from the array
            modelContext.delete(songToDelete) // Delete from SwiftData
        }
        
        songs.remove(atOffsets: offsets) // Remove from the UI list
        try? modelContext.save() // Save changes
    }
}


extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    AlbumCreationView()
}

