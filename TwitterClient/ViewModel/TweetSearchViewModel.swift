//
//  TweetSearchViewModel.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation
import Combine
import UIKit

final class TweetSearchViewModel {
    private let twitterAPIClient: TwitterAPIClientProtocol
    private(set) var snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>()
    private var cancellableSet: Set<AnyCancellable> = []
    private var accessToken: String?

    init(twitterAPIClient: TwitterAPIClientProtocol = TwitterAPIClient()) {
        self.twitterAPIClient = twitterAPIClient
        
        snapshot.appendSections([.main])

        self.twitterAPIClient.getAccessToken()
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // TODO: error handling
                break
                case .finished: break
                }
            }, receiveValue: {
                self.accessToken = $0.accessToken
            })
            .store(in: &cancellableSet)
    }
    
    func search(keyword: String) {
        // TODO: show alert token
        guard let accessToken = accessToken else { return }
        
        self.twitterAPIClient.searchTweetsWithKeyword(accessToken: accessToken, query: keyword)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // TODO: error handling
                break
                case .finished: break
                }
            }, receiveValue: {
                self.snapshot.appendItems($0)
            })
            .store(in: &cancellableSet)
    }
}
