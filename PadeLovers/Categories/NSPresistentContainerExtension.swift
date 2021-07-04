//
//  NSPresistentContainerExtension.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/20.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import CoreData

extension NSPersistentContainer {
    /// viewContextで保存
    func saveContext() {
        saveContext(context: viewContext)
    }
    
    /// 指定したcontextで保存
    /// マルチスレッド環境でのバックグラウンドコンテキストを使う場合など
    func saveContext(context: NSManagedObjectContext) {
        
        // 変更がなければ何もしない
        guard context.hasChanges else {
            return
        }
        
        do {
            try context.save()
        } catch let error as NSError {
            print("Error: \(error), \(error.userInfo)")
        }
    }
}
