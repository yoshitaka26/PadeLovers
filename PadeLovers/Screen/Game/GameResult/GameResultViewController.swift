//
//  GameResultViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/30.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class GameResultViewController: BaseViewController {
    
    private var viewModel = GameResultViewModel()
    
    @IBOutlet weak var customCollectionView: UICollectionView!
    @IBOutlet weak var customToolbar: UIToolbar!
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.navigationBar.barTintColor = .navigationBarColor
            self.navigationController?.isNavigationBarHidden = false
            self.customCollectionView.register(UINib(nibName: "PlayerResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayerCell")
            self.viewModel.loadGameData.onNext(())
            self.createToolbar()
        }).disposed(by: disposeBag)
        rxViewWillAppear.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.loadGameData.onNext(())
        }).disposed(by: disposeBag)
        viewModel.reloadTableView.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.customCollectionView.reloadData()
        }).disposed(by: disposeBag)
    }
    
    func createToolbar() {
        customToolbar.isTranslucent = false
        customToolbar.barTintColor = .navigationBarColor
        
        let playerButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 60))
        playerButton.setImage(UIImage(systemName: "person.crop.square"), for: .normal)
        playerButton.setTitle("プレイヤ", for: .normal)
        playerButton.tintColor = UIColor.white
        playerButton.addTarget(self, action: #selector(playerData), for: .touchUpInside)
        let playerButtonItem = UIBarButtonItem(customView: playerButton)
        let gameButton = UIButton(frame: CGRect(x: 0, y: 0, width: 120, height: 60))
        gameButton.setImage(UIImage(systemName: "rectangle.grid.2x2.fill"), for: .normal)
        gameButton.setTitle("ゲーム", for: .normal)
        gameButton.tintColor = UIColor.white
        gameButton.addTarget(self, action: #selector(gameData), for: .touchUpInside)
        let gameButtonItem = UIBarButtonItem(customView: gameButton)
        let spaceFlex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        customToolbar.setItems([spaceFlex, playerButtonItem, spaceFlex, gameButtonItem, spaceFlex], animated: true)
    }
    @objc func playerData() {
        
    }
    @objc func gameData() {
        
    }
//    let playerDataRecord = PadelDataRecordBrain()
//
//    var players = [PadelModel]()
//    var playingPlayers = [PadelModel]()
//    var restingPlayers = [PadelModel]()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.title = "プレイヤー"
//
//    }
//
//    override func viewWillAppear(_ animated: Bool) {
//        if let playersData = playerDataRecord.loadPlayers() {
//            players = playersData
//        }
//
//        playingPlayers = players.filter { $0.playingFlag }
//
//        restingPlayers = players.filter { !$0.playingFlag }
//        restingPlayers = restingPlayers.filter { $0.playCounts > 0 }
//
//        tableView.reloadData()
//    }
//
//    override func numberOfSections(in tableView: UITableView) -> Int {
//
//        if restingPlayers != [] {
//            return 2
//        } else {
//            return 1
//        }
//    }
//    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
//        switch section {
//        case 0:
//            let label = UILabel()
//            label.text = "参加プレイヤーの試合回数"
//            label.textColor = .white
//            label.font = UIFont.systemFont(ofSize: 22)
//            label.textAlignment = .center
//            label.backgroundColor = UIColor(red: 255/255, green: 121/255, blue: 63/255, alpha: 1.0)
//            return label
//
//        case 1:
//        let label = UILabel()
//        label.text = "離脱プレイヤーの試合回数"
//        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 22)
//        label.textAlignment = .center
//        label.backgroundColor = UIColor(red: 255/255, green: 121/255, blue: 63/255, alpha: 1.0)
//
//        return label
//
//        default:
//            return nil
//        }
//
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//
//        switch section {
//        case 0:
//            return playingPlayers.count
//        case 1:
//            return restingPlayers.count
//        default:
//            return 0
//        }
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ResultCell", for: indexPath)
//
//        switch indexPath.section {
//        case 0:
//            let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
//            nameLabel.text = playingPlayers[indexPath.row].name
//            if !playingPlayers[indexPath.row].gender {
//                nameLabel.textColor = .red
//            } else {
//                nameLabel.textColor = .label
//            }
//
//            let countLabel = cell.contentView.viewWithTag(2) as! UILabel
//            countLabel.text = "\(String(playingPlayers[indexPath.row].playCounts))試合"
//            cell.selectionStyle = .none
//
//            return cell
//
//        case 1:
//            let nameLabel = cell.contentView.viewWithTag(1) as! UILabel
//            nameLabel.text = restingPlayers[indexPath.row].name
//            if !restingPlayers[indexPath.row].gender {
//                nameLabel.textColor = .red
//            } else {
//                nameLabel.textColor = .label
//            }
//
//            let countLabel = cell.contentView.viewWithTag(2) as! UILabel
//            countLabel.text = "\(String(restingPlayers[indexPath.row].playCounts))試合"
//            cell.selectionStyle = .none
//
//            return cell
//
//        default:
//            return cell
//        }
//
//    }
//
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let storyboard = UIStoryboard(name: "ResultDetail", bundle: nil)
//        let modalVC = storyboard.instantiateViewController(identifier: "ResultDetail")
//        if let resultDetailVC = modalVC as? ResultDetailTableViewController {
//            resultDetailVC.playerArrayNumber = indexPath.row
//            switch indexPath.section {
//            case 0:
//                resultDetailVC.player = playingPlayers[indexPath.row]
//            case 1:
//                resultDetailVC.player = restingPlayers[indexPath.row]
//            default:
//                return
//            }
//            present(modalVC, animated: true)
//        }
//    }
}

extension GameResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        customCollectionView.delegate = self
        customCollectionView.dataSource = self
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.allPlayers.value.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath)
        guard let playerCell = cell as? PlayerResultCollectionViewCell else { return cell }
        playerCell.setUI(player: viewModel.allPlayers.value[indexPath.row], minCount: viewModel.minGameCount.value)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let playerCellWidth = Int(collectionView.frame.width - 6.0) / 2
        let playerCellHeight = 100
        return CGSize(width: playerCellWidth, height: playerCellHeight)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 2.0, left: 2.0, bottom: 2.0, right: 2.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2.0
    }
}
