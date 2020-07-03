//
//  NetworkManagerTests.swift
//  GruntyTests
//
//  Created by Andrew Ash on 6/14/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import XCTest
@testable import Grunty

class NetworkManagerTests: XCTestCase {
    let networkManager = NetworkManager()

    func testExpectedNumberOfPostsRetrieved() {
        let expect = expectation(description: "loading posts")
        networkManager.download { (result: Result<[Post], Error>) in
            switch result {
            case .failure(let error):
                XCTFail("Import posts failed with error \(error)")
            case .success(let posts):
                XCTAssertEqual(posts.count, 100, "An unexpected number of posts was received from the server")
            }
            expect.fulfill()
        }
        defaultWaitForExpectations()
    }

    func testExpectedNumberOfCommentsRetrieved() {
        let expect = expectation(description: "loading comments")
        networkManager.download(pathParam: String(3)) { (result: Result<[PostComment], Error>) in
            switch result {
            case .failure(let error):
                XCTFail("Import comments failed with error \(error)")
            case .success(let comments):
                XCTAssertEqual(comments.count, 5, "An unexpected number of comments was received from the server")
            }
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
