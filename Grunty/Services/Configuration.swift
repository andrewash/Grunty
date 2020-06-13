//
//  Configuration.swift
//  Grunty
//
//  Created by Andrew Ash on 6/13/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//
//  Store various hard-coded URLs and config information

import Foundation

class Configuration {
    static let apiBaseUrlString = "https://jsonplaceholder.typicode.com/"
    static let postsFilename = "posts.json"                    /// stores [Post] in device storage for fast retrieval
    static let postCommentsFilename = "postComments.json"      /// stores [PostComment] in device storage for fast retrieval    
}
