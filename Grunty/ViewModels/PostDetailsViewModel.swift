//
//  PostDetailsViewModel.swift
//  Grunty
//
//  Created by Andrew Ash on 7/1/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//
//  View model for PostDetailsViewController

import Foundation

/// Notes:
/// I went back and forth about whether this ViewModel should be a class or struct,
///  and went with a class as described here:
///  https://www.swiftbysundell.com/articles/different-flavors-of-view-models-in-swift/
class PostDetailsViewModel {
    private let dataStore: DataStore

    /// is ViewModel waiting for data to load?
    private(set) var isLoading: Bool = false

    /// underlying model objects
    private var post: Post
    private var comments: [PostComment] = []

    /// We call updateHandler when the viewModel changes such that the view needs to be refreshed
    var updateHandler: () -> Void = {}

    /// We call errorHandler when an error needs to be presented to the user
    var errorHandler: (String) -> Void = { (_) in }

    init(dataStore: DataStore, post: Post) {
        self.dataStore = dataStore
        self.post = post
        loadData()
    }

    var postAuthor: String { "Moose #\(post.userId)" }
    var postTitle: String { post.title }
    var postBody: String { post.body }
    var numberOfComments: Int { comments.count }
    var commentsHeading: String { "\(numberOfComments) Comments" }
    var postsByAuthorButtonTitle: String { "More by \(postAuthor)" }

    /// Retrieves a particular PostComment object, or nil if index is invalid
    func comment(at index: Int) -> PostComment? {
        if index >= 0 && index < comments.count {
            let comment = comments[index]
            let formattedComment = PostComment(id: comment.id,
                                               parentPostId: comment.parentPostId,
                                               postedByEmail: "by \(comment.postedByEmail.lowercased())",
                title: comment.title,
                body: comment.body)
            return formattedComment
        }
        return nil
    }

    /// Creates a new view model for PostsTableViewControllers without the
    ///  controller layer having access to this view model's private properties
    func makePostsWithSameAuthorViewModel() -> PostsViewModel? {
        return PostsViewModel(dataStore: dataStore, filterByUserId: post.userId)
    }

    /// When comments fail to load, controller may request another attempt
    func reloadComments() {
        loadData()
    }

    //==========================================================================
    // MARK: Helpers
    //==========================================================================

    /// Retrieve comments and keep track of whether data is still loading
    private func loadData() {
        isLoading = true
        updateHandler()
        dataStore.retrieveComments(forPostId: post.id) { [weak self] result in
            self?.isLoading = false
            switch result {
            case .success(let comments):
                self?.comments = comments
                self?.updateHandler()
            case .failure(let error):
                self?.errorHandler(error.localizedDescription)
            }
        }
    }
}
