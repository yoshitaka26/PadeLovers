//
//  HomeView.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/03.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    @State private var path: [Screen] = []

    enum Screen: Hashable {
        case gameSetting, gameRecord, gameStart, randomNumber, uses, mainSetting
        case gameStartDefault(groupID: String? = nil, padelID: UUID? = nil)
        case gameStartMix(groupID: String)
    }

    var body: some View {
        NavigationStack(path: $path) {
            GeometryReader { geometry in
                VStack {
                    Spacer()
                    HStack(spacing: 20) {
                        NavigationLink(value: Screen.gameSetting) {
                            MenuButtonImage(
                                image: "btn_game_setting",
                                size: geometry.size.width / 3
                            )
                        }
                        NavigationLink(value: Screen.gameRecord) {
                            MenuButtonImage(
                                image: "btn_game_record",
                                size: geometry.size.width / 3
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                    HStack(spacing: 20) {
                        NavigationLink(value: Screen.gameStart) {
                            MenuButtonImage(
                                image: "btn_game_start",
                                size: geometry.size.width / 3
                            )
                        }
                        NavigationLink(value: Screen.randomNumber) {
                            MenuButtonImage(
                                image: "btn_randomNumber_table",
                                size: geometry.size.width / 3
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                    HStack(spacing: 20) {
                        NavigationLink(value: Screen.uses) {
                            MenuButtonImage(
                                image: "btn_uses",
                                size: geometry.size.width / 3
                            )
                        }
                        NavigationLink(value: Screen.mainSetting) {
                            MenuButtonImage(
                                image: "btn_mainSetting",
                                size: geometry.size.width / 3
                            )
                        }
                    }
                    .frame(maxWidth: .infinity)
                    Spacer()
                }
                .padding(20)
                .navigationDestination(for: Screen.self) { screen in
                    switch screen {
                    case .gameSetting:
                        CommonDataView()
                    case .gameRecord:
                        PadelDataView()
                    case .gameStart:
                        StartGameView(path: $path)
                    case let .gameStartDefault(groupID, padelID):
                        DefaultGameTabView(path: $path, groupID: groupID, padelID: padelID)
                    case .gameStartMix(let groupID):
                        MixGameTabView(viewModel: MixGameViewModel(groupID: groupID))
                    case .randomNumber:
                        RandomNumberTableView()
                    case .uses:
                        HowToUseView()
                    case .mainSetting:
                        MainSettingView()
                    }
                }
            }
        }
        .tint(Color.appNavBarButtonColor)
    }

    private struct MenuButtonImage: View {
        var image: String
        var size: CGFloat

        var body: some View {
            Image(image)
                .resizable()
                .frame(width: size, height: size)
                .background(Color.white)
                .cornerRadius(16)
                .padding(20)
        }
    }
}

#Preview {
    HomeView()
}
