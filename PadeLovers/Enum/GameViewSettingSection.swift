//
//  GameViewSettingSection.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/28.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

enum GameViewSettingSection: Int {
    case gameResultSection
    case courtSection
    case pairingSection
    case playerSection

    var headerTitle: String {
        switch self {
        case .gameResultSection:
            return String(localized: "Game Result")
        case .courtSection:
            return String(localized: "Court")
        case .pairingSection:
            return String(localized: "Pairing")
        case .playerSection:
            return String(localized: "Player")
        }
    }
}
