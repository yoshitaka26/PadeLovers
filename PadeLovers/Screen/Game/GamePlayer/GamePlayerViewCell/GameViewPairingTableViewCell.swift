//
//  GameViewPairingTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/10.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewPairingTableViewCell: UITableViewCell {
    @IBOutlet private weak var pairingFirstLabel: UILabel!
    @IBOutlet private weak var pairingSecondLabel: UILabel!
    @IBOutlet private weak var pairingSwitch: UISwitch!

    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func render(delegate: GameViewPlayerTableDelegate, pairing: Pairing) {
        pairingSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(pairingSwitch.rx.value)
            .subscribe(onNext: { isOn in
                delegate.pairingSwitchChanged(pairing: pairing, isOn: isOn)
            }).disposed(by: disposeBag)

        self.pairingFirstLabel.text = ""
        self.pairingSecondLabel.text = ""
        switch pairing {
        case let pairing as PairingA:
            pairingSwitch.setOn(pairing.isOn, animated: false)
            guard let pairs = pairing.pairing?.allObjects as? [Player],
                  let pairFirst = pairs.first,
                  let pairLast = pairs.last else { return }
            self.pairingFirstLabel.text = pairFirst.name
            self.pairingSecondLabel.text = pairLast.name
        case let pairing as PairingB:
            pairingSwitch.setOn(pairing.isOn, animated: false)
            guard let pairs = pairing.pairing?.allObjects as? [Player],
                  let pairFirst = pairs.first,
                  let pairLast = pairs.last else { return }
            self.pairingFirstLabel.text = pairFirst.name
            self.pairingSecondLabel.text = pairLast.name
        default:
            break
        }
    }
}
