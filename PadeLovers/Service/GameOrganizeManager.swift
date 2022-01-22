//
//  GameCreateManager.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/10.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation

enum PositionType: String {
    case driveA
    case backA
    case driveB
    case backB
}

enum PairingType {
    case pairingA
    case pairingB
}

final class GameOrganizeManager {
    static let shared = GameOrganizeManager()
    let coreDataManager = CoreDataManager.shared
    
    func organaizeMatch(courtID: Int? = nil) {
        let padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
        guard let padel = coreDataManager.loadPadel(uuidString: padelID) else {
            fatalError("padelデータが存在しない")
        }
        guard let newGame = coreDataManager.setGame(uuidString: padelID) else {
            fatalError("ゲームが開始できない")
        }
        var players = coreDataManager.loadPlayersForNewGame(uuidString: padelID)
        var courts = coreDataManager.loadCourts(uuidString: padelID)
        
        var needPairing = false
        var pairingList: [PairingType: [Player]] = [:]
        if let pairingA = padel.pairingA, pairingA.isOn {
            guard let pairedPlayers = coreDataManager.loadPairedPlayers(uuidString: padelID, pairingType: .pairingA) else { return }
            pairingList[.pairingA] = pairedPlayers
            needPairing = true
        }
        if let pairingB = padel.pairingB, pairingB.isOn {
            guard let pairedPlayers = coreDataManager.loadPairedPlayers(uuidString: padelID, pairingType: .pairingB) else { return }
            pairingList[.pairingB] = pairedPlayers
            needPairing = true
        }
        
        var gamePlayers: [PositionType: Player] = [:]
        players = players.filter {
            guard let game = $0.onGame else { return true }
            return game.isEnd ? true : false
        }
        guard players.count > 3 else { fatalError("プレイヤーが４人以下です") }
        
        var minCounts = getMinCountsWithPlayers(players: players)
        let temp1 = players.filter { $0.counts == minCounts }
        guard let driveA = temp1.randomElement() else { fatalError("エラー１−１") }
        gamePlayers[.driveA] = driveA
        
        players = players.filter { $0.playerID != driveA.playerID }
        var temp2 = players.filter { $0.playerID != driveA.playerID }
        if needPairing {
            if let pairingA = pairingList[.pairingA], pairingA.count == 2 {
                if pairingA.contains(driveA) {
                    let pair = pairingA.filter { $0.playerID != driveA.playerID }
                    guard let pairA = pair.first else { fatalError("エラー１−２") }
                    gamePlayers[.backA] = pairA
                    temp2 = temp2.filter { $0.playerID != pairA.playerID }
                    players = players.filter { $0.playerID != pairA.playerID }
                    pairingList[.pairingA]?.removeAll()
                }
            }
            if let pairingB = pairingList[.pairingB], pairingB.count == 2 {
                if pairingB.contains(driveA) {
                    let pair = pairingB.filter { $0.playerID != driveA.playerID }
                    guard let pairA = pair.first else { fatalError("エラー１−３") }
                    gamePlayers[.backA] = pairA
                    temp2 = temp2.filter { $0.playerID != pairA.playerID }
                    players = players.filter { $0.playerID != pairA.playerID }
                    pairingList[.pairingB]?.removeAll()
                }
            }
        }
        minCounts = getMinCountsWithPlayers(players: temp2)
        temp2 = temp2.filter { $0.counts == minCounts }
        guard let driveB = temp2.randomElement() else { fatalError("エラー１−４") }
        gamePlayers[.driveB] = driveB
        
        players = players.filter { $0.playerID != driveB.playerID }
        var temp3 = players.filter { $0.playerID != driveB.playerID }
        
        if needPairing {
            if let pairingA = pairingList[.pairingA], pairingA.count == 2 {
                if pairingA.contains(driveB) {
                    let pair = pairingA.filter { $0.playerID != driveB.playerID }
                    guard let pairB = pair.first else { fatalError("エラー１−５") }
                    gamePlayers[.backB] = pairB
                    temp3 = temp3.filter { $0.playerID != pairB.playerID }
                    players = players.filter { $0.playerID != pairB.playerID }
                } else {
                    temp3 = temp3.filter {
                        guard $0.playerID != pairingA[0].playerID else { return false }
                        guard $0.playerID != pairingA[1].playerID else { return false }
                        return true
                    }
                    players = players.filter {
                        guard $0.playerID != pairingA[0].playerID else { return false }
                        guard $0.playerID != pairingA[1].playerID else { return false }
                        return true
                    }
                }
            }
            if let pairingB = pairingList[.pairingB], pairingB.count == 2 {
                if pairingB.contains(driveB) {
                    let pair = pairingB.filter { $0.playerID != driveB.playerID }
                    guard let pairB = pair.first else { fatalError("エラー１−６") }
                    gamePlayers[.backB] = pairB
                    temp3 = temp3.filter { $0.playerID != pairB.playerID }
                    players = players.filter { $0.playerID != pairB.playerID }
                } else {
                    temp3 = temp3.filter {
                        guard $0.playerID != pairingB[0].playerID else { return false }
                        guard $0.playerID != pairingB[1].playerID else { return false }
                        return true
                    }
                    players = players.filter {
                        guard $0.playerID != pairingB[0].playerID else { return false }
                        guard $0.playerID != pairingB[1].playerID else { return false }
                        return true
                    }
                }
            }
        }
        
        if !gamePlayers.keys.contains(.backA) {
            if padel.playMode {
                if !driveA.pair1.isEmpty {
                    temp3 = temp3.filter { !driveA.pair1.contains($0.playerID) }
                }
            }
            if temp3.isEmpty {
                temp3 = players
            }
            minCounts = getMinCountsWithPlayers(players: temp3)
            temp3 = temp3.filter { $0.counts == minCounts }
            guard let backA = temp3.randomElement() else { fatalError("エラー１−７") }
            gamePlayers[.backA] = backA
        }
        
        guard let backA = gamePlayers[.backA] else { return }
        
        players = players.filter { $0.playerID != backA.playerID }
        var temp4 = players.filter { $0.playerID != backA.playerID }
        
        if !gamePlayers.keys.contains(.backB) {
            if !driveB.pair1.isEmpty {
                temp4 = temp4.filter { !driveB.pair1.contains($0.playerID) }
            }
            if temp4.isEmpty {
                temp4 = players
            }
            minCounts = getMinCountsWithPlayers(players: temp4)
            temp4 = temp4.filter { $0.counts == minCounts }
            guard let backB = temp4.randomElement() else { fatalError("エラー１−８") }
            gamePlayers[.backB] = backB
        }
        
        guard gamePlayers.count == 4 else { fatalError("組み合わせ失敗") }
        guard let safeDriveA = gamePlayers[.driveA] else { return }
        guard let safeDriveB = gamePlayers[.driveB] else { return }
        guard let safeBackA = gamePlayers[.backA] else { return }
        guard let safeBackB = gamePlayers[.backB] else { return }
        
        newGame.driveA = safeDriveA.playerID
        newGame.driveB = safeDriveB.playerID
        newGame.backA = safeBackA.playerID
        newGame.backB = safeBackB.playerID
        gamePlayers.forEach { newGame.addToPlayers($1) }
        
        courts = courts.filter { $0.isOn && $0.onGame == nil }
        if let id = courtID {
            courts = courts.filter { $0.courtID == id }
            guard let court = courts.first else { fatalError("エラー１−９") }
            newGame.court = court
        } else {
            guard let court = courts.first else { fatalError("エラー１−１０") }
            newGame.court = court
        }
        padel.save()
    }
    
