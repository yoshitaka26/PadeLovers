//
//  UIViewController+Common.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/07.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

extension UIViewController {
    func confirmationAlertView(withTitle: String?,
                               message: String? = nil,
                               cancelString: String? = nil,
                               cancelBlock: (() -> Void)? = nil,
                               confirmString: String? = nil,
                               confirmBlock: (() -> Void)? = nil) {
        UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            .addOkAction(title: cancelString, handler: cancelBlock)
            .addCancelAction(title: confirmString, handler: confirmBlock)
            .show(in: self)
    }
    
    func warningAlertView(withTitle: String?, message: String? = nil, action: (() -> Void)? = nil) {
        UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            .addCancelAction(title: DIALOG_OK, handler: action)
            .show(in: self)
    }
    // 表示とともに２秒のタイマーをセットする
    func infoAlertViewWithTitle(title: String, message: String? = nil, afterDismiss: (() -> Void)? = nil) {
        let infoAlert = InfoAlertView(title: title, message: message, preferredStyle: .alert)
        infoAlert.afterDismiss = afterDismiss
        infoAlert.show(in: self) {
            infoAlert.timerStart()
        }
    }
}
