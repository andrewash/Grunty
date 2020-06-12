//
//  Post.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

// Post model
// We store all ids as strings because some systems use alphanumeric ids
struct Post: Codable {
    let id: String
    let userId: String
    let title: String
    let body: String
}
