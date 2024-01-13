//
//  MixGameCourt.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Combine
import Foundation

@MainActor
class MixGameCourt: ObservableObject {
    @Published var game: MixGameMatchGame?
    @Published var isOn = true

    let name: String
    let id = UUID()

    var cancellables = Set<AnyCancellable>()

    init(name: String) {
        self.name = name

        $isOn.dropFirst().sink { [weak self] _ in
            if self?.isOn == false {
                self?.game = nil
            }
        }.store(in: &cancellables)
    }

    var gameId: UUID? {
        guard let game else { return nil }
        return game.id
    }

    var isSet: Bool {
        return game != nil
    }

    var switchDisabled: Bool {
        isOn && isSet
    }

    func replacePlayer(from: MixGamePlayer, to: MixGamePlayer) {
        game?.replacePlayer(from: from, to: to)
    }

    func setGame(players: [MixGamePlayer]) -> MixGameMatchGame {
        let game = MixGameMatchGame(players: players)
        self.game = game
        return game
    }

    func resetGame() {
        guard let game else { return }
        game.resetGame()
        self.game = nil
    }

    func finishGame(totalPlayers: [Int]) {
        guard let game else { return }
        game.finishGame(totalPlayers: totalPlayers)
        self.game = nil
    }
}
