//
//  PadeLoversApp.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/03.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

@main
struct PadeLoversApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
