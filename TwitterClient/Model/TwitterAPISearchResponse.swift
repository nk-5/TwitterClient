//
//  TwitterAPISearchResponse.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation

struct TwitterAPISearchResponse: Decodable {
    let statuses: [Status]

    struct Status: Decodable {
        let text: String
        let createdAt: Date
        let user: User
        
        struct User: Decodable {
            let name: String
            let screenName: String
            let profileImageUrlHttps: URL
        }
    }
}
