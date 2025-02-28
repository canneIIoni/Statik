//
//  AlbumReviewView.swift
//  Statik
//
//  Created by Luca on 28/02/25.
//

import SwiftUI

struct AlbumReviewView: View {
    @Environment(\.modelContext) private var modelContext
    @State var album: Album
    
    var body: some View {
        TextField("Write a review...", text: $album.review)
            .textFieldStyle(.roundedBorder)
            .padding()
    }
}

