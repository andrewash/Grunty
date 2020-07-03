//
//  PostDetailsViewModelTests.swift
//  GruntyTests
//
//  Created by Andrew Ash on 7/2/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import XCTest
@testable import Grunty

class PostDetailsViewModelTests: XCTestCase {
    private var dataStore: DataStore!
    private var post: Post!

    override func setUpWithError() throws {
        super.setUp()
        // Initialize DataStore with mock data
        let post: Post? = TestUtilities.loadObjectFromJSON(filename: "testPost")
        let postComments: [PostComment]? = TestUtilities.loadObjectFromJSON(filename: "testPostComments")
        guard let p = post, let comments = postComments else {
            XCTFail("Error: No mock data available to initialize DataStore, test fails")
            return
        }
        var postCommentsHash: [Int: [PostComment]] = [:]
        postCommentsHash[p.id] = comments
        dataStore = DataStore(mockPosts: [p], mockPostCommentsForPostId: postCommentsHash)
        self.post = p
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        dataStore = nil
    }

    func testPostAuthor() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostDetailsViewModel(dataStore: dataStore, post: post)
        viewModel.updateHandler = {
            XCTAssertEqual(viewModel.postAuthor, "Moose #1", "Incorrect postAuthor")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testPostTitle() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostDetailsViewModel(dataStore: dataStore, post: post)
        viewModel.updateHandler = {
            XCTAssertEqual(viewModel.postTitle, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit", "Incorrect postTitle")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testPostBody() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostDetailsViewModel(dataStore: dataStore, post: post)
        viewModel.updateHandler = {
            XCTAssertEqual(viewModel.postBody, "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto", "Incorrect postBody")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testNumberOfComments() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostDetailsViewModel(dataStore: dataStore, post: post)
        viewModel.updateHandler = {
            XCTAssertEqual(viewModel.numberOfComments, 5, "Incorrect number of comments")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testCommentsHeading() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostDetailsViewModel(dataStore: dataStore, post: post)
        viewModel.updateHandler = {
            XCTAssertEqual(viewModel.commentsHeading, "5 Comments", "Incorrect comments heading")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testPostsByAuthorButtonTitle() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostDetailsViewModel(dataStore: dataStore, post: post)
        viewModel.updateHandler = {
            XCTAssertEqual(viewModel.postsByAuthorButtonTitle, "More by Moose #1", "Incorrect postsByAuthorButtonTitle")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testCommentForIndex() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostDetailsViewModel(dataStore: dataStore, post: post)
        viewModel.updateHandler = {
            let comment = viewModel.comment(at: 4)
            XCTAssertEqual(comment?.id, 5, "Incorrect comment or none retrieved")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testCommentForIndexOutOfBounds() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostDetailsViewModel(dataStore: dataStore, post: post)
        viewModel.updateHandler = {
            let comment = viewModel.comment(at: 10)
            XCTAssertNil(comment, "There should be no comments retrieved")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testMakeModel() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostDetailsViewModel(dataStore: dataStore, post: post)
        viewModel.updateHandler = {
            let siblingViewModel =
            viewModel.makePostsWithSameAuthorViewModel()
            siblingViewModel?.updateHandler = {
                XCTAssertEqual(siblingViewModel?.numberOfPosts, 1, "Sibling view model does not appear to be correct")
                expect.fulfill()
            }
        }
        defaultWaitForExpectations()
    }

    //==========================================================================
    // MARK: Helpers
    //==========================================================================

    func defaultWaitForExpectations() {
        waitForExpectations(timeout: 15) { (error) in
            if let error = error {
              XCTFail("Test timed out with error: \(error.localizedDescription)")
            }
        }
    }
}