    func getMinCountsWithPlayers(players: [Player]) -> Int16 {
        var countsArray = [Int16]()
        players.forEach { countsArray.append($0.counts) }
        guard let min = countsArray.min() else { return 0 }
        return min
    }
    
    func gameEnd(courtID: Int) {
        let padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
        guard let padel = coreDataManager.loadPadel(uuidString: padelID) else {
            fatalError("padelデータが存在しない")
        }
        let games = coreDataManager.loadOnGames(uuidString: padelID)
        
        let game = games.filter {
            guard let court = $0.court, court.onGame != nil else { return false }
            return court.courtID == courtID
        }
        guard let selectedGame = game.first else { fatalError("試合取得失敗") }
        padel.gameCounts += 1
        selectedGame.isEnd = true
        selectedGame.court = nil
        let gamePlayers = selectedGame.fetchAllPlayers()
        
        let players = coreDataManager.loadPlayingPlayers(uuidString: padelID)
        var playersID: [Int16] = []
        players.forEach { playersID.append($0.playerID) }
        
        if let pairingA = padel.pairingA, pairingA.isOn {
            guard let pairedPlayers = coreDataManager.loadPairedPlayers(uuidString: padelID, pairingType: .pairingA) else { return }
            guard pairedPlayers.count == 2  else { return }
            playersID = playersID.filter {
                guard $0 != pairedPlayers[0].playerID else { return false }
                guard $0 != pairedPlayers[1].playerID else { return false }
                return true
            }
        }
        if let pairingB = padel.pairingB, pairingB.isOn {
            guard let pairedPlayers = coreDataManager.loadPairedPlayers(uuidString: padelID, pairingType: .pairingB) else { return }
            guard pairedPlayers.count == 2  else { return }
            playersID = playersID.filter {
                guard $0 != pairedPlayers[0].playerID else { return false }
                guard $0 != pairedPlayers[1].playerID else { return false }
                return true
            }
        }
        
        for (key, player) in gamePlayers {
            player.counts += 1
            switch key {
            case .driveA:
                guard let backA = gamePlayers[.backA] else { return }
                if player.pair1.contains(backA.playerID) {
                    player.pair2.append(backA.playerID)
                } else {
                    player.pair1.append(backA.playerID)
                    var temp = playersID
                    for pairID in player.pair1 {
                        temp = temp.filter { $0 != pairID }
                    }
                    print(temp)
                    if temp.isEmpty {
                        print("ペア記録消去")
                        player.pair1.removeAll()
                        player.pair1.append(contentsOf: player.pair2)
                        player.pair2.removeAll()
                        player.pair2.append(player.playerID)
                    }
                }
            case .backA:
                guard let driveA = gamePlayers[.driveA] else { return }
                if player.pair1.contains(driveA.playerID) {
                    player.pair2.append(driveA.playerID)
                } else {
                    player.pair1.append(driveA.playerID)
                    var temp = playersID
                    for pairID in player.pair1 {
                        temp = temp.filter { $0 != pairID }
                    }
                    print(temp)
                    if temp.isEmpty {
                        print("ペア記録消去")
                        player.pair1.removeAll()
                        player.pair1.append(contentsOf: player.pair2)
                        player.pair2.removeAll()
                        player.pair2.append(player.playerID)
                    }
                }
            case .driveB:
                guard let backB = gamePlayers[.backB] else { return }
                if player.pair1.contains(backB.playerID) {
                    player.pair2.append(backB.playerID)
                } else {
                    player.pair1.append(backB.playerID)
                    var temp = playersID
                    for pairID in player.pair1 {
                        temp = temp.filter { $0 != pairID }
                    }
                    print(temp)
                    if temp.isEmpty {
                        print("ペア記録消去")
                        player.pair1.removeAll()
                        player.pair1.append(contentsOf: player.pair2)
                        player.pair2.removeAll()
                        player.pair2.append(player.playerID)
                    }
                }
            case .backB:
                guard let driveB = gamePlayers[.driveB] else { return }
                if player.pair1.contains(driveB.playerID) {
                    player.pair2.append(driveB.playerID)
                } else {
                    player.pair1.append(driveB.playerID)
                    var temp = playersID
                    for pairID in player.pair1 {
                        temp = temp.filter { $0 != pairID }
                    }
                    print(temp)
                    if temp.isEmpty {
                        print("ペア記録消去")
                        player.pair1.removeAll()
                        player.pair1.append(contentsOf: player.pair2)
                        player.pair2.removeAll()
                        player.pair2.append(player.playerID)
                    }
                }
            }
        }
        guard let safePlayers = selectedGame.players else { return }
        selectedGame.removeFromPlayers(safePlayers)
        padel.date = Date()
        padel.save()
    }
    
