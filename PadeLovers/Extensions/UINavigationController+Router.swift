//
//  UINavigationController+Router.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/06/11.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit

extension UINavigationController {
    func pushScreen(_ screen: Screen) {
        switch screen {
        case .gameViewQuestion:
            let storyboard = UIStoryboard(name: "HowToUseDetail", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "HowToUseDetail")
            pushViewController(vc, animated: true)
//            setNavigationBarHidden(false, animated: true)
        default:
            break
        }
    }
}
