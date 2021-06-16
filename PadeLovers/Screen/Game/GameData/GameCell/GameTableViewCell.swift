//
//  TableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class GameTableViewCell: UITableViewCell {

    @IBOutlet weak var playerChangeButton: UIButton!
    @IBOutlet weak var gameFinishButton: UIButton!

    @IBOutlet weak var courtLabel: UILabel!
    @IBOutlet weak var driveALabel: UILabel!
    @IBOutlet weak var backALabel: UILabel!
    @IBOutlet weak var driveBLabel: UILabel!
    @IBOutlet weak var backBLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        playerChangeButton.layer.cornerRadius = playerChangeButton.frame.size.height / 4
        gameFinishButton.layer.cornerRadius = gameFinishButton.frame.size.height / 4

        playerChangeButton.layer.borderColor = UIColor.gray.cgColor
        playerChangeButton.layer.borderWidth = 1.0

        gameFinishButton.layer.borderColor = UIColor.gray.cgColor
        gameFinishButton.layer.borderWidth = 1.0

    }
    
    func setGameCell(game: Game) {
        let players = game.fetchAllPlayers()
        driveALabel.attributedText = NSAttributedString.setNameOnLabel(name: players[.driveA]!.name ?? "", gender: players[.driveA]!.gender)
        backALabel.attributedText = NSAttributedString.setNameOnLabel(name: players[.backA]!.name ?? "", gender: players[.backA]!.gender)
        driveBLabel.attributedText = NSAttributedString.setNameOnLabel(name: players[.driveB]!.name ?? "", gender: players[.driveB]!.gender)
        backBLabel.attributedText = NSAttributedString.setNameOnLabel(name: players[.backB]!.name ?? "", gender: players[.backB]!.gender)
        courtLabel.text = game.court!.name ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeStyle = .short
        timeLabel.text = dateFormatter.string(from:  game.startAt!)
        
        self.tag = Int(game.court!.courtID)
        gameFinishButton.tag = self.tag
        playerChangeButton.tag = self.tag
        
        switch  self.tag {
        case 0:
            self.backgroundColor = UIColor(displayP3Red: 255/255, green: 121/255, blue: 63/255, alpha: 0.8)
        case 1:
            self.backgroundColor = UIColor(displayP3Red: 63/255, green: 197/255, blue: 255/255, alpha: 0.8)
        default:
            self.backgroundColor = UIColor(displayP3Red: 120/255, green: 160/255, blue: 150/255, alpha: 0.8)
        }
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
