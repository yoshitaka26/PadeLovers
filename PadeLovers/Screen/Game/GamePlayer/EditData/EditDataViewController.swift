//
//  EditDataViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/10.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

class EditDataViewController: BaseViewController {
    
    private var viewModel = EditDataViewModel()
    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    @IBOutlet weak var gameCounts: UILabel!
    @IBOutlet weak var gameCountStepper: UIStepper!
    @IBOutlet weak var doneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var playerID: Int? = nil
    
    override func bind() {
        _ = nameTextField.rx.text <-> viewModel.playerName
        _ = genderSegment.rx.value <-> viewModel.playerGender
        _ = viewModel.gameCountsForLabel.bind(to: gameCounts.rx.text)
        _ = gameCountStepper.rx.value <-> viewModel.gameCountsForStepper
        viewModel.loadData.onNext(playerID)
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.doneAction.onNext(())
        }).disposed(by: disposeBag)
        cancelButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        viewModel.dataSaved.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            NotificationCenter.default.post(name: .updateDataNotificationByEditData, object: nil)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
    }
}
