//
//  DeviceType.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/14.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

enum DeviceType {
    case iPhone, iPad, unknown
}

extension View {
    func currentDeviceType() -> DeviceType {
        switch UIDevice.current.userInterfaceIdiom {
        case .phone:
            return .iPhone
        case .pad:
            return .iPad
        default:
            return .unknown
        }
    }
}
