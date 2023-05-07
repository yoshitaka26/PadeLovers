//
//  MasterPlayerGroup+CoreDataProperties.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/05/07.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//
//

import Foundation
import CoreData


extension MasterPlayerGroup {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MasterPlayerGroup> {
        return NSFetchRequest<MasterPlayerGroup>(entityName: "MasterPlayerGroup")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var created: Date?
    @NSManaged public var modified: Date?
    @NSManaged public var player: NSSet?

}

// MARK: Generated accessors for player
extension MasterPlayerGroup {

    @objc(addPlayerObject:)
    @NSManaged public func addToPlayer(_ value: MasterPlayer)

    @objc(removePlayerObject:)
    @NSManaged public func removeFromPlayer(_ value: MasterPlayer)

    @objc(addPlayer:)
    @NSManaged public func addToPlayer(_ values: NSSet)

    @objc(removePlayer:)
    @NSManaged public func removeFromPlayer(_ values: NSSet)

}

extension MasterPlayerGroup : Identifiable {

}
