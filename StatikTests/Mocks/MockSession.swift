//
//  MockSession.swift
//  Statik
//
//  Created by Luca on 02/05/25.
//


import Foundation
@testable import Statik

class MockSession: NetworkSession {
    var mockData: Data
    var mockResponse: URLResponse = HTTPURLResponse(
        url: URL(string: "https://api.discogs.com")!,
        statusCode: 200, httpVersion: nil, headerFields: nil)!

    init(mockData: Data) {
        self.mockData = mockData
    }

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        return (mockData, mockResponse)
    }
}
