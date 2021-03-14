//
//  MockTwitterAPIClient.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation
import Combine

struct MockTwitterAPIClient: TwitterAPIClientProtocol {
    func getAccessToken() -> Future<TwitterOAuthTokenResponse, TwitterAPIError> {
        return Future<TwitterOAuthTokenResponse, TwitterAPIError> { promise in
            let jsonString = MockTwitterAPIResponseData.oauth2Token
            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            guard let oAuthToken = try? jsonDecoder.decode(TwitterOAuthTokenResponse.self, from: jsonString.data(using: .utf8)!) else {
                promise(.failure(.decodeError))
                return
            }

            promise(.success(oAuthToken))
        }
    }
    
    func searchTweetsWithKeyword(accessToken: String, query: String) -> Future<[Tweet], TwitterAPIError> {
        return Future<[Tweet], TwitterAPIError> { promise in
            let jsonString = MockTwitterAPIResponseData.search
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"

            let jsonDecoder = JSONDecoder()
            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
            guard let twitterAPISearchResponse = try? jsonDecoder.decode(TwitterAPISearchResponse.self, from: jsonString.data(using: .utf8)!) else {
                promise(.failure(.decodeError))
                return
            }
            
            let tweets = twitterAPISearchResponse.statuses.compactMap {
                Tweet(tweet: $0.text,
                      userName: $0.user.name,
                      screenName: $0.user.screenName,
                      createdAt: $0.createdAt,
                      profileIconURL: $0.user.profileImageUrlHttps)
            }
            promise(.success(tweets))
        }
    }
}
