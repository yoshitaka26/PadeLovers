//
//  RandomNumberTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/26.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

enum RandomNumberView: Int {
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    
    var view: UIImage {
        switch self {
        case .one:
            return UIImage.named("1.square")
        case .two:
            return UIImage.named("2.square")
        case .three:
            return UIImage.named("3.square")
        case .four:
            return UIImage.named("4.square")
        case .five:
            return UIImage.named("5.square")
        case .six:
            return UIImage.named( "6.square")
        case .seven:
            return UIImage.named("7.square")
        case .eight:
            return UIImage.named("8.square")
        }
    }
}

class RandomNumberTableViewCell: UITableViewCell {
    
    @IBOutlet weak var pair1Player1: UIImageView!
    @IBOutlet weak var pair1Player2: UIImageView!
    @IBOutlet weak var pair2Player1: UIImageView!
    @IBOutlet weak var pair2Player2: UIImageView!
    @IBOutlet weak var waiting1: UIImageView!
    @IBOutlet weak var waiting2: UIImageView!
    @IBOutlet weak var waiting3: UIImageView!
    @IBOutlet weak var waiting4: UIImageView!
        
    func setUI(match: Match, playersNumber: Int, onMatchNum: Int) {
        var allPlayers: [Int] = []
        for i in 1...playersNumber {
            allPlayers.append(i)
        }
        allPlayers = allPlayers.filter {
            guard $0 != match.pair1.player1 else { return false }
            guard $0 != match.pair1.player2 else { return false }
            guard $0 != match.pair2.player1 else { return false }
            guard $0 != match.pair2.player2 else { return false }
            return true
        }
        pair1Player1.image = nil
        pair1Player2.image = nil
        pair2Player1.image = nil
        pair2Player2.image = nil
        waiting1.image = nil
        waiting2.image = nil
        waiting3.image = nil
        waiting4.image = nil
        
        pair1Player1.image = RandomNumberView(rawValue: match.pair1.player1 - 1)?.view
        pair1Player2.image = RandomNumberView(rawValue: match.pair1.player2 - 1)?.view
        pair2Player1.image = RandomNumberView(rawValue: match.pair2.player1 - 1)?.view
        pair2Player2.image = RandomNumberView(rawValue: match.pair2.player2 - 1)?.view
        
        switch onMatchNum {
        case (..<0):
            self.backgroundColor = .appBlue
        case 0:
            self.backgroundColor = .appYellow
        default:
            self.backgroundColor = .darkGray
        }
        
        guard !allPlayers.isEmpty else { return }
        
        for (index, waiting) in allPlayers.enumerated() {
            switch index {
            case 0:
                waiting1.image = RandomNumberView(rawValue: waiting - 1)?.view
            case 1:
                waiting2.image = RandomNumberView(rawValue: waiting - 1)?.view
            case 2:
                waiting3.image = RandomNumberView(rawValue: waiting - 1)?.view
            default:
                waiting4.image = RandomNumberView(rawValue: waiting - 1)?.view
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
