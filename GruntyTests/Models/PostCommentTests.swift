//
//  PostCommentTests.swift
//  GruntyTests
//
//  Created by Andrew Ash on 6/14/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import XCTest
@testable import Grunty

class PostCommentTests: XCTestCase {
    var comment: PostComment?

    override func setUpWithError() throws {
        super.setUp()
        self.comment = TestUtilities.loadObjectFromJSON(filename: "testPostComment")
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        self.comment = nil
    }

    func testImportCorrect() {
        guard let comment = self.comment else {
            XCTFail("Error: No mock comment available, test fails")
            return
        }
        XCTAssertTrue(comment.parentPostId == 3 &&
            comment.id == 14 &&
            comment.title == "et officiis id praesentium hic aut ipsa dolorem repudiandae" &&
            comment.postedByEmail == "Nathan@solon.io" &&
            comment.body == "vel quae voluptas qui exercitationem\nvoluptatibus unde sed\nminima et qui ipsam aspernatur\nexpedita magnam laudantium et et quaerat ut qui dolorum",
                      "Error: comment not imported correctly")
    }
}
