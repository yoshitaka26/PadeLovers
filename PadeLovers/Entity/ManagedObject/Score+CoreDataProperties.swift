//
//  Score+CoreDataProperties.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/24.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//
//

import Foundation
import CoreData


extension Score {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Score> {
        return NSFetchRequest<Score>(entityName: "Score")
    }

    @NSManaged public var padelID: UUID?
    @NSManaged public var playTime: String?
    @NSManaged public var score1A: Int16
    @NSManaged public var score1B: Int16
    @NSManaged public var score2A: Int16
    @NSManaged public var score2B: Int16
    @NSManaged public var score3A: Int16
    @NSManaged public var score3B: Int16
    @NSManaged public var totalA: Int16
    @NSManaged public var totalB: Int16
    @NSManaged public var game: Game?

}

extension Score : Identifiable {

}
