//
//  PairingB+CoreDataProperties.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/10.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//
//

import Foundation
import CoreData


extension PairingB {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PairingB> {
        return NSFetchRequest<PairingB>(entityName: "PairingB")
    }

    @NSManaged public var isOn: Bool
    @NSManaged public var padelID: UUID?
    @NSManaged public var padel: Padel?
    @NSManaged public var pairing: NSSet?

}

// MARK: Generated accessors for pairing
extension PairingB {

    @objc(addPairingObject:)
    @NSManaged public func addToPairing(_ value: Player)

    @objc(removePairingObject:)
    @NSManaged public func removeFromPairing(_ value: Player)

    @objc(addPairing:)
    @NSManaged public func addToPairing(_ values: NSSet)

    @objc(removePairing:)
    @NSManaged public func removeFromPairing(_ values: NSSet)

}

extension PairingB : Identifiable {

}
