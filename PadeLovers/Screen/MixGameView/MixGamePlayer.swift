//
//  MixGamePlayer.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Combine
import Foundation

class MixGamePlayer: Identifiable, ObservableObject {
    @Published var isPlaying: Bool = true
    @Published var isOnGame: Bool = false
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

    func finishGame(with: [Int]) {
        playedCount += 1
        isOnGame = false
        pairedPlayers.append(
            contentsOf: with.compactMap { $0 != id ? $0 : nil }
        )
    }
}
