//
//  DiscogsService.swift
//  Statik
//
//  Created by Luca on 01/05/25.
//

import Foundation

struct DiscogsMasterRelease: Codable {
    let title: String
    let year: Int?
    let artists: [DiscogsArtist]
    let genres: [String]
    let styles: [String]?
    let images: [DiscogsImage]?
    let tracklist: [DiscogsTrack]
}

struct DiscogsArtist: Codable {
    let name: String
}

struct DiscogsImage: Codable {
    let uri: String
    let type: String
}

struct DiscogsTrack: Codable {
    let title: String
    let duration: String?
    let position: String?
}

class DiscogsService {
    private let baseURL = "https://api.discogs.com"
    private let token = "SCTuZavpfmnVCmsVaDPajUmnoVCJrlRViwRFPuvE"

    func fetchMasterRelease(id: Int, completion: @escaping (Result<DiscogsMasterRelease, Error>) -> Void) {
        guard let url = URL(string: "\(baseURL)/masters/\(id)") else { return }

        var request = URLRequest(url: url)
        request.setValue("Discogs token=\(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: 0)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(DiscogsMasterRelease.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }
    
    func searchAlbums(query: String, completion: @escaping (Result<[DiscogsSearchResult], Error>) -> Void) {
        var components = URLComponents(string: "\(baseURL)/database/search")!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "type", value: "master")
        ]

        guard let url = components.url else { return }

        var request = URLRequest(url: url)
        request.setValue("Discogs token=\(token)", forHTTPHeaderField: "Authorization")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(NSError(domain: "No data", code: 0)))
                }
                return
            }

            do {
                let decoded = try JSONDecoder().decode(DiscogsSearchResponse.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded.results))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }

        task.resume()
    }

}


