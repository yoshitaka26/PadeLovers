//
//  HomeView.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/03.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()
                HStack(spacing: 20) {
                    MenuButton(
                        image: "btn_game_setting",
                        size: geometry.size.width/3) {}
                    MenuButton(
                        image: "btn_game_record",
                        size: geometry.size.width/3) {}
                }
                .frame(maxWidth: .infinity)
                Spacer()
                HStack(spacing: 20) {
                    MenuButton(
                        image: "btn_game_start",
                        size: geometry.size.width/3) {}
                    MenuButton(
                        image: "btn_randomNumber_table",
                        size: geometry.size.width/3) {}
                }
                .frame(maxWidth: .infinity)
                Spacer()
                HStack(spacing: 20) {
                    MenuButton(
                        image: "btn_uses",
                        size: geometry.size.width/3) {}
                    MenuButton(
                        image: "btn_mainSetting",
                        size: geometry.size.width/3) {}
                }
                .frame(maxWidth: .infinity)
                Spacer()
            }
            .padding(20)
        }
    }

    private struct MenuButton: View {
        var image: String
        var size: CGFloat = 100
        var action: () -> Void

        var body: some View {
            Button(action: {
                action()
            }, label: {
                Image(image)
                    .resizable()
                    .frame(width: size, height: size)
                    .foregroundColor(.black)
            })
            .padding(20)
        }
    }
}

#Preview {
    HomeView()
}
