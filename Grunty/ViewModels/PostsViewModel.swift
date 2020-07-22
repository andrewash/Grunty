//
//  PostsViewModel.swift
//  Grunty
//
//  Created by Andrew Ash on 7/1/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//
//  View model for PostsTableViewController

import Foundation

/// Notes:
/// I went back and forth about whether this ViewModel should be a class or struct, and went with a class as described here:
///  https://www.swiftbysundell.com/articles/different-flavors-of-view-models-in-swift/
class PostsViewModel {
    private let dataStore: DataStore

    /// which user are we filtering for (if nil, no filter is applied)
    private let filterByUserId: Int?

    /// is ViewModel waiting for data to load?
    private(set) var isLoading: Bool = false

    /// underlying model objects
    private var posts: [Post] = []

    /// PostsViewModel calls updateHandler when the viewModel changes such that the view needs to be refreshed
    var updateHandler: () -> Void = {}

    /// PostsViewModel calls errorHandler when an error needs to be presented to the user
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
        } else if let filteringForUserId = filterByUserId {
            return "Moose #\(filteringForUserId)'s Grunts"
        } else {
            return "Recent \(posts.count) Grunts"
        }
    }

    /// How many posts to show in the view
    var numberOfPosts: Int { posts.count }

    /// We only show the refresh button when viewing all posts
    var isRefreshButtonAvailable: Bool { filterByUserId == nil }

    /// Retrieves a particular Post object, or nil if index is invalid
    func post(at index: Int) -> Post? {
        if index >= 0 && index < posts.count { return posts[index] }
        return nil
    }

    /// Triggers data-layer to clear caches and reload data
    func reset() {
        posts = []
        dataStore.reset { [weak self] in
            self?.loadData()
        }
    }

    /// Creates a new view model for PostDetailsViewControllers without the
    ///  controller layer having access to this view model's private properties
    func makePostDetailsViewModel(at index: Int) -> PostDetailsViewModel? {
        guard let post = post(at: index) else { return nil }
        return PostDetailsViewModel(dataStore: dataStore, post: post)
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
