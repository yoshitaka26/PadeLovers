//
//  GameViewGameResultTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/10.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewGameResultTableViewCell: UITableViewCell {

    @IBOutlet private weak var gameResultLabel: UILabel! {
        didSet {
            gameResultLabel.text = R.string.localizable.gameResult()
        }
    }
    @IBOutlet private weak var gameResultSwitch: UISwitch!

    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func render(delegate: GameViewPlayerTableDelegate, gameResult: Bool) {
        gameResultSwitch.setOn(gameResult, animated: false)

        gameResultSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(gameResultSwitch.rx.value)
            .subscribe(onNext: { isOn in
                delegate.gameResultSwitchChanged(isOn: isOn)
            }).disposed(by: disposeBag)
    }
}
