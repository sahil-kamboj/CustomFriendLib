//
//  UIViewController.swift
//
//  Created by Lakhwinder Singh on 23/02/17.
//  Copyright © 2017 paige. All rights reserved.
//

import UIKit

extension UIViewController {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    func isPresentedModally() -> Bool {
        return self.presentingViewController?.presentedViewController == self
    }
    
    func findContentViewControllerRecursively() -> UIViewController {
        var childViewController: UIViewController?
        if (self is UITabBarController) {
            childViewController = (self as? UITabBarController)?.selectedViewController
        }
        else if (self is UINavigationController) {
            childViewController = (self as? UINavigationController)?.topViewController
        }
        else if (self is UISplitViewController) {
            childViewController = (self as? UISplitViewController)?.viewControllers.last
        }
        else if (self.presentedViewController != nil) {
            childViewController = self.presentedViewController
        }
        let shouldContinueSearch: Bool = (childViewController != nil) && !((childViewController?.isKind(of: UIAlertController.self))!)
        return shouldContinueSearch ? childViewController!.findContentViewControllerRecursively() : self
    }
    
    func customAddChildViewController(_ child: UIViewController) {
        self.customAddChildViewController(child, toSubview: self.view)
    }
    
    func customAddChildViewController(_ child: UIViewController, toSubview subview: UIView) {
        self.addChildViewController(child)
        subview.addSubview(child.view)
        child.view.addConstraintToFillSuperview()
        child.didMove(toParentViewController: self)
    }
    
    func customRemoveFromParentViewController() {
        self.willMove(toParentViewController: nil)
        self.view.removeFromSuperview()
        self.removeFromParentViewController()
    }
    
    func customRemoveAllChildViewControllers() {
        for control: UIViewController in self.childViewControllers {
            control.customRemoveFromParentViewController()
        }
    }

    func popOrDismissViewController(_ animated: Bool) {
        if self.isPresentedModally() {
            self.dismiss(animated: animated, completion:nil)
        } else if (self.navigationController != nil) {
            _ = self.navigationController?.popViewController(animated: animated)
        }
    }
}


