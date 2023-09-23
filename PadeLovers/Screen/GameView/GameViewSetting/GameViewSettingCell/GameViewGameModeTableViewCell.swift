//
//  GameViewGameModeTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/10.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewGameModeTableViewCell: UITableViewCell {

    @IBOutlet private weak var gameModeLabel: UILabel!
    @IBOutlet private weak var gameModeSwitch: UISwitch!
    
    private var disposeBag = DisposeBag()

    static let identifier = "GameViewGameModeTableViewCell"
    static func nib() -> UINib {
        return UINib(nibName: "GameViewGameModeTableViewCell", bundle: nil)
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func render(delegate: GameViewPlayerTableDelegate, modeType: GameModeType, playMode: Bool, isAuto: Bool) {
//        switch modeType {
//        case .combination:
//            gameModeLabel.text = String(localized: "Combination oriented mode")
//            gameModeSwitch.setOn(playMode, animated: false)
//        case .matchCount:
//            gameModeLabel.text = String(localized: "Match count oriented mode")
//            gameModeSwitch.setOn(!playMode, animated: false)
//        case .auto:
//            gameModeLabel.text = String(localized: "Auto Switching Mode")
//            gameModeSwitch.setOn(isAuto, animated: false)
//        }
        gameModeSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(gameModeSwitch.rx.value)
            .subscribe(onNext: { isOn in
                delegate.gameModeSwitchChanged(gameMode: modeType, isOn: isOn)
            }).disposed(by: disposeBag)
    }
}
