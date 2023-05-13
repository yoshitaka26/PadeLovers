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

enum TableType: Int {
    case group1 = 0
    case group2 = 1
    case group3 = 2
    case court
}

final class CommonDataViewModel: BaseViewModel {
    
    override init() {
        super.init()
        self.dataBind()
        self.mutate()
    }

    private let commonDataBrain = CommonDataBrain.shared
    private let coreDataManager = CoreDataManager.shared
    
    var tableType: BehaviorRelay<TableType> = BehaviorRelay(value: .court)
    
    var groupName: BehaviorRelay<String> = BehaviorRelay(value: "グループ")
    
    var courtList: BehaviorRelay<[BehaviorRelay<String>]> = BehaviorRelay(value: [])

    var masterPlayerGroupList: [MasterPlayerGroup] = []
    var masterPlayerList: BehaviorRelay<[BehaviorRelay<MasterPlayer>]> = BehaviorRelay(value: [])

    var court1Label: BehaviorRelay<String> = BehaviorRelay(value: "コートA")
    var court2Label: BehaviorRelay<String> = BehaviorRelay(value: "コートB")
    var court3Label: BehaviorRelay<String> = BehaviorRelay(value: "コートC")

    let tabButtonSelected = PublishSubject<TableType>()
    let loadData = PublishSubject<Void>()

    let playerCellTextFieldTextInput = PublishRelay<(text: String, index: Int)>()
    let playerCellGenderSegment = PublishRelay<(gender: Bool, index: Int)>()
    
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

        // [改修]CoreDataからプレイヤー情報を取得
        var groupList = coreDataManager.loadMasterPlayerGroup()

        if groupList.isEmpty {
            // 新規作成
            var list = [MasterPlayerGroup]()
            list.append(coreDataManager.createMasterPlayerGroup(name: "グループA"))
            list.append(coreDataManager.createMasterPlayerGroup(name: "グループB"))
            list.append(coreDataManager.createMasterPlayerGroup(name: "グループC"))
            masterPlayerGroupList = list
        } else {
            masterPlayerGroupList = groupList
        }

        if let court = UserDefaults.standard.value(forKey: "court") as? [String], court.count == 2 {
            self.court1Label.accept(court[0])
            self.court2Label.accept(court[1])
            UserDefaults.standard.removeObject(forKey: "court")
        }

        guard let courtNames = UserDefaults.standard.value(forKey: "newCourt") as? [String] else { return }
        for (index, court) in courtNames.enumerated() {
            self.courtList.value[index].accept(court)
        }
        self.reloadTableView.onNext(())
        // swiftlint:enable line_length
    }
    
    func mutate() {
        playerCellTextFieldTextInput
            .subscribe(onNext: { [weak self] text, index in
                guard let self else { return }
                let masterPlayerRelay = self.masterPlayerList.value[index]
                let player = masterPlayerRelay.value
                player.name = text
                masterPlayerRelay.accept(player)
            })
            .disposed(by: disposeBag)

        playerCellGenderSegment
            .subscribe(onNext: { [weak self] gender, index in
                guard let self else { return }
                let masterPlayerRelay = self.masterPlayerList.value[index]
                let player = masterPlayerRelay.value
                player.gender = gender
                masterPlayerRelay.accept(player)
            })
            .disposed(by: disposeBag)

        tabButtonSelected
            .subscribe(onNext: { [weak self] type in
                guard let self else { return }
                guard self.masterPlayerGroupList.count == 3 else {
                    assertionFailure()
                    return
                }

                switch self.tableType.value {
                case .court:
                    let courtNames = [self.court1Label.value, self.court2Label.value, self.court3Label.value]
                    UserDefaults.standard.set(courtNames, forKey: "newCourt")
                default:
                    let masterPlayerList = self.masterPlayerList.value.map { $0.value }
                    self.saveGroupData(
                        group: self.masterPlayerGroupList[self.tableType.value.rawValue],
                        players: masterPlayerList
                    )
                }

                guard self.tableType.value != type else { return }
                self.tableType.accept(type)

                self.loadData.onNext(())
            }).disposed(by: disposeBag)

        loadData
            .subscribe(onNext: { [weak self] _ in
                guard let self else { return }
                guard self.masterPlayerGroupList.count == 3 else {
                    assertionFailure()
                    return
                }

                switch self.tableType.value {
                case .court:
                    guard let courtNames = UserDefaults.standard.value(forKey: "newCourt") as? [String] else { return }
                    for (index, court) in courtNames.enumerated() {
                        self.courtList.value[index].accept(court)
                    }
                    self.reloadTableView.onNext(())
                default:
                    self.groupName.accept(self.masterPlayerGroupList[self.tableType.value.rawValue].name ?? "")
                    self.reloadPlayerData(groupID: self.masterPlayerGroupList[self.tableType.value.rawValue].id!.uuidString)
                }
            }).disposed(by: disposeBag)
    }

    private func saveGroupData(group: MasterPlayerGroup, players: [MasterPlayer]) {
        _ = coreDataManager.updateMasterPlayerGroup(
            groupID: group.id!.uuidString,
            groupName: groupName.value,
            players: players
        )
    }

    private func reloadPlayerData(groupID: String) {
        masterPlayerList.accept(
            coreDataManager.loadMasterPlayers(groupID: groupID)
                .map { BehaviorRelay(value: $0) }
        )
        reloadTableView.onNext(())
    }
}
