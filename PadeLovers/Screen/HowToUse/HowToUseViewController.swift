//
//  HowToUseViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2021/11/30.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

final class HowToUseViewController: BaseViewController {
    
    @IBOutlet private weak var detailButton: UIButton!
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.navigationBar.isHidden = false
            
            self.navigationItem.leftBarButtonItem = self.createBarButtonItem(image: UIImage.named("chevron.backward.circle"), select: #selector(self.back))
        }).disposed(by: disposeBag)
        detailButton.rx.tap.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "HowToUseDetail", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HowToUseDetail")
            self.navigationController?.pushViewController(vc, animated: true)
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }).disposed(by: disposeBag)
    }
    
    @objc
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
