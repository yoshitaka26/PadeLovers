//
//  StartGameTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/24.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

protocol StartGameTableViewControllerDelegate: AnyObject {
    func callBackFromStartGameModalVC(groupID: String?, padelID: UUID?)
}

final class StartGameTableViewController: UITableViewController {
    weak var delegate: StartGameTableViewControllerDelegate?

    private let coreDataManager = CoreDataManager.shared
    private var masterPlayerGroup: [MasterPlayerGroup] = []
    private var gameData: [Padel] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        masterPlayerGroup = coreDataManager.loadMasterPlayerGroup()
        gameData = coreDataManager.loadAllPadelNew()
        self.tableView.tableFooterView = UIView()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "新しく試合を始める" : "過去の試合を再開する"
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? masterPlayerGroup.count : gameData.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DataCell", for: indexPath)
        let firstLabel = cell.contentView.viewWithTag(1) as! UILabel
        let secondLabel = cell.contentView.viewWithTag(2) as! UILabel
        switch indexPath.section {
        case 0:
            firstLabel.text = "グループ名"
            secondLabel.text = masterPlayerGroup[indexPath.row].name
        default:
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .gregorian)
            dateFormatter.locale = Locale(identifier: "ja_JP")
            dateFormatter.dateStyle = .long
            guard let date = gameData[indexPath.row].date else { return cell }
            let dateString = dateFormatter.string(from: date)
            firstLabel.text = dateString
            secondLabel.text = "試合数\(gameData[indexPath.row].gameCounts)"
        }
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let groupID = masterPlayerGroup[indexPath.row].id
            delegate?.callBackFromStartGameModalVC(groupID: groupID?.uuidString, padelID: nil)
        } else {
            let padelID = gameData[indexPath.row].padelID
            delegate?.callBackFromStartGameModalVC(groupID: nil, padelID: padelID)
        }
    }
}
