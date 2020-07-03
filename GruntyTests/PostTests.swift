//
//  PostTests.swift
//  GruntyTests
//
//  Created by Andrew Ash on 6/14/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import XCTest
@testable import Grunty

class PostTests: XCTestCase {
    var post: Post?

    override func setUpWithError() throws {
        super.setUp()
        self.post = TestUtilities.loadObjectFromJSON(filename: "testPost")
    }

    func testImportCorrect() {
        guard let post = self.post else {
            XCTFail("Error: No mock post available, test fails")
            return
        }
        XCTAssertTrue(post.userId == 1 &&
            post.id == 1 &&
            post.title == "sunt aut facere repellat provident occaecati excepturi optio reprehenderit" &&
            post.body == "quia et suscipit\nsuscipit recusandae consequuntur expedita et cum\nreprehenderit molestiae ut ut quas totam\nnostrum rerum est autem sunt rem eveniet architecto",
                      "Error: post not imported correctly")
    }
}
