//
//  CommonDataViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/22.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

final class CommonDataViewController: BaseViewController {
    
    private let viewModel = CommonDataViewModel()
    private let validationManager = ValidationManager.shared
    
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var customToolbar: UIToolbar!
    @IBOutlet private weak var courtButton: UIBarButtonItem!
    @IBOutlet private weak var group1Button: UIBarButtonItem!
    @IBOutlet private weak var group2Button: UIBarButtonItem!
    @IBOutlet private weak var group3Button: UIBarButtonItem!
    
    override func bind() {
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.navigationController?.isNavigationBarHidden = false
            self.tableView.delegate = self
            self.tableView.dataSource = self
            self.tableView.register(UINib(nibName: "CourtTableViewCell", bundle: nil), forCellReuseIdentifier: "CourtCell")
            self.tableView.register(UINib(nibName: "PlayerTableViewCell", bundle: nil), forCellReuseIdentifier: "PlayerCell")
            self.tableView.tableFooterView = UIView()
            
            let notificationCenter = NotificationCenter.default
            notificationCenter.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillHideNotification, object: nil)
            notificationCenter.addObserver(self, selector: #selector(self.adjustForKeyboard), name: UIResponder.keyboardWillChangeFrameNotification, object: nil)
        }).disposed(by: disposeBag)
        rxViewWillDisappear.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.viewModel.tabButtonSelected.onNext(.court)
        }).disposed(by: disposeBag)
        viewModel.reloadTableView.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }).disposed(by: disposeBag)
        _ = courtButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.tabButtonSelected.onNext(.court)
            self.viewModel.courtButtonColor.accept(.appRed)
            self.viewModel.group1ButtonColor.accept(.appBlue)
            self.viewModel.group2ButtonColor.accept(.appBlue)
            self.viewModel.group3ButtonColor.accept(.appBlue)
        }).disposed(by: disposeBag)
        _ = group1Button.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.tabButtonSelected.onNext(.group1)
            self.viewModel.courtButtonColor.accept(.appBlue)
            self.viewModel.group1ButtonColor.accept(.appRed)
            self.viewModel.group2ButtonColor.accept(.appBlue)
            self.viewModel.group3ButtonColor.accept(.appBlue)
        }).disposed(by: disposeBag)
        _ = group2Button.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.tabButtonSelected.onNext(.group2)
            self.viewModel.courtButtonColor.accept(.appBlue)
            self.viewModel.group1ButtonColor.accept(.appBlue)
            self.viewModel.group2ButtonColor.accept(.appRed)
            self.viewModel.group3ButtonColor.accept(.appBlue)
        }).disposed(by: disposeBag)
        _ = group3Button.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.viewModel.tabButtonSelected.onNext(.group3)
            self.viewModel.courtButtonColor.accept(.appBlue)
            self.viewModel.group1ButtonColor.accept(.appBlue)
            self.viewModel.group2ButtonColor.accept(.appBlue)
            self.viewModel.group3ButtonColor.accept(.appRed)
        }).disposed(by: disposeBag)
        _ = viewModel.courtButtonColor.subscribe(onNext: { [weak self] color in
            guard let self = self else { return }
            self.courtButton.tintColor = color
        }).disposed(by: disposeBag)
        _ = viewModel.group1ButtonColor.subscribe(onNext: { [weak self] color in
            guard let self = self else { return }
            self.group1Button.tintColor = color
        }).disposed(by: disposeBag)
        _ = viewModel.group2ButtonColor.subscribe(onNext: { [weak self] color in
            guard let self = self else { return }
            self.group2Button.tintColor = color
        }).disposed(by: disposeBag)
        _ = viewModel.group3ButtonColor.subscribe(onNext: { [weak self] color in
            guard let self = self else { return }
            self.group3Button.tintColor = color
        }).disposed(by: disposeBag)
    }
    
}

