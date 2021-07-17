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

enum ScoreType {
    case player
    case game
}

class GameResultViewModel: BaseViewModel {

    let coreDataManager = CoreDataManager.shared
    let gameCreateManager = GameOrganizeManager.shared
    
    var padelID: BehaviorRelay<String> = BehaviorRelay(value: "")
    let setPadelID = PublishSubject<Void>()
    
    var scoreType: BehaviorRelay<ScoreType> = BehaviorRelay(value: .player)
    var allPlayers: BehaviorRelay<[Player]> = BehaviorRelay(value: [])
    var minGameCount: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var allGames: BehaviorRelay<[Game]> = BehaviorRelay(value: [])
    
    let loadGameData = PublishSubject<Void>()
    let reloadTableView = PublishSubject<Void>()
    
    var longPressedScore: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    let pushToEditDataModalView = PublishSubject<Game>()
    
    var playerButtonColor: BehaviorRelay<UIColor> = BehaviorRelay(value: .appRed)
    var gameButtonColor: BehaviorRelay<UIColor> = BehaviorRelay(value: .appBlue)
    
    override init() {
        super.init()
        self.mutate()
    }
}

extension GameResultViewModel {
    func mutate() {
        setPadelID.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let padelID = UserDefaults.standard.value(forKey: "PadelID") as! String
            self.padelID.accept(padelID)
        }).disposed(by: disposeBag)
        loadGameData.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.allPlayers.accept(self.coreDataManager.loadPlayersForResultData(uuidString: self.padelID.value))
            self.minGameCount.accept(self.coreDataManager.checkMinCountOfPlayingGame(uuidString: self.padelID.value))
            self.allGames.accept(self.coreDataManager.loadGamesForResult(uuidString: self.padelID.value))
            self.reloadTableView.onNext(())
        }).disposed(by: disposeBag)
        longPressedScore.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            guard self.allGames.value.count > index else { return }
            let selectedGame = self.allGames.value[index]
            self.pushToEditDataModalView.onNext((selectedGame))
        }).disposed(by: disposeBag)
    }
}
