//
//  MixGameTabView.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2023/09/23.
//  Copyright © 2023 Yoshitaka. All rights reserved.
//

import SwiftUI

struct MixGameTabView: View {
    @Binding var path: [HomeView.Screen]
    @StateObject var viewModel: MixGameViewModel
    @State var dismissAlert = false
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        TabView(selection: $viewModel.tab) {
            PlayerSettingList(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "person.crop.rectangle.stack")
                    Text("設定")
                }
                .tint(nil)
                .tag(MixGameViewModel.MixGameTab.setting)
            GameSettingList(viewModel: viewModel)
                .tabItem {
                    Image(systemName: "figure.tennis")
                    Text("試合")
                }
                .tint(nil)
                .tag(MixGameViewModel.MixGameTab.game)
        }
        .tint(.appSpecialRed)
        .navigationBarBackButtonHidden(true)
        .navigationTitle(viewModel.tab.title)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                switch viewModel.tab {
                case .setting:
                    Button(action: {
                        path.append(.uses)
                    }, label: {
                        Image(systemName: "questionmark.circle")
                    })
                default:
                    Spacer()
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                switch viewModel.tab {
                case .game:
                    Button {
                        dismissAlert = true
                    } label: {
                        Image(systemName: "house")
                            .foregroundStyle(Color(UIColor.appNavBarButtonColor))
                    }
                default:
                    Spacer()
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
        .customAlert(for: viewModel.alertObject)
        .customToast(for: viewModel.toastObject)
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
            PlayerDetail(player: player)
                .presentationDetents([.height(180)])
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
                .foregroundColor(player.isMale ? .primary : .appSpecialRed)
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
        .sheet(item: $viewModel.replacePlayerGame) { game in
            ScrollView {
                HStack(spacing: 10) {
                    Button(action: {
                        viewModel.dismissReplacePlayerView()
                    }) {
                        Text("キャンセル")
                            .font(.title3)
                            .frame(minWidth: 100, minHeight: 30)
                    }
                    .buttonStyle(ButtonSecondaryStyle())
                    Button(action: {
                        viewModel.replacePlayers()
                    }) {
                        Text("入れ替え")
                            .font(.title3)
                            .frame(minWidth: 100, minHeight: 30)
                    }
                    .buttonStyle(ButtonPrimaryStyle(
                        disabled: !viewModel.isSelectedTwoPlayersForReplacement)
                    )
                }
                .padding(.vertical, 20)
                HStack(alignment: .top, spacing: 10) {
                    VStack {
                        ForEach(game.players, id: \.id) { playingPlayer in
                            Button(action: {
                                viewModel.selectPlayerFrom(playingPlayer)
                            }) {
                                Text(playingPlayer.name)
                                    .font(.headline)
                                    .frame(minWidth: 100, minHeight: 20)
                            }
                            .buttonStyle(SelectButtonStyle(isSelected: viewModel.isSelectedWithPlayerFrom(playingPlayer)))
                        }
                    }
                    Image(systemName: "arrowshape.right")
                        .resizable()
                        .frame(width: 40, height: 40)
                        .foregroundStyle(Color.appSpecialRed)
                        .padding(.top, 80)
                    VStack {
                        Button(action: {
                            viewModel.selectPlayerToWithRandom()
                        }) {
                            Text("ランダム")
                                .font(.headline)
                                .frame(minWidth: 100, minHeight: 20)
                        }
                        .buttonStyle(SelectButtonStyle(isSelected: viewModel.randomSelection))
                        ForEach(viewModel.replaceablePlayers, id: \.id) { replaceablePlayer in
                            Button(action: {
                                viewModel.selectPlayerTo(replaceablePlayer)
                            }) {
                                Text(replaceablePlayer.name)
                                    .font(.headline)
                                    .frame(minWidth: 100, minHeight: 20)
                            }
                            .buttonStyle(SelectButtonStyle(isSelected: viewModel.isSelectedWithPlayerTo(replaceablePlayer)))
                        }
                    }
                }
                .padding(10)
            }
            .scrollIndicators(.never)
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
                        Button {
                            viewModel.resetGame(court: court)
                        } label: {
                            Text("取消")
                                .font(.headline)
                        }
                        .buttonStyle(ButtonSecondaryStyle())

                        Button {
                            viewModel.endGame(court: court)
                        } label: {
                            Text("終了")
                                .font(.headline)
                        }
                        .buttonStyle(ButtonPrimaryStyle())
                    } else {
                        Button {
                            viewModel.setGame(court: court)
                        } label: {
                            Text("開始")
                                .font(.headline)
                        }
                        .buttonStyle(ButtonTertiaryStyle())
                    }
                }
                .padding()
                if court.isSet, let game = court.game {
                    LazyVGrid(
                        columns: [GridItem(.flexible()), GridItem(.flexible())],
                        spacing: 10
                    ) {
                        ForEach(game.players, id: \.id) { player in
                            Text(player.name)
                                .multilineTextAlignment(.center)
                                .font(.headline)
                                .foregroundStyle(.white)
                                .frame(minWidth: 100, minHeight: 40)
                                .padding(4)
                                .cornerRadius(4)
                                .background(
                                    RoundedRectangle(cornerRadius: 4)
                                        .fill(player.isMale ?  Color.appSpecialBlue : Color.appSpecialRed)
                                        .stroke(Color.appNavBarButtonColor, lineWidth: 1)
                                )
                        }
                        .padding(6)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(10)
                    .onTapGesture {
                        guard let game = court.game else { return }
                        viewModel.showReplacePlayerView(game)
                    }
                }
            } else {
                Text("プレイヤーが足りません")
            }
        }
        .frame(height: 180)
        .frame(maxWidth: .infinity)
    }
}
