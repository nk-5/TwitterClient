//
//  TwitterAPIClientProtocol.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation
import Combine

protocol TwitterAPIClientProtocol {
    func getAccessToken() -> Future<TwitterOAuthTokenResponse, TwitterAPIError>
    func searchTweetsWithKeyword(accessToken: String, query: String, maxId: String) -> Future<[Tweet], TwitterAPIError>
}

