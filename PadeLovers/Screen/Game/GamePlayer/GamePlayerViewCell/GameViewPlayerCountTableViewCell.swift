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
            minPlayerCountLabel.text = R.string.localizable.playingPlayer()
        }
    }

    @IBOutlet private weak var minPlayerCountLabel: UILabel! {
        didSet {
            minPlayerCount
                .subscribe(onNext: { [weak self] count in
                    guard let self = self else { return }
                    self.minPlayerCountLabel.text = count > 0 ?  "\(count)人" : "\(abs(count))不足しています"
                    self.minPlayerCountLabel.textColor = count > 0 ? .label : .red

                })
                .disposed(by: disposeBag)
        }
    }

    private let disposeBag = DisposeBag()
    private var minPlayerCount = PublishRelay<Int>()

    func render(minPlayerCount: Int) {
        self.minPlayerCount.accept(minPlayerCount)
    }
}
