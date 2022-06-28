//
//  GameViewSettingSection.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/28.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

enum GameViewSettingSection: Int {
    case gameModeSection
    case gameResultSection
    case courtSection
    case pairingSection
    case playerSection

    var headerTitle: String {
        switch self {
        case .gameModeSection:
            return R.string.localizable.mode()
        case .gameResultSection:
            return R.string.localizable.gameResult()
        case .courtSection:
            return R.string.localizable.court()
        case .pairingSection:
            return R.string.localizable.pairing()
        case .playerSection:
            return R.string.localizable.player()
        }
    }
}
