//
//  MenuViewModel.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/07.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//
import RxSwift
import RxCocoa

enum MenuTransition {
    case setting
    case gameStart
    case generateNumbers
    case padelData
}

class MenuViewModel: BaseViewModel {
    override init() {
        super.init()
        self.mutate()
    }
    let settingButtonSelect = PublishSubject<Void>()
    let gameButtonSelect = PublishSubject<Void>()
    let randomNumbersButtonSelect = PublishSubject<Void>()
    let padelDataButtonSelect = PublishSubject<Void>()
    let behaviorTransition: BehaviorRelay<MenuTransition?> = BehaviorRelay(value: nil)
    var transition: Observable<MenuTransition?> {
        return behaviorTransition.asObservable()
    }
    func mutate() {
        settingButtonSelect.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.behaviorTransition.accept(.setting)
        }).disposed(by: disposeBag)
        gameButtonSelect.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.behaviorTransition.accept(.gameStart)
        }).disposed(by: disposeBag)
        randomNumbersButtonSelect.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.behaviorTransition.accept(.generateNumbers)
        }).disposed(by: disposeBag)
        padelDataButtonSelect.subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.behaviorTransition.accept(.padelData)
        }).disposed(by: disposeBag)
    }
}
