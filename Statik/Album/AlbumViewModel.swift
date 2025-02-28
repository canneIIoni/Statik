//
//  AlbumViewModel.swift
//  Statik
//
//  Created by Luca on 28/02/25.
//


import SwiftData
import SwiftUI

class AlbumViewModel: ObservableObject {
    @Environment(\.modelContext) private var modelContext
    @Query private var albums: [Album] // Fetches data automatically

    func addAlbum(_ album: Album) {
        modelContext.insert(album)
        try? modelContext.save()
    }

    func updateAlbum(_ album: Album) {
        try? modelContext.save() // SwiftData automatically tracks changes
    }

    func deleteAlbum(_ album: Album) {
        modelContext.delete(album)
        try? modelContext.save()
    }
}
