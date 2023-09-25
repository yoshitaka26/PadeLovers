//
//  MixGameMatchGame.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Combine
import Foundation

class MixGameMatchGame: ObservableObject {
    @Published var players: [MixGamePlayer] = []
    @Published var isFinished: Bool = false

    let id = UUID()

    init(players: [MixGamePlayer]) {
        self.players = players
    }

    func finishGame(totalPlayers: [Int]) {
        isFinished = true
        players.forEach { player in
            player.finishGame(
                afterPlayingWith: players.map { $0.id },
                from: totalPlayers
            )
        }
    }

    func resetGame() {
        players.forEach {
            $0.resetGame()
        }
    }
}
