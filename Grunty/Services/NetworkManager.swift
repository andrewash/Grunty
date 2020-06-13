//
//  NetworkManager.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

class NetworkManager {
    let remoteBaseURL: URL
    let decoder: JSONDecoder = {
        // we could do custom data formats or other settings for the JSON decoder here
        return JSONDecoder()
    }()
    
    init() {
        guard let remoteBaseURL = URL(string: Configuration.apiBaseUrlString) else {
            fatalError("Error: API base URL appears to be invalid. App cannot start.")
        }
        self.remoteBaseURL = remoteBaseURL
    }
    
    enum ImportError: Error {        
        case dataTaskFailed
        case decodeFailed
        case noDataReturned
    }
        
    func importPosts(then handler: @escaping (Result<[Post], ImportError>) -> Void) {
        let postsUrlPath = "posts"
        let url = self.remoteBaseURL.appendingPathComponent(postsUrlPath)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                handler(.failure(.dataTaskFailed))
                return
            }
            guard let data = data else {
                handler(.failure(.noDataReturned))
                return
            }
            do {
                let posts = try JSONDecoder().decode([Post].self, from: data)
                Utilities.debugLog("Info: Imported posts from remote API")
                handler(.success(posts))
            } catch {
                handler(.failure(.decodeFailed))
            }
        }.resume()
    }
    
    func importComments(forPostId postId: Int, then handler: @escaping (Result<[PostComment], ImportError>) -> Void) {
        let commentsUrlPath = "posts/\(postId)/comments"
        let url = self.remoteBaseURL.appendingPathComponent(commentsUrlPath)
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else {
                handler(.failure(.dataTaskFailed))
                return
            }
            guard let data = data else {
                handler(.failure(.noDataReturned))
                return
            }
            do {
                let comments = try JSONDecoder().decode([PostComment].self, from: data)
                Utilities.debugLog("Info: Imported posts from remote API")
                handler(.success(comments))
            } catch {
                handler(.failure(.decodeFailed))
            }
        }.resume()
    }
}
