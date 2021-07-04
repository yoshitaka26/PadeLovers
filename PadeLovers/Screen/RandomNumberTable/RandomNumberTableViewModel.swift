//
//  RandomNumberTableViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/25.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class RandomNumberTableViewModel: BaseViewModel {
    let randomNumberManager = RandomNumberTableManager.shared
    
    var playerNumber: BehaviorRelay<Int> = BehaviorRelay(value: 6)
    let generateNumbers = PublishSubject<Void>()
    var numberTables: BehaviorRelay<[Match]> = BehaviorRelay(value: [])
    var onMatchNumber: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    let backAndNextButtonPressed = PublishSubject<Bool>()
    let reloadView = PublishSubject<Void>()
    let errorAlert = PublishSubject<Void>()
    
    override init() {
        super.init()
        self.mutate()
    }
}
extension RandomNumberTableViewModel {
    func mutate() {
        generateNumbers.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            if let matches = self.randomNumberManager.generateTable(playerNumber: self.playerNumber.value) {
                self.numberTables.accept(matches)
                self.reloadView.onNext(())
            } else {
                self.errorAlert.onNext(())
            }
        }).disposed(by: disposeBag)
        backAndNextButtonPressed.subscribe(onNext: { [weak self] flag in
            guard let self = self else { return }
            if flag {
                let temp = self.onMatchNumber.value
                guard temp != self.numberTables.value.count - 1 else { return }
                self.onMatchNumber.accept(temp + 1)
                self.reloadView.onNext(())
            } else {
                let temp = self.onMatchNumber.value
                guard temp != 0 else { return }
                self.onMatchNumber.accept(temp - 1)
                self.reloadView.onNext(())
            }
        }).disposed(by: disposeBag)
    }
}
