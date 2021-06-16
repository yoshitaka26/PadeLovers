//
//  GameTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

class GameDataTableViewController: BaseTableViewController {
    private var viewModel = GameDataTableViewModel()
    
    var lastContentOffSet: CGFloat = 0
    
    var gameSetFlag = false     // 試合の設定が完了しているかどうか->試合を組める状態
    var playModeFlag = true     // 組み合わせ重視モードor試合数重視モード->試合の組み方が変わる

    var courtFirst: Bool = false
    var courtSecond: Bool = false
    var courtFirstName: String = ""
    var courtSecondName: String = ""
    var courtArray: [String] = []

    let playerDataRecord = PadelDataRecordBrain()
    var gameDataModelBrain = GameDataModelBrain()

    var players: [PadelModel] = []

    var courtFirstGamePlayers: [PadelModel]?
    var courtSecondGamePlayers: [PadelModel]?
    var courtFirstReloadFlag: Bool = true
    var courtSecondReloadFlag: Bool = true

    var changePlayerCourtTag: Int = 0

    var gameDataFlag: Bool = false
    var gameDataArray = [GameModel]()
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.navigationBar.barTintColor = .navigationBarColor
            self.navigationController?.isNavigationBarHidden = false
            self.tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
            self.tableView.bounces = true
            self.viewModel.loadGameData.onNext(())
        }).disposed(by: disposeBag)
        rxViewWillAppear.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.loadGameData.onNext(())
        }).disposed(by: disposeBag)
        viewModel.reloadTableView.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
    }
    @objc func gameEnd(_ sender: UIButton) {
        viewModel.gameEnd.onNext(sender.tag)
    }
    @objc func moveToChangePlayerView(_ sender: UIButton) {
        let alert = UIAlertController(title: "message", message: "選択してください", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "試合取り消し", style: .destructive) { _ in
            self.viewModel.deleteGame.onNext(sender.tag)
        }
        let action2 = UIAlertAction(title: "もう一度組み合わせ", style: .destructive) { _ in
            self.viewModel.reOrganaizeGame.onNext(sender.tag)
        }
        let action3 = UIAlertAction(title: "プレイヤー交代", style: .default) { _ in
            let storyboard = UIStoryboard(name: "ReplacePlayer", bundle: nil)
            let modalVC = storyboard.instantiateViewController(identifier: "ReplacePlayer")
            if let replaceVC = modalVC as? ReplacePlayerViewController {
                replaceVC.delegate = self
                replaceVC.courtID = sender.tag
                self.present(modalVC, animated: true)
            }
        }
        let actionCancel = UIAlertAction(title: "キャンセル", style: .cancel)
        let actions = [action1, action2, action3, actionCancel]
        actions.forEach { alert.addAction($0) }
        present(alert, animated: true, completion: nil)
    }
}

extension GameDataTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.onGames.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameTableViewCell
        
        cell.playerChangeButton.addTarget(self, action: #selector(GameDataTableViewController.moveToChangePlayerView), for: .touchUpInside)
        cell.gameFinishButton.addTarget(self, action: #selector(GameDataTableViewController.gameEnd), for: .touchUpInside)
        cell.setGameCell(game: viewModel.onGames.value[indexPath.row])
        return cell
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffSet = scrollView.contentOffset.y
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffSet > scrollView.contentOffset.y {
            self.confirmationAlertView(withTitle: "試合を組みます", message: "組みますか？", cancelString: "キャンセル", confirmString: "OK") {
                self.viewModel.organizeGame.onNext(())
            }
        }
    }
}

extension GameDataTableViewController: ReplacePlayerViewControllerDelegate {
    func returnFromReplacePlayerViewController() {
        viewModel.loadGameData.onNext(())
    }
}
