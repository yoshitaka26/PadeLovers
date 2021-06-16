//
//  Padel+CoreDataProperties.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/12.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//
//

import Foundation
import CoreData


extension Padel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Padel> {
        return NSFetchRequest<Padel>(entityName: "Padel")
    }

    @NSManaged public var date: Date?
    @NSManaged public var gameCounts: Int16
    @NSManaged public var isReady: Bool
    @NSManaged public var padelID: UUID?
    @NSManaged public var playMode: Bool
    @NSManaged public var showResult: Bool
    @NSManaged public var gameIDNumber: Int16
    @NSManaged public var courts: NSOrderedSet?
    @NSManaged public var games: NSOrderedSet?
    @NSManaged public var pairingA: PairingA?
    @NSManaged public var pairingB: PairingB?
    @NSManaged public var players: NSOrderedSet?

}

// MARK: Generated accessors for courts
extension Padel {

    @objc(insertObject:inCourtsAtIndex:)
    @NSManaged public func insertIntoCourts(_ value: Court, at idx: Int)

    @objc(removeObjectFromCourtsAtIndex:)
    @NSManaged public func removeFromCourts(at idx: Int)

    @objc(insertCourts:atIndexes:)
    @NSManaged public func insertIntoCourts(_ values: [Court], at indexes: NSIndexSet)

    @objc(removeCourtsAtIndexes:)
    @NSManaged public func removeFromCourts(at indexes: NSIndexSet)

    @objc(replaceObjectInCourtsAtIndex:withObject:)
    @NSManaged public func replaceCourts(at idx: Int, with value: Court)

    @objc(replaceCourtsAtIndexes:withCourts:)
    @NSManaged public func replaceCourts(at indexes: NSIndexSet, with values: [Court])

    @objc(addCourtsObject:)
    @NSManaged public func addToCourts(_ value: Court)

    @objc(removeCourtsObject:)
    @NSManaged public func removeFromCourts(_ value: Court)

    @objc(addCourts:)
    @NSManaged public func addToCourts(_ values: NSOrderedSet)

    @objc(removeCourts:)
    @NSManaged public func removeFromCourts(_ values: NSOrderedSet)

}

// MARK: Generated accessors for games
extension Padel {

    @objc(insertObject:inGamesAtIndex:)
    @NSManaged public func insertIntoGames(_ value: Game, at idx: Int)

    @objc(removeObjectFromGamesAtIndex:)
    @NSManaged public func removeFromGames(at idx: Int)

    @objc(insertGames:atIndexes:)
    @NSManaged public func insertIntoGames(_ values: [Game], at indexes: NSIndexSet)

    @objc(removeGamesAtIndexes:)
    @NSManaged public func removeFromGames(at indexes: NSIndexSet)

    @objc(replaceObjectInGamesAtIndex:withObject:)
    @NSManaged public func replaceGames(at idx: Int, with value: Game)

    @objc(replaceGamesAtIndexes:withGames:)
    @NSManaged public func replaceGames(at indexes: NSIndexSet, with values: [Game])

    @objc(addGamesObject:)
    @NSManaged public func addToGames(_ value: Game)

    @objc(removeGamesObject:)
    @NSManaged public func removeFromGames(_ value: Game)

    @objc(addGames:)
    @NSManaged public func addToGames(_ values: NSOrderedSet)

    @objc(removeGames:)
    @NSManaged public func removeFromGames(_ values: NSOrderedSet)

}

// MARK: Generated accessors for players
extension Padel {

    @objc(insertObject:inPlayersAtIndex:)
    @NSManaged public func insertIntoPlayers(_ value: Player, at idx: Int)

    @objc(removeObjectFromPlayersAtIndex:)
    @NSManaged public func removeFromPlayers(at idx: Int)

    @objc(insertPlayers:atIndexes:)
    @NSManaged public func insertIntoPlayers(_ values: [Player], at indexes: NSIndexSet)

    @objc(removePlayersAtIndexes:)
    @NSManaged public func removeFromPlayers(at indexes: NSIndexSet)

    @objc(replaceObjectInPlayersAtIndex:withObject:)
    @NSManaged public func replacePlayers(at idx: Int, with value: Player)

    @objc(replacePlayersAtIndexes:withPlayers:)
    @NSManaged public func replacePlayers(at indexes: NSIndexSet, with values: [Player])

    @objc(addPlayersObject:)
    @NSManaged public func addToPlayers(_ value: Player)

    @objc(removePlayersObject:)
    @NSManaged public func removeFromPlayers(_ value: Player)

    @objc(addPlayers:)
    @NSManaged public func addToPlayers(_ values: NSOrderedSet)

    @objc(removePlayers:)
    @NSManaged public func removeFromPlayers(_ values: NSOrderedSet)

}

extension Padel : Identifiable {

}
