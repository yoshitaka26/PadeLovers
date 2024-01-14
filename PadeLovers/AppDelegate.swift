//
//  AppDelegate.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit
import CoreData
import FirebaseCore
import FirebaseAnalytics

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UINavigationBar.appearance().titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]

        #if RELEASE
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        #endif

        // UserDefaultsセットアップ
        UserDefaultsUtil.shared.appLastLaunchDate = Date()
        UserDefaultsUtil.shared.appLaunchCount += 1

        // プレイヤーデータのマイグレーション
        if !UserDefaultsUtil.shared.playerDataMigratedToCoreData {
            CommonDataBrain.shared.migrateToCoreData()
        }

        return true
    }
    
    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
}
