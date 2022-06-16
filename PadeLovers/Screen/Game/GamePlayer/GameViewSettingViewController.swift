//
//  GameViewSettingViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/10.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class GameViewSettingViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView! {
        didSet {
            tableView.register(R.nib.gameViewGameModeTableViewCell)
            tableView.register(R.nib.gameViewCourtTableViewCell)
            tableView.register(R.nib.gameViewGameResultTableViewCell)
            tableView.register(R.nib.gameViewPairingTableViewCell)
            tableView.register(R.nib.gameViewPlayerCountTableViewCell)
            tableView.register(R.nib.gameViewPlayerTableViewCell)

            tableView.rx
                .setDelegate(self)
                .disposed(by: disposeBag)

            tableView.rx
                .setDataSource(self)
                .disposed(by: disposeBag)

            viewModel.reloadTable
                .drive(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    self.tableView.reloadData()
                })
                .disposed(by: disposeBag)
        }
    }

    private let disposeBag = DisposeBag()
    private var viewModel: GameViewSettingViewModel!

    static func make(type: TableType, padelId: String?) -> GameViewSettingViewController {
        let viewController = R.storyboard
            .gameViewSetting
            .instantiateInitialViewController()!
        viewController.viewModel = GameViewSettingViewModel(padelId: padelId, startType: type, coreDataManager: CoreDataManager.shared)
        return viewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
    }

    private func bind() {
        rx.viewWillAppear
            .bind(to: viewModel.viewWillAppear)
            .disposed(by: disposeBag)
        viewModel.presentScreen
            .drive(onNext: { [unowned self] screen in
                self.presentScreen(screen)
            })
            .disposed(by: disposeBag)
        viewModel.pushScreen
            .drive(onNext: { [unowned self] screen in
                self.navigationController?.pushScreen(screen)
            })
            .disposed(by: disposeBag)
    }
}

extension GameViewSettingViewController: UITableViewDelegate {

}

extension GameViewSettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return R.string.localizable.mode()
        case 1:
            return R.string.localizable.gameResult()
        case 2:
            return R.string.localizable.court()
        case 3:
            return R.string.localizable.pairing()
        case 4:
            return R.string.localizable.player()
        default:
            return nil
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 3
        case 1:
            return 1
        case 2:
            return viewModel.courtList.value.count
        case 3:
            return viewModel.pairingList.value.count
        case 4:
            return viewModel.playerList.value.count + 1
        default:
            return 0
        }
    }
    // swiftlint:disable force_unwrapping
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.gameViewGameModeTableViewCell, for: indexPath)!
            cell.render(delegate: self, modeType: GameModeType(rawValue: indexPath.row) ?? .combination, playMode: viewModel.padelPlayMode.value, isAuto: viewModel.autoPlayMode.value)
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.gameViewGameResultTableViewCell, for: indexPath)!
            cell.render(delegate: self, gameResult: viewModel.gameResult.value)
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.gameViewCourtTableViewCell, for: indexPath)!
            cell.render(delegate: self, court: viewModel.courtList.value[indexPath.row])
            return cell
        case 3:
            let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.gameViewPairingTableViewCell, for: indexPath)!
            cell.render(delegate: self, pairing: viewModel.pairingList.value[indexPath.row])
            return cell
        case 4:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.gameViewPlayerCountTableViewCell, for: indexPath)!
                cell.render(minPlayerCount: viewModel.minPlayerCounts.value)
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: R.nib.gameViewPlayerTableViewCell, for: indexPath)!
                cell.render(delegate: self, player: viewModel.playerList.value[indexPath.row - 1])
                return cell
            }
        default:
            // Never comes here
            return UITableViewCell()
        }
    }
    // swiftlint:enable force_unwrapping
}

extension GameViewSettingViewController: GameViewPlayerTableDelegate {
    func gameModeSwitchChanged(gameMode: GameModeType, isOn: Bool) {
        viewModel.handleGameModeSwitchChanged(gameMode: gameMode, isOn: isOn)
    }

    func gameResultSwitchChanged(isOn: Bool) {
        viewModel.handleGameResultSwitchChanged(isOn: isOn)
    }

    func pairingSwitchChanged(pairing: Pairing, isOn: Bool) {
        viewModel.handlePairingSwitchChanged(pairing: pairing, isOn: isOn)
    }

    func courtSwitchChanged(courtId: Int16, isOn: Bool) {
        viewModel.handleCourtSwitchChanged(courtId: courtId, isOn: isOn)
    }

    func playerSwitchChanged(playerId: Int16, isPlaying: Bool) {
        viewModel.handlePlayerSwitchChanged(playerId: playerId, isPlaying: isPlaying)
    }
}
