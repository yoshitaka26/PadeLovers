//
//  ReordScoreViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/17.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

struct ScoreData {
    var A1Score: Int16
    var B1Score: Int16
    var A2Score: Int16
    var B2Score: Int16
    var A3Score: Int16
    var B3Score: Int16
    var totalA: Int16
    var totalB: Int16
    var time: String
}
class RecordScoreViewModel: BaseViewModel {
    override init() {
        super.init()
        mutate()
    }
    let coreDataManager = CoreDataManager.shared
    var padelID: String = UserDefaults.standard.value(forKey: "PadelID") as! String
    
    let bindData = PublishSubject<Game>()
    let bindDataWithScore = PublishSubject<(Game, Score)>()
    var gameData: BehaviorRelay<Game?> = BehaviorRelay(value: nil)
    
    var driveAname: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var backAname: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var driveBname: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var backBname: BehaviorRelay<NSAttributedString?> = BehaviorRelay(value: nil)
    var timeLabel: BehaviorRelay<String> = BehaviorRelay(value: "")
    
    let A1Minus = PublishSubject<Void>()
    let A1Plus = PublishSubject<Void>()
    let B1Minus = PublishSubject<Void>()
    let B1Plus = PublishSubject<Void>()
    let A2Minus = PublishSubject<Void>()
    let A2Plus = PublishSubject<Void>()
    let B2Minus = PublishSubject<Void>()
    let B2Plus = PublishSubject<Void>()
    let A3Minus = PublishSubject<Void>()
    let A3Plus = PublishSubject<Void>()
    let B3Minus = PublishSubject<Void>()
    let B3Plus = PublishSubject<Void>()
    
    var A1Score: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var B1Score: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var A2Score: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var B2Score: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var A3Score: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var B3Score: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var A1ScoreString: Observable<String> {
        return A1Score.asObservable().map { String($0) }
    }
    var B1ScoreString: Observable<String> {
        return B1Score.asObservable().map { String($0) }
    }
    var A2ScoreString: Observable<String> {
        return A2Score.asObservable().map { String($0) }
    }
    var B2ScoreString: Observable<String> {
        return B2Score.asObservable().map { String($0) }
    }
    var A3ScoreString: Observable<String> {
        return A3Score.asObservable().map { String($0) }
    }
    var B3ScoreString: Observable<String> {
        return B3Score.asObservable().map { String($0) }
    }
    var totalAScore: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var totalAScoreString: Observable<String> {
        Observable.combineLatest(A1Score, B1Score, A2Score, B2Score, A3Score, B3Score) { A1, B1, A2, B2, A3, B3 in
            var score = 0
            if A1 > B1 { score += 1 }
            if A2 > B2 { score += 1 }
            if A3 > B3 { score += 1 }
            self.totalAScore.accept(Int16(score))
            return String(score)
        }
    }
    var totalBScore: BehaviorRelay<Int16> = BehaviorRelay(value: 0)
    var totalBScoreString: Observable<String> {
        Observable.combineLatest(A1Score, B1Score, A2Score, B2Score, A3Score, B3Score) { A1, B1, A2, B2, A3, B3 in
            var score = 0
            if A1 < B1 { score += 1 }
            if A2 < B2 { score += 1 }
            if A3 < B3 { score += 1 }
            self.totalBScore.accept(Int16(score))
            return String(score)
        }
    }
    
    let doneButtonPressed = PublishSubject<Void>()
    let closeModalView = PublishSubject<Void>()
    
