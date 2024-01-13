//
//  AlertObject.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/13.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

class AlertObject: ObservableObject {
    @Published var isShow: Bool = false
    @Published var model: Model?

    struct Model {
        var title: String
        var messageView: MessageView?
        var actionView: ActionView
    }

    struct MessageView: View {
        var message: String

        var body: some View {
            Text(message)
        }
    }

    struct ActionView: View {
        var kind: Kind

        enum Kind {
            case single(text: String, action: (() -> Void)? = nil)
            case double(text: String, action: (() -> Void)? = nil, cancelAction: (() -> Void)? = nil)
        }

        var body: some View {
            switch kind {
            case let .single(text, action):
                Button(text, role: .none, action: action ?? {})
            case let .double(text, action, cancelAction):
                Button("キャンセル", role: .cancel, action: cancelAction ?? {})
                Button(text, role: .destructive, action: action ?? {})
            }
        }
    }

    @MainActor func showError(message: String) {
        self.model = Model(
            title: "エラー",
            messageView: MessageView(message: message),
            actionView: ActionView(kind: .single(text: "OK"))
        )
        self.isShow.toggle()
    }

    @MainActor func showSingle(
        title: String,
        message: String?,
        actionText: String? = nil,
        action: (() -> Void)? = nil
    ) {
        self.model = Model(
            title: title,
            messageView: (message != nil) ? MessageView(message: message!) : nil,
            actionView: ActionView(kind: .single(
                text: actionText ?? "OK",
                action: action
            ))
        )
        self.isShow.toggle()
    }

    @MainActor func showDouble(
        title: String,
        message: String?,
        actionText: String? = nil,
        action: (() -> Void)? = nil,
        cancelAction: (() -> Void)? = nil
    ) {
        self.model = Model(
            title: title,
            messageView: (message != nil) ? MessageView(message: message!) : nil,
            actionView: ActionView(kind: .double(
                text: actionText ?? "OK",
                action: action,
                cancelAction: cancelAction
            ))
        )
        self.isShow.toggle()
    }
}
