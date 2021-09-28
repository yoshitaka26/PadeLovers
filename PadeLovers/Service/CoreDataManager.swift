//
//  CoreDataManager.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/20.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import CoreData

enum CoreDataObjectType: String {
    case padel = "Padel"
    case game = "Game"
    case player = "Player"
    case pairingA = "PairingA"
    case pairingB = "PairingB"
    case court = "Court"
    case score = "Score"
}

class CoreDataManager {
    // swiftlint:disable force_unwrapping
    static let shared = CoreDataManager()
    
    lazy var managerObjectModel = { () -> NSManagedObjectModel in
        let modelURL = Bundle.main.url(forResource: "PadeLovers", withExtension: "momd")
        let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL!)!
        return managedObjectModel
    }()
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "PadeLovers")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        return container
    }()
    lazy var persistentStoreCoordinator = { () -> NSPersistentStoreCoordinator in
        let storeURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last?.appendingPathComponent("PadeLovers")
        let options = [NSInferMappingModelAutomaticallyOption: true, NSMigratePersistentStoresAutomaticallyOption: true]
        let persistentStoreCoordinator = NSPersistentStoreCoordinator(managedObjectModel: managerObjectModel)
        do {
            try persistentStoreCoordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: options)
        } catch {
            print(error)
        }
        return persistentStoreCoordinator
    }()
    lazy var managerObjectContext = { () -> NSManagedObjectContext in
        /**
         パラメータ:CoreData環境スレッド
         NSMainQueueConcurrencyType:メインスレッド       遅滞なく保管
         NSPrivateQueueConcurrencyType:分岐スレッド  遅れて保管
         */
        let context = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType)
        // ストレージスケジューラを設定する
        context.persistentStoreCoordinator = persistentStoreCoordinator
        return context
    }()
}

