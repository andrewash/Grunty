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

extension Post: Comparable, Equatable {
    static func == (lhs: Post, rhs: Post) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: Post, rhs: Post) -> Bool {
        lhs.id < rhs.id
    }
}

extension Post: RemoteURLProviding {
    static func makeRemoteURL(pathParam: String?) -> URL? {
        return Configuration.apiBaseUrl?.appendingPathComponent("posts")
    }
}

extension Post: CustomStringConvertible {
    var description: String {
        return "post"
    }
}
