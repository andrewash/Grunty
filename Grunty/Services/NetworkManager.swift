//
//  NetworkManager.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

class NetworkManager {
    let decoder: JSONDecoder = JSONDecoder()
    
    enum ImportError: String, Error, LocalizedError {
        case invalidURL
        case noDataReturned
        
        var localizedDescription: String {
            self.rawValue
        }
    }
        
    /// Downloads content from REST API with an optional remote URL path parameter, and a completion callback. Results are sorted
    func download<T: Codable & Comparable & RemoteURLProviding>(pathParam: String? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        guard let url = T.makeRemoteURL(pathParam: pathParam) else {
            Utilities.debugLog("Error: download URL appears to be invalid, cannot download")
            completion(.failure(ImportError.invalidURL))
            return
        }
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            guard let data = data else {
                completion(.failure(ImportError.noDataReturned))
                return
            }
            do {
                let results = try JSONDecoder().decode([T].self, from: data)
                Utilities.debugLog("Info: Imported JSON from remote API at URL \(url.path)")
                completion(.success(results.sorted()))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
