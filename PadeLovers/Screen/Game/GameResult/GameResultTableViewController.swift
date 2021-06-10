//
//  ResultTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/30.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class GameResultTableViewController: UITableViewController {

    let playerDataRecord = PadelDataRecordBrain()

    var players = [PadelModel]()
    var playingPlayers = [PadelModel]()
    var restingPlayers = [PadelModel]()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "プレイヤー"

    }

    override func viewWillAppear(_ animated: Bool) {
        if let playersData = playerDataRecord.loadPlayers() {
            players = playersData
        }

        playingPlayers = players.filter { $0.playingFlag }

        restingPlayers = players.filter { !$0.playingFlag }
        restingPlayers = restingPlayers.filter { $0.playCounts > 0 }

        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {

        if restingPlayers != [] {
            return 2
        } else {
            return 1
        }
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        switch section {
        case 0:
            let label = UILabel()
            label.text = "参加プレイヤーの試合回数"
            label.textColor = .white
            label.font = UIFont.systemFont(ofSize: 22)
            label.textAlignment = .center
            label.backgroundColor = UIColor(red: 255/255, green: 121/255, blue: 63/255, alpha: 1.0)
            return label

        case 1:
        let label = UILabel()
        label.text = "離脱プレイヤーの試合回数"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 22)
        label.textAlignment = .center
        label.backgroundColor = UIColor(red: 255/255, green: 121/255, blue: 63/255, alpha: 1.0)

        return label

        default:
            return nil
        }

    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        switch section {
        case 0:
            return playingPlayers.count
        case 1:
            return restingPlayers.count
        default:
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)

        switch indexPath.section {
        case 0:
            let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
            nameLabel.text = playingPlayers[indexPath.row].name
            if !playingPlayers[indexPath.row].gender {
                nameLabel.textColor = .red
            } else {
                nameLabel.textColor = .label
            }

            let countLabel = cell.contentView.viewWithTag(2) as! UILabel
            countLabel.text = "\(String(playingPlayers[indexPath.row].playCounts))試合"
            cell.selectionStyle = .none

            return cell

        case 1:
            let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
            nameLabel.text = restingPlayers[indexPath.row].name
            if !restingPlayers[indexPath.row].gender {
                nameLabel.textColor = .red
            } else {
                nameLabel.textColor = .label
            }

            let countLabel = cell.contentView.viewWithTag(2) as! UILabel
            countLabel.text = "\(String(restingPlayers[indexPath.row].playCounts))試合"
            cell.selectionStyle = .none

            return cell

        default:
            return cell
        }

    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "ResultDetail", bundle: nil)
        let modalVC = storyboard.instantiateViewController(identifier: "ResultDetail")
        if let resultDetailVC = modalVC as? ResultDetailTableViewController {
            resultDetailVC.playerArrayNumber = indexPath.row
            switch indexPath.section {
            case 0:
                resultDetailVC.player = playingPlayers[indexPath.row]
            case 1:
                resultDetailVC.player = restingPlayers[indexPath.row]
            default:
                return
            }
            present(modalVC, animated: true)
        }
    }
}
