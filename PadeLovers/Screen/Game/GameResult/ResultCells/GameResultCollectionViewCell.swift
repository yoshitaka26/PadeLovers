//
//  GameResultCollectionViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/16.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

enum ScoreView: Int16 {
    case zero
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    
    var view: UIImage {
        switch self {
        case .zero:
            return UIImage.named("0.square")
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
            return UIImage.named("6.square")
        case .seven:
            return UIImage.named("7.square")
        }
    }
}

class GameResultCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var gameLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var driveAname: UILabel!
    @IBOutlet weak var backAname: UILabel!
    @IBOutlet weak var driveBname: UILabel!
    @IBOutlet weak var backBname: UILabel!
    @IBOutlet weak var A1score: UIImageView!
    @IBOutlet weak var B1score: UIImageView!
    @IBOutlet weak var A2score: UIImageView!
    @IBOutlet weak var B2score: UIImageView!
    @IBOutlet weak var A3score: UIImageView!
    @IBOutlet weak var B3score: UIImageView!
    @IBOutlet weak var Afinalscore: UIImageView!
    @IBOutlet weak var Bfinalscore: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(game: Game, playersList: [Player], count: Int) {
        gameLabel.text = "第 \(count + 1) 試合"
        
        var players = [PositionType: Player]()
        
        playersList.forEach {
            switch $0.playerID {
            case game.driveA:
                players[.driveA] = $0
            case game.backA:
                players[.backA] = $0
            case game.driveB:
                players[.driveB] = $0
            case game.backB:
                players[.backB] = $0
            default:
                break
            }
        }
        driveAname.attributedText = NSAttributedString.setNameOnLabel(name: players[.driveA]?.name ?? "", gender: players[.driveA]?.gender ?? true)
        backAname.attributedText = NSAttributedString.setNameOnLabel(name: players[.backA]?.name ?? "", gender: players[.backA]?.gender ?? true)
        driveBname.attributedText = NSAttributedString.setNameOnLabel(name: players[.driveB]?.name ?? "", gender: players[.driveB]?.gender ?? true)
        backBname.attributedText = NSAttributedString.setNameOnLabel(name: players[.backB]?.name ?? "", gender: players[.backB]?.gender ?? true)
        A1score.image = nil
        B1score.image = nil
        A2score.image = nil
        B2score.image = nil
        A3score.image = nil
        B3score.image = nil
        Afinalscore.image = nil
        Bfinalscore.image = nil
        timeLabel.text = ""
        
        guard let score = game.score else { return }
        guard let time = score.playTime else { return }
        timeLabel.text = String(time)
        A1score.image = ScoreView(rawValue: score.score1A)?.view
        B1score.image = ScoreView(rawValue: score.score1B)?.view
        A2score.image = ScoreView(rawValue: score.score2A)?.view
        B2score.image = ScoreView(rawValue: score.score2B)?.view
        A3score.image = ScoreView(rawValue: score.score3A)?.view
        B3score.image = ScoreView(rawValue: score.score3B)?.view
        Afinalscore.image = ScoreView(rawValue: score.totalA)?.view
        Bfinalscore.image = ScoreView(rawValue: score.totalB)?.view
    }
}
