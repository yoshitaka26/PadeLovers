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

final class GamePlayerViewController: BaseTableViewController {
    private var viewModel = GamePlayerViewModel()
    @IBOutlet private weak var playModeSwitchA: UISwitch!
    @IBOutlet private weak var playModeSwitchB: UISwitch!
    @IBOutlet private weak var playModeAutoSwitch: UISwitch!
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
    
    var startGameType: TableType?
    var padelID: UUID?
    
    override func bind() {
        
        disposeBag.insert(
            viewModel.playModeA.bind(to: playModeSwitchA.rx.isOn),
            playModeSwitchA.rx.isOn.bind(to: viewModel.playModeA),
            playModeSwitchA.rx.isOn.bind(to: viewModel.playModeAisChanged),
            viewModel.playModeB.bind(to: playModeSwitchB.rx.isOn),
            playModeSwitchB.rx.isOn.bind(to: viewModel.playModeB),
            playModeSwitchB.rx.isOn.bind(to: viewModel.playModeBisChanged),
            viewModel.playModeAuto.bind(to: playModeAutoSwitch.rx.isOn),
            gameResultSwitch.rx.isOn <-> viewModel.gameResult
        )
        disposeBag.insert(
            viewModel.courtAname.bind(to: courtAname.rx.text),
            viewModel.courtBname.bind(to: courtBname.rx.text),
            viewModel.courtCname.bind(to: courtCname.rx.text),
            courtA.rx.isOn <-> viewModel.courtAisON,
            courtA.rx.isOn.bind(to: viewModel.courtAisChanged),
            courtB.rx.isOn <-> viewModel.courtBisON,
            courtB.rx.isOn.bind(to: viewModel.courtBisChanged),
            courtC.rx.isOn <-> viewModel.courtCisON,
            courtC.rx.isOn.bind(to: viewModel.courtCisChanged)
        )
        disposeBag.insert(
            viewModel.pairingA1name.bind(to: pairingA1Label.rx.text),
            viewModel.pairingA2name.bind(to: pairingA2Label.rx.text),
            viewModel.pairingB1name.bind(to: pairingB1Label.rx.text),
            viewModel.pairingB2name.bind(to: pairingB2Label.rx.text),
            viewModel.pairingAisOn.bind(to: pairingAswitch.rx.isOn),
            pairingAswitch.rx.isOn.bind(to: viewModel.pairingAisOn),
            pairingAswitch.rx.isOn.bind(to: viewModel.pairingAisChanged),
            viewModel.pairingBisOn.bind(to: pairingBswitch.rx.isOn),
            pairingBswitch.rx.isOn.bind(to: viewModel.pairingBisOn),
            pairingBswitch.rx.isOn.bind(to: viewModel.pairingBisChanged)
        )
        
        disposeBag.insert(
            viewModel.playingPlayerCountsLabel.bind(to: playerCounts.rx.attributedText),
            viewModel.player1name.bind(to: p1.rx.attributedText),
            p1s.rx.isOn <-> viewModel.player1isOn,
            viewModel.player2name.bind(to: p2.rx.attributedText),
            p2s.rx.isOn <-> viewModel.player2isOn,
            viewModel.player3name.bind(to: p3.rx.attributedText),
            p3s.rx.isOn <-> viewModel.player3isOn,
            viewModel.player4name.bind(to: p4.rx.attributedText),
            p4s.rx.isOn <-> viewModel.player4isOn,
            viewModel.player5name.bind(to: p5.rx.attributedText),
            p5s.rx.isOn <-> viewModel.player5isOn,
            viewModel.player6name.bind(to: p6.rx.attributedText),
            p6s.rx.isOn <-> viewModel.player6isOn,
            viewModel.player7name.bind(to: p7.rx.attributedText),
            p7s.rx.isOn <-> viewModel.player7isOn,
            viewModel.player8name.bind(to: p8.rx.attributedText),
            p8s.rx.isOn <-> viewModel.player8isOn,
            viewModel.player9name.bind(to: p9.rx.attributedText),
            p9s.rx.isOn <-> viewModel.player9isOn,
            viewModel.player10name.bind(to: p10.rx.attributedText),
            p10s.rx.isOn <-> viewModel.player10isOn,
            viewModel.player11name.bind(to: p11.rx.attributedText),
            p11s.rx.isOn <-> viewModel.player11isOn,
            viewModel.player12name.bind(to: p12.rx.attributedText),
            p12s.rx.isOn <-> viewModel.player12isOn,
            viewModel.player13name.bind(to: p13.rx.attributedText),
            p13s.rx.isOn <-> viewModel.player13isOn,
            viewModel.player14name.bind(to: p14.rx.attributedText),
            p14s.rx.isOn <-> viewModel.player14isOn,
            viewModel.player15name.bind(to: p15.rx.attributedText),
            p15s.rx.isOn <-> viewModel.player15isOn,
            viewModel.player16name.bind(to: p16.rx.attributedText),
            p16s.rx.isOn <-> viewModel.player16isOn,
            viewModel.player17name.bind(to: p17.rx.attributedText),
            p17s.rx.isOn <-> viewModel.player17isOn,
            viewModel.player18name.bind(to: p18.rx.attributedText),
            p18s.rx.isOn <-> viewModel.player18isOn,
            viewModel.player19name.bind(to: p19.rx.attributedText),
            p19s.rx.isOn <-> viewModel.player19isOn,
            viewModel.player20name.bind(to: p20.rx.attributedText),
            p20s.rx.isOn <-> viewModel.player20isOn,
            viewModel.player21name.bind(to: p21.rx.attributedText),
            p21s.rx.isOn <-> viewModel.player21isOn
        )
        
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationItem.leftBarButtonItem = self.createBarButtonItem(image: UIImage.named("questionmark.circle"), select: #selector(self.back))
            // NotificationCenterの受信設定
            NotificationCenter.default.addObserver(self, selector: #selector(self.callbackByPairingModal), name: .updateDataNotificationByEditPair, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(self.callbackByEditDataModal), name: .updateDataNotificationByEditData, object: nil)
            guard let type = self.startGameType else { return }
            self.viewModel.dataBind.onNext((type, self.padelID))
        }).disposed(by: disposeBag)
        rxViewWillAppear.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.isNavigationBarHidden = false
            UIApplication.shared.isIdleTimerDisabled = true
        }).disposed(by: disposeBag)
        rxViewWillDisappear.subscribe(onNext: { [weak self] in
            guard self != nil else { return }
            UIApplication.shared.isIdleTimerDisabled = false
        }).disposed(by: disposeBag)
        playModeAutoSwitch.rx.isOn.subscribe(onNext: { [weak self] isOn in
            guard let self = self else { return }
            if isOn {
                self.viewModel.playModeAuto.accept(false)
                let storyboard = UIStoryboard(name: "AutoPlayMode", bundle: nil)
                let vc = storyboard.instantiateViewController(identifier: "AutoPlayMode")
                guard let modalVC = vc as? AutoPlayModeViewController else { return }
                modalVC.delegate = self
                modalVC.modalPresentationStyle = .popover
                if let popover = modalVC.popoverPresentationController {
                    if #available(iOS 15.0, *) {
                        let sheet = popover.adaptiveSheetPresentationController
                        sheet.detents = [.medium()]
                        sheet.prefersScrollingExpandsWhenScrolledToEdge = false
                        sheet.largestUndimmedDetentIdentifier = nil
                        sheet.prefersEdgeAttachedInCompactHeight = true
                        sheet.widthFollowsPreferredContentSizeWhenEdgeAttached = true
                    }
                    if UIDevice.current.userInterfaceIdiom == .pad {
                        popover.sourceView = self.view
                        popover.permittedArrowDirections = []
                        popover.sourceRect = CGRect(x: self.view.center.x, y: self.view.center.y / 2, width: 0, height: 0)
                    }
                }
                self.present(modalVC, animated: true)
            } else {
                self.viewModel.playModeAuto.accept(false)
            }
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
                self.openReplaceWindow(windowNavigation: modalVC, modalSize: CGSize(width: 400, height: 600))
            }
        }).disposed(by: disposeBag)
    }
    @objc
    func back() {
        let storyboard = UIStoryboard(name: "HowToUseDetail", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "HowToUseDetail")
        self.navigationController?.pushViewController(vc, animated: true)
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
    
    @objc
    func callbackByPairingModal() {
        viewModel.pairingUIUpdate.onNext(())
    }
    
    @objc
    func callbackByEditDataModal() {
        viewModel.playerUIUpdate.onNext(())
    }
}

extension GamePlayerViewController: UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed))
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 1.5
        tableView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: tableView)
        let indexPath = tableView.indexPathForRow(at: point)
        guard let index = indexPath else { return }
        if index.section == 4 {
            viewModel.longPressedPlayer.accept(index.row)
        }
    }
}

extension GamePlayerViewController: AutoPlayModeViewDelegate {
    func autoPlayModeSelected(setTime: Int) {
        if setTime != 0 {
            self.viewModel.playModeAuto.accept(true)
            self.viewModel.playModeAutoisSet.onNext(setTime)
        } else {
            self.viewModel.playModeAuto.accept(false)
        }
    }
}
