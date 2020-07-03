//
//  Configuration.swift
//  Grunty
//
//  Created by Andrew Ash on 6/13/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//
//  Store various hard-coded URLs and config information

import Foundation

struct Configuration {
    /// Remote REST API base URL
    static let apiBaseUrl = URL(string: "https://jsonplaceholder.typicode.com/")

    /// Filename prefix for storing [PostComment] in device storage
    static let postCommentsFilenamePrefix = "postComments"

    /// Filename suffix for storing [PostComment] in device storage
    static let postCommentsFilenameSuffix = ".json"
}
