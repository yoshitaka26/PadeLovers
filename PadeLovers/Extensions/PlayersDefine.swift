//
//  Players.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/04.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation

enum PlayersDefine: Int {
    // swiftlint:disable switch_case_on_newline
    case player1
    case player2
    case player3
    case player4
    case player5
    case player6
    case player7
    case player8
    case player9
    case player10
    case player11
    case player12
    case player13
    case player14
    case player15
    case player16
    case player17
    case player18
    case player19
    case player20
    case player21
    
    var defaultName: String {
        switch self {
        case .player1: return "プレイヤ１"
        case .player2: return "プレイヤ２"
        case .player3: return "プレイヤ３"
        case .player4: return "プレイヤ４"
        case .player5: return "プレイヤ５"
        case .player6: return "プレイヤ６"
        case .player7: return "プレイヤ７"
        case .player8: return "プレイヤ８"
        case .player9: return "プレイヤ９"
        case .player10: return "プレイヤ１０"
        case .player11: return "プレイヤ１１"
        case .player12: return "プレイヤ１２"
        case .player13: return "プレイヤ１３"
        case .player14: return "プレイヤ１４"
        case .player15: return "プレイヤ１５"
        case .player16: return "プレイヤ１６"
        case .player17: return "プレイヤ１７"
        case .player18: return "プレイヤ１８"
        case .player19: return "プレイヤ１９"
        case .player20: return "プレイヤ２０"
        case .player21: return "プレイヤ２１"
        }
    }
    var key: String {
        switch self {
        case .player1: return "player1"
        case .player2: return "player2"
        case .player3: return "player3"
        case .player4: return "player4"
        case .player5: return "player5"
        case .player6: return "player6"
        case .player7: return "player7"
        case .player8: return "player8"
        case .player9: return "player9"
        case .player10: return "player10"
        case .player11: return "player11"
        case .player12: return "player12"
        case .player13: return "player13"
        case .player14: return "player14"
        case .player15: return "player15"
        case .player16: return "player16"
        case .player17: return "player17"
        case .player18: return "player18"
        case .player19: return "player19"
        case .player20: return "player20"
        case .player21: return "player21"
        }
    }
    // swiftlint:enable switch_case_on_newline
}
