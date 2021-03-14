//
//  SearchHistoryViewCell.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import UIKit
import Reusable

final class SearchHistoryViewCell: UICollectionViewCell, Reusable {

    func setup(history: String) {
        var config = UIListContentConfiguration.cell()
        config.text = history
        contentConfiguration = config
    }
}
