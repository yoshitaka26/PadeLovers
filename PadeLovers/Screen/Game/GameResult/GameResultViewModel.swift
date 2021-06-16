//
//  GameResultViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/14.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class GameResultViewModel: BaseViewModel {

    let coreDataManager = CoreDataManager.shared
    let gameCreateManager = GameCreateManager.shared
    var padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
    
    var allPlayers: BehaviorRelay<[Player]> = BehaviorRelay(value: [])
    var minGameCount: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var allGames: BehaviorRelay<[Game]> = BehaviorRelay(value: [])
    let errorAlert = PublishSubject<ErrorAlert>()
    
    let loadGameData = PublishSubject<Void>()
    let reloadTableView = PublishSubject<Void>()
    let organizeGame = PublishSubject<Void>()
    let gameEnd = PublishSubject<Int>()
    let deleteGame = PublishSubject<Int>()
    let reOrganaizeGame = PublishSubject<Int>()
    
    override init() {
        super.init()
        self.mutate()
    }
}

extension GameResultViewModel {
    func mutate() {
        loadGameData.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.allPlayers.accept(self.coreDataManager.loadPlayersForResultData(uuidString: self.padelID))
            self.minGameCount.accept(self.coreDataManager.checkMinCountOfPlayingGame(uuidString: self.padelID))
            self.allGames.accept(self.coreDataManager.loadOnGames(uuidString: self.padelID))
            self.reloadTableView.onNext(())
        }).disposed(by: disposeBag)
        organizeGame.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let padel = self.coreDataManager.loadPadel(uuidString: self.padelID) else {
                self.errorAlert.onNext(.unexpectedError)
                return
            }
            guard padel.isReady else {
                self.errorAlert.onNext(.lessPlayers)
                return
            }
            let emptyCourtNum = self.coreDataManager.returnEmptyCourtNum(uuidString: self.padelID)
            guard emptyCourtNum != 0 else {
                self.errorAlert.onNext(.noCourtError)
                return
            }
            for _ in 0...emptyCourtNum - 1 {
                self.gameCreateManager.organaizeMatch()
            }
            self.loadGameData.onNext(())
        }).disposed(by: disposeBag)
        gameEnd.subscribe(onNext: { [weak self] courtID in
            guard let self = self else { return }
            self.gameCreateManager.gameEnd(courtID: courtID)
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
