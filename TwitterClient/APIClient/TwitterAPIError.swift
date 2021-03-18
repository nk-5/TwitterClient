//
//  TwitterAPIError.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation

enum TwitterAPIError: Error {
    case nothingAccessToken
    case getFailed
    case decodeError
}

extension TwitterAPIError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .nothingAccessToken: return "Twitter API Access Token is nothing"
        case .getFailed: return "Tweet could not get"
        case .decodeError: return "Twitter API response decode failed"
        }
    }
}
