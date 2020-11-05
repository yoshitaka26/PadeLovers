//
//  GameDataModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/28.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class GameModel: Codable {
    var rightForeside: PadelModel
    var rightBackside: PadelModel
    var leftForeside: PadelModel
    var leftBackside: PadelModel
    
    init(rF: PadelModel, rB: PadelModel, lF: PadelModel, lB: PadelModel) {
        self.rightForeside = rF
        self.rightBackside = rB
        self.leftForeside = lF
        self.leftBackside = lB
    }
}

class PadelModel: Comparable, Codable {
    static func < (lhs: PadelModel, rhs: PadelModel) -> Bool {
        lhs.playCounts < rhs.playCounts
    }
    
    static func == (lhs: PadelModel, rhs: PadelModel) -> Bool {
        lhs.pairedPlayer == rhs.pairedPlayer
    }
    
    var name: String
    var playCounts:Int
    var pairedPlayer: [String]
    var pairedPlayer2: [String]
    var gender: Bool
    var pairing1: Bool
    var pairing2: Bool
    var playingFlag: Bool
    
    init(name: String, playCounts:Int = 0, pairedPlayer:[String] = [], pairedPlayer2: [String] = [], gender: Bool = true, pairing1: Bool = false, pairing2: Bool = false, playingFlag: Bool = true) {
        self.name = name
        self.playCounts = playCounts
        self.pairedPlayer = pairedPlayer
        self.pairedPlayer2 = pairedPlayer2
        self.gender = gender
        self.pairing1 = pairing1
        self.pairing2 = pairing2
        self.playingFlag = playingFlag
    }
}


