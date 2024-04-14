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
    @State private var playerCount: Int?

    var body: some View {
        VStack {
            RandomNumberTableViewRepresentable(playerCount: $playerCount)
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
        .sheet(isPresented: $showPopover) {
            VStack {
                SettingViewRepresentable(playerCount: $playerCount)
            }
        }
    }
}

#Preview {
    RandomNumberTableView()
}

struct RandomNumberTableViewRepresentable: UIViewControllerRepresentable {
    @Binding var playerCount: Int?

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "RandomNumberTable", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "RandomNumber") as! RandomNumberTableViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let playerCount else { return }
        if playerCount != 0, let vc = uiViewController as? RandomNumberTableViewController {
            vc.viewModel.onMatchNumber.accept(0)
            vc.viewModel.playerNumber.accept(playerCount)
            vc.viewModel.generateNumbers.onNext(())
            vc.infoAlertViewWithTitle(title: "乱数表を更新しました")
        }
        Task {
            self.playerCount = nil
        }
    }
}

struct SettingViewRepresentable: UIViewControllerRepresentable {
    @Binding var playerCount: Int?

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "SettingView", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "SettingView") as! SettingViewController
        viewController.delegate = context.coordinator
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // ViewControllerを更新する必要がある場合にここで処理を行います
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, SettingViewControllerDelegate {
        var viewController: SettingViewRepresentable

        init(_ viewController: SettingViewRepresentable) {
            self.viewController = viewController
        }

        func closedSettingViewController(playerCount: Int) {
            viewController.playerCount = playerCount
        }
    }
}
