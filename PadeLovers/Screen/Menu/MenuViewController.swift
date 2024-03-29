//
//  ViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit
import FirebaseAnalytics
import SwiftUI

final class MenuViewController: BaseViewController {
    
    @IBOutlet private weak var settingButton: UIButton!
    @IBOutlet private weak var playButton: UIButton!
    @IBOutlet private weak var randomNumberButton: UIButton!
    @IBOutlet private weak var padelDataButton: UIButton!
    @IBOutlet private weak var mainSettingButton: UIButton!
    @IBOutlet private weak var usesButton: UIButton!
    private var viewModel = MenuViewModel()
    
    override func bind() {
        disposeBag.insert(
            settingButton.rx.tap.bind(to: viewModel.settingButtonSelect),
            playButton.rx.tap.bind(to: viewModel.gameButtonSelect),
            randomNumberButton.rx.tap.bind(to: viewModel.randomNumbersButtonSelect),
            padelDataButton.rx.tap.bind(to: viewModel.padelDataButtonSelect),
            mainSettingButton.rx.tap.bind(to: viewModel.mainSettingButtonSelect),
            usesButton.rx.tap.bind(to: viewModel.howToUseButtonSelect)
        )
        rxViewDidLoad.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            UITabBar.appearance().tintColor = .appRed
            UITabBar.appearance().unselectedItemTintColor = .darkGray
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }).disposed(by: disposeBag)
        rxViewWillAppear.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }).disposed(by: disposeBag)
        viewModel.transition.subscribe(onNext: { [weak self] transition in
            guard let self = self else { return }
            switch transition {
            case .setting:
                let storyboard = UIStoryboard(name: "CommonData", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "CommonData")
                self.present(vc, animated: true)
            case .gameStart:
                let storyboard = UIStoryboard(name: "StartGame", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "StartGame")
                guard let modalVC = vc as? StartGameTableViewController else { return }
                modalVC.delegate = self
                self.present(modalVC, animated: true)
            case .generateNumbers:
                let storyboard = UIStoryboard(name: "RandomNumberTable", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "RandomNumber")
                self.navigationController?.pushViewController(vc, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            case .padelData:
                let storyboard = UIStoryboard(name: "PadelData", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "PadelData")
                self.navigationController?.pushViewController(vc, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            case .mainSetting:
                let storyboard = UIStoryboard(name: "MainSetting", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "MainSetting")
                self.navigationController?.pushViewController(vc, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            case .howToUse:
                let storyboard = UIStoryboard(name: "HowToUse", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "HowToUse")
                self.navigationController?.pushViewController(vc, animated: true)
                self.navigationController?.setNavigationBarHidden(false, animated: true)
            case .none:
                break
            }
        }).disposed(by: disposeBag)
    }
}

extension MenuViewController: StartGameTableViewControllerDelegate {
    // swiftlint:disable force_unwrapping
    func callBackFromStartGameModalVC(groupID: String?, padelID: UUID?) {
        self.dismiss(animated: true, completion: nil)
        if let padelID {
            // ゲーム再開
            showDefaultGameView(groupID: groupID, padelID: padelID)
        } else {
            // ゲーム新規ならアクションシートを表示
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            actionSheet.popoverPresentationController?.sourceView = self.view
            let screenSize = UIScreen.main.bounds
            actionSheet.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 4, y: screenSize.size.height / 2, width: 0, height: 0)
            let action1 = UIAlertAction(title: "標準モード", style: .default) { _ in
                self.showDefaultGameView(groupID: groupID, padelID: nil)
            }

//            let action2 = UIAlertAction(title: "簡易モード", style: .default) { _ in
//                let tabBarCon = UIHostingController(rootView: MixGameTabView(viewModel: MixGameViewModel(groupID: groupID!)))
//                self.navigationController?.setNavigationBarHidden(false, animated: true)
//                self.navigationController?.pushViewController(tabBarCon, animated: true)
//            }

            let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)

            actionSheet.addAction(action1)
//            actionSheet.addAction(action2)
            actionSheet.addAction(cancelAction)

            self.present(actionSheet, animated: true, completion: nil)
        }
    }

    private func showDefaultGameView(groupID: String?, padelID: UUID?) {
        let tabBarCon = UITabBarController()
        let gameViewSettingViewController = GameViewSettingViewController.make(groupID: groupID, padelId: padelID?.uuidString)
        let gameData = UIStoryboard(name: "GameData", bundle: nil).instantiateInitialViewController() as! GameDataTableViewController
        let gameResult = UIStoryboard(name: "GameResult", bundle: nil).instantiateInitialViewController() as! GameResultViewController
        tabBarCon.setViewControllers([gameViewSettingViewController, gameData, gameResult], animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.pushViewController(tabBarCon, animated: true)
    }
    // swiftlint:enable force_unwrapping
}
