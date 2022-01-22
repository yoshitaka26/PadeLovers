//
//  StartGameTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/24.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol StartGameTableViewControllerDelegate: AnyObject {
    func callBackFromStartGameModalVC(type: TableType, padelID: UUID?)
}

final class StartGameTableViewController: BaseTableViewController {
    weak var delegate: StartGameTableViewControllerDelegate?
    
    private let coreDataManager = CoreDataManager.shared
    private var groups: [String] = []
    private var padelData: [Padel] = []
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            
            if let groupName1 = UserDefaults.standard.value(forKey: "group1") as? String {
                self.groups.append(groupName1)
            }
            if let groupName2 = UserDefaults.standard.value(forKey: "group2") as? String {
                self.groups.append(groupName2)
            }
            if let groupName3 = UserDefaults.standard.value(forKey: "group3") as? String {
                self.groups.append(groupName3)
            }
            self.padelData.append(contentsOf: self.coreDataManager.loadAllPadelNew())
            self.tableView.tableFooterView = UIView()
        }).disposed(by: disposeBag)
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "新しく試合を始める" : "過去の試合を再開する"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? groups.count : padelData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        let firstLabel = cell.contentView.viewWithTag(1) as! UILabel
        let secondLabel = cell.contentView.viewWithTag(2) as! UILabel
        switch indexPath.section {
        case 0:
            firstLabel.text = "グループ名"
            secondLabel.text = groups[indexPath.row]
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateStyle = .long
            guard let date = padelData[indexPath.row].date else { return cell }
            let dateString = dateFormatter.string(from: date)
            firstLabel.text = dateString
            secondLabel.text = "試合数\(padelData[indexPath.row].gameCounts)"
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var type: TableType = .court
        var padelID: UUID?
        if indexPath.section == 0 {
            switch indexPath.row {
            case 0:
                type = .group1
            case 1:
                type = .group2
            default:
                type = .group3
            }
        } else {
            padelID = padelData[indexPath.row].padelID
        }
        delegate?.callBackFromStartGameModalVC(type: type, padelID: padelID)
        self.dismiss(animated: true, completion: nil)
    }
}
