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

    //==========================================================================
    // MARK: Posts
    //==========================================================================

    func retrievePosts(filterByUserId userId: Int?, then handler: @escaping (Result<[Post], NetworkManager.ImportError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Load from device storage, when available
            if let posts = CodableStorage.load(Configuration.postsFilename, as: [Post].self) {
                Utilities.debugLog("Info: Loaded cached posts from disk")
                let filteredPosts = self.filterPosts(posts, byUserId: userId)
                let sortedPosts = self.sortPosts(filteredPosts)
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
                    let filteredPosts = self.filterPosts(posts, byUserId: userId)
                    let sortedPosts = self.sortPosts(filteredPosts)
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

    func filterPosts(_ posts: [Post], byUserId userId: Int?) -> [Post] {
        guard let userId = userId else {
            // no filter supplied, so just return all posts
            return posts
        }
        return posts.filter { $0.userId == userId }
    }

    func sortPosts(_ posts: [Post]) -> [Post] {
        return posts.sorted(by: { $0.id < $1.id })
    }

    //==========================================================================
    // MARK: Comments
    //==========================================================================

    func retrieveComments(forPostId postId: Int, then handler: @escaping (Result<[PostComment], NetworkManager.ImportError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            // Load from device storage, when available
            let filename = "\(Configuration.postCommentsFilenamePrefix)\(postId)\(Configuration.postCommentsFilenameSuffix)"
            if let postComments = CodableStorage.load(filename, as: [PostComment].self) {
                Utilities.debugLog("Info: Loaded cached comments from disk for postId \(postId)")
                let sortedComments = self.sortComments(postComments)
                DispatchQueue.main.async {
                    handler(.success(sortedComments))
                }
                return
            }
            // Load from remote server
            self.networkManager.importComments(forPostId: postId) { result in
                switch result {
                case .success(let postComments):
                    // Save [PostComments] to disk for fast retrieval in future, then pass to handler
                    CodableStorage.save(postComments, as: filename)
                    let sortedComments = self.sortComments(postComments)
                    DispatchQueue.main.async {
                        handler(.success(sortedComments))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        handler(.failure(error))
                    }
                }
            }
        }
    }

    func sortComments(_ comments: [PostComment]) -> [PostComment] {
        return comments.sorted(by: { $0.id < $1.id })
    }

    /// Resets the database by clearing the app's cache directory
    func reset(completionHandler: (() -> Void)?) {
        DispatchQueue.global(qos: .background).async {
            CodableStorage.clear()
            DispatchQueue.main.async {
                completionHandler?()
            }
        }
    }
}
