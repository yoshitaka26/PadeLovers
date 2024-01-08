//
//  MainSettingViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/08.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct MainSettingView: View {
    var body: some View {
        VStack {
            MainSettingViewRepresentable()
        }
    }
}

#Preview {
    MainSettingView()
}

struct MainSettingViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "MainSetting", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "MainSetting") as! MainSettingTableViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
