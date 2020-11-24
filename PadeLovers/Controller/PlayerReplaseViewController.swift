//
//  PlayerReplaseViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/30.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

protocol DataReturn {
    func returnData(curretPlayer: PadelModel, newPlayer: PadelModel)
}

class PlayerReplaseViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource  {
    var delegate: DataReturn?
    
    @IBOutlet weak var currentPlayerPicker: UIPickerView!
    @IBOutlet weak var waitingPlayerPicker: UIPickerView!
    @IBOutlet weak var finishButton: UIButton!
    
    var playingPlayer = [PadelModel]()
    var waitingPlayer = [PadelModel]()
    
    var pickerArray = [Int: [PadelModel]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        finishButton.layer.cornerRadius = finishButton.frame.size.height / 4
        
        currentPlayerPicker.delegate = self
        currentPlayerPicker.dataSource = self
        waitingPlayerPicker.delegate = self
        waitingPlayerPicker.dataSource = self
        
        pickerArray[0] = playingPlayer
        pickerArray[1] = waitingPlayer
        
    }
    
    @IBAction func replaseDecideButton(_ sender: UIButton) {
        
        let replasePlayerNum = currentPlayerPicker.selectedRow(inComponent: 0)
        let newPlayerNum = waitingPlayerPicker.selectedRow(inComponent: 0)
        let replasePlayer = playingPlayer[replasePlayerNum]
        
        if waitingPlayer != [] {
            let newPlayer = waitingPlayer[newPlayerNum]
            let alert = UIAlertController(title: "プレイヤーを交代します", message: "\(replasePlayer.name)→\(newPlayer.name)", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.delegate?.returnData(curretPlayer: replasePlayer, newPlayer: newPlayer)
                
                self.navigationController?.popViewController(animated: true)
            }
            let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel)
            
            alert.addAction(action)
            alert.addAction(actionCancel)
            
            present(alert, animated: true, completion: nil)
            
        } else {
            let alert = UIAlertController(title: "交代プレイヤーがいません", message: "", preferredStyle: .alert)
            
            let action = UIAlertAction(title: "OK", style: .default) { (action) in
                self.navigationController?.popViewController(animated: true)
            }
            
            alert.addAction(action)
            
            present(alert, animated: true, completion: nil)
        }
        
        
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerArray[pickerView.tag]?.count ?? 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerArray[pickerView.tag]?[row].name
    }
}
