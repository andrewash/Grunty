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
        
    private let decoder = JSONDecoder()
        
    override func setUpWithError() throws {
        super.setUp()
        self.comment = loadTestCommentFromJSON()
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
        
    
    //==========================================================================
    // MARK: Helpers
    //==========================================================================
    
    func loadTestCommentFromJSON() -> PostComment? {
        let bundle = Bundle(for: PostTests.self)
        guard
            let path = bundle.path(forResource: "testPostComment", ofType: "json"),
            let data = try? Data(contentsOf: URL(fileURLWithPath: path)),
            FileManager.default.fileExists(atPath: path) else
        {
            print("Error: Cannot locate or load testPostComment.json")
            return nil
        }
        let decoder = JSONDecoder()
        do {
            return try decoder.decode(PostComment.self, from: data)
        } catch {
            print("Error: Could not decode PostComment test object with error \(error)")
            return nil
        }
    }
}

