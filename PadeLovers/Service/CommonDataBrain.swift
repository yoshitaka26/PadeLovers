//
//  CommonDataBrain.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/22.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import Foundation

struct CommonDataBrain {
    static let shared = CommonDataBrain()
    let dataFilePathGroup1 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("PlayersGroup1.plist")
    let dataFilePathGroup2 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("PlayersGroup2.plist")
    let dataFilePathGroup3 = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("PlayersGroup3.plist")

    // 現在未使用
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Padel.plist")
    let gameDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("GameData.plist")

    private func loadPlayers(group: TableType) -> [CommonPlayerDataModel]? {
        var players = [CommonPlayerDataModel]()
        var filePath: URL?
        switch  group {
        case .group1:
            filePath = dataFilePathGroup1
        case .group2:
            filePath = dataFilePathGroup2
        case .group3:
            filePath = dataFilePathGroup3
        default:
            break
        }

        guard let path = filePath else { return players }
        if let data = try? Data(contentsOf: path) {
            let decoder = PropertyListDecoder()
            do {
                players = try decoder.decode([CommonPlayerDataModel].self, from: data)
            } catch {
                print("Error decoding, \(error)")
            }
        }
        return players
    }

    func migrateToCoreData() {
        let coreDataManager = CoreDataManager.shared

        if let playerData1 = CommonDataBrain.shared.loadPlayers(group: .group1),
           !playerData1.isEmpty {
            let group1Name = UserDefaults.standard.value(forKey: "group1") as? String
            let group = coreDataManager.createMasterPlayerGroup(name: group1Name ?? "グループA")
            let players = group.allPlayers

            guard playerData1.count <= players.count else { return }
            for i in 0..<playerData1.count {
                players[i].name = playerData1[i].playerName
                players[i].gender = playerData1[i].playerGender
            }

            guard coreDataManager.updateMasterPlayerGroup(
                groupID: group.id!.uuidString,
                groupName: group.name ?? "グループA",
                players: players
            ) else { return }
        }

        if let playerData2 = CommonDataBrain.shared.loadPlayers(group: .group2),
           !playerData2.isEmpty {
            let group2Name = UserDefaults.standard.value(forKey: "group2") as? String
            let group = coreDataManager.createMasterPlayerGroup(name: group2Name ?? "グループB")
            let players = group.allPlayers

            guard playerData2.count <= players.count else { return }
            for i in 0..<playerData2.count {
                players[i].name = playerData2[i].playerName
                players[i].gender = playerData2[i].playerGender
            }

            guard coreDataManager.updateMasterPlayerGroup(
                groupID: group.id!.uuidString,
                groupName: group.name ?? "グループB",
                players: players
            ) else { return }
        }

        if let playerData3 = CommonDataBrain.shared.loadPlayers(group: .group3),
           !playerData3.isEmpty {
            let group3Name = UserDefaults.standard.value(forKey: "group3") as? String
            let group = coreDataManager.createMasterPlayerGroup(name: group3Name ?? "グループC")
            let players = group.allPlayers

            guard playerData3.count <= players.count else { return }
            for i in 0..<playerData3.count {
                players[i].name = playerData3[i].playerName
                players[i].gender = playerData3[i].playerGender
            }

            guard coreDataManager.updateMasterPlayerGroup(
                groupID: group.id!.uuidString,
                groupName: group.name ?? "グループC",
                players: players
            ) else { return }
        }

        UserDefaultsUtil.shared.playerDataMigratedToCoreData = true
    }
}
