//
//  AlbumRequest.swift
//  AppleMusic
//
//  Created by Lambda_School_Loaner_56 on 11/4/19.
//  Copyright © 2019 David Flack. All rights reserved.
//

import Foundation
import UIKit

enum NetworkError: Error {
    case noDataAvailable
    case canNotProcessData
}
class AlbumRequest {
    let baseURL = URL(string: "https://rss.itunes.apple.com/api/v1/us/apple-music/top-albums/all/")!
    
    func getXTopAlbums(_ count: String, completion: @escaping(Result<[AlbumDetail], NetworkError>) -> Void) {
        let reqURL = baseURL
            .appendingPathComponent(count)
            .appendingPathComponent("non-explicit")
            .appendingPathExtension("json")
        URLSession.shared.dataTask(with: reqURL) { data, _, _ in
            guard let jsonData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let albumsResponse = try decoder.decode(AlbumResponse.self, from: jsonData)
                let albumDetails = albumsResponse.feed.results
                completion(.success(albumDetails))
            } catch {
                completion(.failure(.canNotProcessData))
            }
        }.resume()
    }
    
    func getImage(at url: URL, completion: @escaping(Result<UIImage, NetworkError>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let imageData = data else {
                completion(.failure(.noDataAvailable))
                return
            }
            guard let image = UIImage(data: imageData) else {
                completion(.failure(.canNotProcessData))
                return
            }
            completion(.success(image))
        }.resume()
    }
}
