//
//  NSManagedObject+Extensions.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/08.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import CoreData

extension NSManagedObject {
    func save() {
        do {
            try managedObjectContext?.save()
        } catch let error {
            print(error)
            abort()
        }
    }
}
