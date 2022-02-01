//
//  AutoPlayModeModalView.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/02/02.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit

protocol AutoPlayModeModaViewDelegate: AnyObject {
    func autoPlayModeSelected(setTime: Int)
}

class AutoPlayModeModalView: UIViewController {

    weak var delegate: AutoPlayModeModaViewDelegate?
    var leftMin: Int?
    
    var timePicker = UIDatePicker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.4, *) {
            timePicker.preferredDatePickerStyle = .wheels
        }
        timePicker.datePickerMode = .countDownTimer
        timePicker.frame = CGRect(x:0, y:50, width: 300, height:200)
        if let min = leftMin {
            timePicker.minuteInterval = min
        }
        self.view.addSubview(timePicker)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.autoPlayModeSelected(setTime: timePicker.minuteInterval)
    }
}
