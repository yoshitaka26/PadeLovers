//
//  InfoTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/28.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

//NotificationCenter通知名を登録
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
    
    @IBAction func pairCreateSwitch1(_ sender: Any) {
        if pp1.isOn {
            pp1.isOn = false
            performSegue(withIdentifier: "ToSelectPair1", sender: self)
        }
    }
    
    @IBAction func pairCreateSwitch2(_ sender: Any) {
        if pp2.isOn {
            pp2.isOn = false
            performSegue(withIdentifier: "ToSelectPair2", sender: self)
        }
    }
    
    @IBAction func reCalButton(_ sender: UIButton) {
        let counts = countPlayPlayers()
        playerCountsBySwitch.text = String(counts)
    }
    
    
    @IBOutlet weak var pp1A: UILabel!
    @IBOutlet weak var pp1B: UILabel!
    @IBOutlet weak var pp1: UISwitch!
    @IBOutlet weak var pp2A: UILabel!
    @IBOutlet weak var pp2B: UILabel!
    @IBOutlet weak var pp2: UISwitch!
    
    @IBOutlet weak var playerCounts: UILabel!
    @IBOutlet weak var playerCountsBySwitch: UILabel!
    
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
    
    //新しく試合を始めたどうか
    var gameStartFlag: Bool = false
    
    var genderArray = [Bool]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.tintColor = UIColor(red: 255/255, green: 121/255, blue: 63/255, alpha: 1.0)
        
        //UserDefaltsからコート名とプレイヤー名をUIへ反映させる
        if let court = UserDefaults.standard.value(forKey: "court") as? [String] {
            c1.text = court[0]
            c2.text = court[1]
        } else {
            c1.text = "コートA"
            c2.text = "コートB"
        }
        
        //pp1A.text = pp1AName
        //pp1B.text = pp1BName
        
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
        
        //新しく試合を始めた場合はtrueで入ってくる->データをセットしてfalseへ
        if gameStartFlag {
            setTotalPlayerArray()
            savePlayModeBool()
            saveGameResultBool()
            setGameData()
            gameStartFlag = false
        }
        
        //NotificationCenterの受信設定
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
        playerCountsBySwitch.text = String(countPlayPlayers())
        
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
            projectX()      //新しく参加/復帰するプレイヤーのプレイ回数を修正して上書き保存
            savePlayersData()   //プレイ有無アレイからモデルデータを修正、再度FileManagerへ上書き保村
            checkPairingSwitch() //ペアリングスイッチがOFFならモデルのペアリングを削除して上書き保存
            checkPairingData()   //モデルからUIを修正、もしUIのペアリング状況がOFFならペアリングを削除して上書き保存
            saveCourtBool()     //UIよりコート数を取得、UserDefaultsへ書き込み
            savePlayModeBool()      //UIよりプレイモードを取得、UserDefaultsへ書き込み
            saveGameResultBool()        //UIよりゲーム記録モードを取得、UserDefaultsへ書き込み
            switchLock(lock: true)      //UIのスイッチ（プレイヤー・コート・ペアリング・プレイモード・ゲーム記録）を切り替える
            
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
            
            if let gameData = PadelDataRecordBrain().loadGameData() {
                tableViewCon.gameDataArray = gameData
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
            return 23
            
        default:
            return 0
        }
    }
    
    //UserDefaultsから使用コート数を取得
    func setCourtFlag() {
        if let courtBool = UserDefaults.standard.value(forKey: "courtBool") as? [Bool] {
            c1s.isOn = courtBool[0]
            c2s.isOn = courtBool[1]
        }
    }
    
    //UserDefaltsから試合プレイモードを取得
    func setPlayModeFlag() {
        if let playModeBool = UserDefaults.standard.value(forKey: "playModeBool") as? Bool {
            playModeSwitchA.isOn = playModeBool
            playModeSwitchB.isOn = !playModeBool
        }
    }
    
    //UserDefaltsから試合結果表示有無を取得
    func setGameResultFlag() {
        if let gameResultBool = UserDefaults.standard.value(forKey: "gameResultBool") as? Bool {
            gameResultSwitch.isOn = gameResultBool
        }
    }
    
    //コート使用数から必要最小プレイやー数を計算
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
    
    //UIからプレイヤー全21名の名前を取得
    func makeNameArray() -> [String] {
        let playerNameLabelArray = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21]
        var names: [String] = []
        for i in 0...20 {
            let name = playerNameLabelArray[i]?.text ?? "X"
            names.append(name)
        }
        return names
    }
    
    //印数のモデルより全プレイヤーのプレイ有無を取得、UIへ反映させる
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
    
    //UIのスイッチ（プレイヤー・コート・ペアリング・プレイモード・ゲーム記録）を切り替える（使用可or使用不可）
    func switchLock(lock: Bool) {
        let playingFlagSwitchArray = [p1s, p2s, p3s, p4s, p5s, p6s, p7s, p8s, p9s, p10s, p11s, p12s, p13s, p14s, p15s, p16s, p17s, p18s, p19s, p20s, p21s]
        
        for i in 0...20 {
            playingFlagSwitchArray[i]?.isEnabled = !lock
        }
        c1s.isEnabled = !lock
        c2s.isEnabled = !lock
        pp1.isEnabled = !lock
        pp2.isEnabled = !lock
        playModeSwitchA.isEnabled = !lock
        playModeSwitchB.isEnabled = !lock
        gameResultSwitch.isEnabled = !lock
    }
    
    //UIから全プレイヤーの名前、性別アレイより各プレイヤーの性別を取得、FileManagerへ記録する（データを作成）
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
    
    //空のゲームデータアレイを作成、FileManagerへ記録（データ作成）
    func setGameData() {
        let gameData: [GameModel] = []
        
        playerDataRecord.saveGameData(gameData: gameData)
    }
    
    //UIよりプレイヤー全21名のプレイ有無を取得
    func makePlayingFlagArray() -> [Bool] {
        let playingFlagSwitchArray = [p1s, p2s, p3s, p4s, p5s, p6s, p7s, p8s, p9s, p10s, p11s, p12s, p13s, p14s, p15s, p16s, p17s, p18s, p19s, p20s, p21s]
        var playingFlags: [Bool] = []
        for i in 0...20 {
            let flag = playingFlagSwitchArray[i]?.isOn ?? false
            playingFlags.append(flag)
        }
        return playingFlags
    }
    
    func countPlayPlayers() -> Int {
        var flags = self.makePlayingFlagArray()
        flags = flags.filter { $0 == true }
        return flags.count
    }
    
    //プレイ有無アレイからFileManagerより呼び出したモデルデータを修正、再度FileManagerへ上書き保村
    func savePlayersData() {
        let flags = self.makePlayingFlagArray()
        
        if let playersData = playerDataRecord.loadPlayers() {
            for i in 0...20 {
                playersData[i].playingFlag = flags[i]
            }
            playerDataRecord.savePlayers(players: playersData)
        }
    }
    
    //UIよりコート数を取得、UserDefaultsへ書き込み
    func saveCourtBool() {
        let courtBool = [c1s.isOn, c2s.isOn]
        UserDefaults.standard.set(courtBool, forKey: "courtBool")
    }
    //UIよりプレイモードを取得、UserDefaultsへ書き込み
    func savePlayModeBool() {
        let playModeBool = playModeSwitchA.isOn
        UserDefaults.standard.set(playModeBool, forKey: "playModeBool")
    }
    
    //UIよりゲーム記録モードを取得、UserDefaultsへ書き込み
    func saveGameResultBool() {
        let gameResultBool = gameResultSwitch.isOn
        UserDefaults.standard.set(gameResultBool, forKey: "gameResultBool")
    }
    
    //印数のモデルよりペアリングデータを取得、UIにプレイヤー名を反映させる（ペアリング１と２両方）
    //但し、ペアリングとして表示されたプレイヤーが非参加の場合はペアリングOFFへ切り替え
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
    
    //FileManagerよりモデルを取得、メソッドでペアリングデータをUIに反映
    //もしUIのペアリング状況がOFFならモデルのペアリングを削除して上書き保存
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
    
    
    //UIのペアリングスイッチをチェック、OFFならFileManagerのデータを呼び出して、ペアリングを削除して上書き保存
    func checkPairingSwitch() {
        if !pp1.isOn {
            if let playersData = playerDataRecord.loadPlayers() {
                var players = playersData
                players = players.map {
                    if $0.pairing1 {
                        $0.pairing1 = false
                    }
                    return $0
                }
                playerDataRecord.savePlayers(players: players)
            }
        }
        
        if !pp2.isOn {
            if let playersData = playerDataRecord.loadPlayers() {
                var players = playersData
                players = players.map {
                    if $0.pairing2 {
                        $0.pairing2 = false
                    }
                    return $0
                }
                playerDataRecord.savePlayers(players: players)
            }
        }
    }
    
    
    //FileManagerよりモデル取得、UIから取得したプレイ有無アレイとモデルのプレイ有無アレイを比較
    //変更を検知したら（つまり新たな参加者がいたら）現在プレイ中のプレイヤーの中で一番試合回数の少ない数を取得
    //もし新しく参加したプレイヤー（復帰の可能性もあり）の試合回数が取得した回数より少ない場合は
    //参加プレイヤーのプレイ回数を修正して上書き保存
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
    
    //アラートのメソッド
    func updateInfoAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
    //NotificationCenterの実行メソッド
    @objc func updateUI() {
        if let playersData = playerDataRecord.loadPlayers() {
            let array = playersData
            
            let pair1 = array.filter { $0.pairing1 == true }
            let pair2 = array.filter { $0.pairing2 == true }
            
            pp1A.text = ""
            pp1B.text = ""
            pp2A.text = ""
            pp2B.text = ""
            
            let names = self.makeNameArray()
            let flags = self.makePlayingFlagArray()
            
            if pair1.count == 2 {
                pp1A.text = pair1[0].name
                pp1B.text = pair1[1].name
                pp1.isOn = true
                
                for i in 0...20 {
                    if names[i] == pair1[0].name {
                        if !flags[i] {
                            pp1.isOn = false
                        }
                    } else if names[i] == pair1[1].name {
                        if !flags[i] {
                            pp1.isOn = false
                        }
                    }
                }
            } else { pp1.isOn = false }
            
            
            if pair2.count == 2 {
                pp2A.text = pair2[0].name
                pp2B.text = pair2[1].name
                pp2.isOn = true
                
                for i in 0...20 {
                    if names[i] == pair2[0].name {
                        if !flags[i] {
                            pp2.isOn = false
                        }
                    } else if names[i] == pair2[1].name {
                        if !flags[i] {
                            pp2.isOn = false
                        }
                    }
                }
            } else { pp2.isOn = false }
        }
    }
}
