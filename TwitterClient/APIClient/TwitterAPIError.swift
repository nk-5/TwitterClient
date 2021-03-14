//
//  TwitterAPIError.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation

enum TwitterAPIError: Error {
    case getFailed
    case decodeError
}
