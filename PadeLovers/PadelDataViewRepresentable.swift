//
//  PadelDataViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/06.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct PadelDataView: View {
    @State private var isEdit = false

    var body: some View {
        VStack {
            PadelDataViewRepresentable(isEdit: $isEdit)
        }
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    isEdit.toggle()
                }, label: {
                    Text(isEdit ? "完了" : "編集")
                })
            }
        }
    }
}

#Preview {
    PadelDataView()
}

struct PadelDataViewRepresentable: UIViewControllerRepresentable {
    @Binding var isEdit: Bool

    func makeUIViewController(context: Context) -> UIViewController {
        let storyboard = UIStoryboard(name: "PadelData", bundle: nil)
        let viewController = storyboard.instantiateViewController(identifier: "PadelData") as! PadelDataTableViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        guard let padelDataView = uiViewController as? PadelDataTableViewController else { return }
        padelDataView.tableView.isEditing = isEdit
    }
}
