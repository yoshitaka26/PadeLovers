//
//  InfoTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/28.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

extension Notification.Name {
    static let updateDataNotification = Notification.Name("updateDataNotification")
}

class InfoTableViewController: UITableViewController {
    @IBOutlet weak var playModeSwitchA: UISwitch!
    @IBOutlet weak var playModeSwitchB: UISwitch!
    
    @IBOutlet weak var gameResultSwitch: UISwitch!
    
    @IBAction func playModeSwitchAChanged(_ sender: UISwitch) {
        if playModeSwitchA.isOn {
            playModeSwitchB.isOn = false
        } else {
            playModeSwitchB.isOn = true
        }
    }
    
    @IBAction func playModeSwitchBChanged(_ sender: UISwitch) {
        if playModeSwitchB.isOn {
            playModeSwitchA.isOn = false
        } else {
            playModeSwitchA.isOn = true
        }
    }
    
    @IBOutlet weak var c1: UILabel!
    @IBOutlet weak var c1s: UISwitch!
    @IBOutlet weak var c2: UILabel!
    @IBOutlet weak var c2s: UISwitch!
    
    @IBAction func c1sA(_ sender: UISwitch) {
        if !c1s.isOn {
            if !c2s.isOn {
                c2s.isOn = true
            }
        }
        let min = minPlayerCount()
        playerCounts.text = String(min)
    }
    
    @IBAction func c2sA(_ sender: UISwitch) {
        if !c2s.isOn {
            if !c1s.isOn {
                c1s.isOn = true
            }
        }
        let min = minPlayerCount()
        playerCounts.text = String(min)
    }
    
    @IBOutlet weak var pp1A: UILabel!
    @IBOutlet weak var pp1B: UILabel!
    @IBOutlet weak var pp1: UISwitch!
    @IBOutlet weak var pp2A: UILabel!
    @IBOutlet weak var pp2B: UILabel!
    @IBOutlet weak var pp2: UISwitch!
    
    @IBOutlet weak var playerCounts: UILabel!
    
    @IBOutlet weak var p1: UILabel!
    @IBOutlet weak var p1s: UISwitch!
    @IBOutlet weak var p2: UILabel!
    @IBOutlet weak var p2s: UISwitch!
    @IBOutlet weak var p3: UILabel!
    @IBOutlet weak var p3s: UISwitch!
    @IBOutlet weak var p4: UILabel!
    @IBOutlet weak var p4s: UISwitch!
    @IBOutlet weak var p5: UILabel!
    @IBOutlet weak var p5s: UISwitch!
    @IBOutlet weak var p6: UILabel!
    @IBOutlet weak var p6s: UISwitch!
    @IBOutlet weak var p7: UILabel!
    @IBOutlet weak var p7s: UISwitch!
    @IBOutlet weak var p8: UILabel!
    @IBOutlet weak var p8s: UISwitch!
    @IBOutlet weak var p9: UILabel!
    @IBOutlet weak var p9s: UISwitch!
    @IBOutlet weak var p10: UILabel!
    @IBOutlet weak var p10s: UISwitch!
    @IBOutlet weak var p11: UILabel!
    @IBOutlet weak var p11s: UISwitch!
    @IBOutlet weak var p12: UILabel!
    @IBOutlet weak var p12s: UISwitch!
    @IBOutlet weak var p13: UILabel!
    @IBOutlet weak var p13s: UISwitch!
    @IBOutlet weak var p14: UILabel!
    @IBOutlet weak var p14s: UISwitch!
    @IBOutlet weak var p15: UILabel!
    @IBOutlet weak var p15s: UISwitch!
    @IBOutlet weak var p16: UILabel!
    @IBOutlet weak var p16s: UISwitch!
    @IBOutlet weak var p17: UILabel!
    @IBOutlet weak var p17s: UISwitch!
    @IBOutlet weak var p18: UILabel!
    @IBOutlet weak var p18s: UISwitch!
    @IBOutlet weak var p19: UILabel!
    @IBOutlet weak var p19s: UISwitch!
    @IBOutlet weak var p20: UILabel!
    @IBOutlet weak var p20s: UISwitch!
    @IBOutlet weak var p21: UILabel!
    @IBOutlet weak var p21s: UISwitch!
    
    let playerDataRecord = PadelDataRecordBrain()
    
    var pp1AName: String = ""
    var pp1BName: String = ""
    var pp2AName: String = ""
    var pp2BName: String = ""
    
    var players: [PadelModel] = []
    
    var gameStartFlag: Bool = false
    
