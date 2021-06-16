//
//  Player+Additional.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/08.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation

extension Player {
    func isPairingEnable(type: PairingType) -> Bool {
        switch type {
        case .pairingA:
            if let pB = pairingB, pB.isOn { return false }
        case .pairingB:
            if let pA = pairingA, pA.isOn { return false }
        }
        return true
    }
    func isPairedPlayer(type: PairingType) -> Bool {
        switch type {
        case .pairingA:
            if let pA = pairingA, pA.isOn { return true }
        case .pairingB:
            if let pB = pairingB, pB.isOn { return true }
        }
        return false 
    }
}
