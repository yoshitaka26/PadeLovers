//
//  Player+CoreDataProperties.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/10.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//
//

import Foundation
import CoreData


extension Player {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Player> {
        return NSFetchRequest<Player>(entityName: "Player")
    }

    @NSManaged public var counts: Int16
    @NSManaged public var gender: Bool
    @NSManaged public var isPlaying: Bool
    @NSManaged public var name: String?
    @NSManaged public var padelID: UUID?
    @NSManaged public var pair1: [Int16]
    @NSManaged public var pair2: [Int16]
    @NSManaged public var playerID: Int16
    @NSManaged public var padel: Padel?
    @NSManaged public var pairingA: PairingA?
    @NSManaged public var pairingB: PairingB?
    @NSManaged public var onGame: Game?

}

extension Player : Identifiable {

}
