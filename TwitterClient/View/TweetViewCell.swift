//
//  TweetViewCell.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/13.
//

import UIKit
import Reusable
import SDWebImage

final class TweetViewCell: UICollectionViewListCell, Reusable {
    private var config = UIListContentConfiguration.subtitleCell()
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    func setup(tweet: Tweet) {
        config.text = tweet.tweet
        config.secondaryText = "@\(tweet.screenName) \(dateFormatter.string(from: tweet.createdAt))"

        SDWebImageDownloader.shared.downloadImage(with: tweet.profileIconURL) { [weak self] image, _, error,_ in
            guard let self = self else { return }
            if image == nil || error != nil {
                self.config.image = UIImage(systemName: "person.crop.circle")
            } else {
                self.config.image = image
            }
           
            self.contentConfiguration = self.config
        }
    }
}
