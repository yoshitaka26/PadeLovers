//
//  CommonDataViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct CommonDataView: View {
    var body: some View {
        VStack {
            CommonDataViewRepresentable()
        }
    }
}

#Preview {
    CommonDataView()
}

struct CommonDataViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "CommonData", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "CommonData") as! CommonDataViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
