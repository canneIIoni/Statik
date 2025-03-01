//
//  AddSongView.swift
//  Statik
//
//  Created by Luca on 01/03/25.
//

import SwiftUI

struct AddSongView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var title: String = ""
    @State private var trackNumber: String = ""
    @State private var isLiked: Bool = false
    @State private var grade: Double = 0.0
    @State private var review: String = ""

    var onAdd: (Song) -> Void

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Song Details")) {
                    TextField("Title", text: $title)
                    TextField("Track Number", text: $trackNumber)
                        .keyboardType(.numberPad)
                }
            }
            .navigationTitle("Add Song")
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
                        
                    } label: {
                        Text("Save")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.systemRed)
                    }
                    .disabled(title.isEmpty || trackNumber.isEmpty)
                }
            }
        }
    }
}
