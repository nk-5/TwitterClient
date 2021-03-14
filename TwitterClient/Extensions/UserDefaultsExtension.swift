//
//  UserDefaultsExtension.swift
//  TwitterClient
//
//  Created by Keigo Nakagawa on 2021/03/14.
//

import Foundation

enum UserDefaultsKey: String, CaseIterable {
    case searchHistories
}

extension UserDefaults {
    func save(object: Any, key: String) {
        set(object, forKey: key)
        synchronize()
    }

    func object<T>(key: String, defaultValue: T) -> T {
        if object(forKey: key) == nil {
            save(object: defaultValue, key: key)
            return defaultValue
        }

        if defaultValue is String {
            return string(forKey: key) as! T
        }

        if defaultValue is Int {
            return integer(forKey: key) as! T
        }

        if defaultValue is Bool {
            return bool(forKey: key) as! T
        }

        if defaultValue is [Any] {
            return array(forKey: key) as! T
        }

        if defaultValue is [String: Any] {
            return dictionary(forKey: key) as! T
        }
        
        return object(forKey: key) as! T
    }
    
    func clearAll() {
        UserDefaultsKey.allCases.forEach {
            removeObject(forKey: $0.rawValue)
        }
    }
}

extension UserDefaults {
    var searchHistories: [String] {
        return UserDefaults.standard.object(forKey: UserDefaultsKey.searchHistories.rawValue) as? [String] ?? []
    }
    
    func addSearchText(searchText: String) {
        if !searchHistories.contains(searchText) {
            var tmpHistories = searchHistories
            tmpHistories.append(searchText)
            set(tmpHistories, forKey: UserDefaultsKey.searchHistories.rawValue)
        }
    }
}
