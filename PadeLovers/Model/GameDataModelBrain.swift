//
//  GameDataModelBrain.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/28.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

//最小人数 4人（1コート）、8人（2コート）
//ペア固定時　1ペア +2人、2ペア　+4人（2コート）

import UIKit

struct GameDataModelBrain {
    var waitingPlayers: [PadelModel] = []
    
    var player1: PadelModel = PadelModel(name: "A")
    var player2: PadelModel = PadelModel(name: "B")
    var pair1: PadelModel = PadelModel(name: "C")
    var pair2: PadelModel = PadelModel(name: "D")
    
    var matchRecord: [GameModel] = []
    
    mutating func organizeMatch(totalPlayers: [PadelModel], playMode: Bool = true) -> [PadelModel] {
        var players = totalPlayers
        
        let p1Array = self.pickUpByCounts(players: players)
        player1 = p1Array.randomElement()!
        players = players.filter { $0.name != player1.name}
        let playersForPlayer2 = self.afterFirstPlayerDecided(player: player1, players: players)
        
        let p2Array = self.pickUpByCounts(players: playersForPlayer2)
        player2 = p2Array.randomElement()!
        players = players.filter { $0.name != player2.name}
        
        if player1.pairing1 {
            let array = players.filter { $0.pairing1 }
            pair1 = array.randomElement()!
        } else if player1.pairing2 {
            let array = players.filter { $0.pairing2 }
            pair1 = array.randomElement()!
        } else {
            var p1Paires = players.filter { !$0.pairing1 }
            p1Paires = p1Paires.filter { !$0.pairing2 }
            
            if playMode {
                p1Paires = self.pickUpPaires(player: player1, players: p1Paires)
                if let player = checkArray(players: p1Paires) {
                    pair1 = player
                } else {
                    p1Paires = self.pickUpByCounts(players: players)
                    pair1 = p1Paires.randomElement()!
                }
            } else {
                p1Paires = self.pickUpByCounts(players: players)
                pair1 = p1Paires.randomElement()!
            }
        }
        
        players = players.filter { $0.name != pair1.name }
        
        if player2.pairing1 {
            let array = players.filter { $0.pairing1 }
            pair2 = array.randomElement()!
        } else if player2.pairing2 {
            let array = players.filter { $0.pairing2 }
            pair2 = array.randomElement()!
        } else {
            var p2Paires = players.filter { !$0.pairing1 }
            p2Paires = p2Paires.filter { !$0.pairing2 }
            
            p2Paires = self.pickUpPaires(player: player2, players: p2Paires)
            if let player = checkArray(players: p2Paires) {
                pair2 = player
            } else {
                p2Paires = self.pickUpByCounts(players: players)
                pair2 = p2Paires.randomElement()!
            }
        }
        
        players = players.filter { $0.name != pair2.name }
        
        let currentPlayers = [player1,player2,pair1,pair2]
        return currentPlayers
    }
    
    func recordGameDataOnPlayersData(currentPlayers: [PadelModel], playingPlayers: [PadelModel], totalPlayers: [PadelModel]) -> [PadelModel] {
        var players = totalPlayers
        
        for player in players {
            for curretPlayer in currentPlayers {
                if player.name == curretPlayer.name {
                    player.playCounts += 1
                }
            }
        }
        
        let player1X = currentPlayers[0]
        let player2X = currentPlayers[1]
        let pair1X = currentPlayers[2]
        let pair2X = currentPlayers[3]
        
        players = putNameOfPairedPlayer(player: player1X, pairedPlayer: pair1X, playingPlayers: playingPlayers, totalPlayers: players)
        players = putNameOfPairedPlayer(player: pair1X, pairedPlayer: player1X, playingPlayers: playingPlayers, totalPlayers: players)
        players = putNameOfPairedPlayer(player: player2X, pairedPlayer: pair2X, playingPlayers: playingPlayers, totalPlayers: players)
        players = putNameOfPairedPlayer(player: pair2X, pairedPlayer: player2X, playingPlayers: playingPlayers, totalPlayers: players)
        
        return players
    }
    
    //プレイヤー１決定後のプレイヤー２決めアレイ作成
    func afterFirstPlayerDecided(player: PadelModel, players: [PadelModel]) -> [PadelModel] {
        var array = players
        
        if player.pairing1 {
            array = array.filter { !$0.pairing1 }
        }
        if player.pairing2 {
            array = array.filter { !$0.pairing2 }
        }
        
        return array
    }
    
    //組んだ人を記録
    func putNameOfPairedPlayer(player: PadelModel, pairedPlayer: PadelModel, playingPlayers: [PadelModel], totalPlayers: [PadelModel]) -> [PadelModel]{
        let players = totalPlayers
        
        for playerX in players {
            if playerX.name == player.name {
                if playerX.pairedPlayer.contains(pairedPlayer.name) {
                    playerX.pairedPlayer2.append(pairedPlayer.name)
                } else {
                    playerX.pairedPlayer.append(pairedPlayer.name)
                    var array = playingPlayers.filter { $0.name != player.name }
                    array = array.filter { !playerX.pairedPlayer.contains($0.name)}
                    if array == [] {
                        playerX.pairedPlayer = playerX.pairedPlayer2
                        playerX.pairedPlayer2 = []
                    }
                }
            }
        }
        return players
    }
    
    //最小試合数
    func getMinCounts(players: [PadelModel]) -> Int {
        let array = players.map {
            $0.playCounts
        }
        guard let min = array.min() else {
            fatalError()
        }
        
        return min
    }
    
    //最小試合数の人を選ぶ
    func pickUpByCounts(players: [PadelModel]) -> [PadelModel] {
        let min = self.getMinCounts(players: players)
        let array = players.filter {
            $0.playCounts == min
        }
        return array
    }
    
    //組んでない人を選ぶ
    func pickUpPaires(player: PadelModel, players: [PadelModel]) -> [PadelModel] {
        let array = players.filter { !player.pairedPlayer.contains($0.name)}
        return array
    }
    
    //全員組んでた場合
    func checkArray(players: [PadelModel]) -> PadelModel? {
        if players != [] {
            let array = pickUpByCounts(players: players)
            let player = array.randomElement()!
            return player
        } else {
            return nil
        }
    }
    
    //試合待ちの人
    mutating func getWaitingPlayers(playingPlayers: [PadelModel], playingPlayersInAnotherCourt: [PadelModel]?, totalPlayers: [PadelModel]) -> [PadelModel] {
        waitingPlayers = totalPlayers
        for player in playingPlayers {
            waitingPlayers = waitingPlayers.filter { $0.name != player.name }
        }
        
        if let anotherCourtPlayers = playingPlayersInAnotherCourt {
            for player in anotherCourtPlayers {
                waitingPlayers = waitingPlayers.filter { $0.name != player.name }
            }
        }
        
        return waitingPlayers
    }
    
    //試合を記録する
    mutating func recordMatch(playingPlayer: [PadelModel], winFlag: Bool? = nil) {
        var gameDataArray = [GameModel]()
        
        if let data = PadelDataRecordBrain().loadGameData() {
            gameDataArray = data
        }
        
        let gameData = GameModel(rF: playingPlayer[0], rB: playingPlayer[2], lF: playingPlayer[1], lB: playingPlayer[3], winFlag: winFlag)
        
        gameDataArray.append(gameData)
        
        PadelDataRecordBrain().saveGameData(gameData: gameDataArray)
    }
}

