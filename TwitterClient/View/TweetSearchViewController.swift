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
    
//    private let viewModel = TweetSearchViewModel(twitterAPIClient: MockTwitterAPIClient())
    private let viewModel = TweetSearchViewModel(twitterAPIClient: TwitterAPIClient())
    
    private var dataSource: UICollectionViewDiffableDataSource<Section, Tweet>?

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        setupDataSource()
    }
    
    private func setupView() {
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
        dataSource = UICollectionViewDiffableDataSource<Section, Tweet>(collectionView: tweetListCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, tweet: Tweet) -> UICollectionViewCell? in
           
            let cell: TweetViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(tweet: tweet)
            return cell
        }
        
        dataSource?.apply(viewModel.snapshot)
    }
}
