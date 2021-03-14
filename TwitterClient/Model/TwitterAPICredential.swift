//
//  TwitterAPICredential.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation

struct TwitterOAuthTokenResponse: Decodable {
    let tokenType: String
    let accessToken: String
}
