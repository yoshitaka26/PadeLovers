//
//  UIViewController+Common.swift
//  PadeLovers
//
//  Created by Yoshitaka on 2021/05/07.
//  Copyright © 2021 Yoshitaka. All rights reserved.
//

import UIKit

extension UIViewController: UIPopoverPresentationControllerDelegate {
    public func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    func createBarButtonItem(image: UIImage, select: Selector?) -> UIBarButtonItem {
        let button = UIButton(type: .custom)
        button.setImage(image, for: .normal)
        button.tintColor = .darkGray
        if let safeSelect = select {
            button.addTarget(self, action: safeSelect, for: .touchUpInside)
        }
        let barButtonItem = UIBarButtonItem(customView: button)
        return barButtonItem
    }
    
    func openReplaceWindow(windowNavigation: UIViewController, modalSize: CGSize) {
        let selectWindowContentSize = modalSize
        let windowRect = CGRect(x: view.center.x, y: 0,
                                width: selectWindowContentSize.width,
                                height: selectWindowContentSize.height)
        windowNavigation.modalPresentationStyle = .popover
        windowNavigation.preferredContentSize = windowRect.size
        windowNavigation.popoverPresentationController?.delegate = self
        windowNavigation.popoverPresentationController?.sourceView = view
        windowNavigation.popoverPresentationController?.sourceRect = windowRect
        windowNavigation.popoverPresentationController?.permittedArrowDirections = []
        windowNavigation.popoverPresentationController?.canOverlapSourceViewRect = false
        present(windowNavigation, animated: true, completion: nil)
    }
    
    func openPopUpController(popUpController: UIViewController, sourceView: UIView, rect: CGRect, arrowDirections: UIPopoverArrowDirection, canOverlapSourceViewRect: Bool) {
        popUpController.modalPresentationStyle = .popover
        popUpController.preferredContentSize = rect.size
        popUpController.popoverPresentationController?.delegate = self
        popUpController.popoverPresentationController?.sourceView = sourceView
        popUpController.popoverPresentationController?.sourceRect = CGRect(x: 300, y: 40, width: sourceView.frame.size.width / 2, height: 0)
        popUpController.popoverPresentationController?.permittedArrowDirections = arrowDirections
        popUpController.popoverPresentationController?.canOverlapSourceViewRect = canOverlapSourceViewRect
        present(popUpController, animated: true, completion: nil)
    }
    
    public func modalToTop(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Swift.Void)? = nil) {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            let topViewController = getTopPresentedViewController(rootViewController)
            topViewController.present(viewControllerToPresent, animated: flag, completion: completion)
        }
    }
    
    public func closeModal() {
        if let rootViewController = UIApplication.shared.delegate?.window??.rootViewController {
            if let presented = rootViewController.presentedViewController {
                presented.dismiss(animated: false, completion: { [weak self] in
                    self?.closeModal()
                })
            }
        }
    }
    
    func getTopPresentedViewController(_ viewController: UIViewController) -> UIViewController {
        if let presentedViewController = viewController.presentedViewController {
            return getTopPresentedViewController(presentedViewController)
        } else {
            return viewController
        }
    }
    
    func confirmationAlertView(withTitle: String?,
                               message: String? = nil,
                               cancelString: String? = nil,
                               cancelBlock: (() -> Void)? = nil,
                               confirmString: String? = nil,
                               confirmBlock: (() -> Void)? = nil) {
        UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            .addCancelAction(title: cancelString, handler: cancelBlock)
            .addOkAction(title: confirmString, handler: confirmBlock)
            .show(in: self)
    }
    
    func warningAlertView(withTitle: String?, message: String? = nil, action: (() -> Void)? = nil) {
        UIAlertController(title: withTitle, message: message, preferredStyle: .alert)
            .addCancelAction(title: DIALOG_OK, handler: action)
            .show(in: self)
    }
    // 表示とともにタイマーをセットする
    func infoAlertViewWithTitle(title: String, message: String? = nil, afterDismiss: (() -> Void)? = nil) {
        let infoAlert = InfoAlertView(title: title, message: message, preferredStyle: .alert)
        infoAlert.afterDismiss = afterDismiss
        infoAlert.show(in: self) {
            infoAlert.timerStart()
        }
    }
}
