//
//  GameTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class GameTableViewController: UITableViewController, DataReturn {
    
    func returnData(curretPlayer: PadelModel, newPlayer: PadelModel) {
        switch changePlayerCourtTag {
        case 11:
            for (index, player) in courtFirstGamePlayers!.enumerated() {
                if curretPlayer.name == player.name {
                    courtFirstGamePlayers![index] = newPlayer
                }
            }
        case 22:
            for (index, player) in courtSecondGamePlayers!.enumerated() {
                if curretPlayer.name == player.name {
                    courtSecondGamePlayers![index] = newPlayer
                }
            }
        default:
            print("エラー選手交代")
        }
        tableView.reloadData()
    }
    
    var gameSetFlag = false
    
    var playModeFlag = true
    
    var courtFirst: Bool = false
    var courtSecond: Bool = false
    var courtFirstName: String = ""
    var courtSecondName: String = ""
    var courtArray: [String] = []
    
    let playerDataRecord = PadelDataRecordBrain()
    var gameDataModelBrain = GameDataModelBrain()
    
    var players: [PadelModel] = []
    
    var courtFirstGamePlayers: [PadelModel]? = nil
    var courtSecondGamePlayers: [PadelModel]? = nil
    var courtFirstReloadFlag: Bool = true
    var courtSecondReloadFlag: Bool = true
    
    var changePlayerCourtTag: Int = 0
    
    var gameDataFlag: Bool = false
    var gameDataArray = [GameModel]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 121/255, blue: 63/255, alpha: 1.0)
        
        if let court = UserDefaults.standard.value(forKey: "court") as? [String] {
            courtFirstName = court[0]
            courtSecondName = court[1]
        } else {
            courtFirstName = "コートA"
            courtSecondName = "コートB"
        }
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
        tableView.register(UINib(nibName: "gameDataTableViewCell", bundle: nil), forCellReuseIdentifier: "GameDataCell")
    }
    @IBAction func backToHomeButtonPressed(_ sender: UIBarButtonItem) {
        
        let alert = UIAlertController(title: "ホーム画面へ戻ります", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.dismiss(animated: true, completion: nil)
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func setGamesButtonPressed(_ sender: UIBarButtonItem) {
        
        if gameSetFlag {
            loadCourtData()
            loadPlayersData()
            
            if courtFirst {
                if courtFirstReloadFlag {
                    if courtSecond && !courtSecondReloadFlag {
                        if let playingPlayers = courtSecondGamePlayers {
                            for player in playingPlayers {
                                players = players.filter { $0.name != player.name }
                            }
                        }
                        courtFirstGamePlayers = gameDataModelBrain.organizeMatch(totalPlayers: players, playMode: playModeFlag)
                        courtFirstReloadFlag = false
                        updateInfoAlert(title: "試合を組みました", message: courtFirstName)
                    } else if courtSecond && courtSecondReloadFlag {
                        courtFirstGamePlayers = gameDataModelBrain.organizeMatch(totalPlayers: players, playMode: playModeFlag)
                        courtFirstReloadFlag = false
                        if let playingPlayers = courtFirstGamePlayers {
                            for player in playingPlayers {
                                players = players.filter { $0.name != player.name }
                            }
                        }
                        courtSecondGamePlayers = gameDataModelBrain.organizeMatch(totalPlayers: players, playMode: playModeFlag)
                        courtSecondReloadFlag = false
                        updateInfoAlert(title: "試合を組みました", message: "\(courtFirstName)&\(courtSecondName)")
                    } else if !courtSecond {
                        courtFirstGamePlayers = gameDataModelBrain.organizeMatch(totalPlayers: players, playMode: playModeFlag)
                        courtFirstReloadFlag = false
                        updateInfoAlert(title: "試合を組みました", message: courtFirstName)
                    }
                } else if courtSecond && courtSecondReloadFlag {
                    if let playingPlayers = courtFirstGamePlayers {
                        for player in playingPlayers {
                            players = players.filter { $0.name != player.name }
                        }
                    }
                    courtSecondGamePlayers = gameDataModelBrain.organizeMatch(totalPlayers: players, playMode: playModeFlag)
                    courtSecondReloadFlag = false
                    updateInfoAlert(title: "試合を組みました", message: courtSecondName)
                } else {
                    print("何もしない")
                    updateInfoAlert(title: "コートが空いてません", message: "")
                }
            } else {
                if courtSecondReloadFlag {
                    courtSecondGamePlayers = gameDataModelBrain.organizeMatch(totalPlayers: players, playMode: playModeFlag)
                    courtSecondReloadFlag = false
                    updateInfoAlert(title: "試合を組みました", message: courtSecondName)
                } else {
                    print("何もしない")
                    updateInfoAlert(title: "コートが空いていません", message: "")
                }
            }
            tableView.reloadData()
        } else {
            updateInfoAlert(title: "試合設定が変更中です", message: "")
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        if gameDataFlag {
            return 2
        } else {
            return 1
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let label = UILabel()
        label.backgroundColor = UIColor(red: 255/255, green: 63/255, blue: 101/255, alpha: 0.8)
        label.textColor = .white
        label.textAlignment = .center
        
        switch section {
        case 0:
            label.text = "現在の試合"
        default:
            label.text = "試合結果"
        }
        
        return label
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return courtArray.count
        default:
            return gameDataArray.count
        }
        
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! TableViewCell
            
            cell.playerChangeButton.addTarget(self, action: #selector(GameTableViewController.moveToChangePlayerView), for: .touchUpInside)
            cell.gameFinishButton.addTarget(self, action: #selector(GameTableViewController.gameEnd), for: .touchUpInside)
            
            var courtTag: Int = 0
            
            cell.courtLabel.text = courtArray[indexPath.row]
            
            
            if courtArray[indexPath.row] == courtFirstName {
                courtTag = 11
                cell.player1Label.text = courtFirstGamePlayers![0].name
                if !courtFirstGamePlayers![0].gender {
                    cell.player1Label.textColor = UIColor(named: "sepcialRed")
                } else {
                    cell.player1Label.textColor = .black
                }
                cell.player2Label.text = courtFirstGamePlayers![1].name
                if !courtFirstGamePlayers![1].gender {
                    cell.player2Label.textColor = UIColor(named: "sepcialRed")
                } else {
                    cell.player2Label.textColor = .black
                }
                cell.pairOfPlayer1Label.text = courtFirstGamePlayers![2].name
                if !courtFirstGamePlayers![2].gender {
                    cell.pairOfPlayer1Label.textColor = UIColor(named: "sepcialRed")
                } else {
                    cell.pairOfPlayer1Label.textColor = .black
                }
                cell.pairOfPlayer2Label.text = courtFirstGamePlayers![3].name
                if !courtFirstGamePlayers![3].gender {
                    cell.pairOfPlayer2Label.textColor = UIColor(named: "sepcialRed")
                } else {
                    cell.pairOfPlayer2Label.textColor = .black
                }
                cell.backgroundColor = UIColor(displayP3Red: 255/255, green: 121/255, blue: 63/255, alpha: 0.8)
            }
            
            if courtArray[indexPath.row] == courtSecondName {
                courtTag = 22
                cell.player1Label.text = courtSecondGamePlayers![0].name
                if !courtSecondGamePlayers![0].gender {
                    cell.player1Label.textColor = UIColor(named: "sepcialRed")
                } else {
                    cell.player1Label.textColor = .black
                }
                cell.player2Label.text = courtSecondGamePlayers![1].name
                if !courtSecondGamePlayers![1].gender {
                    cell.player2Label.textColor = UIColor(named: "sepcialRed")
                } else {
                    cell.player2Label.textColor = .black
                }
                cell.pairOfPlayer1Label.text = courtSecondGamePlayers![2].name
                if !courtSecondGamePlayers![2].gender {
                    cell.pairOfPlayer1Label.textColor = UIColor(named: "sepcialRed")
                } else {
                    cell.pairOfPlayer1Label.textColor = .black
                }
                cell.pairOfPlayer2Label.text = courtSecondGamePlayers![3].name
                if !courtSecondGamePlayers![3].gender {
                    cell.pairOfPlayer2Label.textColor = UIColor(named: "sepcialRed")
                } else {
                    cell.pairOfPlayer2Label.textColor = .black
                }
                cell.backgroundColor = UIColor(displayP3Red: 63/255, green: 197/255, blue: 255/255, alpha: 0.8)
            }
            
            cell.gameFinishButton.tag = courtTag
            cell.playerChangeButton.tag = courtTag
            
            cell.selectionStyle = .none
            
            return cell
            
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "GameDataCell", for: indexPath) as! gameDataTableViewCell
            
            let gameDataPlayers = gameDataArray[indexPath.row]
            
            cell.gameTitle.text = "第\(indexPath.row + 1)試合"
            
            cell.rFPlayerLabel.text = gameDataPlayers.rightForeside.name
            if !gameDataPlayers.rightForeside.gender {
                cell.rFPlayerLabel.textColor = UIColor(named: "sepcialRed")
            } else {
                cell.rFPlayerLabel.textColor = .black
            }
            cell.rBPlayerLabel.text = gameDataPlayers.rightBackside.name
            if !gameDataPlayers.rightBackside.gender {
                cell.rBPlayerLabel.textColor = UIColor(named: "sepcialRed")
            } else {
                cell.rBPlayerLabel.textColor = .black
            }
            cell.lFPlayerLabel.text = gameDataPlayers.leftForeside.name
            if !gameDataPlayers.leftForeside.gender {
                  cell.lFPlayerLabel.textColor = UIColor(named: "sepcialRed")
              } else {
                  cell.lFPlayerLabel.textColor = .black
              }
            cell.lBPlayerLabel.text = gameDataPlayers.leftBackside.name
            if !gameDataPlayers.leftBackside.gender {
                  cell.lBPlayerLabel.textColor = UIColor(named: "sepcialRed")
              } else {
                  cell.lBPlayerLabel.textColor = .black
              }
            
            if let flag = gameDataPlayers.winFlag {
                if flag {
                    cell.rightPlayersImage.image = UIImage(systemName: "flag")
                    cell.leftPlayersImage.image = nil
                } else {
                    cell.rightPlayersImage.image = nil
                    cell.leftPlayersImage.image = UIImage(systemName: "flag")
                }
            } else {
                cell.rightPlayersImage.image = nil
                cell.leftPlayersImage.image = nil
            }
            
            cell.selectionStyle = .none
            
            return cell
        }
        
    }
    
    @objc func moveToChangePlayerView(_ sender: UIButton) {
        changePlayerCourtTag = sender.tag
        
        var message: String = ""
        switch sender.tag {
        case 11:
            message = courtFirstName
        case 22:
            message = courtSecondName
        default:
            message = ""
        }
        
        let alert = UIAlertController(title: message, message: "選択してください", preferredStyle: .actionSheet)
        
        let action1 = UIAlertAction(title: "もう一度組み合わせ", style: .destructive) { (action) in
            switch self.changePlayerCourtTag {
            case 11:
                let playersBeforeChanged = self.courtFirstGamePlayers
                
                self.courtFirstGamePlayers = nil
                
                self.loadPlayersData()
                
                if let playingPlayers = self.courtSecondGamePlayers {
                    for player in playingPlayers {
                        self.players = self.players.filter { $0.name != player.name }
                    }
                }
                
                let newPlayers = self.gameDataModelBrain.organizeMatch(totalPlayers: self.players, playMode: self.playModeFlag)
                
                let array = playersBeforeChanged!.filter { !newPlayers.contains($0)}
                
                if array != [] {
                    self.courtFirstGamePlayers = newPlayers
                } else {
                    self.courtFirstGamePlayers = self.gameDataModelBrain.organizeMatchWithoutCounts(totalPlayers: self.players)
                }
                
            case 22:
                let playersBeforeChanged = self.courtSecondGamePlayers
                
                self.courtSecondGamePlayers = nil
                
                self.loadPlayersData()
                
                if let playingPlayers = self.courtFirstGamePlayers {
                    for player in playingPlayers {
                        self.players = self.players.filter { $0.name != player.name }
                    }
                }
                
                let newPlayers = self.gameDataModelBrain.organizeMatch(totalPlayers: self.players, playMode: self.playModeFlag)
                
                let array = playersBeforeChanged!.filter { !newPlayers.contains($0)}
                
                if array != [] {
                    self.courtSecondGamePlayers = newPlayers
                } else {
                    self.courtSecondGamePlayers = self.gameDataModelBrain.organizeMatchWithoutCounts(totalPlayers: self.players)
                }
            
            default:
                return
            }
            
            self.tableView.reloadData()
        }
        
        let action2 = UIAlertAction(title: "プレイヤー交代", style: .default) { (action) in
            self.performSegue(withIdentifier: "ChangePlayer", sender: self)
        }
        
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel)
               
        alert.addAction(action1)
        alert.addAction(action2)
        alert.addAction(actionCancel)
               
        present(alert, animated: true, completion: nil)
    }
    
    @objc func gameEnd(_ sender: UIButton) {
        
        var message: String = ""
        switch sender.tag {
        case 11:
            message = courtFirstName
        case 22:
            message = courtSecondName
        default:
            message = ""
        }
        
        let alert = UIAlertController(title: "試合を終了します", message: message, preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            switch sender.tag {
            case 11:
                if let playersData = self.playerDataRecord.loadPlayers() {
                    let newPlayersData = self.gameDataModelBrain.recordGameDataOnPlayersData(currentPlayers: self.courtFirstGamePlayers!, playingPlayers: self.players, totalPlayers: playersData)
                    self.playerDataRecord.savePlayers(players: newPlayersData)
                    if self.gameDataFlag {
                        let alert = UIAlertController(title: "試合結果を記録します", message: "勝者を選択", preferredStyle: .alert)
                        let team1 = "\(self.courtFirstGamePlayers![0].name)&\(self.courtFirstGamePlayers![2].name)"
                        let team2 = "\(self.courtFirstGamePlayers![1].name)&\(self.courtFirstGamePlayers![3].name)"
                        
                        let action1 = UIAlertAction(title: team1, style: .default) { (action) in
                            self.gameDataModelBrain.recordMatch(playingPlayer: self.courtFirstGamePlayers!, winFlag: true)
                            self.courtFirstReloadFlag = true
                            self.courtFirstGamePlayers = nil
                            self.courtArray = self.courtArray.filter { $0 != self.courtFirstName }
                            
                            if let gameData = PadelDataRecordBrain().loadGameData() {
                                self.gameDataArray = gameData
                            }
                            
                            self.tableView.reloadData()
                        }
                        
                        let action2 = UIAlertAction(title: team2, style: .default) { (action) in
                            self.gameDataModelBrain.recordMatch(playingPlayer: self.courtFirstGamePlayers!, winFlag: false)
                            self.courtFirstReloadFlag = true
                            self.courtFirstGamePlayers = nil
                            self.courtArray = self.courtArray.filter { $0 != self.courtFirstName }
                            
                            if let gameData = PadelDataRecordBrain().loadGameData() {
                                self.gameDataArray = gameData
                            }
                            
                            self.tableView.reloadData()
                        }
                        
                        let action3 = UIAlertAction(title: "引き分け", style: .default) { (action) in
                            self.gameDataModelBrain.recordMatch(playingPlayer: self.courtFirstGamePlayers!)
                            self.courtFirstReloadFlag = true
                            self.courtFirstGamePlayers = nil
                            self.courtArray = self.courtArray.filter { $0 != self.courtFirstName }
                            
                            if let gameData = PadelDataRecordBrain().loadGameData() {
                                self.gameDataArray = gameData
                            }
                            
                            self.tableView.reloadData()
                        }
                        alert.addAction(action1)
                        alert.addAction(action2)
                        alert.addAction(action3)
                        
                        self.present(alert, animated: true, completion: nil)
                    } else {
                         self.gameDataModelBrain.recordMatch(playingPlayer: self.courtFirstGamePlayers!)
                        self.courtFirstReloadFlag = true
                        self.courtFirstGamePlayers = nil
                        self.courtArray = self.courtArray.filter { $0 != self.courtFirstName }
                        
                        self.tableView.reloadData()
                    }
                }
                
            case 22:
                if let playersData = self.playerDataRecord.loadPlayers() {
                    let newPlayersData = self.gameDataModelBrain.recordGameDataOnPlayersData(currentPlayers: self.courtSecondGamePlayers!, playingPlayers: self.players, totalPlayers: playersData)
                    self.playerDataRecord.savePlayers(players: newPlayersData)
                    
                    if self.gameDataFlag {
                        let alert = UIAlertController(title: "試合結果を記録します", message: "勝者を選択", preferredStyle: .alert)
                        let team1 = "\(self.courtSecondGamePlayers![0].name)&\(self.courtSecondGamePlayers![2].name)"
                        let team2 = "\(self.courtSecondGamePlayers![1].name)&\(self.courtSecondGamePlayers![3].name)"
                        
                        let action1 = UIAlertAction(title: team1, style: .default) { (action) in
                            self.gameDataModelBrain.recordMatch(playingPlayer: self.courtSecondGamePlayers!, winFlag: true)
                            self.courtSecondReloadFlag = true
                            self.courtSecondGamePlayers = nil
                            self.courtArray = self.courtArray.filter { $0 != self.courtSecondName }
                            
                            if let gameData = PadelDataRecordBrain().loadGameData() {
                                self.gameDataArray = gameData
                            }
                            self.tableView.reloadData()
                        }
                        
                        let action2 = UIAlertAction(title: team2, style: .default) { (action) in
                            self.gameDataModelBrain.recordMatch(playingPlayer: self.courtSecondGamePlayers!, winFlag: false)
                            self.courtSecondReloadFlag = true
                            self.courtSecondGamePlayers = nil
                            self.courtArray = self.courtArray.filter { $0 != self.courtSecondName }
                            
                            if let gameData = PadelDataRecordBrain().loadGameData() {
                                self.gameDataArray = gameData
                            }
                            self.tableView.reloadData()
                        }
                        
                        let action3 = UIAlertAction(title: "引き分け", style: .default) { (action) in
                            self.gameDataModelBrain.recordMatch(playingPlayer: self.courtSecondGamePlayers!)
                            self.courtSecondReloadFlag = true
                            self.courtSecondGamePlayers = nil
                            self.courtArray = self.courtArray.filter { $0 != self.courtSecondName }
                            
                            if let gameData = PadelDataRecordBrain().loadGameData() {
                                self.gameDataArray = gameData
                            }
                            self.tableView.reloadData()
                        }
                        
                        alert.addAction(action1)
                        alert.addAction(action2)
                        alert.addAction(action3)
                        
                        self.present(alert, animated: true, completion: nil)
                    } else {
                        self.gameDataModelBrain.recordMatch(playingPlayer: self.courtSecondGamePlayers!)
                        self.courtSecondReloadFlag = true
                        self.courtSecondGamePlayers = nil
                        self.courtArray = self.courtArray.filter { $0 != self.courtSecondName }
                        
                        self.tableView.reloadData()
                    }
                }
                
            default:
                self.courtFirstReloadFlag = true
                self.courtSecondReloadFlag = true
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
    }
    
    
    func loadCourtData() {
        courtArray = []
        
        if courtFirst {
            courtArray.append(courtFirstName)
        }
        if courtSecond {
            courtArray.append(courtSecondName)
        }
    }
    
    func loadPlayersData() {
        if let playersData = playerDataRecord.loadPlayers() {
            players = playersData.filter { $0.playingFlag }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ChangePlayer" {
            let destinationVC = segue.destination as! PlayerReplaseViewController
            loadPlayersData()
            destinationVC.delegate = self
            
            switch changePlayerCourtTag {
            case 11:
                if let playingPlayerCourtFirst = courtFirstGamePlayers {
                    let waitingPlayer = gameDataModelBrain.getWaitingPlayers(playingPlayers: playingPlayerCourtFirst, playingPlayersInAnotherCourt: courtSecondGamePlayers, totalPlayers: players)
                    
                    destinationVC.playingPlayer = playingPlayerCourtFirst
                    destinationVC.waitingPlayer = waitingPlayer
                }
                
            case 22:
                if let playingPlayerCourtSecond = courtSecondGamePlayers {
                    let waitingPlayer = gameDataModelBrain.getWaitingPlayers(playingPlayers: playingPlayerCourtSecond, playingPlayersInAnotherCourt: courtFirstGamePlayers, totalPlayers: players)
                    
                    destinationVC.playingPlayer = playingPlayerCourtSecond
                    destinationVC.waitingPlayer = waitingPlayer
                }
            default:
                destinationVC.playingPlayer = []
                destinationVC.waitingPlayer = []
            }
        }
    }
    
    func updateInfoAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}
