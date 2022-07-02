//
//  GamePlayerViewModelTest.swift
//  PadeLoversTests
//
//  Created by Yoshitaka Tanaka on 2022/01/16.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import XCTest
import RxSwift
import RxRelay
import RxCocoa
@testable import PadeLovers

class GamePlayerViewModelTest: XCTestCase {
    
//    var expect: XCTestExpectation!
//    var commonDataBrain = CommonDataBrain.shared
//    let coreDataManager = CoreDataManager.shared
//    let viewModel = GameViewSettingViewModel()
//    var disposeBag = DisposeBag()
//
//    override func setUpWithError() throws {
//        if commonDataBrain.loadPlayers(group: TableType.group1) != nil {
//            viewModel.dataBind.onNext((TableType.group1, UUID()))
//        } else {
//            var playerData: [CommonPlayerDataModel] = []
//            for i in 0...20 {
//                let data = CommonPlayerDataModel(name: "\(i)", gender: true)
//                playerData.append(data)
//            }
//            commonDataBrain.savePlayers(group: TableType.group1, players: playerData)
//            }
//    }
//
//    override func tearDownWithError() throws { }
//
//    func test_試合モードが正常に変更されるか() throws {
//        viewModel.playModeAisChanged.onNext(true)
//        XCTAssertEqual(viewModel.playModeB.value, false)
//
//        viewModel.playModeAisChanged.onNext(false)
//        XCTAssertEqual(viewModel.playModeB.value, true)
//
//        viewModel.playModeBisChanged.onNext(true)
//        XCTAssertEqual(viewModel.playModeA.value, false)
//
//        viewModel.playModeBisChanged.onNext(false)
//        XCTAssertEqual(viewModel.playModeA.value, true)
//    }
//
//    func test_最小プレイヤ人数計算の整合性チェック() throws {
//        var testValue = 0
//        viewModel.courtBisON.accept(false)
//        viewModel.courtCisON.accept(false)
//        viewModel.pairingAisOn.accept(false)
//        viewModel.pairingBisOn.accept(false)
//
//        viewModel.minPlayerCounts.subscribe(onNext: { value in
//            testValue = value
//        }).disposed(by: disposeBag)
//
//        viewModel.courtAisON.accept(true)
//        XCTAssertEqual(testValue, 4)
//        viewModel.courtBisON.accept(true)
//        XCTAssertEqual(testValue, 8)
//        viewModel.courtCisON.accept(true)
//        XCTAssertEqual(testValue, 12)
//        viewModel.pairingAisOn.accept(true)
//        XCTAssertEqual(testValue, 14)
//        viewModel.pairingBisOn.accept(true)
//        XCTAssertEqual(testValue, 16)
//    }
//
//    func test_どれか一つのコートは必ずONになる() throws {
//        viewModel.courtAisON.accept(true)
//        viewModel.courtBisON.accept(false)
//        viewModel.courtCisON.accept(false)
//
//        viewModel.courtAisON.accept(false)
//        viewModel.courtAisChanged.onNext(false)
//        XCTAssertEqual(viewModel.courtAisON.value, true)
//
//        viewModel.courtAisON.accept(false)
//        viewModel.courtBisON.accept(true)
//        viewModel.courtCisON.accept(false)
//
//        viewModel.courtBisON.accept(false)
//        viewModel.courtBisChanged.onNext(false)
//        XCTAssertEqual(viewModel.courtAisON.value, true)
//
//        viewModel.courtAisON.accept(false)
//        viewModel.courtBisON.accept(false)
//        viewModel.courtCisON.accept(true)
//
//        viewModel.courtCisON.accept(false)
//        viewModel.courtCisChanged.onNext(false)
//        XCTAssertEqual(viewModel.courtAisON.value, true)
//    }
}
