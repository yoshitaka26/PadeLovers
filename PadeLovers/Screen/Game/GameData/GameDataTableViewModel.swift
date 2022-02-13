//
//  GameDataTableViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/10.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum MessageAlert {
    case lessPlayersError
    case noCourtError
    case gameEndAlert(Int)
    case gameEnd
}

final class GameDataTableViewModel: BaseViewModel {

    let coreDataManager = CoreDataManager.shared
    let gameCreateManager = GameOrganizeManager.shared
    var padelID: BehaviorRelay<String> = BehaviorRelay(value: "")
    let setPadelID = PublishSubject<Void>()
    
    var playingPlayers: BehaviorRelay<[Player]> = BehaviorRelay(value: [])
    var onCourts: BehaviorRelay<[Court]> = BehaviorRelay(value: [])
    var onGames: BehaviorRelay<[Game]> = BehaviorRelay(value: [])
    let messageAlert = PublishSubject<MessageAlert>()
    
    let loadGameData = PublishSubject<Void>()
    let reloadTableView = PublishSubject<Void>()
    let organizeGame = PublishSubject<Void>()
    let actionButtonPressed = PublishSubject<Int>()
    let endGameAfterAlert = PublishSubject<Int>()
    let deleteGame = PublishSubject<Int>()
    let reOrganaizeGame = PublishSubject<Int>()
    
    let assistGameOrganize = PublishSubject<Void>()
    let askToOrganizeNewGames = PublishSubject<Void>()
    let showResultModalView = PublishSubject<Game>()
    
    override init() {
        super.init()
        self.mutate()
    }
}

extension GameDataTableViewModel {
    func mutate() {
        setPadelID.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let padelID = UserDefaults.standard.value(forKey: "PadelID") as! String
            self.padelID.accept(padelID)
        }).disposed(by: disposeBag)
        loadGameData.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.onGames.accept(self.coreDataManager.loadOnGames(uuidString: self.padelID.value))
            self.onCourts.accept(self.coreDataManager.loadCourtsIsOn(uuidString: self.padelID.value))
            self.reloadTableView.onNext(())
        }).disposed(by: disposeBag)
        assistGameOrganize.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let padel = self.coreDataManager.loadPadel(uuidString: self.padelID.value) else { return }
            guard padel.isReady else { return }
            let emptyCourtNum = self.coreDataManager.returnEmptyCourtNum(uuidString: self.padelID.value)
            if emptyCourtNum > 1 {
                self.askToOrganizeNewGames.onNext(())
            }
        }).disposed(by: disposeBag)
        organizeGame.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let padel = self.coreDataManager.loadPadel(uuidString: self.padelID.value) else { return }
            guard padel.isReady else {
                self.messageAlert.onNext(.lessPlayersError)
                return
            }
            let emptyCourtNum = self.coreDataManager.returnEmptyCourtNum(uuidString: self.padelID.value)
            guard emptyCourtNum != 0 else {
                self.messageAlert.onNext(.noCourtError)
                return
            }
            for _ in 0...emptyCourtNum - 1 {
                self.gameCreateManager.organaizeMatch()
            }
            self.loadGameData.onNext(())
        }).disposed(by: disposeBag)
        actionButtonPressed.subscribe(onNext: { [weak self] courtID in
            guard let self = self else { return }
            guard let padel = self.coreDataManager.loadPadel(uuidString: self.padelID.value) else { return }
            guard let court = self.coreDataManager.loadCourt(uuidString: self.padelID.value, courtID: Int16(courtID)) else { return }
            if court.onGame != nil {
                guard let game = self.coreDataManager.loadGameByCourtId(uuidString: self.padelID.value, courtID: Int16(courtID)) else { return }
                guard let startTime = game.startAt, startTime.timeIntervalSinceNow < -180.0 else {
                    self.messageAlert.onNext(.gameEndAlert(courtID))
                    return
                }
                if padel.showResult {
                    self.showResultModalView.onNext((game))
                    self.gameCreateManager.gameEnd(courtID: courtID)
                } else {
                    self.gameCreateManager.gameEnd(courtID: courtID)
                    self.messageAlert.onNext(.gameEnd)
                }
                self.loadGameData.onNext(())
            } else {
                guard padel.isReady else {
                    self.messageAlert.onNext(.lessPlayersError)
                    return
                }
                self.gameCreateManager.organaizeMatch(courtID: courtID)
                self.loadGameData.onNext(())
            }
        }).disposed(by: disposeBag)
        endGameAfterAlert.subscribe(onNext: { [weak self] courtID in
            guard let self = self else { return }
            guard let padel = self.coreDataManager.loadPadel(uuidString: self.padelID.value) else { return }
            guard let game = self.coreDataManager.loadGameByCourtId(uuidString: self.padelID.value, courtID: Int16(courtID)) else { return }
            if padel.showResult {
                self.showResultModalView.onNext((game))
                self.gameCreateManager.gameEnd(courtID: courtID)
            } else {
                self.gameCreateManager.gameEnd(courtID: courtID)
                self.messageAlert.onNext(.gameEnd)
            }
            self.loadGameData.onNext(())
        }).disposed(by: disposeBag)
        deleteGame.subscribe(onNext: { [weak self] courtID in
            guard let self = self else { return }
            self.gameCreateManager.gameDelete(courtID: courtID)
            self.loadGameData.onNext(())
        }).disposed(by: disposeBag)
        reOrganaizeGame.subscribe(onNext: { [weak self] courtID in
            guard let self = self else { return }
            self.gameCreateManager.reOrganizeGame(courtID: courtID)
            self.loadGameData.onNext(())
        }).disposed(by: disposeBag)
    }
}