    func gameDelete(courtID: Int) {
        let padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
        let games = coreDataManager.loadOnGames(uuidString: padelID)
        
        let game = games.filter {
            guard let court = $0.court, court.onGame != nil else { return false }
            return court.courtID == courtID
        }
        guard let selectedGame = game.first else { fatalError("試合取得失敗") }
        guard !selectedGame.isEnd else { fatalError("終了済みの試合は消せない") }
        coreDataManager.deleteGame(uuidString: padelID, gameID: selectedGame.gameID)
    }
    func replacePlayersFromWaiting(player1: Player, _player2: Player?) -> Player? {
        let padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
        guard let padel = coreDataManager.loadPadel(uuidString: padelID) else { fatalError("padelデータが存在しない") }
        var tempPlayer2 = _player2
        if _player2 == nil {
            let players = coreDataManager.loadPlayersForNewGame(uuidString: padelID)
            let minCounts = getMinCountsWithPlayers(players: players)
            let tempPlayers = players.filter { $0.counts == minCounts }
            guard let replacePlayer = tempPlayers.randomElement() else { return nil }
            tempPlayer2 = replacePlayer
        }

        guard let player2 = tempPlayer2 else { return nil }

        guard let game = player1.onGame else { return nil }
        guard player2.onGame == nil else { return nil }
        if game.driveA == player1.playerID { game.driveA = player2.playerID }
        if game.backA == player1.playerID { game.backA = player2.playerID }
        if game.driveB == player1.playerID { game.driveB = player2.playerID }
        if game.backB == player1.playerID { game.backB = player2.playerID }
        game.removeFromPlayers(player1)
        game.addToPlayers(player2)
        padel.save()

        return player2
    }
    func replacePlayersOnSameGame(player1: Player, player2: Player) {
        let padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
        guard let padel = coreDataManager.loadPadel(uuidString: padelID) else {
            fatalError("padelデータが存在しない")
        }
        guard let game = player1.onGame else { return }
        guard let anotherGame = player2.onGame else { return }
        guard game == anotherGame else { return }
        
        switch game.driveA {
        case player1.playerID:
            game.driveA = player2.playerID
        case player2.playerID:
            game.driveA = player1.playerID
        default:
            break
        }
        switch game.backA {
        case player1.playerID:
            game.backA = player2.playerID
        case player2.playerID:
            game.backA = player1.playerID
        default:
            break
        }
        switch game.driveB {
        case player1.playerID:
            game.driveB = player2.playerID
        case player2.playerID:
            game.driveB = player1.playerID
        default:
            break
        }
        switch game.backB {
        case player1.playerID:
            game.backB = player2.playerID
        case player2.playerID:
            game.backB = player1.playerID
        default:
            break
        }
        padel.save()
    }
    
