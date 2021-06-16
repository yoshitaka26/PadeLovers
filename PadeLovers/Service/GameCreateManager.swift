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

class GameCreateManager {
    static let shared: GameCreateManager = GameCreateManager()
    let coreDataManager = CoreDataManager.shared
    var padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
    
    func organaizeMatch(courtID: Int? = nil) {
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
        
        var temp2 = players.filter { $0.playerID != driveA.playerID }
        if needPairing {
            if let pairingA = pairingList[.pairingA], pairingA.count == 2 {
                if pairingA.contains(driveA) {
                    let pair = pairingA.filter { $0.playerID != driveA.playerID }
                    guard let pairA = pair.first else { fatalError("エラー１−２") }
                    gamePlayers[.backA] = pairA
                    temp2 = temp2.filter { $0.playerID != pairA.playerID }
                }
            }
            if let pairingB = pairingList[.pairingB], pairingB.count == 2 {
                if pairingB.contains(driveA) {
                    let pair = pairingB.filter { $0.playerID != driveA.playerID }
                    guard let pairA = pair.first else { fatalError("エラー１−３")  }
                    gamePlayers[.backA] = pairA
                    temp2 = temp2.filter { $0.playerID != pairA.playerID }
                }
            }
        }
        minCounts = getMinCountsWithPlayers(players: temp2)
        temp2 = temp2.filter { $0.counts == minCounts }
        guard let driveB = temp2.randomElement() else { fatalError("エラー１−４")  }
        gamePlayers[.driveB] = driveB
        
        var temp3 = players.filter { $0.playerID != driveA.playerID && $0.playerID != driveB.playerID }
        
        if needPairing {
            if let pairingA = pairingList[.pairingA], pairingA.count == 2 {
                if pairingA.contains(driveB) {
                    let pair = pairingA.filter { $0.playerID != driveB.playerID }
                    guard let pairB = pair.first else { fatalError("エラー１−５")  }
                    gamePlayers[.backB] = pairB
                    temp3 = temp3.filter { $0.playerID != pairB.playerID }
                }
            }
            if let pairingB = pairingList[.pairingB], pairingB.count == 2 {
                if pairingB.contains(driveB) {
                    let pair = pairingB.filter { $0.playerID != driveB.playerID }
                    guard let pairB = pair.first else { fatalError("エラー１−６")  }
                    gamePlayers[.backB] = pairB
                    temp3 = temp3.filter { $0.playerID != pairB.playerID }
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
                temp3 = players.filter { $0.playerID != driveA.playerID && $0.playerID != driveB.playerID }
            }
            minCounts = getMinCountsWithPlayers(players: temp3)
            temp3 = temp3.filter { $0.counts == minCounts }
            guard let backA = temp3.randomElement() else { fatalError("エラー１−７")  }
            gamePlayers[.backA] = backA
        }
        
        var temp4 = players.filter { $0.playerID != driveA.playerID && $0.playerID != driveB.playerID && $0.playerID != gamePlayers[.backA]!.playerID }
        
        if !gamePlayers.keys.contains(.backB) {
            if !driveB.pair1.isEmpty {
                temp4 = temp4.filter { !driveB.pair1.contains($0.playerID) }
            }
            if temp4.isEmpty {
                temp4 = players.filter { $0.playerID != driveA.playerID && $0.playerID != driveB.playerID && $0.playerID != gamePlayers[.backA]!.playerID }
            }
            minCounts = getMinCountsWithPlayers(players: temp4)
            temp4 = temp4.filter { $0.counts == minCounts }
            guard let backB = temp4.randomElement() else { fatalError("エラー１−８") }
            gamePlayers[.backB] = backB
        }
        guard gamePlayers.count == 4 else { fatalError("組み合わせ失敗") }
        
        newGame.driveA = gamePlayers[.driveA]!.playerID
        newGame.driveB = gamePlayers[.driveB]!.playerID
        newGame.backA = gamePlayers[.backA]!.playerID
        newGame.backB = gamePlayers[.backB]!.playerID
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
        return countsArray.min()!
    }
    
    func gameEnd(courtID: Int) {
        guard let padel = coreDataManager.loadPadel(uuidString: padelID) else {
            fatalError("padelデータが存在しない")
        }
        let games = coreDataManager.loadOnGames(uuidString: self.padelID)
        
        let game = games.filter {
            guard let court = $0.court, court.onGame != nil else { return false }
            return court.courtID == courtID
        }
        guard let selectedGame = game.first else { fatalError("試合取得失敗") }
        padel.gameCounts += 1
        selectedGame.isEnd = true
        selectedGame.court = nil
        let players = selectedGame.fetchAllPlayers()
        
        for (key, player) in players {
            player.counts += 1
            switch key {
            case .driveA:
                if player.pair1.contains(players[.backA]!.playerID) {
                    player.pair2.append(players[.backA]!.playerID)
                } else {
                    player.pair1.append(players[.backA]!.playerID)
                }
            case .backA:
                if player.pair1.contains(players[.driveA]!.playerID) {
                    player.pair2.append(players[.driveA]!.playerID)
                } else {
                    player.pair1.append(players[.driveA]!.playerID)
                }
            case .driveB:
                if player.pair1.contains(players[.backB]!.playerID) {
                    player.pair2.append(players[.backB]!.playerID)
                } else {
                    player.pair1.append(players[.backB]!.playerID)
                }
            case .backB:
                if player.pair1.contains(players[.driveB]!.playerID) {
                    player.pair2.append(players[.driveB]!.playerID)
                } else {
                    player.pair1.append(players[.driveB]!.playerID)
                }
            }
        }
        padel.save()
    }
    
    func gameDelete(courtID: Int) {
        let games = coreDataManager.loadOnGames(uuidString: self.padelID)
        
        let game = games.filter {
            guard let court = $0.court, court.onGame != nil else { return false }
            return court.courtID == courtID
        }
        guard let selectedGame = game.first else { fatalError("試合取得失敗") }
        guard !selectedGame.isEnd else { fatalError("終了済みの試合は消せない") }
        coreDataManager.deleteGame(uuidString: padelID, gameID: selectedGame.gameID)
    }
    
    func replacePlayers(player1: Player, player2: Player) {
        guard let padel = coreDataManager.loadPadel(uuidString: padelID) else {
            fatalError("padelデータが存在しない")
        }
        guard let game = player1.onGame else { return }
        if let anotherGame = player2.onGame {
            if game == anotherGame {
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
                return
            }
        }
        if game.driveA == player1.playerID { game.driveA = player2.playerID }
        if game.backA == player1.playerID { game.backA = player2.playerID }
        if game.driveB == player1.playerID { game.driveB = player2.playerID }
        if game.backB == player1.playerID { game.backB = player2.playerID }
        game.removeFromPlayers(player1)
        game.addToPlayers(player2)
        
        guard let anotherGame = player2.onGame else {
            padel.save()
            return
        }
        if anotherGame.driveA == player2.playerID { anotherGame.driveA = player1.playerID }
        if anotherGame.backA == player2.playerID { anotherGame.backA = player1.playerID }
        if anotherGame.driveB == player2.playerID { anotherGame.driveB = player1.playerID }
        if anotherGame.backB == player2.playerID { anotherGame.backB = player1.playerID }
        anotherGame.removeFromPlayers(player2)
        anotherGame.addToPlayers(player1)
        padel.save()
    }
    
    func reOrganizeGame(courtID: Int) {
        guard let padel = coreDataManager.loadPadel(uuidString: padelID) else {
            fatalError("padelデータが存在しない")
        }
        var playersBefore = coreDataManager.loadPlayersOfGameByCourtID(uuidString: padelID, courtID: courtID)
        gameDelete(courtID: courtID)
        organaizeMatch(courtID: courtID)
        let newPlayers =  coreDataManager.loadPlayersOfGameByCourtID(uuidString: padelID, courtID: courtID)
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
        replacePlayers(player1: player1, player2: player2)
        padel.save()
    }
}
