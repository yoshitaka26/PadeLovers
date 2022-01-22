//
//  CourtTableViewCell.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/22.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit
import RxSwift

final class CourtTableViewCell: UITableViewCell {

    var disposeBag = DisposeBag()
    
    // swiftlint:disable private_outlet
    @IBOutlet weak var numberLabel: UILabel!
    @IBOutlet weak var courtName: UITextField!
    // swiftlint:enable private_outlet
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.disposeBag = DisposeBag()
    }
}
