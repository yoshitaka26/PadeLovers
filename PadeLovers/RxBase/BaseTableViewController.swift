//
//  BaseTableViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/07.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class BaseTableViewController: UITableViewController {
    var disposeBag = DisposeBag()
    let rxViewDidLoad = PublishSubject<Void>()
    let rxViewWillAppear = PublishSubject<Void>()
    let rxViewDidAppear = PublishSubject<Void>()
    let rxviewDidLayoutSubviews = PublishSubject<Void>()
    let rxViewWillDisappear = PublishSubject<Void>()
    let rxViewDidDisappear = PublishSubject<Void>()

    func bind() {
        fatalError("Must Override")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
      rxViewDidLoad.onNext(())
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rxViewWillAppear.onNext(())
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        rxViewDidAppear.onNext(())
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        rxviewDidLayoutSubviews.onNext(())
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        rxViewWillDisappear.onNext(())
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        rxViewDidDisappear.onNext(())
    }
}
