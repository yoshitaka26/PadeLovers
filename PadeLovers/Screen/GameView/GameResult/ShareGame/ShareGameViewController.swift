//
//  ShareGameViewController.swift
//  PadeLovers
//
//  Created by Yoshitaka Tanaka on 2022/05/20.
//  Copyright © 2022 Yoshitaka. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import LineSDK

class ShareGameViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        if let token = AccessToken.current,
           !token.isExpired {
            print(token.userID)
            // User is logged in, do work such as go to next view controller.
        }

        view.backgroundColor = .white

        // Create Facebook Login Button.
        let loginFBButton = FBLoginButton()
        loginFBButton.permissions = ["public_profile", "email"]
        loginFBButton.delegate = self
        loginFBButton.center = view.center
        view.addSubview(loginFBButton)
        
        // Create LINE Login Button.
        let loginLINEButton = LoginButton()
        loginLINEButton.delegate = self
        loginLINEButton.permissions = [.profile]
        loginLINEButton.presentingViewController = self
        view.addSubview(loginLINEButton)
        loginLINEButton.translatesAutoresizingMaskIntoConstraints = false
        loginLINEButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginLINEButton.topAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
    }
}

extension ShareGameViewController: FBSDKLoginKit.LoginButtonDelegate {
    func loginButton(_ loginButton: FBLoginButton, didCompleteWith result: LoginManagerLoginResult?, error: Error?) {
        switch (result?.isCancelled, error) {
        case (_, .some(let error)):
            print(error)
        case (true, .none):
            print("エラー")
        case (_, .none):
            print("ログイン")
            let accessToken = AccessToken.current
        }
    }
    func loginButtonDidLogOut(_ loginButton: FBLoginButton) {
        print("ログアウト")
    }
}

extension ShareGameViewController: LineSDK.LoginButtonDelegate {
    func loginButton(_ button: LoginButton, didSucceedLogin loginResult: LineSDK.LoginResult) {
        //        hideIndicator()
                print("Login Succeeded.")
        let profileEnabled = loginResult.permissions.contains(.profile)
        if let profile = loginResult.userProfile {
            print("User ID: \(profile.userID)")
            print("User Display Name: \(profile.displayName)")
            print("User Icon: \(String(describing: profile.pictureURL))")
        }    }
    func loginButton(_ button: LoginButton, didFailLogin error: LineSDKError) {
        if error.isUserCancelled {
            // User cancelled the login process himself/herself.
            
        } else if error.isPermissionError {
            // Equivalent to checking .responseFailed.invalidHTTPStatusAPIError
            // with code 403. Should login again.
            
        } else if error.isURLSessionTimeOut {
            // Underlying request timeout in URL session. Should try again later.
            
        } else if error.isRefreshTokenError {
            // User is accessing a public API with expired token, LINE SDK tried to
            // refresh the access token automatically, but failed (due to refresh token)
            // also expired. Should login again.
            
        } else {
            // Any other errors.
            print("\(error)")
        }
        print("Error: \(error)")
    }
    
    func loginButtonDidStartLogin(_ button: LoginButton) {
//        showIndicator()
        print("Login Started.")
    }
}
