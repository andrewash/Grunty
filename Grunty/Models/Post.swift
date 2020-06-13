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
    let id: Int
    let userId: Int
    let title: String
    let body: String
}
