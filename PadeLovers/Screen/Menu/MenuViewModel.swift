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
    case gameRestart
}

class MenuViewModel: BaseViewModel {
    override init() {
        super.init()
        self.mutate()
    }
    let settingButtonSelect = PublishSubject<Void>()
    let gameButtonSelect = PublishSubject<Void>()
    let restartButtonSelect = PublishSubject<Void>()
    let behaviorTransition: BehaviorRelay<MenuTransition?> = BehaviorRelay(value: nil)
    var transition: Observable<MenuTransition?> {
        return behaviorTransition.asObservable()
    }
    func mutate() {
        settingButtonSelect.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.behaviorTransition.accept(.setting)
        }).disposed(by: disposeBag)
        gameButtonSelect.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.behaviorTransition.accept(.gameStart)
        }).disposed(by: disposeBag)
        restartButtonSelect.asObservable().subscribe(onNext: { [weak self] _ in
            guard let self = self else { return }
            self.behaviorTransition.accept(.gameRestart)
        }).disposed(by: disposeBag)
    }
}
