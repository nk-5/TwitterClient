//
//  TweetViewCell.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/13.
//

import UIKit
import Reusable
import SDWebImage
import PinLayout

final class TweetViewCell: UITableViewCell, Reusable {
    private let userIconView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 4
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let tweetLabel: UILabel = {
       let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private let userNameLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let tweetCreatedAtLabel: UILabel = {
       let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        return formatter
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(userIconView)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(tweetCreatedAtLabel)
        contentView.addSubview(tweetLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
         super.layoutSubviews()

         setupLayout()
     }
    
    func setup(tweet: Tweet) {
        userIconView.image = nil
        
        userIconView.sd_setImage(with: tweet.profileIconURL)
        userNameLabel.text = tweet.userName
        tweetCreatedAtLabel.text = dateFormatter.string(from: tweet.createdAt)
        tweetLabel.text = tweet.tweet
    }
    

    private func setupLayout() {
        userIconView.pin.topLeft(4).size(40)
        userNameLabel.pin.top(4).right(of: userIconView, aligned: .top).marginLeft(8).minWidth(10).sizeToFit(.widthFlexible)
        tweetCreatedAtLabel.pin.right(of: userNameLabel).top(4).marginLeft(8).minWidth(10).sizeToFit(.widthFlexible)
        tweetLabel.pin.below(of: userNameLabel).right(of: userIconView).right().margin(4, 8, 4, 4).sizeToFit(.widthFlexible)
    }

    override func sizeThatFits(_ size: CGSize) -> CGSize {
        contentView.pin.width(size.width)

        setupLayout()

        return CGSize(width: contentView.frame.width, height: tweetLabel.frame.maxY + 30)
    }
}
