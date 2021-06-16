//
//  PlayerResultCollectionViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/15.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

class PlayerResultCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var playerLabel: UILabel!
    @IBOutlet weak var playingStatusLabel: UILabel!
    @IBOutlet weak var gameCountsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setUI(player: Player, minCount: Int16) {
        playerLabel.attributedText = NSAttributedString.setNameOnLabel(name: player.name ?? "", gender: player.gender)
        playingStatusLabel.text = player.isPlaying ? "参加中" : "休憩中"
        self.backgroundColor = player.isPlaying ? .clear : .lightGray
        
        if player.isPlaying && player.counts != 0 {
            playingStatusLabel.text = player.onGame != nil ? "試合中" : "試合待ち"
            self.backgroundColor = player.counts == minCount ? .orange : .clear
        }
        gameCountsLabel.text = "\(player.counts) 試合プレイ"
    }
}
