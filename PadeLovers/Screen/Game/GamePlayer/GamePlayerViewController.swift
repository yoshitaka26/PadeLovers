//
//  InfoTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/28.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

// NotificationCenter通知名を登録
extension Notification.Name {
    static let updateDataNotificationByEditPair = Notification.Name("updateByEditPair")
    static let updateDataNotificationByEditData = Notification.Name("updateByEditData")
}

class GamePlayerViewController: BaseTableViewController {
    private var viewModel = GamePlayerViewModel()
    @IBOutlet private weak var playModeSwitchA: UISwitch!
    @IBOutlet private weak var playModeSwitchB: UISwitch!
    @IBOutlet private weak var gameResultSwitch: UISwitch!
    @IBOutlet private weak var courtAname: UILabel!
    @IBOutlet private weak var courtBname: UILabel!
    @IBOutlet private weak var courtCname: UILabel!
    @IBOutlet private weak var courtA: UISwitch!
    @IBOutlet private weak var courtB: UISwitch!
    @IBOutlet private weak var courtC: UISwitch!
    @IBOutlet private weak var pairingA1Label: UILabel!
    @IBOutlet private weak var pairingA2Label: UILabel!
    @IBOutlet private weak var pairingAswitch: UISwitch!
    @IBOutlet private weak var pairingB1Label: UILabel!
    @IBOutlet private weak var pairingB2Label: UILabel!
    @IBOutlet private weak var pairingBswitch: UISwitch!
    
    @IBOutlet private weak var playerCounts: UILabel!
    @IBOutlet private weak var p1: UILabel!
    @IBOutlet private weak var p1s: UISwitch!
    @IBOutlet private weak var p2: UILabel!
    @IBOutlet private weak var p2s: UISwitch!
    @IBOutlet private weak var p3: UILabel!
    @IBOutlet private weak var p3s: UISwitch!
    @IBOutlet private weak var p4: UILabel!
    @IBOutlet private weak var p4s: UISwitch!
    @IBOutlet private weak var p5: UILabel!
    @IBOutlet private weak var p5s: UISwitch!
    @IBOutlet private weak var p6: UILabel!
    @IBOutlet private weak var p6s: UISwitch!
    @IBOutlet private weak var p7: UILabel!
    @IBOutlet private weak var p7s: UISwitch!
    @IBOutlet private weak var p8: UILabel!
    @IBOutlet private weak var p8s: UISwitch!
    @IBOutlet private weak var p9: UILabel!
    @IBOutlet private weak var p9s: UISwitch!
    @IBOutlet private weak var p10: UILabel!
    @IBOutlet private weak var p10s: UISwitch!
    @IBOutlet private weak var p11: UILabel!
    @IBOutlet private weak var p11s: UISwitch!
    @IBOutlet private weak var p12: UILabel!
    @IBOutlet private weak var p12s: UISwitch!
    @IBOutlet private weak var p13: UILabel!
    @IBOutlet private weak var p13s: UISwitch!
    @IBOutlet private weak var p14: UILabel!
    @IBOutlet private weak var p14s: UISwitch!
    @IBOutlet private weak var p15: UILabel!
    @IBOutlet private weak var p15s: UISwitch!
    @IBOutlet private weak var p16: UILabel!
    @IBOutlet private weak var p16s: UISwitch!
    @IBOutlet private weak var p17: UILabel!
    @IBOutlet private weak var p17s: UISwitch!
    @IBOutlet private weak var p18: UILabel!
    @IBOutlet private weak var p18s: UISwitch!
    @IBOutlet private weak var p19: UILabel!
    @IBOutlet private weak var p19s: UISwitch!
    @IBOutlet private weak var p20: UILabel!
    @IBOutlet private weak var p20s: UISwitch!
    @IBOutlet private weak var p21: UILabel!
    @IBOutlet private weak var p21s: UISwitch!
    
