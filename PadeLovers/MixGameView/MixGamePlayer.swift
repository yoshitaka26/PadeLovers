//
//  MixGamePlayer.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Combine
import Foundation

@MainActor
class MixGamePlayer: Identifiable, ObservableObject {
    @Published var isPlaying = true
    @Published var isOnGame = false
    @Published var playedCount: Int = 0

    let id: Int
    let name: String
    let isMale: Bool

    var pairedPlayers: [Int] = []

    init(id: Int, name: String, isMale: Bool) {
        self.id = id
        self.name = name
        self.isMale = isMale
    }

    var switchDisabled: Bool {
        isPlaying && isOnGame
    }

    func fixCount(newValue: Int) {
        playedCount = newValue
    }

    func addPlayCount() {
        playedCount += 1
    }

    func minusPlayCount() {
        playedCount -= 1
    }

    func startGame() {
        isOnGame = true
    }

    func resetGame() {
        isOnGame = false
    }

    func finishGame(afterPlayingWith players: [Int], from totalPlayers: [Int]) {
        playedCount += 1
        isOnGame = false
        pairedPlayers.append(contentsOf: players.filter { $0 != id })

        if totalPlayers.allSatisfy({ $0 == id || pairedPlayers.contains($0) }) {
            pairedPlayers.removeAll { totalPlayers.contains($0) }
        }
    }
}
