//
//  EditDataViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/10.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

final class EditDataViewController: BaseViewController {
    
    private var viewModel = EditDataViewModel()
    
    @IBOutlet private weak var nameTextField: UITextField!
    @IBOutlet private weak var genderSegment: UISegmentedControl!
    @IBOutlet private weak var gameCounts: UILabel!
    @IBOutlet private weak var gameCountStepper: UIStepper!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var cancelButton: UIButton!
    
    var playerID: Int?
    
    override func bind() {
        disposeBag.insert(
            nameTextField.rx.text <-> viewModel.playerName,
            genderSegment.rx.value <-> viewModel.playerGender,
            viewModel.gameCountsForLabel.bind(to: gameCounts.rx.text),
            gameCountStepper.rx.value <-> viewModel.gameCountsForStepper
        )
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.loadData.onNext(self.playerID)
            self.doneButton.layer.cornerRadius = self.doneButton.frame.size.height / 8
            self.cancelButton.layer.cornerRadius = self.cancelButton.frame.size.height / 8
        }).disposed(by: disposeBag)
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.doneAction.onNext(())
        }).disposed(by: disposeBag)
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        viewModel.playerGender.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.genderSegment.selectedSegmentTintColor = value != 0 ? .appRed : .appBlue
        }).disposed(by: disposeBag)
        viewModel.dataSaved.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .updateDataNotificationByEditData, object: nil)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        viewModel.validationError.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.warningAlertView(withTitle: "プレイヤ名を変更して下さい")
        }).disposed(by: disposeBag)
    }
}
