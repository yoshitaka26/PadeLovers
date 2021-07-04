//
//  PadelDataTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/07/03.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PadelDataTableViewController: BaseTableViewController {
    private let coreDataManager = CoreDataManager.shared
    private var padelData: [Padel] = []
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.padelData.append(contentsOf: self.coreDataManager.loadAllPadelOld())
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.navigationBar.tintColor = .darkGray
            self.navigationItem.leftBarButtonItem = self.createBarButtonItem(image: UIImage.named("arrowshape.turn.up.backward"), select: #selector(self.back))
            self.navigationItem.rightBarButtonItem = self.editButtonItem
            self.tableView.tableFooterView = UIView()
        }).disposed(by: disposeBag)
    }
    @objc
    func back() {
        self.navigationController?.popViewController(animated: true)
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard let padelID = padelData[indexPath.row].padelID else { return }
        guard coreDataManager.deletePadel(uuidString: padelID.uuidString) else {
            infoAlertViewWithTitle(title: "試合データの削除に失敗しました")
            return
        }
        padelData.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        infoAlertViewWithTitle(title: "試合データを削除しました")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "試合データの管理"
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return padelData.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PadelDataCell", for: indexPath)
        let firstLabel = cell.contentView.viewWithTag(1) as! UILabel
        let secondLabel = cell.contentView.viewWithTag(2) as! UILabel
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .long
        guard let date = padelData[indexPath.row].date else { return cell }
        let dateString = dateFormatter.string(from: date)
        firstLabel.text = dateString
        secondLabel.text = "試合数\(padelData[indexPath.row].gameCounts)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        guard indexPath.section != 0 else { return nil }
        tableView.cellForRow(at: indexPath)?.isEditing = true
        return nil
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        if tableView.isEditing {
            return .delete
        }
        return .none
    }
}
