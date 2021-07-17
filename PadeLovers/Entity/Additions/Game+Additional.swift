//
//  Game+Additional.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/11.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation

extension Game {
    func fetchAllPlayers() -> [PositionType: Player] {
        let players = self.players?.allObjects as! [Player]
        var playersList = [PositionType: Player]()
        players.forEach {
            switch $0.playerID {
            case self.driveA:
                playersList[.driveA] = $0
            case self.backA:
                playersList[.backA] = $0
            case self.driveB:
                playersList[.driveB] = $0
            case self.backB:
                playersList[.backB] = $0
            default:
                fatalError("ゲームデータエラー")
            }
        }
        return playersList
    }
}
