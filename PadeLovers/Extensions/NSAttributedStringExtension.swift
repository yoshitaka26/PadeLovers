//
//  NSAttributedStringExtension.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/06/05.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

extension NSAttributedString {
    static func setNameOnLabel(name: String, gender: Bool = true) -> NSAttributedString {
        NSAttributedString(string: name, attributes: [.foregroundColor: gender ? UIColor.black : UIColor.red])
    }
}
