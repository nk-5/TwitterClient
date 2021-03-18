//
//  ViewController.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/13.
//

import UIKit
import Cartography
import Combine
import CombineCocoa
import MBProgressHUD

enum Section {
    case main
    case history
}

final class TweetSearchViewController: UIViewController {

    private let searchTextField: UITextField = {
        let textField = UITextField()
        textField.borderStyle = .roundedRect
        textField.leftViewMode = .unlessEditing
        let searchIcon = UIImageView(image: UIImage(systemName: "magnifyingglass")?.withRenderingMode(.alwaysOriginal).withTintColor(.lightGray))
        textField.leftView = searchIcon
        textField.placeholder = "キーワード検索"
        return textField
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton()
        button.setTitle("Clear", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let tweetListTableView: UITableView = {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UITableView(frame: .zero, style: .plain)
        collectionView.backgroundColor = .white
        collectionView.register(cellType: TweetViewCell.self)
        return collectionView
    }()
    
    private let searchHistoryCollectionView: UICollectionView = {
        let config = UICollectionLayoutListConfiguration(appearance: .plain)
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.register(cellType: SearchHistoryViewCell.self)
        collectionView.isHidden = true
        return collectionView
    }()
    
//    private let viewModel = TweetSearchViewModel(twitterAPIClient: MockTwitterAPIClient())
    private let viewModel = TweetSearchViewModel(twitterAPIClient: TwitterAPIClient())
    
    private var dataSource: UITableViewDiffableDataSource<Section, Tweet>?
    private var historyDataSource: UICollectionViewDiffableDataSource<Section, String>?
    private var historySnapshot = NSDiffableDataSourceSnapshot<Section, String>()
    private var cancellableSet: Set<AnyCancellable> = []

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupView()
        setupDataSource()
        bindUI()
    }
    
    private func setupView() {
        view.addSubview(searchTextField)
        view.addSubview(clearButton)
        view.addSubview(tweetListTableView)
        view.addSubview(searchHistoryCollectionView)

        constrain(view.safeAreaLayoutGuide, searchTextField, tweetListTableView, searchHistoryCollectionView) {
            $1.top == $0.top
            $1.height == 30
            $1.centerX == $0.centerX
            $1.width == $0.width / 2

            $2.top == $1.bottom + 10
            $2.leading == $0.leading + 16
            $2.trailing == $0.trailing - 16
            $0.bottom == $2.bottom
            
            $3.edges == $2.edges
        }
        
        constrain(view.safeAreaLayoutGuide, searchTextField, clearButton) {
            $2.top == $0.top
            $2.height == 30
            $2.leading == $0.leading + 4
            $2.trailing == $1.leading - 6
        }
    }
    
    private func setupDataSource() {
        dataSource = UITableViewDiffableDataSource<Section, Tweet>(tableView: tweetListTableView) { (tableView: UITableView, indexPath: IndexPath, tweet: Tweet) -> UITableViewCell? in
           
            let cell: TweetViewCell = tableView.dequeueReusableCell(for: indexPath)
            cell.setup(tweet: tweet)
            return cell
        }
        
        historyDataSource = UICollectionViewDiffableDataSource<Section, String>(collectionView: searchHistoryCollectionView) { (collectionView: UICollectionView, indexPath: IndexPath, history: String) -> UICollectionViewCell? in
           
            let cell: SearchHistoryViewCell = collectionView.dequeueReusableCell(for: indexPath)
            cell.setup(history: history)
            return cell
        }

        updateSearchHistory()
    }

    private func bindUI() {
        searchTextField.delegate = self
        searchHistoryCollectionView.delegate = self
        
        clearButton.tapPublisher.sink(receiveValue: {
            self.viewModel.clearDataSource()
        }).store(in: &cancellableSet)
        
        tweetListTableView.reachedBottomPublisher().sink(receiveValue: { [weak self] in
            guard let self = self else { return }
            self.viewModel.search(shouldLoadMoreContent: true)
            MBProgressHUD.showAdded(to: self.view, animated: true)
        }).store(in: &cancellableSet)
        
        NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: searchTextField)
            .debounce(for: 0.8, scheduler: RunLoop.main)
            .compactMap { $0.object as? UITextField }
            .compactMap { $0.text }
            .removeDuplicates()
            .eraseToAnyPublisher()
            .receive(on: RunLoop.main)
            .assign(to: \.searchText, on: viewModel)
            .store(in: &cancellableSet)
        
        viewModel.dataSourceUpdateSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                self.dataSource?.apply(self.viewModel.snapshot, animatingDifferences: false)
                MBProgressHUD.hide(for: self.view, animated: true)
            }).store(in: &cancellableSet)
   
        
        viewModel.apiErrorSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: {
                ProgressHUD.showErrorAlert(to: self.view, errorText: $0.localizedDescription)
            }).store(in: &cancellableSet)
    }
    
    private func updateSearchHistory() {
        historySnapshot = NSDiffableDataSourceSnapshot<Section, String>()
        historySnapshot.appendSections([.history])
        historySnapshot.appendItems(UserDefaults.standard.searchHistories)
        historyDataSource?.apply(historySnapshot)
    }
}

extension TweetSearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        searchHistoryCollectionView.isHidden = true
        viewModel.search()
        MBProgressHUD.showAdded(to: self.view, animated: true)
       
        updateSearchHistory()
        return false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        searchHistoryCollectionView.isHidden = false
    }
}

extension TweetSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let historyCell = collectionView.cellForItem(at: indexPath) as? SearchHistoryViewCell else { return }
      
        viewModel.searchText = historyCell.history
        searchTextField.text = historyCell.history
        searchHistoryCollectionView.isHidden = true
        viewModel.search()
        MBProgressHUD.showAdded(to: self.view, animated: true)
    }
}
