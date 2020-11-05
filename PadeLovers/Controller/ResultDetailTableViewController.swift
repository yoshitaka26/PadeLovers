//
//  ResultDetailTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/30.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class ResultDetailTableViewController: UITableViewController {
    let playerDataRecord = PadelDataRecordBrain()
    
    var playerArrayNumber: Int?
    var players = [PadelModel]()
    var player: PadelModel? = nil
    var pairedArray = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let player = player else { return }
        pairedArray = player.pairedPlayer
        pairedArray.append(contentsOf: player.pairedPlayer2)
    }
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        if let player = player {
            label.text = "\(player.name)の組んだプレイヤー"
        }
        label.textAlignment = .center
        return label
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return pairedArray.count
        
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PairedPlayerCell", for: indexPath)
        
        cell.textLabel?.text = pairedArray[indexPath.row]
        cell.textLabel?.textAlignment = .center
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}
