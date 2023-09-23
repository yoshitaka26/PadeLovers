//
//  MixGamePlayer.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Combine

class MixGamePlayer: ObservableObject {
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

    func fixCount(newValue: Int) {
        playedCount = newValue
    }

    func toggleIsPlaying() {
        isPlaying.toggle()
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
    }
}
