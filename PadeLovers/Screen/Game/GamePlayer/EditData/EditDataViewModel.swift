//
//  EditDataViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/10.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class EditDataViewModel: BaseViewModel {
    override init() {
        super.init()
        self.mutate()
    }
    let validationManager = ValidationManager.shared
    let coreDataManager = CoreDataManager.shared
    var padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
    
    var playerName: BehaviorRelay<String?> = BehaviorRelay(value: nil)
    var playerGender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var gameCountsForLabel: BehaviorRelay<String> = BehaviorRelay(value: "0")
    var gameCountsForStepper: BehaviorRelay<Double> = BehaviorRelay(value: 0.0)
    
    let loadData = PublishSubject<Int?>()
    var playerData: BehaviorRelay<Player?> = BehaviorRelay(value: nil)
    let doneAction = PublishSubject<Void>()
    let dataSaved = PublishSubject<Void>()
    let validationError = PublishSubject<Void>()
}

extension EditDataViewModel {
    func mutate() {
        gameCountsForStepper.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.gameCountsForLabel.accept(String(Int(value)))
        }).disposed(by: disposeBag)
        loadData.subscribe(onNext: { [weak self] playerID in
            guard let self = self else { return }
            guard let playerID = playerID else { return }
            guard let player = self.coreDataManager.loadPlayerForEditingData(uuidString: self.padelID, playerID: playerID) else { return }
            self.playerData.accept(player)
            self.playerName.accept(player.name)
            self.playerGender.accept(player.gender ? 0 : 1)
            self.gameCountsForLabel.accept(String(player.counts))
            self.gameCountsForStepper.accept(Double(player.counts))
        }).disposed(by: disposeBag)
        doneAction.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let result: ValidationResult = self.validationManager.validate(self.playerName.value ?? "")
            guard result != .invalid else {
                self.validationError.onNext(())
                return
            }
            
            guard let playerData = self.playerData.value else { return }
            if let name = self.playerName.value { playerData.name = name }
            playerData.gender = self.playerGender.value == 0 ? true :  false
            playerData.counts = Int16(self.gameCountsForStepper.value)
            playerData.save()
            self.dataSaved.onNext(())
        }).disposed(by: disposeBag)
    }
}
