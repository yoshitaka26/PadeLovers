//
//  PadelDataViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct PadelDataView: View {
    var body: some View {
        VStack {
            PadelDataViewRepresentable()
        }
    }
}

#Preview {
    RandomNumberTableView()
}

struct PadelDataViewRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "PadelData", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "PadelData") as! PadelDataTableViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
