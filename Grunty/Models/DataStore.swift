//
//  DataStore.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

class DataStore {    
    static let shared = DataStore()
    let networkManager = NetworkManager()
            
    func retrievePosts(then handler: @escaping (Result<[Post], NetworkManager.ImportError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Load from device storage, when available
            if let posts = CodableStorage.load(Configuration.postsFilename, as: [Post].self) {                
                Utilities.debugLog("Info: Loaded cached posts from disk")
                let sortedPosts = self.sortPosts(posts: posts)
                DispatchQueue.main.async {
                    handler(.success(sortedPosts))
                }
                return
            }
            // Load from remote server
            self.networkManager.importPosts { result in
                switch result {
                case .success(let posts):
                    // Save [Posts] to disk for fast retrieval in future, then pass to handler
                    CodableStorage.save(posts, as: Configuration.postsFilename)
                    let sortedPosts = self.sortPosts(posts: posts)
                    DispatchQueue.main.async {
                        handler(.success(sortedPosts))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        handler(.failure(error))
                    }
                }
            }
        }
    }
    
    func sortPosts(posts: [Post]) -> [Post] {
        return posts.sorted(by: { $0.id < $1.id })
    }
    
    func retrieveComments(forPostId postId: Int, then handler: @escaping (Result<[PostComment], NetworkManager.ImportError>) -> Void) {
        // TODO
    }
    
    /// Resets the database by clearing the app's cache directory
    func reset(completionHandler: (() -> ())?) {
        DispatchQueue.global(qos: .background).async {
            CodableStorage.clear()
            DispatchQueue.main.async {
                completionHandler?()
            }
        }
    }
}