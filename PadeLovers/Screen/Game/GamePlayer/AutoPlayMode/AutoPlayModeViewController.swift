//
//  AutoPlayModeViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/02/02.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol AutoPlayModeModaViewDelegate: AnyObject {
    func autoPlayModeSelected(setTime: Int)
}

class AutoPlayModeViewController: BaseViewController {

    weak var delegate: AutoPlayModeModaViewDelegate?
    
    @IBOutlet private weak var resetButton: UIButton!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var countTimePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        resetButton.layer.cornerRadius = 5.0
        doneButton.layer.cornerRadius = 5.0
    }
    
    override func bind() {
        doneButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
            self.delegate?.autoPlayModeSelected(setTime: Int(self.countTimePicker.countDownDuration / 60))
        }).disposed(by: disposeBag)
        resetButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.dismiss(animated: true)
            self.delegate?.autoPlayModeSelected(setTime: 0)
        }).disposed(by: disposeBag)
    }
}
