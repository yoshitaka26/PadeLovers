//
//  SelectPair1ViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/28.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

final class FixedPairViewController: BaseViewController {
    
    @IBOutlet private weak var pair1Picker: UIPickerView!
    @IBOutlet private weak var pair2Picker: UIPickerView!
    @IBOutlet private weak var finishButton: UIButton!
    @IBOutlet private weak var resetButton: UIButton!
    
    private var viewModel = FixedPairViewModel()
    
    var pairing: PairingType?
    private var nameData: [String] = []
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.pairingType.accept(self.pairing)
            self.viewModel.loadData.onNext(())

            self.pair1Picker.delegate = self
            self.pair1Picker.dataSource = self
            self.pair2Picker.delegate = self
            self.pair2Picker.dataSource = self
            self.finishButton.layer.cornerRadius = self.finishButton.frame.size.height / 4
            self.resetButton.layer.cornerRadius = self.resetButton.frame.size.height / 4
        }).disposed(by: disposeBag)
        rxViewWillDisappear.subscribe(onNext: { [weak self] in
            guard self != nil else { return }
            NotificationCenter.default.post(name: .updateDataNotificationByEditPair, object: nil)
        }).disposed(by: disposeBag)
        viewModel.picker1SelectedRow.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.pair1Picker.selectRow(value, inComponent: 0, animated: true)
            }
        }).disposed(by: disposeBag)
        viewModel.picker2SelectedRow.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            DispatchQueue.main.async {
                self.pair2Picker.selectRow(value, inComponent: 0, animated: true)
            }
        }).disposed(by: disposeBag)
        finishButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.picker1SelectedRow.accept(self.pair1Picker.selectedRow(inComponent: 0))
            self.viewModel.picker2SelectedRow.accept(self.pair2Picker.selectedRow(inComponent: 0))
            self.viewModel.okAction.onNext(())
        }).disposed(by: disposeBag)
        resetButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.resetAction.onNext(())
        }).disposed(by: disposeBag)
        viewModel.moveWith.subscribe(onNext: { [weak self] type in
            guard let self = self else { return }
            switch type {
            case .setPairing:
                NotificationCenter.default.post(name: .updateDataNotificationByEditPair, object: nil)
                self.warningAlertView(withTitle: TITLE_FIXED_PAIR_COLLECTLY, action: {
                    self.dismiss(animated: true, completion: nil)
                })
            case .samePlayerSelected:
                self.infoAlertViewWithTitle(title: ALERT_MESSAGE_SELECTED_SAME_PLAYER)
            case .resetPairing:
                NotificationCenter.default.post(name: .updateDataNotificationByEditPair, object: nil)
                switch self.pairing {
                case .pairingA:
                    self.warningAlertView(withTitle: TITLE_FIXED_PAIR_1_RESET, action: {
                        self.dismiss(animated: true, completion: nil)
                    })
                case .pairingB:
                    self.warningAlertView(withTitle: TITLE_FIXED_PAIR_2_RESET, action: {
                        self.dismiss(animated: true, completion: nil)
                    })
                case .none:
                    return
                }
            }
        }).disposed(by: disposeBag)
    }
}

extension FixedPairViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.viewModel.pairingPlayers.value.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.viewModel.pairingPlayers.value[row].name
    }
}
