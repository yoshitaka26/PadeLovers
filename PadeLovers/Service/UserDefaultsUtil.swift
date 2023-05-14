//
//  UserDefaultsManager.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/11.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

final class UserDefaultsUtil {
    static let shared = UserDefaultsUtil()
    private var userDefaults = UserDefaults.standard

    private init() { }

    enum StringKey: String {
        case padelId = "PadelID"
        case newCourt
        case appLastLaunchDate
        case appLaunchCount
        case playerDataMigratedToCoreData

        case court
        // 過去に使用
        case player
        case gender
        case group1
        case group2
        case group3
    }
}

extension UserDefaultsUtil {
    var padelID: String? {
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

    var appLastLaunchDate: Date {
        get {
            return Date(
                timeIntervalSince1970: TimeInterval(userDefaults.integer(forKey: StringKey.appLastLaunchDate.rawValue))
            )
        }
        set {
            userDefaults.set(newValue.timeIntervalSince1970, forKey: StringKey.appLastLaunchDate.rawValue)
        }
    }

    var appLaunchCount: Int {
        get {
            return userDefaults.integer(forKey: StringKey.appLaunchCount.rawValue)
        }
        set {
            userDefaults.set(newValue, forKey: StringKey.appLastLaunchDate.rawValue)
        }
    }

    var playerDataMigratedToCoreData: Bool {
        get {
            return UserDefaults.standard.bool(forKey: StringKey.playerDataMigratedToCoreData.rawValue)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: StringKey.playerDataMigratedToCoreData.rawValue)
        }
    }
}
