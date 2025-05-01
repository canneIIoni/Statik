//
//  StatikApp.swift
//  Statik
//
//  Created by Luca on 28/02/25.
//

import SwiftUI
import SwiftData

@main
struct StatikApp: App {
    var body: some Scene {
        WindowGroup {
            AlbumTabView()
        }
        .modelContainer(for: Album.self) 
    }
}
