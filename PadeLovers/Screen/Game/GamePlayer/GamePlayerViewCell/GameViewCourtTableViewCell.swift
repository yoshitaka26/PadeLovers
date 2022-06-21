//
//  GameViewCourtTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/10.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewCourtTableViewCell: UITableViewCell {

    @IBOutlet private weak var courtLabel: UILabel!
    @IBOutlet private weak var courtSwitch: UISwitch!

    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func render(delegate: GameViewPlayerTableDelegate, court: Court) {
        courtLabel.text = court.name
        courtSwitch.setOn(court.isOn, animated: false)

        courtSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(courtSwitch.rx.value)
            .subscribe(onNext: { isOn in
                delegate.courtSwitchChanged(courtId: court.courtID, isOn: isOn)
            }).disposed(by: disposeBag)
    }
}
