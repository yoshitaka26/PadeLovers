//
//  CommonPlayerDataModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/22.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

final class CommonPlayerDataModel: Codable {
    
    var playerName: String
    var playerGender: Bool
    
    init(name: String, gender: Bool) {
        self.playerName = name
        self.playerGender = gender
    }
}
