//
//  ShareGameViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/05/20.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class ShareGameViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let token = AccessToken.current,
            !token.isExpired {
            // User is logged in, do work such as go to next view controller.
        }
        
        view.backgroundColor = .white
        let loginButton = FBLoginButton()
        loginButton.permissions = ["public_profile", "email"]
        loginButton.center = view.center
        view.addSubview(loginButton)
    }
}
