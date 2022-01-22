//
//  GameTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2020/10/27.
//  Copyright © 2020 Yoshitaka. All rights reserved.
//

import UIKit

final class GameDataTableViewController: BaseTableViewController {
    private var viewModel = GameDataTableViewModel()
    
    var lastContentOffSet: CGFloat = 0
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.setPadelID.onNext(())
            self.navigationController?.isNavigationBarHidden = false
            self.tableView.register(UINib(nibName: "GameTableViewCell", bundle: nil), forCellReuseIdentifier: "GameCell")
            self.tableView.bounces = true
            self.viewModel.loadGameData.onNext(())
        }).disposed(by: disposeBag)
        rxViewWillAppear.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.loadGameData.onNext(())
            UIApplication.shared.isIdleTimerDisabled = true
        }).disposed(by: disposeBag)
        rxViewWillDisappear.subscribe(onNext: { [weak self] in
            guard self != nil else { return }
            UIApplication.shared.isIdleTimerDisabled = false
        }).disposed(by: disposeBag)
        viewModel.reloadTableView.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        viewModel.askToOrganizeNewGames.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.confirmationAlertView(withTitle: "複数コート空いています", message: "全コートで試合を組みますか？", cancelString: "キャンセル", confirmString: "OK") {
                self.viewModel.organizeGame.onNext(())
            }
        }).disposed(by: disposeBag)
        viewModel.showResultModalView.subscribe(onNext: { [weak self] game in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "RecordScore", bundle: nil)
            let modalVC = storyboard.instantiateViewController(identifier: "RecordScore")
            if let recordVC = modalVC as? RecordScoreViewController {
                recordVC.delegate = self
                recordVC.gameData = game
                self.openReplaceWindow(windowNavigation: modalVC)
            }
        }).disposed(by: disposeBag)
        viewModel.messageAlert.subscribe(onNext: { [weak self] messageType in
            guard let self = self else { return }
            switch messageType {
            case .lessPlayersError:
                guard let tabBarCon = self.navigationController?.parent as? UITabBarController else { return }
                guard let navBarCon = tabBarCon.viewControllers?[0] as? UINavigationController else { return }
                guard let gamePlayerVC = navBarCon.viewControllers[0] as? GamePlayerViewController else { return }
                gamePlayerVC.tableView.scrollToRow(at: IndexPath(row: 0, section: 4), at: .top, animated: true)
                self.tabBarController?.selectedViewController = navBarCon
                self.warningAlertView(withTitle: "プレイヤが不足しています")
            case .noCourtError:
                self.warningAlertView(withTitle: "コートが空いていません")
            case .gameEnd:
                self.infoAlertViewWithTitle(title: "試合を終了しました")
            }
        }).disposed(by: disposeBag)
    }
    @objc
    func actionButtonPressed(_ sender: UIButton) {
        viewModel.actionButtonPressed.onNext(sender.tag)
    }
    @objc
    func moveToChangePlayerView(_ sender: UIButton) {
        var title = ""
        viewModel.onCourts.value.forEach {
            guard $0.courtID == sender.tag else { return }
            title = $0.name ?? ""
        }
        let alert = UIAlertController(title: title, message: "選択してください", preferredStyle: .actionSheet)
        let action1 = UIAlertAction(title: "試合取り消し", style: .destructive) { _ in
            self.viewModel.deleteGame.onNext(sender.tag)
            self.infoAlertViewWithTitle(title: "試合を取り消しました")
        }
        let action2 = UIAlertAction(title: "もう一度組み合わせ", style: .destructive) { _ in
            self.viewModel.reOrganaizeGame.onNext(sender.tag)
            self.infoAlertViewWithTitle(title: "\(title)の試合を変更しました")
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
        
        if UIDevice.current.userInterfaceIdiom == .pad {
                alert.popoverPresentationController?.sourceView = self.view
                let screenSize = UIScreen.main.bounds
                alert.popoverPresentationController?.sourceRect = CGRect(x: screenSize.size.width / 2, y: screenSize.size.height, width: 0, height: 0)
            }
        
        present(alert, animated: true, completion: nil)
    }
}

extension GameDataTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.onCourts.value.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "GameCell", for: indexPath) as! GameTableViewCell
        
        cell.playerChangeButton.addTarget(self, action: #selector(GameDataTableViewController.moveToChangePlayerView), for: .touchUpInside)
        cell.gameFinishButton.addTarget(self, action: #selector(GameDataTableViewController.actionButtonPressed), for: .touchUpInside)
        cell.setGameCell(court: viewModel.onCourts.value[indexPath.row])
        return cell
    }
    override func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.lastContentOffSet = scrollView.contentOffset.y
    }
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if self.lastContentOffSet > scrollView.contentOffset.y {
            self.viewModel.pageScrolled.onNext(())
        }
    }
}

extension GameDataTableViewController: ReplacePlayerViewControllerDelegate {
    func returnFromReplacePlayerViewController() {
        viewModel.loadGameData.onNext(())
    }
}
extension GameDataTableViewController: RecordScoreViewControllerDelegate {
    func returnFromRecordScoreViewController() {
        viewModel.loadGameData.onNext(())
    }
}
