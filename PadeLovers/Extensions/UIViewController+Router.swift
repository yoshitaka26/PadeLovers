//
//  UIViewController+Router.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/11.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit

extension UIViewController {
    func presentScreen(_ screen: Screen) {
        switch screen {
        case .infoAlert(let message):
            infoAlertViewWithTitle(title: message)
        case .errorAlert(let message):
            warningAlertView(withTitle: message)
        default:
            break
        }
    }
}