    override func bind() {
        _ = viewModel.playModeA.bind(to: playModeSwitchA.rx.isOn)
        _ = playModeSwitchA.rx.isOn.bind(to: viewModel.playModeA)
        _ = playModeSwitchA.rx.isOn.bind(to: viewModel.playModeAisChanged)
        _ = viewModel.playModeB.bind(to: playModeSwitchB.rx.isOn)
        _ = playModeSwitchB.rx.isOn.bind(to: viewModel.playModeB)
        _ = playModeSwitchB.rx.isOn.bind(to: viewModel.playModeBisChanged)
        
        _ = gameResultSwitch.rx.isOn <-> viewModel.gameResult
        
        _ = viewModel.courtAname.bind(to: courtAname.rx.text)
        _ = viewModel.courtBname.bind(to: courtBname.rx.text)
        _ = viewModel.courtCname.bind(to: courtCname.rx.text)
        _ = courtA.rx.isOn <-> viewModel.courtAisON
        _ = courtA.rx.isOn.bind(to: viewModel.courtAisChanged)
        _ = courtB.rx.isOn <-> viewModel.courtBisON
        _ = courtB.rx.isOn.bind(to: viewModel.courtBisChanged)
        _ = courtC.rx.isOn <-> viewModel.courtCisON
        _ = courtC.rx.isOn.bind(to: viewModel.courtCisChanged)
        
        _ = viewModel.pairingA1name.bind(to: pairingA1Label.rx.text)
        _ = viewModel.pairingA2name.bind(to: pairingA2Label.rx.text)
        _ = viewModel.pairingB1name.bind(to: pairingB1Label.rx.text)
        _ = viewModel.pairingB2name.bind(to: pairingB2Label.rx.text)
        _ = viewModel.pairingAisOn.bind(to: pairingAswitch.rx.isOn)
        _ = pairingAswitch.rx.isOn.bind(to: viewModel.pairingAisOn)
        _ = pairingAswitch.rx.isOn.bind(to: viewModel.pairingAisChanged)
        _ = viewModel.pairingBisOn.bind(to: pairingBswitch.rx.isOn)
        _ = pairingBswitch.rx.isOn.bind(to: viewModel.pairingBisOn)
        _ = pairingBswitch.rx.isOn.bind(to: viewModel.pairingBisChanged)
        
        _ = viewModel.playingPlayerCountsLabel.bind(to: playerCounts.rx.attributedText)

        _ = viewModel.player1name.bind(to: p1.rx.attributedText)
        _ = p1s.rx.isOn <-> viewModel.player1isOn
        _ = viewModel.player2name.bind(to: p2.rx.attributedText)
        _ = p2s.rx.isOn <-> viewModel.player2isOn
        _ = viewModel.player3name.bind(to: p3.rx.attributedText)
        _ = p3s.rx.isOn <-> viewModel.player3isOn
        _ = viewModel.player4name.bind(to: p4.rx.attributedText)
        _ = p4s.rx.isOn <-> viewModel.player4isOn
        _ = viewModel.player5name.bind(to: p5.rx.attributedText)
        _ = p5s.rx.isOn <-> viewModel.player5isOn
        _ = viewModel.player6name.bind(to: p6.rx.attributedText)
        _ = p6s.rx.isOn <-> viewModel.player6isOn
        _ = viewModel.player7name.bind(to: p7.rx.attributedText)
        _ = p7s.rx.isOn <-> viewModel.player7isOn
        _ = viewModel.player8name.bind(to: p8.rx.attributedText)
        _ = p8s.rx.isOn <-> viewModel.player8isOn
        _ = viewModel.player9name.bind(to: p9.rx.attributedText)
        _ = p9s.rx.isOn <-> viewModel.player9isOn
        _ = viewModel.player10name.bind(to: p10.rx.attributedText)
        _ = p10s.rx.isOn <-> viewModel.player10isOn
        _ = viewModel.player11name.bind(to: p11.rx.attributedText)
        _ = p11s.rx.isOn <-> viewModel.player11isOn
        _ = viewModel.player12name.bind(to: p12.rx.attributedText)
        _ = p12s.rx.isOn <-> viewModel.player12isOn
        _ = viewModel.player13name.bind(to: p13.rx.attributedText)
        _ = p13s.rx.isOn <-> viewModel.player13isOn
        _ = viewModel.player14name.bind(to: p14.rx.attributedText)
        _ = p14s.rx.isOn <-> viewModel.player14isOn
        _ = viewModel.player15name.bind(to: p15.rx.attributedText)
        _ = p15s.rx.isOn <-> viewModel.player15isOn
        _ = viewModel.player16name.bind(to: p16.rx.attributedText)
        _ = p16s.rx.isOn <-> viewModel.player16isOn
        _ = viewModel.player17name.bind(to: p17.rx.attributedText)
        _ = p17s.rx.isOn <-> viewModel.player17isOn
        _ = viewModel.player18name.bind(to: p18.rx.attributedText)
        _ = p18s.rx.isOn <-> viewModel.player18isOn
        _ = viewModel.player19name.bind(to: p19.rx.attributedText)
        _ = p19s.rx.isOn <-> viewModel.player19isOn
        _ = viewModel.player20name.bind(to: p20.rx.attributedText)
        _ = p20s.rx.isOn <-> viewModel.player20isOn
        _ = viewModel.player21name.bind(to: p21.rx.attributedText)
        _ = p21s.rx.isOn <-> viewModel.player21isOn
        
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.navigationBar.barTintColor = .navigationBarColor
            // NotificationCenterの受信設定
            NotificationCenter.default.addObserver(self, selector: #selector(self.callbackByPairingModal), name: .updateDataNotificationByEditPair, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.callbackByEditDataModal), name: .updateDataNotificationByEditData, object: nil)
        }).disposed(by: disposeBag)
        rxViewWillAppear.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.isNavigationBarHidden = false
        }).disposed(by: disposeBag)
        viewModel.pairingAWindowShow.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "FixedPair", bundle: nil)
            let modalVC = storyboard.instantiateViewController(identifier: "FixedPair")
            if let pairingVC = modalVC as? FixedPairViewController {
                pairingVC.pairing = .pairingA
                self.present(modalVC, animated: true)
            }
        }).disposed(by: disposeBag)
        viewModel.pairingBWindowShow.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "FixedPair", bundle: nil)
            let modalVC = storyboard.instantiateViewController(identifier: "FixedPair")
            if let pairingVC = modalVC as? FixedPairViewController {
                pairingVC.pairing = .pairingB
                self.present(modalVC, animated: true)
            }
        }).disposed(by: disposeBag)
        viewModel.showMessage.subscribe(onNext: { [weak self] message in
            guard let self = self else { return }
            self.infoAlertViewWithTitle(title: message)
        }).disposed(by: disposeBag)
        viewModel.pushToEditDataModalView.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "EditData", bundle: nil)
            let modalVC = storyboard.instantiateViewController(identifier: "EditData")
            if let editDataVC = modalVC as? EditDataViewController {
                editDataVC.playerID = value
                self.openReplaceWindow(windowNavigation: modalVC)
            }
            
        }).disposed(by: disposeBag)
    }
    @objc func callbackByPairingModal() {
        viewModel.pairingUIUpdate.onNext(())
    }
    @objc func callbackByEditDataModal() {
        viewModel.playerUIUpdate.onNext(())
    }
}
//
extension GamePlayerViewController: UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed))
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 3.0
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    @objc func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        guard let index = indexPath else { return }
        if index.section == 4 {
            viewModel.longPressedPlayer.accept(index.row)
        }
    }
}
