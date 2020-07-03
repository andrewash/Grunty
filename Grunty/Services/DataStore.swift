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

    /// For testing, you can init a DataStore with mock objects
    convenience init(mockPosts: [Post], mockPostCommentsForPostId: [Int: [PostComment]]) {
        self.init()
        self.posts = mockPosts
        self.postCommentsForPostId = mockPostCommentsForPostId
    }

    /// Retrieves an array of objects of type T from disk, or if not cached on disk retrieves from network
    /// - parameter filter: filters objects before passing them to completion closure, if specified
    /// - parameter pathParam: URL parameter to include with network request, if required
    /// - parameter diskCacheFilename: specifies a filename for disk storage of this object, otherwise the filename is determined by CodableStorage
    private func retrieve<T: Codable & Comparable & RemoteURLProviding>(diskCacheFilename filename: String? = nil, pathParam: String? = nil, filter: @escaping ((T) -> Bool) = { _ in true }, completion: @escaping (Result<[T], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            // First we try loading from disk
            if let onDisk: [T] = CodableStorage.load(filename: filename)?.filter(filter) {
                Utilities.debugLog("Info: Loaded cached \(String(describing: T.self).lowercased())s from disk")
                DispatchQueue.main.async {
                    completion(.success(onDisk))
                }
                return
            }
            // Worst-case, we load from remote server
            self.networkManager.download(pathParam: pathParam) { (result: Result<[T], Error>) in
                switch result {
                case .success(let objects):
                    // Save objects to disk for fast retrieval in future, then pass to handler
                    CodableStorage.save(objects, as: filename)
                    DispatchQueue.main.async {
                        completion(.success(objects.sorted().filter(filter)))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        completion(.failure(error))
                    }
                }
            }
        }
    }

    /// Retrieves posts from memory, disk, or remote network
    func retrievePosts(filterByUserId userId: Int?, then completion: @escaping (Result<[Post], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let postsFilter = { (post: Post) -> Bool in
                userId == nil || post.userId == userId
            }
            // Load posts from memory, if available
            if let posts = self.posts?.sorted().filter(postsFilter) {
                Utilities.debugLog("Info: Loaded cached poosts from memory")
                DispatchQueue.main.async {
                    completion(.success(posts))
                }
                return
            }

            // Otherwise, load posts from disk or network, then save result to memory
            self.retrieve(filter: postsFilter) { result in
                switch result {
                case .success(let posts):
                    self.posts = posts
                default:
                    break
                }
                completion(result)
            }
        }
    }

    /// Retrieves comments from memory, disk, or remote network
    func retrieveComments(forPostId postId: Int, then completion: @escaping (Result<[PostComment], Error>) -> Void) {
        DispatchQueue.global(qos: .background).async {
            let filename = "\(Configuration.postCommentsFilenamePrefix)\(postId)\(Configuration.postCommentsFilenameSuffix)"
            // Load comments from memory, if available
            if let postComments = self.postCommentsForPostId[postId] {
                Utilities.debugLog("Info: Loaded cached postcomments from memory for postId \(postId)")
                DispatchQueue.main.async {
                    completion(.success(postComments))
                }
                return
            }

            // Otherwise, load comments from disk or network, then save result to memory
            self.retrieve(diskCacheFilename: filename, pathParam: String(postId)) { (result: Result<[PostComment], Error>) in
                switch result {
                case .success(let comments):
                    self.postCommentsForPostId[postId] = comments
                default:
                    break
                }
                completion(result)
                return
            }
        }
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
