//
//  SettingViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/26.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol SettingViewControllerDelegate: AnyObject {
    func closedSettingViewController(playerCount: Int)
}

class SettingViewController: BaseViewController {
    weak var delegate: SettingViewControllerDelegate?
    
    @IBOutlet weak var playerNumberPicker: UIPickerView!
    
    @IBOutlet weak var setButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }

            self.playerNumberPicker.delegate = self
            self.playerNumberPicker.dataSource = self
            self.setButton.layer.cornerRadius = self.setButton.frame.size.height / 3
            self.backButton.layer.cornerRadius = self.setButton.frame.size.height / 3
        }).disposed(by: disposeBag)
        
        setButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.delegate?.closedSettingViewController(playerCount: self.playerNumberPicker.selectedRow(inComponent: 0) + 4)
            self.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        backButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true, completion: nil)
            self.delegate?.closedSettingViewController(playerCount: 0)
        }).disposed(by: disposeBag)
    }
}

extension SettingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 5
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 4) + "人の乱数表"
    }
}
