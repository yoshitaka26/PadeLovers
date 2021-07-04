//
//  Court+CoreDataProperties.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/24.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//
//

import Foundation
import CoreData


extension Court {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Court> {
        return NSFetchRequest<Court>(entityName: "Court")
    }

    @NSManaged public var courtID: Int16
    @NSManaged public var isOn: Bool
    @NSManaged public var name: String?
    @NSManaged public var padelID: UUID?
    @NSManaged public var onGame: Game?
    @NSManaged public var padel: Padel?

}

extension Court : Identifiable {

}
