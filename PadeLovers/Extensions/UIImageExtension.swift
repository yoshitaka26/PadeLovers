//
//  UIImageExtension.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/07/04.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

extension UIImage {
    static func named(_ name: String) -> UIImage {
        if let image = UIImage(systemName: name) {
            return image
        } else {
            fatalError("Could not initialize \(UIImage.self) named \(name).")
        }
    }
    func resize(width: CGFloat, height: CGFloat) -> UIImage? {
        let resizedSize = CGSize(width: width, height: height)
        UIGraphicsBeginImageContextWithOptions(resizedSize, false, 0.0)
        draw(in: CGRect(origin: .zero, size: resizedSize))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }
}
