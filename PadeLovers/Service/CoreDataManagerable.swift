//
//  CoreDataManagerable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/10.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

protocol CoreDataManagerable {
    // MARK: Padel
    func loadPadel(uuidString: String) -> Padel?
    // MARK: GameMode
    func updateGameMode(uuidString: String, isOn: Bool)
    // MARK: GameResult
    func updateShowResult(uuidString: String, isOn: Bool)
    // MARK: Court
    func loadCourts(uuidString: String) -> [Court]
    func loadCourtsIsOn(uuidString: String) -> [Court]
    func updateCourtIsOn(uuidString: String, courtID: Int, isOn: Bool) -> Bool
    // MARK: Pairing
    func loadPairing(uuidString: String) -> [Pairing]
    func updatePairing(uuidString: String, pairingType: PairingType, isOn: Bool)
    // MARK: Player
    func loadAllPlayers(uuidString: String) -> [Player]
    func updateIsPlaying(uuidString: String, playerID: Int, isOn isPlaying: Bool) -> Int
    func countPlayers(uuidString: String) -> Int
    func minPlayersCount(uuidString: String) -> Int

    // MARK: GameStatus
    func initPadel(players: [CommonPlayerDataModel], courts: [String]) -> String
    func setReadyStatusOnPadel(uuidString: String, isReady: Bool)
}