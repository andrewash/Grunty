//
//  PostsViewModelTests.swift
//  GruntyTests
//
//  Created by Andrew Ash on 7/2/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import XCTest
@testable import Grunty

class PostsViewModelTests: XCTestCase {
    private var dataStore: DataStore!

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
    }

    override func tearDownWithError() throws {
        try super.tearDownWithError()
        dataStore = nil
    }

    func testTitleDefault() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostsViewModel(dataStore: dataStore)
        viewModel.updateHandler = {
            XCTAssertEqual(viewModel.titleForScreen, "Recent 1 Grunts", "Incorrect title")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testTitleForFilteredViewModel() {
        let expect = expectation(description: "loading view model's data")
        let filteringForUserId = 1
        let viewModel = PostsViewModel(dataStore: dataStore, filterByUserId: filteringForUserId)
        viewModel.updateHandler = {
            XCTAssertEqual(viewModel.titleForScreen, "Moose #\(filteringForUserId)'s Grunts", "Incorrect title when viewModel is filtered")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testNumberOfPosts() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostsViewModel(dataStore: dataStore)
        viewModel.updateHandler = {
            XCTAssertEqual(viewModel.numberOfPosts, 1, "Wrong number of posts")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testRefreshButtonDefaultViewModel() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostsViewModel(dataStore: dataStore)
        viewModel.updateHandler = {
            XCTAssertTrue(viewModel.isRefreshButtonAvailable, "Refresh button should be available but is not")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testRefreshButtonWhenViewModelFiltered() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostsViewModel(dataStore: dataStore, filterByUserId: 1)
        viewModel.updateHandler = {
            XCTAssertFalse(viewModel.isRefreshButtonAvailable, "Refresh button is available when it should be hidden")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testPostForIndex() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostsViewModel(dataStore: dataStore)
        viewModel.updateHandler = {
            let post = viewModel.post(at: 0)
            XCTAssertEqual(post?.id, 1, "Incorrect post or none retrieved")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testPostForIndexOutOfBounds() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostsViewModel(dataStore: dataStore)
        viewModel.updateHandler = {
            let post = viewModel.post(at: 10)
            XCTAssertNil(post, "There should be no posts retrieved")
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testMakeModel() {
        let expect = expectation(description: "loading view model's data")
        let viewModel = PostsViewModel(dataStore: dataStore)
        viewModel.updateHandler = {
            let siblingViewModel = viewModel.makePostDetailsViewModel(at: 0)
            XCTAssertEqual(siblingViewModel?.postTitle, "sunt aut facere repellat provident occaecati excepturi optio reprehenderit", "Sibling view model does not appear to be correct")
            expect.fulfill()
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
