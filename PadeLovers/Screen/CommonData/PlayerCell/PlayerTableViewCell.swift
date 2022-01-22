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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.genderSegment.selectedSegmentTintColor = self.genderSegment.selectedSegmentIndex != 0 ? .appRed : .appBlue
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
        genderSegment.rx.value.subscribe(onNext: { [weak self] value in
            guard let self = self else { return }
            self.genderSegment.selectedSegmentTintColor = value != 0 ? .appRed : .appBlue
        }).disposed(by: disposeBag)
    }
}