extension CommonDataViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch viewModel.tableType.value {
        case .court:
            return "コート設定"
        case .group1:
            return "グループ1 設定"
        case .group2:
            return "グループ2 設定"
        case .group3:
            return "グループ3 設定"
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch viewModel.tableType.value {
        case .court:
            return 3
        default:
            return 22
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        switch viewModel.tableType.value {
        case .court:
            let cell = tableView.dequeueReusableCell(withIdentifier: "CourtCell", for: indexPath) as! CourtTableViewCell
            cell.prepareForReuse()
            cell.numberLabel.text = String(indexPath.row + 1)
            cell.disposeBag.insert(
                cell.courtName.rx.textInput <-> viewModel.courtList.value[indexPath.row]
            )
            cell.courtName.rx.controlEvent(.editingDidEnd).asDriver()
                .drive(onNext: { [weak self] _ in
                    guard let self = self else { return }
                    let result: ValidationResult = self.validationManager.validate(cell.courtName.text ?? "")
                    if result != .valid {
                        self.warningAlertView(withTitle: "コート名が登録できません")
                        self.viewModel.courtList.value[indexPath.row].accept("コート")
                    }
                }).disposed(by: cell.disposeBag)
            return cell
        default:
            if indexPath.row == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "TeamCell", for: indexPath)
                let groupName = cell.contentView.viewWithTag(1) as! UITextField
                groupName.delegate = self
                _ = groupName.rx.textInput <-> viewModel.groupName
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath) as! PlayerTableViewCell
                cell.prepareForReuse()
                cell.numberLabel.text = String(indexPath.row)

                viewModel.masterPlayerList.value[indexPath.row - 1]
                    .subscribe(onNext: { player in
                        cell.set(name: player.name, gender: player.gender)
                    })
                    .disposed(by: cell.disposeBag)

                cell.nameTextField.rx.controlEvent(.editingDidEnd).asDriver()
                    .drive(onNext: { [weak self] _ in
                        guard let self else { return }
                        let result: ValidationResult = self.validationManager.validate(cell.nameTextField.text ?? "")
                        switch result {
                        case .valid:
                            self.viewModel.playerCellTextFieldTextInput.accept((
                                text: cell.nameTextField.text ?? "",
                                index: indexPath.row - 1
                            ))
                        case .invalid:
                            self.warningAlertView(withTitle: "名前が登録できません")
                            self.viewModel.playerCellTextFieldTextInput.accept((
                                text: String((cell.nameTextField.text ?? "").dropLast()),
                                index: indexPath.row - 1
                            ))
                        }
                    })
                    .disposed(by: cell.disposeBag)

                cell.genderSegment.rx.selectedSegmentIndex
                    .subscribe(onNext: { [weak self] gender in
                        guard let self else { return }
                        self.viewModel.playerCellGenderSegment.accept((
                            gender: gender == 0,
                            index: indexPath.row - 1
                        ))
                    })
                    .disposed(by: cell.disposeBag)
                return cell
            }
        }
    }
}

extension CommonDataViewController: UITextFieldDelegate {
    func textFieldDidEndEditing(_ textField: UITextField) {
        let result: ValidationResult = validationManager.validate(textField.text ?? "")
        if result != .valid {
            self.warningAlertView(withTitle: "グループ名が登録できません")
            viewModel.groupName.accept("グループ")
        }
    }
    @objc
    func adjustForKeyboard(notification: Notification) {
        guard let keyboardValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }

        let keyboardScreenEndFrame = keyboardValue.cgRectValue
        let keyboardViewEndFrame = view.convert(keyboardScreenEndFrame, from: view.window)

        if notification.name == UIResponder.keyboardWillHideNotification {
            tableView.contentInset = .zero
        } else {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardViewEndFrame.height - view.safeAreaInsets.bottom, right: 0)
        }

        tableView.scrollIndicatorInsets = tableView.contentInset
    }
}
