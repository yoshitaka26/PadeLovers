//
//  GameViewPlayerCountTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/10.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameViewPlayerCountTableViewCell: UITableViewCell {

    @IBOutlet private weak var playingPlayerTitleLabel: UILabel! {
        didSet {
            playerCountLabel.text = R.string.localizable.playingPlayer()
        }
    }

    @IBOutlet private weak var playerCountLabel: UILabel! {
        didSet {
            playingPlayerCount
                .subscribe(onNext: { [weak self] count in
                    guard let self = self else { return }
                    self.playerCountLabel.text = count > 0 ?  ("\(count)" + R.string.localizable.playerCount()) : ("\(abs(count))" + R.string.localizable.needMorePlayers())
                    self.playerCountLabel.textColor = count > 0 ? .label : .red

                })
                .disposed(by: disposeBag)
        }
    }

    private let disposeBag = DisposeBag()
    private var playingPlayerCount = PublishRelay<Int>()

    func render(minPlayerCount: Int) {
        self.playingPlayerCount.accept(minPlayerCount)
    }
}
