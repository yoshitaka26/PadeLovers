//
//  PlayerResultCollectionViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/15.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

final class PlayerResultCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet private weak var playerLabel: UILabel!
    @IBOutlet private weak var playingStatusLabel: UILabel!
    @IBOutlet private weak var gameCountsLabel: UILabel!
    
    func setUI(player: Player, minCount: Int16) {
        playerLabel.attributedText = NSAttributedString.setNameOnLabel(name: player.name ?? "", gender: player.gender)
        playingStatusLabel.text = player.isPlaying ? "参加中" : "休憩中"
        self.backgroundColor = player.isPlaying ? .clear : .darkGray
        
        if player.isPlaying && player.counts != 0 {
            playingStatusLabel.text = player.onGame != nil ? "試合中" : "試合待ち"
            self.backgroundColor = player.onGame == nil && player.counts == minCount ? .appSpecialYellow : .clear
        }
        gameCountsLabel.text = "\(player.counts) 試合"
    }
}
