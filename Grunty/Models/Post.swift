//
//  Post.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

// Post model
struct Post: Codable {
    let id: String      /// we use strings for ids because some APIs use alphanumeric ids
    let userId: String
    let title: String
    let body: String
}
