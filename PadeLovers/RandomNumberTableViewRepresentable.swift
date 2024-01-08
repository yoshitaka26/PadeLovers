//
//  RandomNumberTableViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/05.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct RandomNumberTableView: View {
    @State private var showPopover = false

    var body: some View {
        VStack {
            RandomNumberTableViewRepresentable()
        }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showPopover.toggle()
                    }, label: {
                        Image(systemName: "gearshape")
                    })
                }
            }
            .popover(isPresented: $showPopover) {
                VStack {
                    SettingViewRepresentable()
                }
            }
    }
}

#Preview {
    RandomNumberTableView()
}

struct RandomNumberTableViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "RandomNumberTable", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "RandomNumber") as! RandomNumberTableViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // ViewControllerを更新する必要がある場合にここで処理を行います
    }
}

struct SettingViewRepresentable: UIViewControllerRepresentable {
    var delegate: SettingViewControllerDelegate?

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "SettingView", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "SettingView") as! SettingViewController
        viewController.delegate = delegate
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // ViewControllerを更新する必要がある場合にここで処理を行います
    }
}
