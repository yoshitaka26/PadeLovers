//
//  MixGameViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Combine

@MainActor
final class MixGameViewModel: ObservableObject {
    @Published var tab: MixGameTab = .player

    enum MixGameTab {
        case player
        case game
    }

    @Published var players: [MixGamePlayer] = []
    @Published var matchGame: [MixGameMatchGame] = []

    init(groupID: String) {
        let playersData = CoreDataManager.shared.loadMasterPlayers(groupID: groupID)
        let courtData = UserDefaultsUtil.shared.courtNames
        self.players = playersData.map {
            return MixGamePlayer(id: Int($0.order), name: $0.name ?? "ゲスト", isMale: $0.gender)
        }
    }

}
