//
//  PlayerTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/22.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift

final class PlayerTableViewCell: UITableViewCell {
    var disposeBag = DisposeBag()

    // swiftlint:disable private_outlet
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var genderSegment: UISegmentedControl!
    // swiftlint:enable private_outlet

    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
        genderSegment.rx.value.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.genderSegment.selectedSegmentTintColor = value == 0 ? .appBlue : .appRed
        }).disposed(by: disposeBag)
    }

    func set(name: String?, gender: Bool) {
        self.nameTextField.text = name
        self.genderSegment.selectedSegmentIndex = gender ? 0 : 1
        self.genderSegment.selectedSegmentTintColor = gender ? .appBlue : .appRed
    }
}
