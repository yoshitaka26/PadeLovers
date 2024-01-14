//
//  MixGameMatchGame.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Combine
import Foundation

@MainActor
class MixGameMatchGame: ObservableObject, Identifiable {
    @Published var players: [MixGamePlayer] = []
    @Published var isFinished = false

    let id = UUID()

    init(players: [MixGamePlayer]) {
        self.players = players
    }

    func replacePlayer(from: MixGamePlayer, to: MixGamePlayer) {
        from.resetGame()
        to.startGame()
        guard let fromIndex = players.firstIndex(where: { $0.id == from.id }) else { return }
        var newPlayers = players
        newPlayers[fromIndex] = to
        players = newPlayers // 配列全体を更新
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
