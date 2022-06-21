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

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func render(delegate: GameViewPlayerTableDelegate, modeType: GameModeType, playMode: Bool, isAuto: Bool) {
        switch modeType {
        case .combination:
            gameModeLabel.text = R.string.localizable.combinationOrientedMode()
            gameModeSwitch.setOn(playMode, animated: false)
        case .matchCount:
            gameModeLabel.text = R.string.localizable.matchCountOrientedMode()
            gameModeSwitch.setOn(!playMode, animated: false)
        case .auto:
            gameModeLabel.text = R.string.localizable.autoSwitchingMode()
            gameModeSwitch.setOn(isAuto, animated: false)
        }
        gameModeSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(gameModeSwitch.rx.value)
            .subscribe(onNext: { isOn in
                delegate.gameModeSwitchChanged(gameMode: modeType, isOn: isOn)
            }).disposed(by: disposeBag)
    }
}
