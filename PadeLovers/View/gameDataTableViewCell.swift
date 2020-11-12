//
//  gameDataTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/11/11.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class gameDataTableViewCell: UITableViewCell {

    @IBOutlet weak var rFPlayerLabel: UILabel!
    @IBOutlet weak var rBPlayerLabel: UILabel!
    @IBOutlet weak var lFPlayerLabel: UILabel!
    @IBOutlet weak var lBPlayerLabel: UILabel!
    @IBOutlet weak var rightPlayersImage: UIImageView!
    @IBOutlet weak var leftPlayersImage: UIImageView!
    @IBOutlet weak var gameTitle: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
