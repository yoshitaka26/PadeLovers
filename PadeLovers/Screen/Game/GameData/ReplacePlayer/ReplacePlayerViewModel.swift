//
//  ReplacePlayerViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/11.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//


import Foundation
import RxSwift
import RxCocoa

enum MessageType {
    case samePlayersSelected
    case replacedPlayerFromWaiting
    case replacedPlayerOnSameGame
    case replacePlayerFromAnotherGame
}

class ReplacePlayerViewModel: BaseViewModel {
    override init() {
        super.init()
        self.mutate()
    }

    let coreDataManager = CoreDataManager.shared
    let gameCreateManager = GameCreateManager.shared
    var padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
    
    var playersOnGame: BehaviorRelay<[Player]> = BehaviorRelay(value: [])
    var playersForReplace: BehaviorRelay<[Player]> = BehaviorRelay(value: [])
    var picker1SelectedRow: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var picker2SelectedRow: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    let loadData = PublishSubject<Int>()
    let okAction = PublishSubject<Void>()
    let pushWith = PublishSubject<MessageType>()
    let replacePlayerFromAnotherGame = PublishSubject<Void>()
    
    var players: Observable<[Int: [Player]]> {
        Observable.combineLatest(playersOnGame, playersForReplace) { playing, waiting in
            return [0: playing, 1: waiting]
        }
    }
    var playersForPickerView: BehaviorRelay<[Int: [Player]]?> = BehaviorRelay(value: nil)
}

extension ReplacePlayerViewModel {
    func mutate() {
        loadData.subscribe(onNext: { [weak self] courtID in
            guard let self = self else { return }
            let playersOnGame = self.coreDataManager.loadPlayersOfGameByCourtID(uuidString: self.padelID, courtID: courtID)
            let playingPlayers = self.coreDataManager.loadPlayingPlayers(uuidString: self.padelID)
            self.playersOnGame.accept(playersOnGame)
            self.playersForReplace.accept(playingPlayers)
        }).disposed(by: disposeBag)
        players.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.playersForPickerView.accept(value)
        }).disposed(by: disposeBag)
        okAction.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let row1 = self.picker1SelectedRow.value
            let row2 = self.picker2SelectedRow.value
            let playersOnGame = self.playersOnGame.value
            let playersForeReplace = self.playersForReplace.value
            let player1 = playersOnGame[row1]
            let player2 = playersForeReplace[row2]
            
            if player1.playerID == player2.playerID {
                self.pushWith.onNext(.samePlayersSelected)
            }

            if player2.onGame == nil {
                self.gameCreateManager.replacePlayers(player1: player1, player2: player2)
                self.pushWith.onNext(.replacedPlayerFromWaiting)
            }
            
            if let game = player2.onGame, let mainGame = player1.onGame {
                if game.gameID == mainGame.gameID {
                    self.gameCreateManager.replacePlayers(player1: player1, player2: player2)
                    self.pushWith.onNext(.replacedPlayerOnSameGame)
                } else {
                    self.pushWith.onNext(.replacePlayerFromAnotherGame)
                }
            }
        }).disposed(by: disposeBag)
        replacePlayerFromAnotherGame.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let row1 = self.picker1SelectedRow.value
            let row2 = self.picker2SelectedRow.value
            let playersOnGame = self.playersOnGame.value
            let playersForeReplace = self.playersForReplace.value
            let player1 = playersOnGame[row1]
            let player2 = playersForeReplace[row2]
            self.gameCreateManager.replacePlayers(player1: player1, player2: player2)
        }).disposed(by: disposeBag)
    }
}