    var genderArray = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 121/255, blue: 63/255, alpha: 1.0)
        
        if let court = UserDefaults.standard.value(forKey: "court") as? [String] {
            c1.text = court[0]
            c2.text = court[1]
        } else {
            c1.text = "コートA"
            c2.text = "コートB"
        }
        
        pp1A.text = pp1AName
        pp1B.text = pp1BName
        
        let playerNameLabelArray = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21]
        
        if let gender = UserDefaults.standard.value(forKey: "gender") as? [Bool] {
            genderArray = gender
        }
        
        if let player = UserDefaults.standard.value(forKey: "player") as? [String] {
            if player.count == 21 {
                for i in 0...20 {
                    playerNameLabelArray[i]?.text = player[i]
                    if genderArray != [] {
                        if !genderArray[i] {
                            playerNameLabelArray[i]?.textColor = .red
                        }
                    }
                }
            }
        }
        
        if gameStartFlag {
            setTotalPlayerArray()
            savePlayModeBool()
            saveGameResultBool()
            setGameData()
            gameStartFlag = false
        }
        
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(updateUI),
                                               name: .updateDataNotification,
                                               object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let playersData = playerDataRecord.loadPlayers() {
            players = playersData
        }
        
        if players.count == 21 {
            changePlayingFlagByData(playersData: players)
            changePairingLabel(playersData: players)
        }
        
        let min = minPlayerCount()
        playerCounts.text = String(min)
        setCourtFlag()
        setPlayModeFlag()
        setGameResultFlag()
        
        tableView.reloadData()
    }
    
    
    @IBAction func switchUnLock(_ sender: UIBarButtonItem) {
        switchLock(lock: false)
        
        let NavigationController = tabBarController?.viewControllers?[1] as! UINavigationController
        let tableViewCon = NavigationController.topViewController as! GameTableViewController
        tableViewCon.gameSetFlag = false
        
        updateInfoAlert(title: "試合設定を変更できます")
    }
    
    @IBAction func decideButtonPressed(_ sender: UIBarButtonItem) {
        var array = makePlayingFlagArray()
        array = array.filter { $0 == true }
        let min = minPlayerCount()
        if array.count >= min {
            projectX()
            savePlayersData()
            checkPairingData()
            saveCourtBool()
            savePlayModeBool()
            saveGameResultBool()
            switchLock(lock: true)
            
            updateInfoAlert(title: "試合設定を更新しました")
            
            let NavigationController = tabBarController?.viewControllers?[1] as! UINavigationController
            let tableViewCon = NavigationController.topViewController as! GameTableViewController
            
            tableViewCon.gameSetFlag = true
            if playModeSwitchA.isOn {
                tableViewCon.playModeFlag = true
            } else {
                tableViewCon.playModeFlag = false
            }
            
            if c1s.isOn {
                tableViewCon.courtFirst = true
            } else {
                tableViewCon.courtFirst = false
            }
            if c2s.isOn {
                tableViewCon.courtSecond = true
            } else {
                tableViewCon.courtSecond = false
            }
            
            if gameResultSwitch.isOn {
                tableViewCon.gameDataFlag = true
            } else {
                tableViewCon.gameDataFlag = false
            }
            
            tabBarController?.selectedViewController = NavigationController
        } else {
            updateInfoAlert(title: "参加プレイヤーが不足しています")
        }
    }
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 5
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 1
        case 2:
            return 2
        case 3:
            return 2
        case 4:
            return 22
            
        default:
            return 0
        }
    }
    
    func setCourtFlag() {
        if let courtBool = UserDefaults.standard.value(forKey: "courtBool") as? [Bool] {
            c1s.isOn = courtBool[0]
            c2s.isOn = courtBool[1]
        }
    }
    
    func setPlayModeFlag() {
        if let playModeBool = UserDefaults.standard.value(forKey: "playModeBool") as? Bool {
            playModeSwitchA.isOn = playModeBool
            playModeSwitchB.isOn = !playModeBool
        }
    }
    
    func setGameResultFlag() {
        if let gameResultBool = UserDefaults.standard.value(forKey: "gameResultBool") as? Bool {
            gameResultSwitch.isOn = gameResultBool
        }
    }
    
    func minPlayerCount() -> Int {
        var count = 4
        
        if c1s.isOn && c2s.isOn {
            count += 4
        }
        if pp1.isOn {
            count += 2
        }
        if pp2.isOn {
            count += 2
        }
        
        return count
    }
    
    func makeNameArray() -> [String] {
        let playerNameLabelArray = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21]
        var names: [String] = []
        for i in 0...20 {
            let name = playerNameLabelArray[i]?.text ?? "X"
            names.append(name)
        }
        return names
    }
    
    func makePlayingFlagArray() -> [Bool] {
        let playingFlagSwitchArray = [p1s, p2s, p3s, p4s, p5s, p6s, p7s, p8s, p9s, p10s, p11s, p12s, p13s, p14s, p15s, p16s, p17s, p18s, p19s, p20s, p21s]
        var playingFlags: [Bool] = []
        for i in 0...20 {
            let flag = playingFlagSwitchArray[i]?.isOn ?? false
            playingFlags.append(flag)
        }
        return playingFlags
    }
    
    func changePlayingFlagByData(playersData: [PadelModel]) {
        let playingFlagSwitchArray = [p1s, p2s, p3s, p4s, p5s, p6s, p7s, p8s, p9s, p10s, p11s, p12s, p13s, p14s, p15s, p16s, p17s, p18s, p19s, p20s, p21s]
        
        for i in 0...20 {
            if playersData[i].playingFlag {
                playingFlagSwitchArray[i]?.isOn = true
            } else {
                playingFlagSwitchArray[i]?.isOn = false
            }
        }
    }
    
    func switchLock(lock: Bool) {
        let playingFlagSwitchArray = [p1s, p2s, p3s, p4s, p5s, p6s, p7s, p8s, p9s, p10s, p11s, p12s, p13s, p14s, p15s, p16s, p17s, p18s, p19s, p20s, p21s]
        
        for i in 0...20 {
            playingFlagSwitchArray[i]?.isEnabled = !lock
        }
        c1s.isEnabled = !lock
        c2s.isEnabled = !lock
        playModeSwitchA.isEnabled = !lock
        playModeSwitchB.isEnabled = !lock
        gameResultSwitch.isEnabled = !lock
    }
    
    func setTotalPlayerArray() {
        let names = self.makeNameArray()
        
        for i in 0...20 {
            if genderArray != [] {
                players.append(PadelModel(name: names[i], gender: genderArray[i]))
            } else {
                players.append(PadelModel(name: names[i]))
            }
            
        }
        playerDataRecord.savePlayers(players: players)
    }
    
    func setGameData() {
        let gameData: [GameModel] = []
        
        playerDataRecord.saveGameData(gameData: gameData)
    }
    
    func savePlayersData() {
        let flags = self.makePlayingFlagArray()
        
        if let playersData = playerDataRecord.loadPlayers() {
            for i in 0...20 {
                playersData[i].playingFlag = flags[i]
            }
            playerDataRecord.savePlayers(players: playersData)
        }
    }
    
    func saveCourtBool() {
        let courtBool = [c1s.isOn, c2s.isOn]
        UserDefaults.standard.set(courtBool, forKey: "courtBool")
    }
    
    func savePlayModeBool() {
        let playModeBool = playModeSwitchA.isOn
        UserDefaults.standard.set(playModeBool, forKey: "playModeBool")
    }
    
    func saveGameResultBool() {
        let gameResultBool = gameResultSwitch.isOn
        UserDefaults.standard.set(gameResultBool, forKey: "gameResultBool")
    }
    
    func changePairingLabel(playersData: [PadelModel]) {
        let pair1 = playersData.filter { $0.pairing1 == true }
        let pair2 = playersData.filter { $0.pairing2 == true }
        
        pp1A.text = ""
        pp1B.text = ""
        pp2A.text = ""
        pp2B.text = ""
        
        if pair1.count == 2 {
            pp1A.text = pair1[0].name
            pp1B.text = pair1[1].name
            if pair1[0].playingFlag && pair1[1].playingFlag {
                pp1.isOn = true
            } else { pp1.isOn = false }
        } else { pp1.isOn = false }
        
        if pair2.count == 2 {
            pp2A.text = pair2[0].name
            pp2B.text = pair2[1].name
            if pair2[0].playingFlag && pair2[1].playingFlag {
                pp2.isOn = true
            } else { pp2.isOn = false }
        } else { pp2.isOn = false }
    }
    
    func checkPairingData() {
        if let playersData = playerDataRecord.loadPlayers() {
            var array = playersData
            
            changePairingLabel(playersData: array)
            
            if !pp1.isOn {
                array = array.map {
                    if $0.pairing1 {
                        $0.pairing1 = false
                    }
                    return $0
                }
            }
            if !pp2.isOn {
                array = array.map {
                    if $0.pairing2 {
                        $0.pairing2 = false
                    }
                    return $0
                }
            }
             playerDataRecord.savePlayers(players: array)
        }
    }
    
    func projectX() {
        let tp = playerDataRecord.loadPlayers()
        var fad = [Bool]()
        var fan = [Bool]()
        var index = [Int]()
        for p in tp! {
            fad.append(p.playingFlag)
        }
        fan = self.makePlayingFlagArray()
        for i in 0...20 {
            if !fad[i] && fan[i] {
                index.append(i)
            }
        }
        
        let array = tp!.filter { $0.playingFlag == true }
        let arrayInt = array.map { $0.playCounts }
        let min = arrayInt.min()
        
        if index != [] {
            for i in index {
                if tp![i].playCounts < min! {
                    tp![i].playCounts = min!
                }
            }
        }
        
        playerDataRecord.savePlayers(players: tp!)
    }
    
    
    func updateInfoAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    @objc func updateUI() {
        switchLock(lock: false)
        
        let NavigationController = tabBarController?.viewControllers?[1] as! UINavigationController
        let tableViewCon = NavigationController.topViewController as! GameTableViewController
        tableViewCon.gameSetFlag = false
    }
}

