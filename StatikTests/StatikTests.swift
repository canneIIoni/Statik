//
//  StatikTests.swift
//  StatikTests
//
//  Created by Luca on 28/02/25.
//

import Testing
@testable import Statik

struct StatikTests {
    
    // MARK: - Discogs API tests

    @Test func testSearchAlbums() async throws {
        let json = """
        {
            "results": [
                {
                    "id": 123,
                    "title": "Artist - Album Title",
                    "year": "2000",
                    "type": "master",
                    "thumb": "thumb.jpg",
                    "cover_image": "cover.jpg",
                    "artist": "Artist"
                }
            ]
        }
        """.data(using: .utf8)!

        let service = DiscogsService(session: MockSession(mockData: json))
        let results = try await service.searchAlbums(query: "Album Title")

        #expect(results.count == 1)
        #expect(results.first?.name == "Album Title")
        #expect(results.first?.artistName == "Artist")
    }
    
    @Test func testFetchMasterRelease() async throws {
        let json = """
        {
            "title": "Album Title",
            "year": 2000,
            "artists": [{ "name": "Artist Name" }],
            "genres": ["Rock"],
            "styles": ["Alternative Rock"],
            "images": [{ "uri": "https://example.com/image.jpg", "type": "primary" }],
            "tracklist": [
                { "title": "Track One", "duration": "3:45", "position": "A1" },
                { "title": "Track Two", "duration": "4:20", "position": "A2" }
            ]
        }
        """.data(using: .utf8)!

        let service = DiscogsService(session: MockSession(mockData: json))
        let release = try await service.fetchMasterRelease(id: 123)

        #expect(release.title == "Album Title")
        #expect(release.year == 2000)
        #expect(release.artists.first?.name == "Artist Name")
        #expect(release.genres.contains("Rock"))
        #expect(release.styles?.contains("Alternative Rock") == true)
        #expect(release.tracklist.count == 2)
        #expect(release.tracklist.first?.title == "Track One")
    }

}

