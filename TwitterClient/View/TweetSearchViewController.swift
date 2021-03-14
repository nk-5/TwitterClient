//
//  ViewController.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/13.
//

import UIKit
import Cartography

enum Section {
    case main
}

final class TweetSearchViewController: UIViewController {

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.keyboardType = .twitter
        textField.borderStyle = .roundedRect
        textField.leftViewMode = .unlessEditing
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray))
        textField.leftView = searchIcon
        textField.placeholder = "キーワード検索"
        return textField
    }()
    
    private let tweetListCollectionView: UICollectionView = {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(cellType: TweetViewCell.self)
        return collectionView
    }()
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Tweet>?
    private(set) var snapshot = NSDiffableDataSourceSnapshot<Section, Tweet>()

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        setupDataSource()
    }
    
    private func setupView() {
        tweetListCollectionView.delegate = self
       
        view.addSubview(searchTextField)
        view.addSubview(tweetListCollectionView)

        constrain(view.safeAreaLayoutGuide, searchTextField, tweetListCollectionView) {
            $1.top == $0.top
            $1.height == 30
            $1.centerX == $0.centerX
            $1.width == $0.width / 2

            $2.top == $1.bottom + 10
            $2.leading == $0.leading + 16
            $2.trailing == $0.trailing - 16
            $0.bottom == $2.bottom
        }
    }
    
    private func setupDataSource() {
        snapshot.appendSections([.main])
        let tweet = Tweet(tweet: "tweet", userName: "hoge", screenName: "test", createdAt: Date(), profileIconURL: URL(string: "https://pbs.twimg.com/profile_images/1190985555644952576/cDurbyzD_normal.jpg"))
        snapshot.appendItems([tweet])
        
        dataSource = UICollectionViewDiffableDataSource<Section, Tweet>(collectionView: tweetListCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, tweet: Tweet) -> UICollectionViewCell? in
           
            let cell: TweetViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(tweet: tweet)
            return cell
        }
        
        dataSource?.apply(snapshot)
    }
}

extension TweetSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // TODO: set datasource count
        return 1
    }
}