    func replacePlayersFromAnotherGame(player1: Player, player2: Player) {
        let padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
        guard let padel = coreDataManager.loadPadel(uuidString: padelID) else {
            fatalError("padelデータが存在しない")
        }
        guard let game = player1.onGame else { return }
        guard let anotherGame = player2.onGame else { return }
        
        if game.driveA == player1.playerID { game.driveA = player2.playerID }
        if game.backA == player1.playerID { game.backA = player2.playerID }
        if game.driveB == player1.playerID { game.driveB = player2.playerID }
        if game.backB == player1.playerID { game.backB = player2.playerID }
        
        if anotherGame.driveA == player2.playerID { anotherGame.driveA = player1.playerID }
        if anotherGame.backA == player2.playerID { anotherGame.backA = player1.playerID }
        if anotherGame.driveB == player2.playerID { anotherGame.driveB = player1.playerID }
        if anotherGame.backB == player2.playerID { anotherGame.backB = player1.playerID }
        
        game.removeFromPlayers(player1)
        anotherGame.removeFromPlayers(player2)
        anotherGame.addToPlayers(player1)
        game.addToPlayers(player2)
        padel.save()
    }
    
    func reOrganizeGame(courtID: Int) {
        let padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
        guard let padel = coreDataManager.loadPadel(uuidString: padelID) else {
            fatalError("padelデータが存在しない")
        }
        var playersBefore = coreDataManager.loadPlayersOfGameByCourtID(uuidString: padelID, courtID: courtID)
        gameDelete(courtID: courtID)
        organaizeMatch(courtID: courtID)
        let newPlayers = coreDataManager.loadPlayersOfGameByCourtID(uuidString: padelID, courtID: courtID)
        for newPlayer in newPlayers {
            playersBefore = playersBefore.filter { !($0.playerID == newPlayer.playerID) }
        }
        if !playersBefore.isEmpty {
            padel.save()
            return
        }
        let players = coreDataManager.loadPlayersForNewGame(uuidString: padelID)
        if players.isEmpty {
            padel.save()
            return
        }
        guard let player1 = newPlayers.randomElement(),
              let player2 = players.randomElement() else {
            padel.save()
            return
        }
        _ = replacePlayersFromWaiting(player1: player1, _player2: player2)
        padel.save()
    }
}
