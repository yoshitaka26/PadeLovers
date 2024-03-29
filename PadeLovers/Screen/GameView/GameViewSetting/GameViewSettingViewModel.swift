//
//  GameViewSettingViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/10.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

final class GameViewSettingViewModel {
    private(set) var viewWillAppear = PublishRelay<Void>()
    private(set) var viewWillDisappear = PublishRelay<Void>()

    private(set) var padelPlayMode = BehaviorRelay<Bool>(value: false)
    private(set) var autoPlayMode = BehaviorRelay<Bool>(value: false)
    private(set) var gameResult = BehaviorRelay<Bool>(value: false)
    private(set) var courtList = BehaviorRelay<[Court]>(value: [])
    private(set) var pairingList = BehaviorRelay<[Pairing]>(value: [])
    private(set) var playingPlayerCounts = BehaviorRelay<Int>(value: 0)
    private(set) var playerList = BehaviorRelay<[Player]>(value: [])

    private var autoPlayModeTimer: Disposable?

    private(set) var reloadTableSubject = PublishSubject<Void>()
    var reloadTable: Driver<Void> {
        return reloadTableSubject.asDriver(onErrorJustReturn: ())
    }

    private var pushScreenSubject = PublishRelay<Screen>()
    var pushScreen: Driver<Screen> {
        return pushScreenSubject.asDriver(onErrorJustReturn: .other)
    }

    private var presentScreenSubject = PublishRelay<Screen>()
    var presentScreen: Driver<Screen> {
        return presentScreenSubject.asDriver(onErrorJustReturn: .other)
    }

    private let disposeBag = DisposeBag()
    private let coreDataManager: CoreDataManagerable
    private let userDefaultsManager = UserDefaultsUtil.shared
    private var padelID: String
    // テストの為privateにはしない
    let minuteSeconds = 60

    init(padelId: String?, groupID: String?, coreDataManager: CoreDataManagerable) {
        self.padelID = padelId ?? UUID().uuidString
        self.coreDataManager = coreDataManager
        setInitialData(groupID: groupID)
        subscribe()
    }

    private func subscribe() {
        viewWillAppear
            .subscribe(onNext: { [unowned self] _ in
                self.loadPadelData()
                UIApplication.shared.isIdleTimerDisabled = true
            })
            .disposed(by: disposeBag)
        
        viewWillDisappear
            .subscribe(onNext: { [unowned self] _ in
                self.loadPadelData()
                UIApplication.shared.isIdleTimerDisabled = false
            })
            .disposed(by: disposeBag)

        padelPlayMode
            .subscribe(onNext: { [unowned self] _ in
                self.reloadTableSubject.onNext(())
            })
            .disposed(by: disposeBag)
        autoPlayMode
            .subscribe(onNext: { [unowned self] _ in
                self.reloadTableSubject.onNext(())
            })
            .disposed(by: disposeBag)
        courtList
            .subscribe(onNext: { [unowned self] _ in
                calculatePlayers()
                self.reloadTableSubject.onNext(())
            })
            .disposed(by: disposeBag)
        pairingList
            .subscribe(onNext: { [unowned self] _ in
                calculatePlayers()
                self.reloadTableSubject.onNext(())
            })
            .disposed(by: disposeBag)
        playingPlayerCounts
            .subscribe(onNext: { [unowned self] _ in
                self.reloadTableSubject.onNext(())
            })
            .disposed(by: disposeBag)
        playerList
            .subscribe(onNext: { [unowned self] _ in
                calculatePlayers()
                self.reloadTableSubject.onNext(())
            })
            .disposed(by: disposeBag)
    }

    private func setInitialData(groupID: String?) {
        if let groupID = groupID {
            let playersData = coreDataManager.loadMasterPlayers(groupID: groupID)
            let courtData = userDefaultsManager.courtNames
            guard playersData.count < 22,
                  courtData.count < 4 else { return }
            let players = playersData.filter { !(($0.name ?? "").isEmpty) }
            let courtNames = courtData.filter { !$0.isEmpty }
            let padelId = self.coreDataManager.initPadel(players: players, courts: courtNames)
            userDefaultsManager.padelID = padelId
            self.padelID = padelId
        } else {
            userDefaultsManager.padelID = padelID
        }
    }

    private func loadPadelData() {
        if let padel = coreDataManager.loadPadel(uuidString: padelID) {
            padelPlayMode.accept(padel.playMode)
            gameResult.accept(padel.showResult)
            courtList.accept(coreDataManager.loadCourts(uuidString: padelID))
            pairingList.accept(coreDataManager.loadPairing(uuidString: padelID))
            playerList.accept(coreDataManager.loadAllPlayers(uuidString: padelID))
        } else {
            presentScreenSubject.accept(.errorAlert(message: ""))
        }
    }
    private func calculatePlayers() {
        let playingPlayersCount = coreDataManager.countPlayers(uuidString: padelID)
        let minCount = coreDataManager.minPlayersCount(uuidString: padelID)
        let balancing = playingPlayersCount - minCount
        if balancing >= 0 {
            coreDataManager.setReadyStatusOnPadel(uuidString: padelID, isReady: true)
            playingPlayerCounts.accept(playingPlayersCount)
        } else {
            coreDataManager.setReadyStatusOnPadel(uuidString: padelID, isReady: false)
            playingPlayerCounts.accept(balancing)
        }
    }
}

