//
//  NetworkManager.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//
//  Retrieve data from remote servers

import Foundation

class NetworkManager {
    let decoder: JSONDecoder = JSONDecoder()
    let urlSession: URLSession

    enum ImportError: String, Error {
        case invalidURL
        case noDataReturned
    }
        
    /// Initialize a NetworkManager
    /// - parameter timeout: By default we set a shorter timeout because the Heroku web service can be unreliable. You can specify your own timeout.
    init(timeout: TimeInterval = TimeInterval(30)) {
    
        let config = URLSessionConfiguration.default
        config.timeoutIntervalForRequest = timeout
        config.timeoutIntervalForResource = timeout
        self.urlSession = URLSession(configuration: config)
    }

    /// Downloads content from REST API with an optional remote URL path parameter, and a completion callback. Results are sorted
    func download<T: Codable & Comparable & RemoteURLProviding>(pathParam: String? = nil, completion: @escaping (Result<[T], Error>) -> Void) {
        guard let url = T.makeRemoteURL(pathParam: pathParam) else {
            Utilities.debugLog("Error: download URL appears to be invalid, cannot download")
            completion(.failure(ImportError.invalidURL))
            return
        }
        urlSession.dataTask(with: url) { (data, _, error) in
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
