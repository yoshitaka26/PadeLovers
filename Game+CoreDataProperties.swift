//
//  Game+CoreDataProperties.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/10.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//
//

import Foundation
import CoreData


extension Game {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Game> {
        return NSFetchRequest<Game>(entityName: "Game")
    }

    @NSManaged public var gameID: Int16
    @NSManaged public var isEnd: Bool
    @NSManaged public var padelID: UUID?
    @NSManaged public var winner: Bool
    @NSManaged public var backB: Int16
    @NSManaged public var backA: Int16
    @NSManaged public var driveB: Int16
    @NSManaged public var driveA: Int16
    @NSManaged public var court: Court?
    @NSManaged public var padel: Padel?
    @NSManaged public var players: NSSet?
    @NSManaged public var score: Score?

}

// MARK: Generated accessors for players
extension Game {

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSSet)

}

extension Game : Identifiable {

}
