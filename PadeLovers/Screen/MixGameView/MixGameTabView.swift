//
//  MixGameTabView.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import SwiftUI

struct MixGameTabView: View {
    @StateObject var viewModel: MixGameViewModel

    var body: some View {
        TabView(selection: $viewModel.tab) {
            PlayerSettingList(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "house")
                    Text("プレイヤー")
                }
                .tag(MixGameViewModel.MixGameTab.player)
            GameSettingList(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "message")
                    Text("ゲーム")
                }
                .tag(MixGameViewModel.MixGameTab.game)
        }
    }
}

struct PlayerSettingList: View {
    @ObservedObject var viewModel: MixGameViewModel

    var body: some View {
        List {
            ForEach(viewModel.players, id: \.id) { player in
                PlayerCell(player: player)
            }
        }
    }
}

struct PlayerCell: View {
    @ObservedObject var player: MixGamePlayer

    var body: some View {
        HStack {
            Text(player.name)
                .font(.title)
                .foregroundColor(player.isMale ? .blue : .red)
            Spacer()
            Toggle("", isOn: $player.isPlaying)
                .labelsHidden()
        }
    }
}

struct GameSettingList: View {
    @ObservedObject var viewModel: MixGameViewModel

    var body: some View {
        /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Hello, world!@*/Text("Hello, world!")/*@END_MENU_TOKEN@*/
    }
}
