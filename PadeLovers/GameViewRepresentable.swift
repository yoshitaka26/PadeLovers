//
//  GameViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/08.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct DefaultGameTabView: View {
    var groupID: String?
    var padelID: UUID? = nil

    var body: some View {
        TabView {
            GameViewSettingRepresentable(groupID: groupID, padelID: padelID)
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("設定")
                }
            GameDataRepresentable()
                .tabItem {
                    Image(systemName: "chart.bar")
                    Text("データ")
                }
            GameResultRepresentable()
                .tabItem {
                    Image(systemName: "chart.pie")
                    Text("結果")
                }
        }
    }
}

#Preview {
    RandomNumberTableView()
}

struct GameViewSettingRepresentable: UIViewControllerRepresentable {
    var groupID: String?
    var padelID: UUID? = nil

    func makeUIViewController(context: Context) -> UIViewController {
        return GameViewSettingViewController.make(groupID: groupID, padelId: padelID?.uuidString)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

struct GameDataRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIStoryboard(name: "GameData", bundle: nil).instantiateInitialViewController() as! GameDataTableViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

struct GameResultRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIStoryboard(name: "GameResult", bundle: nil).instantiateInitialViewController() as! GameResultViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
