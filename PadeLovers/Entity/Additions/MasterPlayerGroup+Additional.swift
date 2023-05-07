//
//  MasterPlayerGroup+Additional.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/05/07.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Foundation

extension MasterPlayerGroup {
    var allPlayers: [MasterPlayer] {
        guard let players = player?.allObjects as? [MasterPlayer] else {
            assertionFailure()
            return []
        }
        return players
    }
}
