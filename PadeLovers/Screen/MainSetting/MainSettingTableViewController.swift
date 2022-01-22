//
//  MainSettingTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2021/11/30.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

final class MainSettingTableViewController: BaseTableViewController {

    @IBOutlet private weak var versionLabel: UILabel!
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.tintColor = .darkGray
            self.navigationItem.leftBarButtonItem = self.createBarButtonItem(image: UIImage.named("chevron.backward.circle"), select: #selector(self.back))
            self.tableView.tableFooterView = UIView()
            
            // アプリバージョン
            if let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String {
                self.versionLabel.text = version
            }
        }).disposed(by: disposeBag)
    }
    @objc
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
