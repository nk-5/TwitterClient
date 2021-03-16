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
    var searchText: String = ""

    private let twitterAPIClient: TwitterAPIClientProtocol
    private(set) var snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>()
    private(set) var dataSourceUpdateSubject = PassthroughSubject<Void, Never>()
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
    
    func search(shouldLoadMoreContent: Bool = false) {
        // TODO: show alert token
        guard let accessToken = accessToken else { return }
     
        saveSearchText()
        
        var maxId: String?
        if shouldLoadMoreContent {
            maxId = snapshot.itemIdentifiers.last?.id
        }
        self.twitterAPIClient.searchTweetsWithKeyword(accessToken: accessToken, query: searchText, maxId: maxId ?? "")
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    // TODO: error handling
                break
                case .finished: break
                }
            }, receiveValue: {
                if !shouldLoadMoreContent {
                    self.snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>()
                    self.snapshot.appendSections([.main])
                }
                self.snapshot.appendItems($0)
                self.dataSourceUpdateSubject.send(())
            })
            .store(in: &cancellableSet)
    }
    
    func clearDataSource() {
        snapshot.deleteAllItems()
        snapshot.appendSections([.main])
        dataSourceUpdateSubject.send(())
    }
    
    private func saveSearchText() {
        UserDefaults.standard.addSearchText(searchText: searchText)
    }
}
