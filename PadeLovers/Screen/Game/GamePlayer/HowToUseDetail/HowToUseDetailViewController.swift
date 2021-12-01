//
//  HowToUseDetailViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2021/12/01.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

class HowToUseDetailViewController: BaseViewController {
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.navigationBar.isHidden = false
            
            self.navigationItem.leftBarButtonItem = self.createBarButtonItem(image: UIImage.named("chevron.backward.circle"), select: #selector(self.back))
        }).disposed(by: disposeBag)
    }
    
    @objc
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
