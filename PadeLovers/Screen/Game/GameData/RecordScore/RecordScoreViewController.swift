//
//  RecordScoreViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/17.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

protocol RecordScoreViewControllerDelegate: AnyObject {
    func returnFromRecordScoreViewController()
}

final class RecordScoreViewController: BaseViewController {
    weak var delegate: RecordScoreViewControllerDelegate?
    var gameData: Game?
    
    @IBOutlet private weak var driveAname: UILabel!
    @IBOutlet private weak var backAname: UILabel!
    @IBOutlet private weak var driveBname: UILabel!
    @IBOutlet private weak var backBname: UILabel!
    
    @IBOutlet private weak var A1MinusButton: UIButton!
    @IBOutlet private weak var A1PlusButton: UIButton!
    @IBOutlet private weak var A1Score: UILabel!
    @IBOutlet private weak var B1MinusButton: UIButton!
    @IBOutlet private weak var B1PlusButton: UIButton!
    @IBOutlet private weak var B1Score: UILabel!
    @IBOutlet private weak var A2MinusButton: UIButton!
    @IBOutlet private weak var A2PlusButton: UIButton!
    @IBOutlet private weak var A2Score: UILabel!
    @IBOutlet private weak var B2MinusButton: UIButton!
    
    @IBOutlet private weak var B2PlusButton: UIButton!
    @IBOutlet private weak var B2Score: UILabel!
    @IBOutlet private weak var A3MinusButton: UIButton!
    
    @IBOutlet private weak var A3PlusButton: UIButton!
    @IBOutlet private weak var A3Score: UILabel!
    @IBOutlet private weak var B3MinusButton: UIButton!
    
    @IBOutlet private weak var B3PlusButton: UIButton!
    @IBOutlet private weak var B3Score: UILabel!
    @IBOutlet private weak var ATotalScore: UILabel!
    @IBOutlet private weak var BTotalScore: UILabel!
    
    @IBOutlet private weak var timeLabel: UILabel!
    private let viewModel = RecordScoreViewModel()
    
    @IBOutlet private weak var doneButton: UIButton!
    
    override func bind() {
        disposeBag.insert(
            viewModel.driveAname.bind(to: driveAname.rx.attributedText),
            viewModel.backAname.bind(to: backAname.rx.attributedText),
            viewModel.driveBname.bind(to: driveBname.rx.attributedText),
            viewModel.backBname.bind(to: backBname.rx.attributedText),
            A1MinusButton.rx.tap.bind(to: viewModel.A1Minus),
            A1PlusButton.rx.tap.bind(to: viewModel.A1Plus),
            B1MinusButton.rx.tap.bind(to: viewModel.B1Minus),
            B1PlusButton.rx.tap.bind(to: viewModel.B1Plus),
            A2MinusButton.rx.tap.bind(to: viewModel.A2Minus),
            A2PlusButton.rx.tap.bind(to: viewModel.A2Plus),
            B2MinusButton.rx.tap.bind(to: viewModel.B2Minus),
            B2PlusButton.rx.tap.bind(to: viewModel.B2Plus),
            A3MinusButton.rx.tap.bind(to: viewModel.A3Minus),
            A3PlusButton.rx.tap.bind(to: viewModel.A3Plus),
            B3MinusButton.rx.tap.bind(to: viewModel.B3Minus),
            B3PlusButton.rx.tap.bind(to: viewModel.B3Plus),
            viewModel.A1ScoreString.bind(to: A1Score.rx.text),
            viewModel.B1ScoreString.bind(to: B1Score.rx.text),
            viewModel.A2ScoreString.bind(to: A2Score.rx.text),
            viewModel.B2ScoreString.bind(to: B2Score.rx.text),
            viewModel.A3ScoreString.bind(to: A3Score.rx.text),
            viewModel.B3ScoreString.bind(to: B3Score.rx.text),
            viewModel.totalAScoreString.bind(to: ATotalScore.rx.text),
            viewModel.totalBScoreString.bind(to: BTotalScore.rx.text),
            viewModel.timeLabel.bind(to: timeLabel.rx.text),
            doneButton.rx.tap.bind(to: viewModel.doneButtonPressed)
        )
        
        rxViewDidLoad.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.doneButton.layer.cornerRadius = self.doneButton.frame.size.height / 4
            guard let game = self.gameData else { return }
            if let score = game.score {
                self.viewModel.bindDataWithScore.onNext((game, score))
            } else {
                self.viewModel.bindData.onNext(game)
            }
        }).disposed(by: disposeBag)
        viewModel.closeModalView.subscribe(onNext: { [weak self] in
            guard let self = self else { return }
            self.warningAlertView(withTitle: "試合結果を記録しました", action: {
                self.delegate?.returnFromRecordScoreViewController()
                self.dismiss(animated: true, completion: nil)
            })
        }).disposed(by: disposeBag)
    }
}
