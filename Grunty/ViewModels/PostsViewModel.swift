//
//  PostsViewModel.swift
//  Grunty
//
//  Created by Andrew Ash on 7/1/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

class PostsViewModel {
    private let dataStore: DataStore
    private let filterByUserId: Int?                /// which user are we filtering for (if nil, no filter is applied)
    private(set) var isLoading: Bool = false        /// is ViewModel waiting for data to load?
    private var posts: [Post] = []
    
    var updateHandler: () -> Void = {}
    var errorHandler: (String) -> Void = { (_) in }
        
    init(dataStore: DataStore, filterByUserId: Int? = nil) {
        self.dataStore = dataStore
        self.filterByUserId = filterByUserId
        loadData()
    }

    /// Title shown in navigation bar. It's a function of the current state of this view model
    var titleForScreen: String {
        if isLoading {
            return "Loading Grunts..."
        } else if let filteringForUserId = self.filterByUserId {
            return "Moose #\(filteringForUserId)'s Grunts"
        } else {
            return "Recent \(posts.count) Grunts"
        }
    }
    
    var numberOfPosts: Int {
        return posts.count
    }
        
    /// We only show the refresh button when viewing all posts
    var isRefreshButtonAvailable: Bool { filterByUserId == nil }
    
    /// Retrieves a particular Post object, or nil if index is invalid
    func post(at index: Int) -> Post? {
        if index < posts.count { return posts[index] }
        return nil
    }
    
    /// Triggers data-layer to clear caches and reload data
    func reset() {
        self.posts = []
        dataStore.reset { [weak self] in
            self?.loadData()
        }
    }
    
    /// Creates a new view model for PostDetailsViewControllers without the
    ///  controller layer having access to this view model's private properties
    func makePostDetailsViewModel(at index: Int) -> PostDetailsViewModel? {
        guard let post = post(at: index) else { return nil }
        return PostDetailsViewModel(dataStore: self.dataStore, post: post)
    }
    
    
    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    
    /// Retrieve posts and keep track of whether data is still loading
    private func loadData() {
        isLoading = true
        updateHandler()
        dataStore.retrievePosts(filterByUserId: filterByUserId) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let posts):
                self?.posts = posts
                self?.updateHandler()
            case .failure(let error):
                self?.errorHandler(error.localizedDescription)
            }
        }
    }
}
