//
//  RandomNumberTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/25.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class RandomNumberTableViewController: BaseViewController {
    let viewModel = RandomNumberTableViewModel()
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var toolbar: UIToolbar!
    @IBOutlet private weak var backButton: UIBarButtonItem!
    @IBOutlet private weak var nextButton: UIBarButtonItem!
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.navigationBar.isHidden = false
            self.navigationItem.rightBarButtonItem = self.createBarButtonItem(image: UIImage.named("gearshape"), select: #selector(self.setting))
            self.navigationItem.hidesBackButton = true
            self.tableView.register(UINib(nibName: "RandomNumberTableViewCell", bundle: nil), forCellReuseIdentifier: "RandomNumberCell")
            self.tableView.delegate = self
            self.tableView.dataSource = self
        }).disposed(by: disposeBag)
        rxViewWillAppear.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.generateNumbers.onNext(())
            UIApplication.shared.isIdleTimerDisabled = true
        }).disposed(by: disposeBag)
        rxViewWillDisappear.subscribe(onNext: { [weak self] in
            guard self != nil else { return }
            UIApplication.shared.isIdleTimerDisabled = false
        }).disposed(by: disposeBag)
        viewModel.reloadView.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.onMatchNumber.value, section: 0), at: .top, animated: true)
        }).disposed(by: disposeBag)
        backButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.backAndNextButtonPressed.onNext(false)
        }).disposed(by: disposeBag)
        nextButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.backAndNextButtonPressed.onNext(true)
        }).disposed(by: disposeBag)
        viewModel.errorAlert.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.warningAlertView(withTitle: "乱数表生成に失敗しました")
            self.dismiss(animated: true)
        }).disposed(by: disposeBag)
    }
    @objc
    func setting() {
        let storyboard = UIStoryboard(name: "SettingView", bundle: nil)
        let modalVC = storyboard.instantiateViewController(identifier: "SettingView")
        if let settingVC = modalVC as? SettingViewController {
            settingVC.delegate = self
            guard let vc = self.navigationController else { return }
            self.openPopUpController(popUpController: modalVC, sourceView: vc.navigationBar, rect: CGRect(x: 0, y: 0, width: 200, height: 400), arrowDirections: .up, canOverlapSourceViewRect: true)
        }
    }
}

extension RandomNumberTableViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberTables.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RandomNumberCell", for: indexPath) as! RandomNumberTableViewCell
        cell.setUI(match: self.viewModel.numberTables.value[indexPath.row], playersNumber: self.viewModel.playerNumber.value, onMatchNum: self.viewModel.onMatchNumber.value - indexPath.row)
        return cell
    }
}

extension RandomNumberTableViewController: SettingViewControllerDelegate {
    func closedSettingViewController(playerCount: Int) {
        if playerCount == 0 {
            self.navigationController?.popViewController(animated: true)
        } else {
            self.viewModel.onMatchNumber.accept(0)
            self.viewModel.playerNumber.accept(playerCount)
            self.viewModel.generateNumbers.onNext(())
            self.infoAlertViewWithTitle(title: "乱数表を更新しました")
        }
    }
}
