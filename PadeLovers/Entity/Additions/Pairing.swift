//
//  Pairing.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/11.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

protocol Pairing {
    func checkPairingType() -> PairingType
}
extension PairingA: Pairing {
    func checkPairingType() -> PairingType {
        return .pairingA
    }
}
extension PairingB: Pairing {
    func checkPairingType() -> PairingType {
        return .pairingB
    }
}
