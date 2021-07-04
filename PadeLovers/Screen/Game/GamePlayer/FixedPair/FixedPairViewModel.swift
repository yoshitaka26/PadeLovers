//
//  FixedPairViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/09.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum MoveWithType {
    case setPairing
    case samePlayerSelected
    case resetPairing
}

class FixedPairViewModel: BaseViewModel {
    override init() {
        super.init()
        self.mutate()
    }

    let coreDataManager = CoreDataManager.shared
    var padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
    
    var pairingType: BehaviorRelay<PairingType?> = BehaviorRelay(value: nil)
    var pairingPlayers: BehaviorRelay<[Player]> = BehaviorRelay(value: [])
    var picker1SelectedRow: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var picker2SelectedRow: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    let loadData = PublishSubject<Void>()
    let okAction = PublishSubject<Void>()
    let resetAction = PublishSubject<Void>()
    let moveWith = PublishSubject<MoveWithType>()
}

extension FixedPairViewModel {
    func mutate() {
        loadData.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            guard let type = self.pairingType.value else { return }
            let players = self.coreDataManager.loadPlayersForPairing(uuidString: self.padelID, pairingType: type)
            self.pairingPlayers.accept(players)
            var numbers: (Int?, Int?) = (nil, nil)
            switch type {
            case .pairingA:
                for (index, player) in players.enumerated() {
                    guard player.pairingA != nil else { continue }
                    if numbers.0 == nil {
                        numbers.0 = index
                    } else {
                        numbers.1 = index
                    }
                }
            case .pairingB:
                for (index, player) in players.enumerated() {
                    guard player.pairingB != nil else { continue }
                    if numbers.0 == nil {
                        numbers.0 = index
                    } else {
                        numbers.1 = index
                    }
                }
            }
            guard let num1 = numbers.0, let num2 = numbers.1 else { return }
            guard num1 < players.count, num2 < players.count else { return }
            self.picker1SelectedRow.accept(num1)
            self.picker2SelectedRow.accept(num2)
        }).disposed(by: disposeBag)
        okAction.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let picker1Row = self.picker1SelectedRow.value
            let picker2Row = self.picker2SelectedRow.value
            guard picker1Row != picker2Row else {
                self.moveWith.onNext(.samePlayerSelected)
                return
            }
            let player1 = self.pairingPlayers.value[picker1Row]
            let player2 = self.pairingPlayers.value[picker2Row]
            guard let mainData = self.coreDataManager.loadPadel(uuidString: self.padelID) else { return }
            guard let type = self.pairingType.value else { return }
            switch type {
            case .pairingA:
                guard let pairingA = mainData.pairingA else { return }
                if let pairingAPlayers = pairingA.pairing {
                    pairingA.removeFromPairing(pairingAPlayers)
                }
                pairingA.addToPairing(player1)
                pairingA.addToPairing(player2)
                pairingA.isOn = true
                mainData.save()
            case .pairingB:
                guard let pairingB = mainData.pairingB else { return }
                if let pairingBPlayers = pairingB.pairing {
                    pairingB.removeFromPairing(pairingBPlayers)
                }
                pairingB.addToPairing(player1)
                pairingB.addToPairing(player2)
                pairingB.isOn = true
                mainData.save()
            }
            self.moveWith.onNext(.setPairing)
        }).disposed(by: disposeBag)
        resetAction.subscribe(onNext: {[weak self] in
            guard let self = self else { return }
            guard let type = self.pairingType.value else { return }
            switch type {
            case .pairingA:
                self.coreDataManager.deletePairing(uuidString: self.padelID, pairingType: .pairingA)
            case .pairingB:
                self.coreDataManager.deletePairing(uuidString: self.padelID, pairingType: .pairingB)
            }
            self.moveWith.onNext(.resetPairing)
        }).disposed(by: disposeBag)
    }
}
