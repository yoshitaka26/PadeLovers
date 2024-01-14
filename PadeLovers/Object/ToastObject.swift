//
//  ToastObject.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/13.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

class ToastObject: ObservableObject {
    @Published var toastText: String = ""
    @Published var isShowToast: Bool = false

    var toast: some View {
        Text(toastText)
            .frame(width: 240.0, height: 48.0)
            .background(toastText.isEmpty ?
                        Color.clear : Color.black.opacity(0.5))
            .foregroundColor(.white)
            .cornerRadius(24.0)
    }

    @MainActor func showToast(text: String) {
        self.toastText = text
        self.isShowToast.toggle()
    }
}
