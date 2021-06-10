//
//  ViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit
import Gifu

class MenuViewController: BaseViewController {
    
    @IBOutlet weak var mainImage: UIImageView!
    @IBOutlet weak var settingButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    private var viewModel: MenuViewModel = MenuViewModel()
    override func bind() {
        _ = settingButton.rx.tap.bind(to: viewModel.settingButtonSelect)
        _ = playButton.rx.tap.bind(to: viewModel.gameButtonSelect)
        _ = restartButton.rx.tap.bind(to: viewModel.restartButtonSelect)
        rxViewDidLoad.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            let imageView = GIFImageView(frame: CGRect(x: 0, y: 0, width: 300, height: 300))
            imageView.animate(withGIFNamed: "welcome")
            self.mainImage.addSubview(imageView)
            self.settingButton.layer.cornerRadius = self.settingButton.frame.size.height / 4
            self.playButton.layer.cornerRadius = self.playButton.frame.size.height / 4
            self.restartButton.layer.cornerRadius = self.restartButton.frame.size.height / 4
            UITabBar.appearance().tintColor = UIColor(red: 255 / 255, green: 63 / 255, blue: 101 / 255, alpha: 1.0)
            UITabBar.appearance().unselectedItemTintColor = UIColor(red: 255 / 255, green: 121 / 255, blue: 63 / 255, alpha: 1.0)
            self.navigationController?.setNavigationBarHidden(true, animated: true)
        }).disposed(by: disposeBag)
        
        viewModel.transition.subscribe(onNext: { [weak self] transition in
            guard let self = self else { return }
            switch transition {
            case .setting:
                let storyboard = UIStoryboard(name: "Setting", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "Setting")
                self.navigationController?.pushViewController(vc, animated: true)
            case .gameStart:
                self.confirmationAlertView(withTitle: TITLE_PLYA_GAME, message: MESSAGE_PLAY_GAME, cancelString: DIALOG_CANCEL, confirmString: DIALOG_OK) {
                    let storyboard = UIStoryboard(name: "Game", bundle: nil)
                    let next = storyboard.instantiateViewController(identifier: "Game")
                    guard let tabBarCon = next as? UITabBarController else { return }
                    guard let navBarCon = tabBarCon.viewControllers?[0] as? UINavigationController else { return }
                    guard let destinationVC = navBarCon.topViewController as? GamePlayerViewController else { return }
                    self.navigationController?.pushViewController(tabBarCon, animated: true)
                }
            case .gameRestart:
                let dataBrain = PadelDataRecordBrain()
                if let data = dataBrain.loadPlayers() {
                    if data != [] {
                        self.confirmationAlertView(withTitle: TITLE_RESTART_GAME, message: MESSAGE_RESTART_GAME, cancelString: DIALOG_CANCEL, confirmString: DIALOG_OK) {
                            let storyboard = UIStoryboard(name: "Game", bundle: nil)
                            let vc = storyboard.instantiateViewController(identifier: "Game")
                            self.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else {
                        self.warningAlertView(withTitle: ALERT_MESSAGE_RESTART)
                    }
                }
            case .none:
                break
            }
        }).disposed(by: disposeBag)
    }
}
