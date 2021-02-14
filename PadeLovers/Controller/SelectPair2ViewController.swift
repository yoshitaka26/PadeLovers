//
//  SelectPair2ViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/28.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class SelectPair2ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    @IBOutlet weak var pair1Picker: UIPickerView!
    @IBOutlet weak var pair2Picker: UIPickerView!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    
    let playerDataRecord = PadelDataRecordBrain()
    
    var nameData: [String] = [""]
    var players: [PadelModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.layer.cornerRadius = finishButton.frame.size.height / 4
        resetButton.layer.cornerRadius = resetButton.frame.size.height / 4
        
        if let playersData = playerDataRecord.loadPlayers() {
            if playersData.count == 21 {
                for i in 0...20 {
                    nameData.append(playersData[i].name)
                }
            }
        }
        
        pair1Picker.delegate = self
        pair1Picker.dataSource = self
        pair2Picker.delegate = self
        pair2Picker.dataSource = self
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return nameData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return nameData[row]
    }
    
    @IBAction func resetButtonPressed(_ sender: UIButton) {
        
        
        //FileManagerのデータを呼び出して、ペアリング1を削除して上書き保存
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
        
        let alert = UIAlertController(title: "固定ペア２をリセット", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            //NotificationCenter通知の送信
            NotificationCenter.default.post(name: .updateDataNotification,
                       object: nil)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func okButtonPressed(_ sender: UIButton) {
        if pair1Picker.selectedRow(inComponent: 0) == 0 {
            print("p1空白")
            updateInfoAlert(title: "プレイヤー１が未選択です")
        } else if pair2Picker.selectedRow(inComponent: 0) == 0 {
            print("p2空白")
            updateInfoAlert(title: "プレイヤー２が未選択です")
        } else if pair1Picker.selectedRow(inComponent: 0) == pair2Picker.selectedRow(inComponent: 0) {
            print("同じプレイヤー選択")
            updateInfoAlert(title: "同じプレイヤーを選択しています")
        } else {
            let p1Num = pair1Picker.selectedRow(inComponent: 0)
            let player1 = nameData[p1Num]
            let p2Num = pair2Picker.selectedRow(inComponent: 0)
            let player2 = nameData[p2Num]
            
            //FileManagerのデータを呼び出して、ペアリング1を削除して、新しいペアリング1を記録して上書き保存
            if let playersData = playerDataRecord.loadPlayers() {
                var players = playersData
                players = players.map {
                    if $0.pairing2 {
                        $0.pairing2 = false
                    }
                    if $0.name == player1 || $0.name == player2 {
                        $0.pairing2 = true
                        if $0.pairing1 {
                            $0.pairing1 = false
                        }
                    }
                    return $0
                }
                let checkError = players.filter { $0.pairing1 == true }
                if checkError.count != 2 {
                    players = players.map {
                        if $0.pairing1 {
                            $0.pairing1 = false
                        }
                        return $0
                    }
                }
                playerDataRecord.savePlayers(players: players)
            }
        }
        let alert = UIAlertController(title: "ペアを固定しました", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            
            //NotificationCenter通知の送信
            NotificationCenter.default.post(name: .updateDataNotification,
            object: nil)
            
            self.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func updateInfoAlert(title: String) {
        let alert = UIAlertController(title: title, message: "", preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}

