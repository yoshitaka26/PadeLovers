//
//  MixGameMatchGame.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import Combine

class MixGameMatchGame: ObservableObject {
    @Published var players: [MixGamePlayer] = []
    @Published var isFinished: Bool = false

}
