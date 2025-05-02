//
//  AlbumTabView.swift
//  Statik
//
//  Created by Luca on 01/05/25.
//

import SwiftUI

struct AlbumTabView: View {
    var body: some View {
        TabView {
            AlbumListView()
                .tabItem {
                    Label("My Albums", systemImage: "music.note.list")
                }

            AlbumSearchView()
                .tabItem {
                    Label("Search Discogs", systemImage: "magnifyingglass")
                }
        }
    }
}

#Preview {
    AlbumTabView()
}
