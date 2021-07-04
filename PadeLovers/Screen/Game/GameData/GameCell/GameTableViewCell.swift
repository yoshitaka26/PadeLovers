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
    
    func setGameCell(court: Court) {
        
        courtLabel.text = court.name ?? ""
        
        self.tag = Int(court.courtID)
        gameFinishButton.tag = self.tag
        playerChangeButton.tag = self.tag
        
        switch  self.tag {
        case 0:
            self.backgroundColor = .appSpecialYellow
        case 1:
            self.backgroundColor = .appSpecialGreen
        default:
            self.backgroundColor = .appSpecialBlue
        }
        
        guard let game = court.onGame else {
            timeLabel.text = ""
            driveALabel.text = ""
            backALabel.text = ""
            driveBLabel.text = ""
            backBLabel.text = ""
            playerChangeButton.isHidden = true
            gameFinishButton.setTitle("試合を組む", for: .normal)
            return
        }
        playerChangeButton.isHidden = false
        gameFinishButton.setTitle("試合終了", for: .normal)
        
        let players = game.fetchAllPlayers()
        guard players.count == 4 else { return }
        guard let driveA = players[.driveA] else { return }
        guard let backA = players[.backA] else { return }
        guard let driveB = players[.driveB] else { return }
        guard let backB = players[.backB] else { return }
        guard let court = game.court else { return }
        driveALabel.attributedText = NSAttributedString.setNameOnLabel(name: driveA.name ?? "", gender: driveA.gender)
        backALabel.attributedText = NSAttributedString.setNameOnLabel(name: backA.name ?? "", gender: backA.gender)
        driveBLabel.attributedText = NSAttributedString.setNameOnLabel(name: driveB.name ?? "", gender: driveB.gender)
        backBLabel.attributedText = NSAttributedString.setNameOnLabel(name: backB.name ?? "", gender: backB.gender)
        courtLabel.text = court.name ?? ""
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.timeStyle = .short
        timeLabel.text = dateFormatter.string(from: game.startAt ?? Date())
        
        self.selectionStyle = .none
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
}
