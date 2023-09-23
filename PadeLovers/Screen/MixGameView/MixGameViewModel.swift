//
//  MixGameViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Combine

@MainActor
final class MixGameViewModel: ObservableObject {
    @Published var tab: MixGameTab = .player

    enum MixGameTab {
        case player
        case game
    }

    @Published var players: [MixGamePlayer] = []
    @Published var matchGame: [MixGameMatchGame] = []
    @Published var courts: [MixGameCourt] = []

    @Published var playerDetail: MixGamePlayer?

    var cancellables = Set<AnyCancellable>()

    init(groupID: String) {
        let playersData = CoreDataManager.shared.loadMasterPlayers(groupID: groupID)
        let courtData = UserDefaultsUtil.shared.courtNames

        self.players = playersData.map {
            return MixGamePlayer(id: Int($0.order), name: $0.name ?? "ゲスト", isMale: $0.gender)
        }
        self.courts = courtData.map {
            return MixGameCourt(name: $0)
        }

        self.players.forEach { player in
            player.$isPlaying.dropFirst().sink { [weak self] isPlaying in
                if isPlaying == true {
                    player.fixCount(newValue: self?.getMinCount() ?? 0)
                }
            }.store(in: &cancellables)
        }
    }

    func isAvailable() -> Bool {
        return players.filter { $0.isPlaying && !$0.isOnGame }.count >= 4
    }

    func setGame(court: MixGameCourt) {
        let players = players.filter { $0.isPlaying && !$0.isOnGame }
        guard players.count >= 4 else { return } // 4人以上いないと試合を始められない

        var candidates = makeCandidates(without: [])
        let one = candidates.randomElement()!

        candidates = filterCandidates(pairedWith: one, without: [one.id])
        let two = candidates.randomElement()!

        candidates = filterCandidates(pairedWith: two, without: [one.id, two.id])
        let three = candidates.randomElement()!

        candidates = filterCandidates(pairedWith: three, without: [one.id, two.id, three.id])
        let four = candidates.randomElement()!

        let set = [one, two, three, four]
        set.forEach { $0.startGame() }
        let game = court.setGame(players: set)
        matchGame.append(game)
    }

    func resetGame(court: MixGameCourt) {
        court.endGame()
        matchGame.removeAll(where: { $0.id == court.gameId })
    }

    func endGame(court: MixGameCourt) {
        court.endGame()
    }

    private func getMinCount() -> Int {
        var candidates = players.filter { $0.isPlaying }
        return candidates
            .map { $0.playedCount }
            .min() ?? 0
    }

    private func makeCandidates(without: [Int]) -> [MixGamePlayer] {
        var candidates = players.filter { $0.isPlaying && !$0.isOnGame }
        candidates = candidates.filter { !without.contains($0.id) }
        let minCount = candidates
            .map { $0.playedCount }
            .min()
        candidates = candidates.filter { $0.playedCount == minCount }
        return candidates
    }

    private func filterCandidates(pairedWith: MixGamePlayer, without: [Int]) -> [MixGamePlayer] {
        var candidates = makeCandidates(without: without)
        candidates = candidates.filter { !pairedWith.pairedPlayers.contains($0.id) }
        if candidates.isEmpty {
            return makeCandidates(without: without)
        } else {
            return candidates
        }
    }
}
