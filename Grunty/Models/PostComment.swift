//
//  PostComment.swift
//  Grunty
//
//  Created by Andrew Ash on 6/12/20.
//  Copyright © 2020 Andrew Ash. All rights reserved.
//

import Foundation

// PostComment model
struct PostComment {
    let id: Int
    let parentPostId: Int
    let postedByEmail: String
    let title: String
    let body: String
}

extension PostComment: Comparable, Equatable {
    static func == (lhs: PostComment, rhs: PostComment) -> Bool {
        lhs.id == rhs.id
    }

    static func < (lhs: PostComment, rhs: PostComment) -> Bool {
        lhs.id < rhs.id
    }
}

extension PostComment: Codable {
    // custom mapping of API's keys to clearer names for our iOS data model
    // "name" is particularly ambiguous. The sample values are far too long for a human name, so I've assumed it's the name of a post, i.e. "title".
    enum CodingKeys: String, CodingKey {
        case id
        case body
        case parentPostId = "postId"
        case title = "name"
        case postedByEmail = "email"
    }
}

extension PostComment: RemoteURLProviding {
    static func makeRemoteURL(pathParam: String?) -> URL? {
        guard let pathParam = pathParam else { return nil }
        let commentsUrlPath = "posts/\(pathParam)/comments"
        return Configuration.apiBaseUrl?.appendingPathComponent(commentsUrlPath)
    }
}

extension PostComment: CustomStringConvertible {
    var description: String {
        return "postComment"
    }
}
