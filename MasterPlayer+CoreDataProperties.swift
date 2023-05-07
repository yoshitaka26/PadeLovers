//
//  MasterPlayer+CoreDataProperties.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/05/07.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//
//

import Foundation
import CoreData


extension MasterPlayer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MasterPlayer> {
        return NSFetchRequest<MasterPlayer>(entityName: "MasterPlayer")
    }

    @NSManaged public var name: String?
    @NSManaged public var gender: Bool
    @NSManaged public var order: Int16
    @NSManaged public var groupID: UUID?
    @NSManaged public var group: MasterPlayerGroup?

}

extension MasterPlayer : Identifiable {

}
