//
//  GameViewPlayerTableDelegate.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/10.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

protocol GameViewPlayerTableDelegate: AnyObject {
    func gameModeSwitchChanged(gameMode: GameModeType, isOn: Bool)
    func gameResultSwitchChanged(isOn: Bool)
    func pairingSwitchChanged(pairing: Pairing, isOn: Bool)
    func courtSwitchChanged(courtId: Int16, isOn: Bool)
    func playerSwitchChanged(playerId: Int16, isPlaying: Bool)
}
