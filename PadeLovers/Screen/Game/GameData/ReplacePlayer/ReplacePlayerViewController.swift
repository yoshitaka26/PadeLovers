//
//  PlayerReplaseViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/30.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

protocol ReplacePlayerViewControllerDelegate: AnyObject {
    func returnFromReplacePlayerViewController()
}

class ReplacePlayerViewController: BaseViewController {
    weak var delegate: ReplacePlayerViewControllerDelegate?
    var courtID: Int = 0
    
    private var viewModel = ReplacePlayerViewModel()

    @IBOutlet weak var currentPlayerPicker: UIPickerView!
    @IBOutlet weak var waitingPlayerPicker: UIPickerView!
    @IBOutlet weak var finishButton: UIButton!
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.currentPlayerPicker.tag = 0
            self.currentPlayerPicker.delegate = self
            self.currentPlayerPicker.dataSource = self
            self.waitingPlayerPicker.tag = 1
            self.waitingPlayerPicker.delegate = self
            self.waitingPlayerPicker.dataSource = self
            self.finishButton.layer.cornerRadius = self.finishButton.frame.size.height / 4
            self.viewModel.loadData.onNext((self.courtID))
        }).disposed(by: disposeBag)
        finishButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.picker1SelectedRow.accept(self.currentPlayerPicker.selectedRow(inComponent: 0))
            self.viewModel.picker2SelectedRow.accept(self.waitingPlayerPicker.selectedRow(inComponent: 0))
            self.viewModel.okAction.onNext(())
        }).disposed(by: disposeBag)
        viewModel.pushWith.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .samePlayersSelected:
                self.infoAlertViewWithTitle(title: "同じプレイヤーを選択してます")
            case .replacedPlayerFromWaiting:
                self.warningAlertView(withTitle: "プレイヤーをチェンジしました", action: {
                    self.delegate?.returnFromReplacePlayerViewController()
                    self.dismiss(animated: true, completion: nil)
                })
            case .replacedPlayerOnSameGame:
                self.warningAlertView(withTitle: "同じ試合内で\nポジション変更しました", action: {
                    self.delegate?.returnFromReplacePlayerViewController()
                    self.dismiss(animated: true, completion: nil)
                })
            case .replacePlayerFromAnotherGame:
                let row2 = self.viewModel.picker2SelectedRow.value
                let playersForeReplace = self.viewModel.playersForReplace.value
                guard let player2 = playersForeReplace[row2].name else { return }
                self.confirmationAlertView(withTitle: "\(player2)は試合中です", message: "他の試合と入れ替えますか？", cancelString: "キャンセル", confirmString: "OK") {
                    self.viewModel.replacePlayerFromAnotherGame.onNext(())
                    self.delegate?.returnFromReplacePlayerViewController()
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }).disposed(by: disposeBag)
    }
}

extension ReplacePlayerViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        guard let source = self.viewModel.playersForPickerView.value else { return 0 }
        guard let players = source[pickerView.tag] else { return 0 }
        return players.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        guard let source = self.viewModel.playersForPickerView.value else { return "" }
        guard let players = source[pickerView.tag] else { return "" }
        return players[row].name
    }
}
