//
//  DataStore.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

class DataStore {
    let networkManager: NetworkManager
    
    var posts: [Post]?                                      /// in-memory cache of posts
    var postCommentsForPostId: [Int: [PostComment]] = [:]   /// in-memory cache of comments retrieved for a given post.id

    init() {
        self.networkManager = NetworkManager()
    }
    
    //==========================================================================
    // MARK: Posts
    //==========================================================================

    // TODO: Try to generalize retrievePosts and retrieveComments, like I did in NetworkManager.swift
    
    func retrievePosts(filterByUserId userId: Int?, then completion: @escaping (Result<[Post], NetworkManager.ImportError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let postsFilter = { (post: Post) -> Bool in
                userId == nil || post.userId == userId
            }
            if let posts = self.posts?.filter(postsFilter) {
                // Loaded posts from memory
                Utilities.debugLog("Info: Loaded cached posts from memory")
                DispatchQueue.main.async {
                    completion(.success(posts))
                }
            } else if let posts: [Post] = CodableStorage.load()?.filter(postsFilter) {
                // Loaded posts from device storage
                self.posts = posts
                Utilities.debugLog("Info: Loaded cached posts from disk")
                DispatchQueue.main.async {
                    completion(.success(posts))
                }
            } else {
                // Worst-case, we load from remote server
                self.networkManager.download { (result: Result<[Post], NetworkManager.ImportError>) in
                    switch result {
                    case .success(let posts):
                        // Save [Posts] to memory and disk for fast retrieval in future, then pass to handler
                        self.posts = posts
                        CodableStorage.save(posts)
                        DispatchQueue.main.async {
                            completion(.success(posts.sorted().filter(postsFilter)))
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
                    }
                }
            }
        }
    }

    

    //==========================================================================
    // MARK: Comments
    //==========================================================================

    func retrieveComments(forPostId postId: Int, then completion: @escaping (Result<[PostComment], NetworkManager.ImportError>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let filename = "\(Configuration.postCommentsFilenamePrefix)\(postId)\(Configuration.postCommentsFilenameSuffix)"
            
            if let postComments = self.postCommentsForPostId[postId] {
                // Loaded postComments from memory
                Utilities.debugLog("Info: Loaded cached comments from memory for postId \(postId)")
                DispatchQueue.main.async {
                    completion(.success(postComments))
                }
            } else if let postComments: [PostComment] = CodableStorage.load(filename: filename) {
                // Loaded postComments from device storage
                // Save [PostComment] to memory for fast retrieval
                self.postCommentsForPostId[postId] = postComments
                Utilities.debugLog("Info: Loaded cached comments from disk for postId \(postId)")
                DispatchQueue.main.async {
                    completion(.success(postComments.sorted()))
                }
            } else {
                // Worst-case, we load from remote server
                self.networkManager.download(pathParam: String(postId)) {
                    (result: Result<[PostComment], NetworkManager.ImportError>) in
                    switch result {
                    case .success(let postComments):
                        // Save [PostComment] to memory and disk for fast retrieval in future, then pass to handler
                        self.postCommentsForPostId[postId] = postComments
                        CodableStorage.save(postComments, as: filename)
                        DispatchQueue.main.async {
                            completion(.success(postComments.sorted()))
                        }
                    case .failure(let error):
                        DispatchQueue.main.async {
                            completion(.failure(error))
                        }
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
            self.posts = nil
            self.postCommentsForPostId = [:]
            CodableStorage.clear()
            DispatchQueue.main.async {
                completionHandler?()
            }
        }
    }
}
