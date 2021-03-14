//
//  TwitterAPIClient.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation
import Combine
import Alamofire

// refs: https://developer.twitter.com/en/docs/twitter-api
final class TwitterAPIClient: TwitterAPIClientProtocol {
    private let endpoint = "https://api.twitter.com/"
    private var encodedCredentialToken: String = ""
    private var cancellableSet: Set<AnyCancellable> = []
    
    init(encodedCredentialToken: String? = nil) {
        if let token = encodedCredentialToken {
            self.encodedCredentialToken = token
            return
        }
        
        guard let path = Bundle.main.path(forResource: "TwitterAPIConfig", ofType: "txt") else {
            precondition(false, "TwitterAPIConfig file not found and need encoded token from consumer key and secret. try make TWITTER_CREDENTIAL_TOKEN=[encoded token]")
        }
        
        do {
            let tmpToken  = try String(contentsOfFile: path, encoding: .utf8)
            self.encodedCredentialToken = tmpToken.components(separatedBy: "\n")[0]
        } catch {
            precondition(false, "\(error)")
        }
    }
    
    func getAccessToken() -> Future<TwitterOAuthTokenResponse, TwitterAPIError> {
        let param: [String: String] = ["grant_type": "client_credentials"]
        let headers: HTTPHeaders = [
            "Authorization": "Basic " + encodedCredentialToken,
            "Content-Type": "application/x-www-form-urlencoded;charset=UTF-8"
        ]

        return Future<TwitterOAuthTokenResponse, TwitterAPIError> { promise in
            APIClient.shared.request(url: self.endpoint + "oauth2/token", method: .post, param: param, headers: headers)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .failure(let error):
                                promise(.failure(.getFailed))
                            case .finished: break
                            }
                        }, receiveValue: {
                            let jsonDecoder = JSONDecoder()
                            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                            guard let data = $0,
                                  let oAuthToken = try? jsonDecoder.decode(TwitterOAuthTokenResponse.self, from: data) else {
                                promise(.failure(.decodeError))
                                return
                            }
                            promise(.success(oAuthToken))
                        })
                .store(in: &self.cancellableSet)
        }
    }
    
    func searchTweetsWithKeyword(accessToken: String, query: String) -> Future<[Tweet], TwitterAPIError> {
        let param: [String: String] = [
            "q": query,
            "include_entities": "false"
        ]
        let headers: HTTPHeaders = [
            "Authorization": "Bearer " + accessToken
        ]
        
        return Future<[Tweet], TwitterAPIError> { promise in
            APIClient.shared.request(url: self.endpoint + "1.1/search/tweets.json", param: param, headers: headers)
                        .sink(receiveCompletion: { completion in
                            switch completion {
                            case .failure(let error):
                                promise(.failure(.getFailed))
                            case .finished: break
                            }
                        }, receiveValue: {
                            let jsonDecoder = JSONDecoder()
                            let dateFormatter = DateFormatter()
                            dateFormatter.dateFormat = "E MMM d HH:mm:ss Z yyyy"
                            jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
                            jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
                            
                            guard let data = $0, let twitterAPISearchResponse = try? jsonDecoder.decode(TwitterAPISearchResponse.self, from: data) else {
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
                        })
                .store(in: &self.cancellableSet)
        }
    }
}
