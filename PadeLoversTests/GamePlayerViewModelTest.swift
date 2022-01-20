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
    
    var expect: XCTestExpectation!
    var commonDataBrain = CommonDataBrain.shared
    let coreDataManager = CoreDataManager.shared
    let viewModel = GamePlayerViewModel()
    
    override func setUpWithError() throws {
//        expect = expectation(description: "")
        
        if commonDataBrain.loadPlayers(group: TableType.group1) != nil {
            viewModel.dataBind.onNext((TableType.group1, UUID()))
        } else {
            var playerData: [CommonPlayerDataModel] = []
            for i in 0...20 {
                let data = CommonPlayerDataModel(name: "\(i)", gender: true)
                playerData.append(data)
            }
            commonDataBrain.savePlayers(group: TableType.group1, players: playerData)
            }
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        viewModel.playModeAisChanged.onNext(true)
        
        XCTAssertEqual(viewModel.playModeA.value, true)
        XCTAssertEqual(viewModel.playModeB.value, false)
        
//        waitForExpectations(timeout: 0.1, handler: nil)
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
