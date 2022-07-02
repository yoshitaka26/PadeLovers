//
//  NotificationName+Extension.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/07/02.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation

// NotificationCenter通知名を登録
extension Notification.Name {
    static let updateDataNotificationByEditPair = Notification.Name("updateByEditPair")
    static let updateDataNotificationByEditData = Notification.Name("updateByEditData")
}
