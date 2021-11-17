//
//  ViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class MenuViewController: BaseViewController {
    
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var randomNumberButton: UIButton!
    @IBOutlet weak var padelDataButton: UIButton!
    private var viewModel = MenuViewModel()
    override func bind() {
        disposeBag.insert(
            settingButton.rx.tap.bind(to: viewModel.settingButtonSelect),
            playButton.rx.tap.bind(to: viewModel.gameButtonSelect),
            randomNumberButton.rx.tap.bind(to: viewModel.randomNumbersButtonSelect),
            padelDataButton.rx.tap.bind(to: viewModel.padelDataButtonSelect)
        )
        rxViewDidLoad.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.settingButton.layer.cornerRadius = self.settingButton.frame.size.height / 4
            self.playButton.layer.cornerRadius = self.playButton.frame.size.height / 4
            UITabBar.appearance().tintColor = .appRed
            UITabBar.appearance().unselectedItemTintColor = .darkGray
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }).disposed(by: disposeBag)
        rxViewWillAppear.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.navigationController?.navigationBar.isHidden = true
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
            case .none:
                break
            }
        }).disposed(by: disposeBag)
    }
}

extension MenuViewController: StartGameTableViewControllerDelegate {
    func callBackFromStartGameModalVC(type: TableType, padelID: UUID?) {
        let storyboard = UIStoryboard(name: "Game", bundle: nil)
        let next = storyboard.instantiateViewController(identifier: "Game")
        guard let tabBarCon = next as? UITabBarController else { return }
        guard let navBarCon = tabBarCon.viewControllers?[0] as? UINavigationController else { return }
        guard let destinationVC = navBarCon.topViewController as? GamePlayerViewController else { return }
        destinationVC.startGameType = type
        destinationVC.padelID = padelID
        self.navigationController?.pushViewController(tabBarCon, animated: true)
    }
}
