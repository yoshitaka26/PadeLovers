//
//  CustomAlertView.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/13.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

extension View {
    func customAlert(for alertObject: AlertObject) -> some View {
        modifier(CustomAlertView(alertObject: alertObject))
    }
}

struct CustomAlertView: ViewModifier {
    @ObservedObject var alertObject: AlertObject

    func body(content: Content) -> some View {
        content
            .alert(
                alertObject.model?.title ?? "",
                isPresented: $alertObject.isShow,
                presenting: alertObject.model
            ) {
                $0.actionView
            } message: {
                $0.messageView
            }
    }
}
