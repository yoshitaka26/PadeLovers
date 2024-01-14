//
//  CustomToastView.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/13.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import PopupView

extension View {
    func customToast(for toastObject: ToastObject) -> some View {
        modifier(CustomToastView(toastObject: toastObject))
    }
}

struct CustomToastView: ViewModifier {
    @ObservedObject var toastObject: ToastObject

    func body(content: Content) -> some View {
        content
            .popup(isPresented: $toastObject.isShowToast) {
                toastObject.toast
            } customize: {
                $0
                    .type(.floater())
                    .position(.top)
                    .animation(.default)
                    .closeOnTapOutside(true)
                    .backgroundColor(.black.opacity(0.5))
            }
    }
}
