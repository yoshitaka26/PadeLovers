//
//  DefaultGameTabView.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/08.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI

struct DefaultGameTabView: View {
    @Binding var path: [HomeView.Screen]
    @State private var selection: Int = 0
    @State private var showAlert = false
    var groupID: String?
    var padelID: UUID?

    var body: some View {
        TabView(selection: $selection) {
            GameViewSettingRepresentable(groupID: groupID, padelID: padelID)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("試合組合せ")
                }
                .tag(0)
            GameDataRepresentable()
                .tabItem {
                    Image(systemName: "person.crop.rectangle.stack")
                    Text("試合設定")
                }
                .tag(1)
            GameResultRepresentable()
                .tabItem {
                    Image(systemName: "doc.text.magnifyingglass")
                    Text("試合結果")
                }
                .tag(2)
        }
        .accentColor(.appSpecialRed)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                switch selection {
                case 0, 1:
                    Button(action: {
                        path.append(.uses)
                    }, label: {
                        Image(systemName: "questionmark.circle")
                            .foregroundStyle(Color.appNavBarButtonColor)
                    })
                default:
                    Spacer()
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                switch selection {
                case 2:
                    Button(action: {
                        showAlert = true
                    }, label: {
                        Image(systemName: "house.fill")
                            .foregroundStyle(Color.appNavBarButtonColor)

                    })
                default:
                    Spacer()
                }
            }
        }
        .alert("試合終了", isPresented: $showAlert, actions: {
            Button("終了する", role: .destructive) {
                path.removeAll()
            }
        }, message: {
            Text("ホーム画面に戻ります。データは一時保存されます。終了してよろしいですか？")
        })
    }
}

#Preview {
    RandomNumberTableView()
}

struct GameViewSettingRepresentable: UIViewControllerRepresentable {
    var groupID: String?
    var padelID: UUID?

    func makeUIViewController(context: Context) -> UIViewController {
        return GameViewSettingViewController.make(groupID: groupID, padelId: padelID?.uuidString)
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

struct GameDataRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIStoryboard(name: "GameData", bundle: nil).instantiateInitialViewController() as! GameDataTableViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}

struct GameResultRepresentable: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIStoryboard(name: "GameResult", bundle: nil).instantiateInitialViewController() as! GameResultViewController
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) { }
}
