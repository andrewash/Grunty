//
//  DataStore.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

class DataStore {    
    static let shared = DataStore()
    let postsFilename = "posts.json"                    /// stores [Post] for fast retrieval
    let postCommentsFilename = "postComments.json"      /// stores [PostComment] for fast retrieval
    
    
    /// Resets the database by clearing the app's cache directory
    func reset(completionHandler: (() -> ())?) {
        CodableStorage.clear()
        completionHandler?()
    }
}
