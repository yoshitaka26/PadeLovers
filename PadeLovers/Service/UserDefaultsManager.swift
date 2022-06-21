//
//  UserDefaultsManager.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/11.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

final class UserDefaultsManager {
    static let shared = UserDefaultsManager()

    private init() { }
}

extension UserDefaultsManager {
    var padelId: String? {
        get {
            return UserDefaults.standard.string(forKey: StringKey.padelId.rawValue)
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: StringKey.padelId.rawValue)
        }
    }
    var courtNames: [String]? {
        get {
            return UserDefaults.standard.value(forKey: StringKey.newCourt.rawValue) as? [String]
        }
        set {
            guard let newValue = newValue else { return }
            UserDefaults.standard.set(newValue, forKey: StringKey.newCourt.rawValue)
        }
    }

    enum StringKey: String {
        case padelId = "PadelID"
        case newCourt
    }
}
