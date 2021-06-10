//
//  InfoAlertView.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/10.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

class InfoAlertView: UIAlertController {
    var afterDismiss: (() -> Void)?
    
    func timerStart() {
        Timer.scheduledTimer(timeInterval: TimeInterval(integerLiteral: infoDialogTime), target: self, selector: #selector(performDismiss), userInfo: nil, repeats: false)
    }
    
    @objc func performDismiss(timer: Timer) {
        dismiss(animated: true, completion: afterDismiss)
    }
}