extension CoreDataManager {
    func initPadel(players: [CommonPlayerDataModel], courts: [String]) -> String {
        let main = createNewObject(objecteType: .padel) as! Padel
        let ID = UUID()
        main.padelID = ID
        main.date = Date()
        for index in 0...2 {
            let court = createNewObject(objecteType: .court) as! Court
            court.courtID = Int16(index)
            if index < courts.count {
                if courts[index] != "" {
                    court.name = courts[index]
                    court.isOn = index < 2 ? true : false
                } else {
                    court.name = "コート\(index + 1)"
                    court.isOn = false
                }
            } else {
                court.name = "コート\(index + 1)"
                court.isOn = false
            }
            court.padelID = ID
            court.onGame = nil
            main.insertIntoCourts(court, at: index)
        }
        for index in 0...20 {
            let player = createNewObject(objecteType: .player) as! Player
            player.padelID = ID
            player.playerID = Int16(index)
            if index < players.count {
                player.name = players[index].playerName
                player.gender = players[index].playerGender
                player.isPlaying = index < 12 ? true : false
            } else {
                player.name = "ゲスト\(index - players.count + 1)"
                player.gender = true
                player.isPlaying = false
            }
            player.pair1 = [Int16(index)]
            player.pair2 = [Int16(index)]
            main.insertIntoPlayers(player, at: index)
        }
        let pairingA = createNewObject(objecteType: .pairingA) as! PairingA
        pairingA.padelID = ID
        pairingA.padel = main
        let pairingB = createNewObject(objecteType: .pairingB) as! PairingB
        pairingB.padelID = ID
        pairingB.padel = main
        saveContext()
        return ID.uuidString
    }
    func deletePadel(uuidString: String) -> Bool {
        let fetchRequest = createRequest(objecteType: .padel)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let padels = try managerObjectContext.fetch(fetchRequest) as! [Padel]
            guard let padel = padels.first else { return false }
            guard let players = padel.players else { return false }
            guard let courts = padel.courts else { return false }
            if let pairingA = padel.pairingA { managerObjectContext.delete(pairingA) }
            if let pairingB = padel.pairingB { managerObjectContext.delete(pairingB) }
            courts.forEach { managerObjectContext.delete($0 as! NSManagedObject) }
            players.forEach { managerObjectContext.delete($0 as! NSManagedObject) }
            deleteAllGames(uuidString: uuidString)
            managerObjectContext.delete(padel)
            saveContext()
            return true
        } catch {
            fatalError("loadData error")
        }
    }
    func loadAllPadelNew() -> [Padel] {
        let fetchRequest = createRequest(objecteType: .padel)
        let sortDescripter = NSSortDescriptor(key: "date", ascending: false)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            let padels = try managerObjectContext.fetch(fetchRequest) as! [Padel]
            return padels
        } catch {
            fatalError("loadData error")
        }
    }
    func loadAllPadelOld() -> [Padel] {
        let fetchRequest = createRequest(objecteType: .padel)
        let sortDescripter = NSSortDescriptor(key: "date", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            let padels = try managerObjectContext.fetch(fetchRequest) as! [Padel]
            return padels
        } catch {
            fatalError("loadData error")
        }
    }
    func loadPadel(uuidString: String) -> Padel? {
        let fetchRequest = createRequest(objecteType: .padel)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let padels = try managerObjectContext.fetch(fetchRequest) as! [Padel]
            guard let padel = padels.first else { return nil }
            return padel
        } catch {
            fatalError("loadData error")
        }
    }
    func loadAllPlayers(uuidString: String) -> [Player] {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "playerID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            let players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            return players
        } catch {
            fatalError("loadData error")
        }
    }
    func loadPlayingPlayers(uuidString: String) -> [Player] {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isPlaying", NSNumber(value: true))
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "playerID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            let players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            return players
        } catch {
            fatalError("countPlayers error")
        }
    }
    func loadPlayersForResultData(uuidString: String) -> [Player] {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "playerID", ascending: true)
        let sortDescripterAdditional = NSSortDescriptor(key: "isPlaying", ascending: false)
        fetchRequest.sortDescriptors = [sortDescripterAdditional, sortDescripter]
        do {
            var players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            players = players.filter { $0.isPlaying || $0.counts > 0 }
            return players
        } catch {
            fatalError("loadData error")
        }
    }
    func loadPlayersForNewGame(uuidString: String) -> [Player] {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isPlaying", NSNumber(value: true))
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "playerID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            var players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            players = players.filter {
                guard let onGame = $0.onGame else { return true }
                if onGame.isEnd { return true }
                return false
            }
            return players
        } catch {
            fatalError("loadData error")
        }
    }
    func loadPlayersOnGame(uuidString: String, gameID: Int16) -> [Player] {
        let fetchRequest = createRequest(objecteType: .game)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K = %d", "padelID", uuid!, "gameID", gameID)
        fetchRequest.predicate = predicate
        do {
            let games = try managerObjectContext.fetch(fetchRequest) as! [Game]
            guard let game = games.first, let players = game.players else { return [] }
            return players.allObjects as! [Player]
        } catch {
            fatalError("loadData error")
        }
    }
    func loadOnGames(uuidString: String) -> [Game] {
        let fetchRequest = createRequest(objecteType: .game)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "startAt", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            var games = try managerObjectContext.fetch(fetchRequest) as! [Game]
            games = games.filter { !$0.isEnd }
            return games
        } catch {
            fatalError("loadData error")
        }
    }
    func loadGameByCourtId(uuidString: String, courtID: Int16) -> Game? {
        let fetchRequest = createRequest(objecteType: .game)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isEnd", NSNumber(value: false))
        fetchRequest.predicate = predicate
        do {
            var games = try managerObjectContext.fetch(fetchRequest) as! [Game]
            games = games.filter {
                guard let court = $0.court, court.onGame != nil else { return false }
                return court.courtID == courtID
            }
            guard let game = games.first else { return nil }
            return game
        } catch {
            fatalError("loadData error")
        }
    }
    func loadGamesForResult(uuidString: String) -> [Game] {
        let fetchRequest = createRequest(objecteType: .game)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isEnd", NSNumber(value: true))
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "gameID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            let games = try managerObjectContext.fetch(fetchRequest) as! [Game]
            return games
        } catch {
            fatalError("loadData error")
        }
    }
    func loadPlayersOfGameByCourtID(uuidString: String, courtID: Int) -> [Player] {
        let fetchRequest = createRequest(objecteType: .court)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K = %d", "padelID", uuid!, "courtID", courtID)
        fetchRequest.predicate = predicate
        do {
            let courts = try managerObjectContext.fetch(fetchRequest) as! [Court]
            guard let court = courts.first, let game = court.onGame else { return [] }
            guard let players = game.players else { return [] }
            return players.allObjects as! [Player]
        } catch {
            fatalError("countPlayers error")
        }
    }
    func deleteGame(uuidString: String, gameID: Int16) {
        guard let padel = loadPadel(uuidString: uuidString) else { return }
        let fetchRequest = createRequest(objecteType: .game)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K = %d", "padelID", uuid!, "gameID", gameID)
        fetchRequest.predicate = predicate
        do {
            let games = try managerObjectContext.fetch(fetchRequest) as! [Game]
            padel.gameCounts -= 1
            games.forEach {
                padel.removeFromGames($0)
                managerObjectContext.delete($0)
            }
            saveContext()
        } catch {
            fatalError("loadData error")
        }
    }
    func deleteAllGames(uuidString: String) {
        let fetchRequest = createRequest(objecteType: .game)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let games = try managerObjectContext.fetch(fetchRequest) as! [Game]
            games.forEach {
                if let score = $0.score {
                    managerObjectContext.delete(score)
                }
                managerObjectContext.delete($0)
            }
        } catch {
            fatalError("loadData error")
        }
    }
    func countPlayers(uuidString: String) -> Int {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isPlaying", NSNumber(value: true))
        fetchRequest.predicate = predicate
        do {
            let players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            return players.count
        } catch {
            fatalError("countPlayers error")
        }
    }
    func loadPlayerForEditingData(uuidString: String, playerID: Int) -> Player? {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K = %d", "padelID", uuid!, "playerID", playerID)
        fetchRequest.predicate = predicate
        do {
            let players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            guard let player = players.first else { return nil }
            return player
        } catch {
            fatalError("countPlayers error")
        }
    }
    func updateIsPlaying(uuidString: String, playerID: Int, isOn isPlaying: Bool) -> Int {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K = %d", "padelID", uuid!, "playerID", playerID)
        fetchRequest.predicate = predicate
        do {
            let players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            guard let player = players.first else { return 0 }
            let min = checkMinCountOfPlayingGame(uuidString: uuidString)
            player.isPlaying = isPlaying
            if isPlaying {
                if player.counts < min {
                    player.counts = min
                    saveContext()
                    return Int(min)
                } else {
                        return 0
                    }
            } else {
                if let pairingA = player.pairingA, pairingA.isOn {
                    deletePairing(uuidString: uuidString, pairingType: .pairingA)
                    return -1
                }
                if let pairingB = player.pairingB, pairingB.isOn {
                    deletePairing(uuidString: uuidString, pairingType: .pairingB)
                    return -1
                }
                if player.counts > 0 {
                    return -2
                }
            }
            return 0
        } catch {
            fatalError("countPlayers error")
        }
    }
    func updateGameMode(uuidString: String, isOn: Bool) {
        let fetchRequest = createRequest(objecteType: .padel)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let padels = try managerObjectContext.fetch(fetchRequest) as! [Padel]
            guard let padel = padels.first else { return }
            padel.playMode = isOn
            saveContext()
        } catch {
            fatalError("loadData error")
        }
    }
    func updateShowResult(uuidString: String, isOn: Bool) {
        let fetchRequest = createRequest(objecteType: .padel)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let padels = try managerObjectContext.fetch(fetchRequest) as! [Padel]
            guard let padel = padels.first else { return }
            padel.showResult = isOn
            saveContext()
        } catch {
            fatalError("loadData error")
        }
    }
    func loadCourts(uuidString: String) -> [Court] {
        let fetchRequest = createRequest(objecteType: .court)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "courtID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            let courts = try managerObjectContext.fetch(fetchRequest) as! [Court]
            return courts
        } catch {
            fatalError("loadData error")
        }
    }
    func loadCourt(uuidString: String, courtID: Int16) -> Court? {
        let fetchRequest = createRequest(objecteType: .court)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K = %d", "padelID", uuid!, "courtID", courtID)
        fetchRequest.predicate = predicate
        do {
            let courts = try managerObjectContext.fetch(fetchRequest) as! [Court]
            guard let court = courts.first else { return nil }
            return court
        } catch {
            fatalError("countPlayers error")
        }
    }
    func loadCourtsIsOn(uuidString: String) -> [Court] {
        let fetchRequest = createRequest(objecteType: .court)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isOn", NSNumber(value: true))
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "courtID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            let courts = try managerObjectContext.fetch(fetchRequest) as! [Court]
            return courts
        } catch {
            fatalError("loadData error")
        }
    }
    func updateCourtIsOn(uuidString: String, courtID: Int, isOn: Bool) -> Bool {
        let fetchRequest = createRequest(objecteType: .court)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K = %d", "padelID", uuid!, "courtID", courtID)
        fetchRequest.predicate = predicate
        do {
            let courts = try managerObjectContext.fetch(fetchRequest) as! [Court]
            guard let court = courts.first else { return false }
            court.isOn = isOn
            if !isOn, let game = court.onGame {
                deleteGame(uuidString: uuidString, gameID: game.gameID)
            }
            saveContext()
            return true
        } catch {
            fatalError("countPlayers error")
        }
    }
    func returnEmptyCourtNum(uuidString: String) -> Int {
        let fetchRequest = createRequest(objecteType: .court)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "courtID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            let courts = try managerObjectContext.fetch(fetchRequest) as! [Court]
            var num = 0
            for court in courts {
                if court.isOn && court.onGame == nil { num += 1 }
            }
            return num
        } catch {
            fatalError("loadData error")
        }
    }
    func updatePairing(uuidString: String, pairingType: PairingType, isOn: Bool) {
        let objectType = changePairingTypeToObjectType(pairingType: pairingType)
        let fetchRequest = createRequest(objecteType: objectType)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let pairing = try managerObjectContext.fetch(fetchRequest)
            if let paringA = pairing as? [PairingA] { paringA.first?.isOn = isOn }
            if let paringB = pairing as? [PairingB] { paringB.first?.isOn = isOn }
            saveContext()
        } catch {
            fatalError("loadData error")
        }
    }
    func deletePairing(uuidString: String, pairingType: PairingType) {
        let objectType = changePairingTypeToObjectType(pairingType: pairingType)
        let fetchRequest = createRequest(objecteType: objectType)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let pairing = try managerObjectContext.fetch(fetchRequest)
            if let paring = pairing as? [PairingA] {
                guard pairing.count == 1 else { return }
                guard let pairingA = paring.first else { return }
                if let pairingPlayers = pairingA.pairing {
                    pairingA.removeFromPairing(pairingPlayers)
                    pairingA.isOn = false
                }
            }
            if let pairing = pairing as? [PairingB] {
                guard pairing.count == 1 else { return }
                guard let pairingB = pairing.first else { return }
                if let pairingPlayers = pairingB.pairing {
                    pairingB.removeFromPairing(pairingPlayers)
                    pairingB.isOn = false
                }
            }
            saveContext()
        } catch {
            fatalError("loadData error")
        }
    }
    func loadPlayersForPairing(uuidString: String, pairingType: PairingType) -> [Player] {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isPlaying", NSNumber(value: true))
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "playerID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            var players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            players = players.filter { $0.isPairingEnable(type: pairingType) }
            return players
        } catch {
            fatalError("loadData error")
        }
    }
    func loadPairedPlayers(uuidString: String, pairingType: PairingType) -> [Player]? {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isPlaying", NSNumber(value: true))
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "playerID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            var players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            players = players.filter { $0.isPairedPlayer(type: pairingType) }
            guard players.count == 2 else { return nil }
            return players
        } catch {
            fatalError("loadData error")
        }
    }
    func checkMinCountOfPlayingGame(uuidString: String) -> Int16 {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isPlaying", NSNumber(value: true))
        fetchRequest.predicate = predicate
        do {
            let players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            var countsArray: [Int16] = []
            players.forEach { countsArray.append($0.counts) }
            guard let minCount = countsArray.min() else { return 0 }
            return minCount
        } catch {
            fatalError("loadData error")
        }
    }
    func setReadyStatusOnPadel(uuidString: String, isReady: Bool) {
        guard let padel = loadPadel(uuidString: uuidString) else { return }
        padel.isReady = isReady
        saveContext()
    }
    func checkReadyStatus(uuidString: String) -> Bool {
        guard let padel = loadPadel(uuidString: uuidString) else { return false }
        return padel.isReady
    }
    func setGame(uuidString: String) -> Game? {
        let game = createNewObject(objecteType: .game) as! Game
        guard let padel = loadPadel(uuidString: uuidString) else { return nil }
        guard padel.isReady else { return nil }
        game.padelID = UUID(uuidString: uuidString)
        game.gameID = padel.gameIDNumber
        game.startAt = Date()
        game.isEnd = false
        padel.addToGames(game)
        padel.gameIDNumber += 1
        padel.gameCounts += 1
        saveContext()
        return game
    }
    func recordScore(uuidString: String, game: Game, scoreData: ScoreData) {
        let score = createNewObject(objecteType: .score) as! Score
        guard let padel = loadPadel(uuidString: uuidString) else { return }
        score.padelID = padel.padelID
        score.score1A = scoreData.A1Score
        score.score1B = scoreData.B1Score
        score.score2A = scoreData.A2Score
        score.score2B = scoreData.B2Score
        score.score3A = scoreData.A3Score
        score.score3B = scoreData.B3Score
        score.totalA = scoreData.totalA
        score.totalB = scoreData.totalB
        score.playTime = scoreData.time
        game.score = score
        saveContext()
    }
    func updateScore(uuidString: String, game: Game, scoreData: ScoreData) {
        guard let score = game.score else { return }
        score.score1A = scoreData.A1Score
        score.score1B = scoreData.B1Score
        score.score2A = scoreData.A2Score
        score.score2B = scoreData.B2Score
        score.score3A = scoreData.A3Score
        score.score3B = scoreData.B3Score
        score.totalA = scoreData.totalA
        score.totalB = scoreData.totalB
        game.score = score
        saveContext()
    }
    func changePairingTypeToObjectType(pairingType: PairingType) -> CoreDataObjectType {
        switch pairingType {
        case .pairingA:
            return CoreDataObjectType.pairingA
        case .pairingB:
            return CoreDataObjectType.pairingB
        }
    }
    func createRequest(objecteType: CoreDataObjectType) -> NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest<NSFetchRequestResult>(entityName: objecteType.rawValue)
    }
    func createNewObject(objecteType: CoreDataObjectType) -> NSManagedObject {
        return NSEntityDescription.insertNewObject(forEntityName: objecteType.rawValue, into: managerObjectContext)
    }
    func saveContext() {
        if managerObjectContext.hasChanges {
            do {
                try managerObjectContext.save()
            } catch let error {
                print(error)
                abort()
            }
        }
    }
    // swiftlint:enable force_unwrapping
}
