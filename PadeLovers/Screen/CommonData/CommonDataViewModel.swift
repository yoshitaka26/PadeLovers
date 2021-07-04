//
//  MasterDataViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/22.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

enum TableType {
    case court
    case group1
    case group2
    case group3
}

class CommonDataViewModel: BaseViewModel {
    
    override init() {
        super.init()
        self.dataBind()
        self.mutate()
    }
    private let commonDataBrain = CommonDataBrain.shared
    
    var tableType: BehaviorRelay<TableType> = BehaviorRelay(value: .court)
    
    var groupName: BehaviorRelay<String> = BehaviorRelay(value: "グループ")
    
    var courtList: BehaviorRelay<[BehaviorRelay<String>]> = BehaviorRelay(value: [])
    var playersList: BehaviorRelay<[BehaviorRelay<String>]> = BehaviorRelay(value: [])
    var playersGenderList: BehaviorRelay<[BehaviorRelay<Int>]> = BehaviorRelay(value: [])
    
    var court1Label: BehaviorRelay<String> = BehaviorRelay(value: "コートA")
    var court2Label: BehaviorRelay<String> = BehaviorRelay(value: "コートB")
    var court3Label: BehaviorRelay<String> = BehaviorRelay(value: "コートC")
    
    var player1name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ1")
    var player1Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player2name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ2")
    var player2Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player3name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ3")
    var player3Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player4name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ4")
    var player4Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player5name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ5")
    var player5Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player6name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ6")
    var player6Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player7name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ7")
    var player7Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player8name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ8")
    var player8Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player9name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ9")
    var player9Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player10name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ10")
    var player10Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player11name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ11")
    var player11Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player12name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ12")
    var player12Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player13name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ13")
    var player13Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player14name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ14")
    var player14Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player15name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ15")
    var player15Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player16name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ16")
    var player16Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player17name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ17")
    var player17Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player18name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ18")
    var player18Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player19name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ19")
    var player19Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player20name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ20")
    var player20Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    var player21name: BehaviorRelay<String> = BehaviorRelay(value: "プレイヤ21")
    var player21Gender: BehaviorRelay<Int> = BehaviorRelay(value: 0)
    
    let tabButtonSelected = PublishSubject<TableType>()
    let saveData = PublishSubject<Void>()
    let loadData = PublishSubject<Void>()
    
    let reloadTableView = PublishSubject<Void>()
    
    var courtButtonColor: BehaviorRelay<UIColor> = BehaviorRelay(value: .appRed)
    var group1ButtonColor: BehaviorRelay<UIColor> = BehaviorRelay(value: .appBlue)
    var group2ButtonColor: BehaviorRelay<UIColor> = BehaviorRelay(value: .appBlue)
    var group3ButtonColor: BehaviorRelay<UIColor> = BehaviorRelay(value: .appBlue)
}

extension CommonDataViewModel {
    func dataBind() {
        // swiftlint:disable line_length
        courtList.accept([court1Label, court2Label, court3Label])
        playersList.accept([player1name, player2name, player3name, player4name, player5name, player6name, player7name, player8name, player9name, player10name, player11name, player12name, player13name, player14name, player15name, player16name, player17name, player18name, player19name, player20name, player21name])
        playersGenderList.accept([player1Gender, player2Gender, player3Gender, player4Gender, player5Gender, player6Gender, player7Gender, player8Gender, player9Gender, player10Gender, player11Gender, player12Gender, player13Gender, player14Gender, player15Gender, player16Gender, player17Gender, player18Gender, player19Gender, player20Gender, player21Gender])
        if let court = UserDefaults.standard.value(forKey: "court") as? [String], court.count == 2 {
            self.court1Label.accept(court[0])
            self.court2Label.accept(court[1])
            UserDefaults.standard.removeObject(forKey: "court")
        }
        if let players = UserDefaults.standard.value(forKey: "player") as? [String], players.count == 21 {
            for (index, player) in players.enumerated() {
                self.playersList.value[index].accept(player)
            }
        }
        if let genders = UserDefaults.standard.value(forKey: "gender") as? [Bool], genders.count == 21 {
            for (index, gender) in genders.enumerated() {
                self.playersGenderList.value[index].accept(gender ? 0 : 1)
            }
        }
            
        guard let courtNames = UserDefaults.standard.value(forKey: "newCourt") as? [String] else { return }
        for (index, court) in courtNames.enumerated() {
            self.courtList.value[index].accept(court)
        }
        self.reloadTableView.onNext(())
        // swiftlint:enable line_length
    }
    
    func mutate() {
        tabButtonSelected.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            
            switch self.tableType.value {
            case .court:
                let courtNames = [self.court1Label.value, self.court2Label.value, self.court3Label.value]
                UserDefaults.standard.set(courtNames, forKey: "newCourt")
            case .group1:
                UserDefaults.standard.set(self.groupName.value, forKey: "group1")
                self.saveData.onNext(())
            case .group2:
                UserDefaults.standard.set(self.groupName.value, forKey: "group2")
                self.saveData.onNext(())
            case .group3:
                UserDefaults.standard.set(self.groupName.value, forKey: "group3")
                self.saveData.onNext(())
            }
            guard self.tableType.value != type else { return }
            self.tableType.accept(type)
            self.loadData.onNext(())
        }).disposed(by: disposeBag)
        saveData.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            var commonPlayers: [CommonPlayerDataModel] = []
            self.playersList.value.forEach {
                let temp = CommonPlayerDataModel(name: $0.value, gender: true)
                commonPlayers.append(temp)
            }
            for (index, temp) in  commonPlayers.enumerated() {
                temp.playerGender = (self.playersGenderList.value[index].value == 0)
            }
            if self.tableType.value != .court {
                self.commonDataBrain.savePlayers(group: self.tableType.value, players: commonPlayers)
            }
        }).disposed(by: disposeBag)
        loadData.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            
            switch self.tableType.value {
            case .court:
                guard let courtNames = UserDefaults.standard.value(forKey: "newCourt") as? [String] else { return }
                for (index, court) in courtNames.enumerated() {
                    self.courtList.value[index].accept(court)
                }
                self.reloadTableView.onNext(())
                return
            case .group1:
                if let groupName = UserDefaults.standard.value(forKey: "group1") as? String {
                    self.groupName.accept(groupName)
                }
            case .group2:
                if let groupName = UserDefaults.standard.value(forKey: "group2") as? String {
                    self.groupName.accept(groupName)
                }
            case .group3:
                if let groupName = UserDefaults.standard.value(forKey: "group3") as? String {
                    self.groupName.accept(groupName)
                }
            }
            
            let playersData = self.commonDataBrain.loadPlayers(group: self.tableType.value)
            guard let players = playersData, players.count < 22 else { return }
            for (index, player) in players.enumerated() {
                self.playersList.value[index].accept(player.playerName)
                self.playersGenderList.value[index].accept(player.playerGender ? 0 : 1)
            }
            self.reloadTableView.onNext(())
        }).disposed(by: disposeBag)
    }
}
