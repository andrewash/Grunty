//
//  PostDetailsViewModel.swift
//  Grunty
//
//  Created by Andrew Ash on 7/1/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

class PostDetailsViewModel {
    private let dataStore: DataStore
    private(set) var isLoading: Bool = false        /// is ViewModel waiting for data to load?
    private var post: Post
    private var comments: [PostComment] = []
    
    var updateHandler: () -> Void = {}
    var errorHandler: (String) -> Void = { (_) in }
    
    init(dataStore: DataStore, post: Post) {
        self.dataStore = dataStore
        self.post = post
        loadData()
    }
        
    var postAuthor: String {
        "Moose #\(post.userId)"
    }
    
    var postTitle: String {
        post.title
    }
    
    var postBody: String {
        post.body
    }
    
    var numberOfComments: Int {
        return comments.count
    }
    
    var commentsHeading: String {
        "\(numberOfComments) Comments"
    }
    
    var postsByAuthorButtonTitle: String {
        "More by \(postAuthor)"
    }
    
    /// Retrieves a particular PostComment object, or nil if index is invalid
    func comment(at index: Int) -> PostComment? {
        if index < comments.count {
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
        return PostsViewModel(dataStore: self.dataStore, filterByUserId: post.userId)
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
    
    func reloadComments() {
        loadData()
    }
}
