//
//  MainSettingViewRepresentable.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2024/01/08.
//  Copyright © 2024 Yoshitaka. All rights reserved.
//

import SwiftUI
import StoreKit

struct MainSettingView: View {
    var body: some View {
        VStack {
            SettingView()
        }
    }
}

struct SettingView: View {
    var body: some View {
        List {
            Section(header: Text("お問い合わせ")) {
                HStack {
                    Text("アプリレビュー")
                    Spacer()
                    Button(action: {
                        guard let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene else { return }
                        // 最後にリクエストした日から1ヶ月たっていればレビューをリクエスト
                        if UserDefaultsUtil.shared.isReviewRequested {
                            if UserDefaultsUtil.shared.reviewRequestedDate.addingTimeInterval(60 * 60 * 24 * 30) < Date() {
                                SKStoreReviewController.requestReview(in: scene)
                                UserDefaultsUtil.shared.reviewRequestedDate = Date()
                            } else {
                                let appId = "1538873089"
                                    guard let writeReviewURL = URL(string: "https://apps.apple.com/app/id\(appId)?action=write-review")
                                    else { return }

                                    if UIApplication.shared.canOpenURL(writeReviewURL) {
                                        UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                                    }
                            }
                        } else {
                            SKStoreReviewController.requestReview(in: scene)
                            UserDefaultsUtil.shared.isReviewRequested = true
                            UserDefaultsUtil.shared.reviewRequestedDate = Date()
                        }
                    }, label: {
                        Text("協力する")
                    })
                    .buttonStyle(ButtonTertiaryStyle())
                }
                HStack {
                    Text("機能追加")
                    Spacer()
                    Button(action: {
                        guard let writeReviewURL = URL(string: "https://forms.gle/AGtCksQemqAjWCA9A")
                        else { return }

                        if UIApplication.shared.canOpenURL(writeReviewURL) {
                            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
                        }
                    }, label: {
                        Text("要望する")
                    })
                    .buttonStyle(ButtonTertiaryStyle())
                }
            }

            Section(header: Text("アプリ情報")) {
                HStack {
                    Text("App Version")
                    Spacer()
                    Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")
                }
                HStack {
                    Text("Licenses")
                    Spacer()
                    Text("2020 PadeLovers.")
                }
            }
        }
        .font(.subheadline)
        .listStyle(.grouped)
        .navigationBarTitle("設定")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MainSettingView()
}
