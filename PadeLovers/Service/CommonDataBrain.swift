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
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Padel.plist")

    let gameDataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("GameData.plist")
    
    func savePlayers(group: TableType, players: [CommonPlayerDataModel]) {
        let encoder = PropertyListEncoder()
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

        do {
            let data = try encoder.encode(players)
            guard let path = filePath else { return }
            try data.write(to: path)
        } catch {
            print("Error encording item, \(error)")
        }
    }

    func loadPlayers(group: TableType) -> [CommonPlayerDataModel]? {
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
}
