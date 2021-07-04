//
//  GamePlayerViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/19.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GamePlayerViewModel: BaseViewModel {
    var padelID: String = UUID().uuidString
    
    var playModeA: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var playModeAisChanged = PublishSubject<Bool>()
    var playModeB: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var playModeBisChanged = PublishSubject<Bool>()
    var gameResult: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var courtAname: BehaviorRelay<String> = BehaviorRelay(value: LABEL_COURT_A)
    var courtAisON: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var courtAisChanged = PublishSubject<Bool>()
    var courtBname: BehaviorRelay<String> = BehaviorRelay(value: LABEL_COURT_B)
    var courtBisON: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var courtBisChanged = PublishSubject<Bool>()
    var courtCname: BehaviorRelay<String> = BehaviorRelay(value: LABEL_COURT_C)
    var courtCisON: BehaviorRelay<Bool> = BehaviorRelay(value: true)
    var courtCisChanged = PublishSubject<Bool>()
    var pairingAisOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var pairingAisChanged = PublishSubject<Bool>()
    let pairingAWindowShow = PublishSubject<Void>()
    var pairingBisOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var pairingBisChanged = PublishSubject<Bool>()
    let pairingBWindowShow = PublishSubject<Void>()
    var pairingA1name: BehaviorRelay<String> = BehaviorRelay(value: "")
    var pairingA2name: BehaviorRelay<String> = BehaviorRelay(value: "")
    var pairingB1name: BehaviorRelay<String> = BehaviorRelay(value: "")
    var pairingB2name: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    var player1name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player1isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player2name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player2isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player3name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player3isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player4name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player4isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player5name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player5isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player6name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player6isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player7name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player7isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player8name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player8isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player9name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player9isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player10name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player10isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player11name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player11isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player12name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player12isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player13name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player13isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player14name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player14isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player15name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player15isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player16name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player16isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player17name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player17isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player18name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player18isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player19name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player19isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player20name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player20isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    var player21name: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var player21isOn: BehaviorRelay<Bool> = BehaviorRelay(value: false)
    
    var longPressedPlayer: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    let pushToEditDataModalView = PublishSubject<Int>()
    
    let pairingUIUpdate = PublishSubject<Void>()
    let playerUIUpdate = PublishSubject<Void>()
    
    let showMessage = PublishSubject<String>()
    
    var playersSwitches: [BehaviorRelay<Bool>]
    var playersLabels: [BehaviorRelay<NSAttributedString?>]
    var courtsSwitches: [BehaviorRelay<Bool>]
    var courtsLabels: [BehaviorRelay<String>]
    
    let saveAction = PublishSubject<Void>()
    private let coreDataManager = CoreDataManager.shared
    private let gameDataBrain = CommonDataBrain.shared
    
    let dataBind = PublishSubject<(TableType, UUID?)>()
    
    var playingPlayerCounts: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var minPlayerCounts: Observable<Int> {
        return Observable.combineLatest(courtAisON, courtBisON, courtCisON, pairingAisOn, pairingBisOn) { court1, court2, court3, pair1, pair2 in
            var count = 0
            if court1 { count += 4 }
            if court2 { count += 4 }
            if court3 { count += 4 }
            if pair1 { count += 2 }
            if pair2 { count += 2 }
            return count
        }
    }
    var playingPlayerCountsLabel: Observable<NSAttributedString?> {
        return Observable.combineLatest(playingPlayerCounts, minPlayerCounts) { counts, minCounts in
            let num = counts - minCounts
            if num >= 0 {
                self.coreDataManager.setReadyStatusOnPadel(uuidString: self.padelID, isReady: true)
                let value = NSAttributedString(string: "\(counts)人", attributes: [.foregroundColor: UIColor.label])
                return  value
            } else {
                self.coreDataManager.setReadyStatusOnPadel(uuidString: self.padelID, isReady: false)
                let value = NSAttributedString(string: "\(abs(num))人不足しています", attributes: [.foregroundColor: UIColor.red])
                return value
            }
        }
    }
    override init() {
        // swiftlint:disable line_length
        playersSwitches = [player1isOn, player2isOn, player3isOn, player4isOn, player5isOn, player6isOn, player7isOn, player8isOn, player9isOn, player10isOn, player11isOn, player12isOn, player13isOn, player14isOn, player15isOn, player16isOn, player17isOn, player18isOn, player19isOn, player20isOn, player21isOn]
        playersLabels = [player1name, player2name, player3name, player4name, player5name, player6name, player7name, player8name, player9name, player10name, player11name, player12name, player13name, player14name, player15name, player16name, player17name, player18name, player19name, player20name, player21name]
        courtsSwitches = [courtAisON, courtBisON, courtCisON]
        courtsLabels = [courtAname, courtBname, courtCname]
        super.init()
        mutate()
        // swiftlint:enable line_length
    }
    
    func mutate() {
        for (index, playerSwitch) in playersSwitches.enumerated() {
            playerSwitch.subscribe(onNext: { [weak self] isOn in
                guard let self = self else { return }
                let value = self.coreDataManager.updateIsPlaying(uuidString: self.padelID, playerID: index, isOn: isOn)
                switch value {
                case 0:
                    break
                case -1:
                    self.pairingUIUpdate.onNext(())
                    self.showMessage.onNext(ALERT_MESSAGE_PLAYER_ON_PAIRING)
                case -2:
                    self.showMessage.onNext("試合から抜けました")
                default:
                    self.showMessage.onNext("試合数\(value)で参加しました")
                }
                let playingPlayerCounts = self.coreDataManager.countPlayers(uuidString: self.padelID)
                self.playingPlayerCounts.accept(playingPlayerCounts)
            }).disposed(by: disposeBag)
        }
        for (index, courtSwitch) in courtsSwitches.enumerated() {
            courtSwitch.subscribe(onNext: { [weak self] isOn in
                guard let self = self else { return }
                guard self.coreDataManager.updateCourtIsOn(uuidString: self.padelID, courtID: index, isOn: isOn) else { return }
            }).disposed(by: disposeBag)
        }
        dataBind.subscribe(onNext: { [weak self] type, id in
            guard let self = self else { return }
            var gameData: [Int: Player] = [:]
            var courtData: [Int: Court] = [:]
            
            switch type {
            case .court:
                guard let iD = id else { return }
                self.padelID = iD.uuidString
                UserDefaults.standard.set(self.padelID, forKey: "PadelID")
            default:
                let playersData = self.gameDataBrain.loadPlayers(group: type)
                guard let players = playersData, players.count < 22 else { return }
                let filterdPlayersData = players.filter { !$0.playerName.isEmpty }
                guard let courtNames = UserDefaults.standard.value(forKey: "newCourt") as? [String], courtNames.count < 4 else { return }
                let filterdCourtNames = courtNames.filter { !$0.isEmpty }
                let iDstring = self.coreDataManager.initPadel(players: filterdPlayersData, courts: filterdCourtNames)
                self.padelID = iDstring
                UserDefaults.standard.set(iDstring, forKey: "PadelID")
            }
            
            let players = self.coreDataManager.loadAllPlayers(uuidString: self.padelID)
            let courts = self.coreDataManager.loadCourts(uuidString: self.padelID)
            guard players.count == 21, courts.count == 3 else { fatalError("プレイヤー・コートデータが正しく取得できない") }
            for player in players { gameData[Int(player.playerID)] = player }
            for court in courts { courtData[Int(court.courtID)] = court }
            for (index, playerLabel) in self.playersLabels.enumerated() {
                guard let player = gameData[index] else { return }
                playerLabel.accept(NSAttributedString.setNameOnLabel(name: player.name ?? "", gender: player.gender))
            }
            for (index, isPlayingSwitch) in self.playersSwitches.enumerated() {
                guard let player = gameData[index] else { return }
                isPlayingSwitch.accept(player.isPlaying)
            }
            for (index, courtLabel) in self.courtsLabels.enumerated() {
                guard let court = courtData[index] else { return }
                courtLabel.accept(court.name ?? "")
            }
            for (index, courtSwitch) in self.courtsSwitches.enumerated() {
                guard let court = courtData[index] else { return }
                courtSwitch.accept(court.isOn)
            }
            guard let mainData = self.coreDataManager.loadPadel(uuidString: self.padelID) else { return }
            self.playModeA.accept(mainData.playMode)
            self.playModeB.accept(!mainData.playMode)
            self.gameResult.accept(mainData.showResult)
            self.pairingUIUpdate.onNext(())
        }).disposed(by: disposeBag)
        playModeAisChanged.subscribe(onNext: { [weak self] isOn in
            guard let self = self else { return }
            self.coreDataManager.updateGameMode(uuidString: self.padelID, isOn: isOn)
            self.playModeB.accept(!isOn)
        }).disposed(by: disposeBag)
        playModeBisChanged.subscribe(onNext: { [weak self] isOn in
            guard let self = self else { return }
            self.coreDataManager.updateGameMode(uuidString: self.padelID, isOn: !isOn)
            self.playModeA.accept(!isOn)
        }).disposed(by: disposeBag)
        gameResult.subscribe(onNext: { [weak self] isOn in
            guard let self = self else { return }
            self.coreDataManager.updateShowResult(uuidString: self.padelID, isOn: isOn)
        }).disposed(by: disposeBag)
        courtAisChanged.subscribe(onNext: { [weak self] isOn in
            guard let self = self else { return }
            if !isOn && !self.courtBisON.value && !self.courtCisON.value { self.courtAisON.accept(true) }
        }).disposed(by: disposeBag)
        courtBisChanged.subscribe(onNext: { [weak self] isOn in
            guard let self = self else { return }
            if !isOn && !self.courtAisON.value && !self.courtCisON.value { self.courtAisON.accept(true) }
        }).disposed(by: disposeBag)
        courtCisChanged.subscribe(onNext: { [weak self] isOn in
            guard let self = self else { return }
            if !isOn && !self.courtAisON.value && !self.courtBisON.value { self.courtAisON.accept(true) }
        }).disposed(by: disposeBag)
        pairingAisChanged.subscribe(onNext: { [weak self] isOn in
            guard let self = self else { return }
            if isOn {
                self.pairingAWindowShow.onNext(())
            } else {
                self.coreDataManager.updatePairing(uuidString: self.padelID, pairingType: .pairingA, isOn: false)
            }
        }).disposed(by: disposeBag)
        pairingBisChanged.subscribe(onNext: { [weak self] isOn in
            guard let self = self else { return }
            if isOn {
                self.pairingBWindowShow.onNext(())
            } else {
                self.coreDataManager.updatePairing(uuidString: self.padelID, pairingType: .pairingB, isOn: false)
            }
        }).disposed(by: disposeBag)
        pairingUIUpdate.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.pairingAisOn.accept(false)
            self.pairingBisOn.accept(false)
            self.pairingA1name.accept("")
            self.pairingA2name.accept("")
            self.pairingB1name.accept("")
            self.pairingB2name.accept("")
            
            guard let mainData = self.coreDataManager.loadPadel(uuidString: self.padelID) else { return }
            guard let paringA = mainData.pairingA else { return }
            guard let paringB = mainData.pairingB else { return }
            
            if paringA.isOn {
                guard let pairingAplayers = paringA.pairing?.allObjects as? [Player] else { return }
                guard let A1 = pairingAplayers.first else { return }
                guard let A2 = pairingAplayers.last else { return }
                self.pairingA1name.accept(A1.name ?? "")
                self.pairingA2name.accept(A2.name ?? "")
                self.pairingAisOn.accept(true)
            }
            if paringB.isOn {
                guard let pairingBplayers = paringB.pairing?.allObjects as? [Player] else { return }
                guard let B1 = pairingBplayers.first else { return }
                guard let B2 = pairingBplayers.last else { return }
                self.pairingB1name.accept(B1.name ?? "")
                self.pairingB2name.accept(B2.name ?? "")
                self.pairingBisOn.accept(true)
            }
        }).disposed(by: disposeBag)
        playerUIUpdate.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            var gameData: [Int: Player] = [:]
            let players = self.coreDataManager.loadAllPlayers(uuidString: self.padelID)
            for player in players { gameData[Int(player.playerID)] = player }
            for (index, playerLabel) in self.playersLabels.enumerated() {
                guard let player = gameData[index] else { return }
                playerLabel.accept(NSAttributedString.setNameOnLabel(name: player.name ?? "", gender: player.gender))
            }
        }).disposed(by: disposeBag)
        longPressedPlayer.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            guard value != 0 else { return }
            self.pushToEditDataModalView.onNext((value - 1))
        }).disposed(by: disposeBag)
    }
}
