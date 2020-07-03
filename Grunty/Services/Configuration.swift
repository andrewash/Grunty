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
    static let apiBaseUrl = URL(string: "https://jsonplaceholder.typicode.com/")
    static let postCommentsFilenamePrefix = "postComments"      /// stores [PostComment] in device storage for fast retrieval
    static let postCommentsFilenameSuffix = ".json"
}
