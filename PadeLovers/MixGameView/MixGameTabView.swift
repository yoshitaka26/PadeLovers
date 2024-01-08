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
    @State var dismissAlert = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        TabView(selection: $viewModel.tab) {
            PlayerSettingList(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "person.crop.rectangle.stack")
                    Text("プレイヤー")
                }
                .tag(MixGameViewModel.MixGameTab.player)
            GameSettingList(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "figure.tennis")
                    Text("試合")
                }
                .tag(MixGameViewModel.MixGameTab.game)
        }
        .accentColor(.appSpecialRed)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    dismissAlert = true
                } label: {
                    Image(systemName: "house")
                        .foregroundStyle(Color(UIColor.appNavBarButtonColor))
                }
            }
        }
        .alert("試合データ削除", isPresented: $dismissAlert) {
            Button("終了する", role: .destructive) {
                dismiss()
            }
        } message: {
            Text("データは保存されません。試合データを削除してホーム画面に戻ります。終了してよろしいですか？")
        }

    }
}

struct PlayerSettingList: View {
    @ObservedObject var viewModel: MixGameViewModel

    var body: some View {
        List {
            Section("コート") {
                ForEach(viewModel.courts, id: \.id) { court in
                    CourtCell(court: court)
                }
            }
            Section("プレイヤー") {
                ForEach(viewModel.players, id: \.id) { player in
                    Button {
                        viewModel.playerDetail = player
                    } label: {
                        PlayerCell(player: player)
                    }
                }
            }
        }
        .listStyle(.grouped)
        .sheet(item: $viewModel.playerDetail) { player in
            if #available(iOS 16.0, *) {
                PlayerDetail(player: player)
                    .presentationDetents([.height(180)])
            } else {
                PlayerDetail(player: player)
            }
        }
    }
}

struct PlayerDetail: View {
    @ObservedObject var player: MixGamePlayer

    var body: some View {
        VStack {
            Text(player.name)
            Text("試合数： \(player.playedCount)")
            HStack(spacing: 20) {
                Button(action: {
                    player.minusPlayCount()
                }, label: {
                    Image(systemName: "minus.circle")
                })
                .buttonStyle(.bordered)
                Button(action: {
                    player.addPlayCount()
                }, label: {
                    Image(systemName: "plus.circle")
                })
                .buttonStyle(.bordered)
            }
        }
    }
}

struct CourtCell: View {
    @ObservedObject var court: MixGameCourt

    var body: some View {
        HStack {
            Text(court.name)
                .font(.subheadline)
            Spacer()
            Toggle("", isOn: $court.isOn)
                .labelsHidden()
                .disabled(court.switchDisabled)
        }
    }
}

struct PlayerCell: View {
    @ObservedObject var player: MixGamePlayer

    var body: some View {
        HStack {
            Text(player.name)
                .font(.subheadline)
                .foregroundColor(player.isMale ? .primary : .red)
            Spacer()
            Toggle("", isOn: $player.isPlaying)
                .labelsHidden()
                .disabled(player.switchDisabled)
        }
    }
}
struct GameSettingList: View {
    @ObservedObject var viewModel: MixGameViewModel

    var body: some View {
        ScrollView {
            ForEach(viewModel.courts, id: \.id) { court in
                if court.isOn {
                    GameView(viewModel: viewModel, court: court)
                }
            }
        }
    }
}

struct GameView: View {
    @ObservedObject var viewModel: MixGameViewModel
    @ObservedObject var court: MixGameCourt

    var body: some View {
        HStack {
            if viewModel.isAvailable() || court.isSet {
                VStack {
                    if court.isSet {
                        Button("取消", role: .cancel) {
                            viewModel.resetGame(court: court)
                        }
                        .buttonStyle(.bordered)
                        Button("終了", role: .destructive) {
                            viewModel.endGame(court: court)
                        }
                        .buttonStyle(.bordered)
                    } else {
                        Button("開始", role: .none) {
                            viewModel.setGame(court: court)
                        }
                        .buttonStyle(.bordered)
                    }
                }
                .padding()
                Spacer()
                if court.isSet {
                    VStack {
                        ForEach(court.game!.players, id: \.id) { player in
                            Text(player.name)
                                .font(.subheadline)
                                .foregroundColor(player.isMale ? .primary : .red)
                        }
                    }
                }
                Spacer()
            } else {
                Text("プレイヤーが足りません")
            }
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
    }
}
