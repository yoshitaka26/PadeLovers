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

final class GameResultViewController: BaseViewController {
    
    private var viewModel = GameResultViewModel()
    
    @IBOutlet private weak var customCollectionView: UICollectionView!
    @IBOutlet private weak var customToolbar: UIToolbar!
    @IBOutlet private weak var playerButton: UIBarButtonItem!
    @IBOutlet private weak var gameButton: UIBarButtonItem!

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup()
    }

    private func setup() {
        tabBarController?.navigationItem.title = String(localized: "Game view result")
        tabBarController?.navigationItem.hidesBackButton = true
        tabBarController?.navigationItem.rightBarButtonItem = self.createBarButtonItem(image: UIImage.named("house.fill"), select: #selector(self.back))
        tabBarItem.title = String(localized: "Game view result")
    }
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.setPadelID.onNext(())
            self.customCollectionView.bounces = false
            self.customCollectionView.register(UINib(nibName: "PlayerResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "PlayerCell")
            self.customCollectionView.register(UINib(nibName: "GameResultCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GameCell")
            self.viewModel.loadGameData.onNext(())
        }).disposed(by: disposeBag)
        rxViewWillAppear.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.loadGameData.onNext(())
            self.viewModel.scoreType.accept(.player)
            self.customCollectionView.reloadData()
            self.viewModel.playerButtonColor.accept(.appRed)
            self.viewModel.gameButtonColor.accept(.darkGray)
            UIApplication.shared.isIdleTimerDisabled = true
        }).disposed(by: disposeBag)
        rxViewWillDisappear.subscribe(onNext: { [weak self] in
            guard self != nil else { return }
            UIApplication.shared.isIdleTimerDisabled = false
        }).disposed(by: disposeBag)
        viewModel.reloadTableView.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.customCollectionView.reloadData()
        }).disposed(by: disposeBag)
        viewModel.pushToEditDataModalView.subscribe(onNext: { [weak self] game in
            guard let self = self else { return }
            let storyboard = UIStoryboard(name: "RecordScore", bundle: nil)
            let modalVC = storyboard.instantiateViewController(identifier: "RecordScore")
            if let recordVC = modalVC as? RecordScoreViewController {
                recordVC.delegate = self
                recordVC.gameData = game
                self.openReplaceWindow(windowNavigation: modalVC, modalSize: CGSize(width: 400, height: 600))
            }
        }).disposed(by: disposeBag)
        playerButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.scoreType.accept(.player)
            self.customCollectionView.reloadData()
            self.viewModel.playerButtonColor.accept(.appRed)
            self.viewModel.gameButtonColor.accept(.darkGray)
        }).disposed(by: disposeBag)
        gameButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.scoreType.accept(.game)
            self.customCollectionView.reloadData()
            self.viewModel.playerButtonColor.accept(.darkGray)
            self.viewModel.gameButtonColor.accept(.appRed)
            self.customCollectionView.scrollToItem(at: IndexPath(item: self.viewModel.allGames.value.count - 1, section: 0), at: .bottom, animated: true)
        }).disposed(by: disposeBag)
        viewModel.playerButtonColor.subscribe(onNext: { [weak self] color in
            guard let self = self else { return }
            self.playerButton.tintColor = color
        }).disposed(by: disposeBag)
        viewModel.gameButtonColor.subscribe(onNext: { [weak self] color in
            guard let self = self else { return }
            self.gameButton.tintColor = color
        }).disposed(by: disposeBag)
    }
    
    @objc
    func back() {
        self.confirmationAlertView(withTitle: "ホーム画面に戻ります", cancelString: "キャンセル", confirmString: "OK") {
            let navigationController = self.tabBarController?.parent as? UINavigationController
            navigationController?.popToRootViewController(animated: true)
        }
    }
}

extension GameResultViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIGestureRecognizerDelegate {
    override func viewDidLoad() {
        super.viewDidLoad()
        customCollectionView.delegate = self
        customCollectionView.dataSource = self
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(cellLongPressed))
        longPressRecognizer.delegate = self
        longPressRecognizer.minimumPressDuration = 2.0
        customCollectionView.addGestureRecognizer(longPressRecognizer)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch viewModel.scoreType.value {
        case .player:
            return viewModel.allPlayers.value.count
        case .game:
            return viewModel.allGames.value.count
        }
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch viewModel.scoreType.value {
        case .player:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PlayerCell", for: indexPath)
            guard let playerCell = cell as? PlayerResultCollectionViewCell else { return cell }
            playerCell.setUI(player: viewModel.allPlayers.value[indexPath.row], minCount: viewModel.minGameCount.value)
            return playerCell
        case .game:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GameCell", for: indexPath)
            guard let gameCell = cell as? GameResultCollectionViewCell else { return cell }
            gameCell.setUI(game: viewModel.allGames.value[indexPath.row], playersList: viewModel.allPlayers.value, count: indexPath.row)
            return gameCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        switch viewModel.scoreType.value {
        case .player:
            let playerCellWidth = Int(collectionView.frame.width - 6.0) / 2
            let playerCellHeight = 100
            return CGSize(width: playerCellWidth, height: playerCellHeight)
        case .game:
            let gameCellWidth = Int(collectionView.frame.width - 4.0)
            let gameCellHeight = 170
            return CGSize(width: gameCellWidth, height: gameCellHeight)
        }
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
    @objc
    func cellLongPressed(recognizer: UILongPressGestureRecognizer) {
        let point = recognizer.location(in: customCollectionView)
        let indexPath = customCollectionView.indexPathForItem(at: point)
        guard let index = indexPath else { return }
        guard viewModel.scoreType.value == .game else { return }
        viewModel.longPressedScore.accept(index.row)
    }
}
extension GameResultViewController: RecordScoreViewControllerDelegate {
    func returnFromRecordScoreViewController() {
        viewModel.reloadTableView.onNext(())
    }
}
