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

    private let decoder = JSONDecoder()

    override func setUpWithError() throws {
        super.setUp()
        self.post = loadTestPostFromJSON()
    }

    func testImportCorrect() {
        guard let post = self.post else {
            XCTFail("Error: No mock post available, test fails")
            return
        }
        XCTAssertTrue(post.userId == 10 &&
            post.id == 98 &&
            post.title == "laboriosam dolor voluptates" &&
            post.body == "doloremque ex facilis sit sint culpa\nsoluta assumenda eligendi non ut eius\nsequi ducimus vel quasi\nveritatis est dolores",
                      "Error: post not imported correctly")
    }

    //==========================================================================
    // MARK: Helpers
    //==========================================================================

    func loadTestPostFromJSON() -> Post? {
        let bundle = Bundle(for: PostTests.self)
        guard
            let path = bundle.path(forResource: "testPost", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            FileManager.default.fileExists(atPath: path) else
        {
            print("Error: Cannot locate or load testPost.json")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(Post.self, from: data)
        } catch {
            print("Error: Could not decode Post test object with error \(error)")
            return nil
        }
    }
}
