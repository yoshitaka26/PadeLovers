//
//  SettingTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class SettingTableViewController: UITableViewController {

    @IBOutlet weak var c1: UITextField!
    @IBOutlet weak var c2: UITextField!
    
    @IBOutlet weak var p1: UITextField!
    @IBOutlet weak var p1g: UISegmentedControl!
    @IBOutlet weak var p2: UITextField!
    @IBOutlet weak var p2g: UISegmentedControl!
    @IBOutlet weak var p3: UITextField!
    @IBOutlet weak var p3g: UISegmentedControl!
    @IBOutlet weak var p4: UITextField!
    @IBOutlet weak var p4g: UISegmentedControl!
    @IBOutlet weak var p5: UITextField!
    @IBOutlet weak var p5g: UISegmentedControl!
    @IBOutlet weak var p6: UITextField!
    @IBOutlet weak var p6g: UISegmentedControl!
    @IBOutlet weak var p7: UITextField!
    @IBOutlet weak var p7g: UISegmentedControl!
    @IBOutlet weak var p8: UITextField!
    @IBOutlet weak var p8g: UISegmentedControl!
    @IBOutlet weak var p9: UITextField!
    @IBOutlet weak var p9g: UISegmentedControl!
    @IBOutlet weak var p10: UITextField!
    @IBOutlet weak var p10g: UISegmentedControl!
    @IBOutlet weak var p11: UITextField!
    @IBOutlet weak var p11g: UISegmentedControl!
    @IBOutlet weak var p12: UITextField!
    @IBOutlet weak var p12g: UISegmentedControl!
    @IBOutlet weak var p13: UITextField!
    @IBOutlet weak var p13g: UISegmentedControl!
    @IBOutlet weak var p14: UITextField!
    @IBOutlet weak var p14g: UISegmentedControl!
    @IBOutlet weak var p15: UITextField!
    @IBOutlet weak var p15g: UISegmentedControl!
    @IBOutlet weak var p16: UITextField!
    @IBOutlet weak var p16g: UISegmentedControl!
    @IBOutlet weak var p17: UITextField!
    @IBOutlet weak var p17g: UISegmentedControl!
    @IBOutlet weak var p18: UITextField!
    @IBOutlet weak var p18g: UISegmentedControl!
    @IBOutlet weak var p19: UITextField!
    @IBOutlet weak var p19g: UISegmentedControl!
    @IBOutlet weak var p20: UITextField!
    @IBOutlet weak var p20g: UISegmentedControl!
    @IBOutlet weak var p21: UITextField!
    @IBOutlet weak var p21g: UISegmentedControl!
    
    var courtNameArray: [String] = []
    var nameArray: [String] = []
    var genderArray: [Bool] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let court = UserDefaults.standard.value(forKey: "court") as? [String] {
            c1.text = court[0]
            c2.text = court[1]
        }
        
        let textFieldArray = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21]
        let segmentArray = [p1g, p2g, p3g, p4g, p5g, p6g, p7g, p8g, p9g, p10g, p11g, p12g, p13g, p14g, p15g, p16g, p17g, p18g, p19g,p20g, p21g]
        
        
        if let player = UserDefaults.standard.value(forKey: "player") as? [String] {
            if player.count == 21 {
                for i in 0...20 {
                    textFieldArray[i]?.text = player[i]
                }
            }
        }
        
        
        if let gender = UserDefaults.standard.value(forKey: "gender") as? [Bool] {
            if gender.count == 21 {
                for i in 0...20 {
                    if gender[i] {
                        segmentArray[i]?.selectedSegmentIndex = 0
                    } else {
                        segmentArray[i]?.selectedSegmentIndex = 1
                    }
                }
            }
        }
    }
    
    
    
    override func viewDidDisappear(_ animated: Bool) {
        
        let court1 = c1.text ?? "X"
        let court2 = c2.text ?? "X"
        courtNameArray = [court1, court2]

        let textFieldArray = [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p20, p21]
        let segmentArray = [p1g, p2g, p3g, p4g, p5g, p6g, p7g, p8g, p9g, p10g, p11g, p12g, p13g, p14g, p15g, p16g, p17g, p18g, p19g,p20g, p21g]
        
        for textField in textFieldArray {
            let name = textField?.text ?? "X"
            nameArray.append(name)
        }
        
        for segment in segmentArray {
            let index = segment?.selectedSegmentIndex
            if index == 0 {
                genderArray.append(true)
            } else {
                genderArray.append(false)
            }
        }
        
        UserDefaults.standard.set(courtNameArray, forKey: "court")
        UserDefaults.standard.set(nameArray, forKey: "player")
        UserDefaults.standard.set(genderArray, forKey: "gender")
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return 2
        case 1:
            return 21
            
        default:
            return 0
        }
    }
}
