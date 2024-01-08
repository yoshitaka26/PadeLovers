//
//  HowToUseViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/08.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct HowToUseView: View {
    var body: some View {
        VStack {
            HowToUseViewRepresentable()
        }
    }
}

#Preview {
    HowToUseView()
}

struct HowToUseViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "HowToUse", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "HowToUse") as! HowToUseViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
