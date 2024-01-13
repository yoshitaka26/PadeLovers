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
    @Published var replacePlayerGame: MixGameMatchGame?

    @Published var replaceFrom: MixGamePlayer?
    @Published var replaceTo: MixGamePlayer?
    @Published var randomSelection = false

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

        self.players = playersData
            .sorted { $0.order < $1.order }
            .map {
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
    
    // 入れ替え画面用
    var replaceablePlayers: [MixGamePlayer] {
        playingPlayers.filter { !$0.isOnGame }
    }

    var isSelectedTwoPlayersForReplacement: Bool {
        replaceFrom != nil && (replaceTo != nil || randomSelection)
    }

    func isSelectedWithPlayerFrom(_ player: MixGamePlayer) -> Bool {
        replaceFrom?.id == player.id
    }

    func selectPlayerFrom(_ player: MixGamePlayer) {
        replaceFrom = player
    }

    func isSelectedWithPlayerTo(_ player: MixGamePlayer) -> Bool {
        replaceTo?.id == player.id
    }

    func selectPlayerTo(_ player: MixGamePlayer) {
        randomSelection = false
        replaceTo = player
    }

    func selectPlayerToWithRandom() {
        replaceTo = nil
        randomSelection = true
    }

    func replacePlayers() {
        guard let replacePlayerGame,
              let replaceFrom else { return }
        if let replaceTo {
            replacePlayerGame.replacePlayer(from: replaceFrom, to: replaceTo)
        } else if randomSelection {
            if let player = replaceablePlayers.randomElement() {
                replacePlayerGame.replacePlayer(from: replaceFrom, to: player)
            }
        } else {
            assertionFailure("ありえない")
        }

        dismissReplacePlayerView()
    }

    func showReplacePlayerView(_ game: MixGameMatchGame) {
        replacePlayerGame = game
    }

    func dismissReplacePlayerView() {
        replacePlayerGame = nil
        replaceFrom = nil
        replaceTo = nil
        randomSelection = false
    }

    func isAvailable() -> Bool {
        return players.filter { $0.isPlaying && !$0.isOnGame }.count >= 4
    }

    func setGame(court: MixGameCourt) {
        let players = players.filter { $0.isPlaying && !$0.isOnGame }
        guard players.count >= 4 else { return } // 4人以上いないと試合を始められない

        var candidates = makeCandidates(excludingIds: [])
        let one = candidates.randomElement()!

        candidates = filterCandidates(pairedWith: one, excludingIds: [one.id])
        let two = candidates.randomElement()!

        candidates = filterCandidates(pairedWith: two, excludingIds: [one.id, two.id])
        let three = candidates.randomElement()!

        candidates = filterCandidates(pairedWith: three, excludingIds: [one.id, two.id, three.id])
        let four = candidates.randomElement()!

        let set = [one, two, three, four]
        set.forEach { $0.startGame() }
        let game = court.setGame(players: set)
        matchGame.append(game)
    }

    func resetGame(court: MixGameCourt) {
        court.resetGame()
        matchGame.removeAll(where: { $0.id == court.gameId })
    }

    func endGame(court: MixGameCourt) {
        court.finishGame(totalPlayers: playingPlayers.map { $0.id })
    }

    private var playingPlayers: [MixGamePlayer] {
        players.filter { $0.isPlaying }
    }

    private func getMinCount() -> Int {
        var candidates = playingPlayers
        return candidates
            .map { $0.playedCount }
            .min() ?? 0
    }

    private func makeCandidates(excludingIds: [Int]) -> [MixGamePlayer] {
        let nonPlayingPlayers = playingPlayers.filter { !$0.isOnGame && !excludingIds.contains($0.id) }
        if let minCount = nonPlayingPlayers.map({ $0.playedCount }).min() {
            return nonPlayingPlayers.filter { $0.playedCount == minCount }
        }
        return []
    }

    private func filterCandidates(pairedWith: MixGamePlayer, excludingIds: [Int]) -> [MixGamePlayer] {
        var candidates = makeCandidates(excludingIds: excludingIds)
        candidates = candidates.filter { !pairedWith.pairedPlayers.contains($0.id) }
        if candidates.isEmpty {
            return makeCandidates(excludingIds: excludingIds)
        } else {
            return candidates
        }
    }
}
