//
//  ViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var infoButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var restartButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        infoButton.layer.cornerRadius = infoButton.frame.size.height / 4
        
        playButton.layer.cornerRadius = playButton.frame.size.height / 4
        
        restartButton.layer.cornerRadius = restartButton.frame.size.height / 4
        
        UITabBar.appearance().tintColor = UIColor(red: 255/255, green: 63/255, blue: 101/255, alpha: 1.0)
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 255/255, green: 121/255, blue: 63/255, alpha: 1.0)
        
    }

    
    @IBAction func PlayGameButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "新しく試合を始めます", message: "前回の試合データは消去されます", preferredStyle: .alert)

        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.performSegue(withIdentifier: "PlayGame", sender: self)
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel)

        alert.addAction(action)
        alert.addAction(actionCancel)

        present(alert, animated: true, completion: nil)
        
    }
    
    @IBAction func ContinueGameButtonPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "試合を再開します", message: "前回の試合データを読み込みます", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "OK", style: .default) { (action) in
            self.performSegue(withIdentifier: "ContinueGame", sender: self)
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel)
        
        alert.addAction(action)
        alert.addAction(actionCancel)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayGame" {
            let tabBarCon = segue.destination as! UITabBarController
            let navCon = tabBarCon.viewControllers![0] as! UINavigationController
            let destinationViewController = navCon.topViewController as! InfoTableViewController
            
            destinationViewController.gameStartFlag = true
            
        }
    }
}

