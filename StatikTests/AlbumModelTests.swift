//
//  AlbumModelTests.swift
//  StatikTests
//
//  Created by You on 02/05/25.
//


import XCTest
import SwiftData
import UIKit
@testable import Statik

@available(iOS 17.0, *)
@MainActor
final class AlbumModelTests: XCTestCase {
    var container: ModelContainer!

    override func setUpWithError() throws {
        // Use the default store (no inMemory) per project requirements
        container = try ModelContainer(for: Album.self, Song.self)
    }

    override func tearDownWithError() throws {
        container = nil
    }

    // MARK: — Model Logic
    
    /*
     Checks:
     
     - That any input below 0 gets clamped up to 0.
     - That any input above 5 gets clamped down to 5.
     - That a value already in the valid range remains unchanged.
     */

    func testGradeIsClampedBetweenZeroAndFive() {
        let below = Album(
            name: "A",
            artist: "B",
            year: "2020",
            review: "",
            isLiked: false,
            grade: -3,
            image: nil,
            songs: [],
            dateLogged: Date()
        )
        XCTAssertEqual(below.grade, 0)

        let above = Album(
            name: "A",
            artist: "B",
            year: "2020",
            review: "",
            isLiked: false,
            grade: 7,
            image: nil,
            songs: [],
            dateLogged: Date()
        )
        XCTAssertEqual(above.grade, 5)

        let valid = Album(
            name: "A",
            artist: "B",
            year: "2020",
            review: "",
            isLiked: false,
            grade: 4.2,
            image: nil,
            songs: [],
            dateLogged: Date()
        )
        XCTAssertEqual(valid.grade, 4.2)
    }
    
    /*
     Checks:
     
     - That imageData is non‑nil (i.e. your jpegData(compressionQuality:) call stored something).
     - That albumImage is non‑nil (i.e. decoding the stored data back into a UIImage works).
     */

    func testAlbumImageRoundTripsThroughData() {
        // Draw a 1x1 red image
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: 1, height: 1))
        let redDot = renderer.image { ctx in
            UIColor.red.setFill()
            ctx.fill(CGRect(origin: .zero, size: CGSize(width: 1, height: 1)))
        }

        let album = Album(
            name: "X",
            artist: "Y",
            year: "2021",
            review: "",
            isLiked: false,
            grade: 3,
            image: redDot,
            songs: [],
            dateLogged: Date()
        )

        XCTAssertNotNil(album.imageData)
        XCTAssertNotNil(album.albumImage)
    }

}


