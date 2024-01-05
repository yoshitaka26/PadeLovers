//
//  RandomNumberTableViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/05.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import Foundation
import SwiftUI

struct RandomNumberTableViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "RandomNumberTable", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "RandomNumber")
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // ViewControllerを更新する必要がある場合にここで処理を行います
    }
}
