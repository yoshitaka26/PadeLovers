//
//  GameViewPlayerTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/09.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewPlayerTableViewCell: UITableViewCell {

    @IBOutlet private weak var playerLabel: UILabel!
    @IBOutlet private weak var playerSwitch: UISwitch!

    private var disposeBag = DisposeBag()

    static let identifier = "GameViewPlayerTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "GameViewPlayerTableViewCell", bundle: nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func render (delegate: GameViewPlayerTableDelegate, player: Player) {
        self.playerLabel.text = player.name
        self.playerLabel.textColor = player.gender ? .label : .red
        playerSwitch.setOn(player.isPlaying, animated: false)

        playerSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(playerSwitch.rx.value)
            .subscribe(onNext: { isPlaying in
                delegate.playerSwitchChanged(playerId: player.playerID, isPlaying: isPlaying)
            }).disposed(by: disposeBag)
    }
}
