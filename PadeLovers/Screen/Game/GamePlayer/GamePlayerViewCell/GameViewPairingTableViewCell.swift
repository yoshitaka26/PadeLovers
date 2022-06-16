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
    @IBOutlet weak var pairingFirstLabel: UILabel! 
    @IBOutlet weak var pairingSecondLabel: UILabel!
    @IBOutlet weak var pairingSwitch: UISwitch!

    private var disposeBag = DisposeBag()

    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }

    func render(delegate: GameViewPlayerTableDelegate, pairing: Pairing) {
        switch pairing {
        case let pairing as PairingA:
            guard let pairs = pairing.pairing?.allObjects as? [Player],
                  let pairFirst = pairs.first,
                  let pairLast = pairs.last else { return }
            self.pairingFirstLabel.text = pairFirst.name
            self.pairingSecondLabel.text = pairLast.name
            pairingSwitch.setOn(pairing.isOn, animated: false)
        case let pairing as PairingB:
            guard let pairs = pairing.pairing?.allObjects as? [Player],
                  let pairFirst = pairs.first,
                  let pairLast = pairs.last else { return }
            self.pairingFirstLabel.text = pairFirst.name
            self.pairingSecondLabel.text = pairLast.name
            pairingSwitch.setOn(pairing.isOn, animated: false)
        default:
            break
        }

        pairingSwitch.rx.controlEvent(.valueChanged)
            .withLatestFrom(pairingSwitch.rx.value)
            .subscribe(onNext: { isOn in
                delegate.pairingSwitchChanged(pairing: pairing, isOn: isOn)
            }).disposed(by: disposeBag)
    }
}
