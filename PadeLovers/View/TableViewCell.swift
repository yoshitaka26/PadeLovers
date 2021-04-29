//
//  TableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var playerChangeButton: UIButton!
    @IBOutlet weak var gameFinishButton: UIButton!

    @IBOutlet weak var courtLabel: UILabel!
    @IBOutlet weak var player1Label: UILabel!
    @IBOutlet weak var pairOfPlayer1Label: UILabel!
    @IBOutlet weak var player2Label: UILabel!
    @IBOutlet weak var pairOfPlayer2Label: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()

        playerChangeButton.layer.cornerRadius = playerChangeButton.frame.size.height / 4
        gameFinishButton.layer.cornerRadius = gameFinishButton.frame.size.height / 4

        playerChangeButton.layer.borderColor = UIColor.gray.cgColor
        playerChangeButton.layer.borderWidth = 1.0

        gameFinishButton.layer.borderColor = UIColor.gray.cgColor
        gameFinishButton.layer.borderWidth = 1.0

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
