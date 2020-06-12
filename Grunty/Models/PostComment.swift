//
//  PostComment.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

// PostComment model
// We store all ids as strings because some systems use alphanumeric ids
struct PostComment: Codable {
    let id: String
    let parentPostId: String
    let postedByEmail: String
    let title: String
    let body: String
}
