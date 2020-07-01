//
//  RemoteURLProviding.swift
//  Grunty
//
//  Created by Andrew Ash on 6/30/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

/// A type that can provide a remote URL for its retrieval
protocol RemoteURLProviding {
    /// pathParam is an optional single path parameter that the type will insert into the remote URL appropriately
    /// ex. postId in a PostComment URL
    static func makeRemoteURL(pathParam: String?) -> URL?
}