    func mutate() {
        bindData.subscribe(onNext: { [weak self] game in
            guard let self = self else { return }
            self.gameData.accept(game)
            let playersList = self.coreDataManager.loadPlayersForResultData(uuidString: self.padelID)
            var players = [PositionType: Player]()
            
            playersList.forEach {
                switch $0.playerID {
                case game.driveA:
                    players[.driveA] = $0
                case game.backA:
                    players[.backA] = $0
                case game.driveB:
                    players[.driveB] = $0
                case game.backB:
                    players[.backB] = $0
                default:
                    break
                }
            }
            self.driveAname.accept(NSAttributedString.setNameOnLabel(name: players[.driveA]?.name ?? "", gender: players[.driveA]?.gender ?? true))
            self.backAname.accept(NSAttributedString.setNameOnLabel(name: players[.backA]?.name ?? "", gender: players[.backA]?.gender ?? true))
            self.driveBname.accept(NSAttributedString.setNameOnLabel(name: players[.driveB]?.name ?? "", gender: players[.driveB]?.gender ?? true))
            self.backBname.accept(NSAttributedString.setNameOnLabel(name: players[.backB]?.name ?? "", gender: players[.backB]?.gender ?? true))
            guard !game.isEnd, let startAt = game.startAt else { return }
            let timeInterval = Date().timeIntervalSince(startAt)
            let time = Int(timeInterval)
            let timeMinutes = time / 60
            var timeString = String(timeMinutes)
            if timeMinutes > 200 {
                timeString = "∞"
            }
            self.timeLabel.accept(timeString)
        }).disposed(by: disposeBag)
        bindDataWithScore.subscribe(onNext: { [weak self] game, score in
            guard let self = self else { return }
            self.gameData.accept(game)
            let playersList = self.coreDataManager.loadPlayersForResultData(uuidString: self.padelID)
            var players = [PositionType: Player]()
            
            playersList.forEach {
                switch $0.playerID {
                case game.driveA:
                    players[.driveA] = $0
                case game.backA:
                    players[.backA] = $0
                case game.driveB:
                    players[.driveB] = $0
                case game.backB:
                    players[.backB] = $0
                default:
                    break
                }
            }
            
            self.driveAname.accept(NSAttributedString.setNameOnLabel(name: players[.driveA]?.name ?? "", gender: players[.driveA]?.gender ?? true))
            self.backAname.accept(NSAttributedString.setNameOnLabel(name: players[.backA]?.name ?? "", gender: players[.backA]?.gender ?? true))
            self.driveBname.accept(NSAttributedString.setNameOnLabel(name: players[.driveB]?.name ?? "", gender: players[.driveB]?.gender ?? true))
            self.backBname.accept(NSAttributedString.setNameOnLabel(name: players[.backB]?.name ?? "", gender: players[.backB]?.gender ?? true))
            self.A1Score.accept(score.score1A)
            self.B1Score.accept(score.score1B)
            self.A2Score.accept(score.score2A)
            self.B2Score.accept(score.score2B)
            self.A3Score.accept(score.score3A)
            self.B3Score.accept(score.score3B)
            guard let score = score.playTime else { return }
            self.timeLabel.accept(score)
        }).disposed(by: disposeBag)
        
        A1Minus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.A1Score.value > 0 else { return }
            self.A1Score.accept(self.A1Score.value - 1)
        }).disposed(by: disposeBag)
        A1Plus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.A1Score.value != 0 else {
                self.A1Score.accept(4)
                return
            }
            guard self.A1Score.value < 7 else { return }
            self.A1Score.accept(self.A1Score.value + 1)
        }).disposed(by: disposeBag)
        
        B1Minus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.B1Score.value > 0 else { return }
            self.B1Score.accept(self.B1Score.value - 1)
        }).disposed(by: disposeBag)
        B1Plus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.B1Score.value != 0 else {
                self.B1Score.accept(4)
                return
            }
            guard self.B1Score.value < 7 else { return }
            self.B1Score.accept(self.B1Score.value + 1)
        }).disposed(by: disposeBag)
        A2Minus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.A2Score.value > 0 else { return }
            self.A2Score.accept(self.A2Score.value - 1)
        }).disposed(by: disposeBag)
        A2Plus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.A2Score.value != 0 else {
                self.A2Score.accept(4)
                return
            }
            guard self.A2Score.value < 7 else { return }
            self.A2Score.accept(self.A2Score.value + 1)
        }).disposed(by: disposeBag)
        B2Minus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.B2Score.value > 0 else { return }
            self.B2Score.accept(self.B2Score.value - 1)
        }).disposed(by: disposeBag)
        B2Plus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.B2Score.value != 0 else {
                self.B2Score.accept(4)
                return
            }
            guard self.B2Score.value < 7 else { return }
            self.B2Score.accept(self.B2Score.value + 1)
        }).disposed(by: disposeBag)
        
        A3Minus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.A3Score.value > 0 else { return }
            self.A3Score.accept(self.A3Score.value - 1)
        }).disposed(by: disposeBag)
        A3Plus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.A3Score.value != 0 else {
                self.A3Score.accept(4)
                return
            }
            guard self.A3Score.value < 7 else { return }
            self.A3Score.accept(self.A3Score.value + 1)
        }).disposed(by: disposeBag)
        
        B3Minus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.B3Score.value > 0 else { return }
            self.B3Score.accept(self.B3Score.value - 1)
        }).disposed(by: disposeBag)
        B3Plus.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard self.B3Score.value != 0 else {
                self.B3Score.accept(4)
                return
            }
            guard self.B3Score.value < 7 else { return }
            self.B3Score.accept(self.B3Score.value + 1)
        }).disposed(by: disposeBag)
        
        // swiftlint:disable line_length
        doneButtonPressed.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            guard let game = self.gameData.value else { return }
            let scoreData = ScoreData(A1Score: self.A1Score.value, B1Score: self.B1Score.value, A2Score: self.A2Score.value, B2Score: self.B2Score.value, A3Score: self.A3Score.value, B3Score: self.B3Score.value, totalA: self.totalAScore.value, totalB: self.totalBScore.value, time: self.timeLabel.value)
            
            if game.score != nil {
                self.coreDataManager.updateScore(uuidString: self.padelID, game: game, scoreData: scoreData)
                self.closeModalView.onNext(())
            } else {
                self.coreDataManager.recordScore(uuidString: self.padelID, game: game, scoreData: scoreData)
                self.closeModalView.onNext(())
            }
        }).disposed(by: disposeBag)
        // swiftlint:enable line_length
    }
}