extension GameViewSettingViewModel {
    func handleGameModeSwitchChanged(gameMode: GameModeType, isOn: Bool) {
        switch gameMode {
        case .combination:
            coreDataManager.updateGameMode(uuidString: padelID, isOn: isOn)
            padelPlayMode.accept(isOn)
        case .matchCount:
            coreDataManager.updateGameMode(uuidString: padelID, isOn: !isOn)
            padelPlayMode.accept(!isOn)
        case .auto:
            if isOn {
                presentScreenSubject.accept(.autoPlayMode)
            } else {
                resetAutoModeTimer()
                autoPlayMode.accept(false)
                presentScreenSubject.accept(.infoAlert(message: String(localized: "Auto play mode reset")))
            }
        }
    }

    func handleGameResultSwitchChanged(isOn: Bool) {
        coreDataManager.updateShowResult(uuidString: padelID, isOn: isOn)
        gameResult.accept(isOn)
    }

    func handlePairingSwitchChanged(pairing: Pairing, isOn: Bool) {
        if isOn {
            presentScreenSubject.accept(.pairing(pairing: pairing))
        } else {
            switch pairing {
            case is PairingA:
                coreDataManager.updatePairing(uuidString: padelID, pairingType: .pairingA, isOn: isOn)
            case is PairingB:
                coreDataManager.updatePairing(uuidString: padelID, pairingType: .pairingB, isOn: isOn)
            default:
                break
            }
            pairingList.accept(coreDataManager.loadPairing(uuidString: padelID))
        }
    }

    func handleCourtSwitchChanged(courtId: Int16, isOn: Bool) {
        _ = coreDataManager.updateCourtIsOn(uuidString: padelID, courtID: Int(courtId), isOn: isOn)
        if coreDataManager.loadCourtsIsOn(uuidString: padelID).isEmpty {
            guard let firstCourtId = courtList.value.first?.courtID else { return }
            _ = coreDataManager.updateCourtIsOn(uuidString: padelID, courtID: Int(firstCourtId), isOn: true)
        }
        courtList.accept(coreDataManager.loadCourts(uuidString: padelID))
    }

    func handlePlayerSwitchChanged(playerId: Int16, isPlaying: Bool) {
        let result = coreDataManager.updateIsPlaying(uuidString: padelID, playerID: Int(playerId), isOn: isPlaying)
        switch result {
        case 0:
            break
        case -1:
            presentScreenSubject.accept(.infoAlert(message: String(localized: "Reset pairing")))
        case -2:
            presentScreenSubject.accept(.infoAlert(message: String(localized: "Get out of the match")))
        default:
            let message = String(localized: "Match count") + "\(result)" + "\n" + String(localized: "Participate in the match")
            presentScreenSubject.accept(.infoAlert(message: message))
        }
        playerList.accept(coreDataManager.loadAllPlayers(uuidString: padelID))
    }
}

extension GameViewSettingViewModel {
    func handleQuestionBarButtonItem() {
        pushScreenSubject.accept(.gameViewQuestion)
    }
    func handleLongPressedPlayerCell(index: Int) {
        presentScreenSubject.accept(.playerDataEdit(playerId: Int(playerList.value[index - 1].playerID)))
    }
    func handelPairingSetNotification() {
        pairingList.accept(coreDataManager.loadPairing(uuidString: padelID))
    }
    func handlePlayerDataEditNotification() {
        pairingList.accept(coreDataManager.loadPairing(uuidString: padelID))
        playerList.accept(coreDataManager.loadAllPlayers(uuidString: padelID))
    }
    func handleAutoPlayModeDelegate(setTime: Int) {
        resetAutoModeTimer()
        if setTime != 0 {
            autoPlayMode.accept(true)
            handleGameModeSwitchChanged(gameMode: .combination, isOn: true)
            presentScreenSubject.accept(.infoAlert(message: "\(setTime)" + String(localized: "Auto play mode set")))
            autoPlayModeTimer = Observable<Int>
                .interval(DispatchTimeInterval.seconds(setTime * minuteSeconds), scheduler: MainScheduler.instance)
                .subscribe { [weak self] _ in
                    guard let self = self else { return }
                    if self.padelPlayMode.value {
                        self.presentScreenSubject.accept(.infoAlert(message: String(localized: "Auto play mode fired")))
                    }
                    self.autoPlayMode.accept(false)
                    self.handleGameModeSwitchChanged(gameMode: .matchCount, isOn: true)
                    self.resetAutoModeTimer()
                }
        } else {
            autoPlayMode.accept(false)
        }
    }

    private func resetAutoModeTimer() {
        autoPlayModeTimer?.dispose()
    }
}
