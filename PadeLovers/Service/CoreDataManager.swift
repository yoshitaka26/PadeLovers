//
//  CoreDataManager.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/20.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import CoreData

enum CoreDataObjectType: String {
    case padel = "Padel"
    case game = "Game"
    case player = "Player"
    case pairingA = "PairingA"
    case pairingB = "PairingB"
    case court = "Court"
}

class CoreDataManager {
    static let shared: CoreDataManager = CoreDataManager()
    
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
    func initGame(uuidString: String) {
        let main = createNewObject(objecteType: .padel) as! Padel
        let ID = UUID(uuidString: uuidString)
        main.padelID = ID
        main.date = Date()
        for index in 0...2 {
            let court = createNewObject(objecteType: .court) as! Court
            court.courtID = Int16(index)
            court.name = "青コート"
            court.padelID = ID
            court.isOn = true
            main.insertIntoCourts(court, at: index)
        }
        for index in 0...20 {
            let player = createNewObject(objecteType: .player) as! Player
            player.padelID = ID
            player.playerID = Int16(index)
            player.name = PlayersDefine(rawValue: index)?.defaultName ?? ""
            player.gender = false
            player.isPlaying = true
            player.pair1 = [0, 2]
            player.pair2 = [4, 7]
            main.insertIntoPlayers(player, at: index)
        }
        let pairingA = createNewObject(objecteType: .pairingA) as! PairingA
        pairingA.padelID = ID
        pairingA.padel = main
        let pairingB = createNewObject(objecteType: .pairingB) as! PairingB
        pairingB.padelID = ID
        pairingB.padel = main
        saveContext()
    }
    func checkMainDataByID(uuidString: String) -> Bool {
        let fetchRequest = createRequest(objecteType: .padel)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let padels = try managerObjectContext.fetch(fetchRequest) as! [Padel]
            guard padels.first != nil else { return false }
            return true
        } catch {
            fatalError("loadData error")
        }
    }
    func loadMainData(uuidString: String) -> Padel? {
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
    func loadPlayers(uuidString: String) -> [Player]? {
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
    func loadPlayerForEditingData(uuidString: String, index playerID: Int) -> Player? {
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
    func updateIsPlaying(uuidString: String, index playerID: Int, isOn isPlaying: Bool) -> Int {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K = %d", "padelID", uuid!, "playerID", playerID)
        fetchRequest.predicate = predicate
        do {
            let players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            guard let player = players.first else { return 0 }
            player.isPlaying = isPlaying
            if isPlaying {
                let min = checkMinCountOfPlayingGame(uuidString: uuidString)
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
    func loadCourts(uuidString: String) -> [Court]? {
        let fetchRequest = createRequest(objecteType: .court)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "courtID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            let courts = try managerObjectContext.fetch(fetchRequest) as! [Court]
            guard courts.count == 3 else { return nil }
            return courts
        } catch {
            fatalError("loadData error")
        }
    }
    func updateCourtIsOn(uuidString: String, index courtID: Int, isOn: Bool) -> Bool {
        let fetchRequest = createRequest(objecteType: .court)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K = %d", "padelID", uuid!, "courtID", courtID)
        fetchRequest.predicate = predicate
        do {
            let courts = try managerObjectContext.fetch(fetchRequest) as! [Court]
            guard let court = courts.first else { return false }
            court.isOn = isOn
            saveContext()
            return true
        } catch {
            fatalError("countPlayers error")
        }
    }
    func updatePairing(uuidString: String, pairingType: CoreDataObjectType, isOn: Bool) {
        let fetchRequest = createRequest(objecteType: pairingType)
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
    func deletePairing(uuidString: String, pairingType: CoreDataObjectType) {
        let fetchRequest = createRequest(objecteType: pairingType)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let pairing = try managerObjectContext.fetch(fetchRequest)
            if let paringA = pairing as? [PairingA] {
                guard let pairingAone = paringA.first else { return }
                if let pairingPlayers = pairingAone.pairing {
                    pairingAone.removeFromPairing(pairingPlayers)
                    pairingAone.isOn = false
                }
            }
            if let pairingB = pairing as? [PairingB] {
                guard let pairingBone = pairingB.first else { return }
                if let pairingPlayers = pairingBone.pairing {
                    pairingBone.removeFromPairing(pairingPlayers)
                    pairingBone.isOn = false
                }
            }
            saveContext()
        } catch {
            fatalError("loadData error")
        }
    }
    func loadPairingPlayers(uuidString: String, pairingType: PairingType) -> [Player] {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@ AND %K == %@", "padelID", uuid!, "isPlaying", NSNumber(value: true))
        fetchRequest.predicate = predicate
        let sortDescripter = NSSortDescriptor(key: "playerID", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        do {
            var players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            players = players.filter{ $0.isPairingEnable(type: pairingType) }
            return players
        } catch {
            fatalError("loadData error")
        }
    }
    func checkMinCountOfPlayingGame(uuidString: String) -> Int16 {
        let fetchRequest = createRequest(objecteType: .player)
        let uuid = NSUUID(uuidString: uuidString)
        let predicate = NSPredicate(format: "%K == %@", "padelID", uuid!)
        fetchRequest.predicate = predicate
        do {
            let players = try managerObjectContext.fetch(fetchRequest) as! [Player]
            var countsArray: [Int16] = []
            players.forEach { countsArray.append($0.counts) }
            return countsArray.min()!
        } catch {
            fatalError("loadData error")
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
}
