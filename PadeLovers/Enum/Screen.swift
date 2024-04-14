//
//  Screen.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/11.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

enum Screen {
    case main
    case setting
    case gameViewQuestion
    case pairing(pairing: Pairing)
    case playerDataEdit(playerId: Int)
    case infoAlert(message: String)
    case errorAlert(message: String)
    case other
}

// swiftlint:disable operator_whitespace
// swiftlint:disable static_operator
func ==(a: Screen, b: Screen) -> Bool {
    switch (a, b) {
    case (.main, .main),
        (.errorAlert, .errorAlert),
        (.other, .other):
        return true
    default:
        return false
    }
}
