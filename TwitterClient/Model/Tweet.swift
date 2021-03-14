//
//  Tweet.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/13.
//

import Foundation

struct Tweet: Hashable {
    let tweet: String
    let userName: String
    let screenName: String
    let createdAt: Date
    let profileIconURL: URL?
}
