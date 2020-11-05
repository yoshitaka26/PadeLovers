//
//  GameDataRecordBrain.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/28.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

struct PadelDataRecordBrain {
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Padel.plist")

    func savePlayers(players: [PadelModel]) {
        let encoder = PropertyListEncoder()
        
        do {
            let data = try encoder.encode(players)
            try data.write(to: dataFilePath!)
        } catch {
            print("Error encording item, \(error)")
        }
    }
    
    func loadPlayers() -> [PadelModel]? {
        var players = [PadelModel]()
        
        if let data = try? Data(contentsOf: dataFilePath!) {
            let decoder = PropertyListDecoder()
            do {
                players = try decoder.decode([PadelModel].self, from: data)
            } catch {
                print("Error decoding, \(error)")
            }
        }
        return players
    }
}
