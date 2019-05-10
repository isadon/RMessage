//
//  UIWindow+ViewController.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/3/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
  /// Returns the top view controller in the window going up from the passed in view controller.
  ///
  /// - Parameter viewController: The view controller from which to start traversing.
  /// - Returns: The top view controller in the window.
  static func topViewController(forViewController viewController: UIViewController) -> UIViewController {

    if let navController = viewController as? UINavigationController,
      let navTopVC = navController.topViewController, !navTopVC.isKind(of: UIAlertController.self) {

      return topViewController(forViewController: navTopVC)
    }

    if let presented = viewController.presentedViewController, !presented.isKind(of: UIAlertController.self) {
      return topViewController(forViewController: presented)
    }

    if let tabBarController = viewController as? UITabBarController,
      let selectedTabBarVC = tabBarController.selectedViewController {

      return topViewController(forViewController: selectedTabBarVC)
    }

    return viewController
  }

  /// Returns the top view controller in the window going up from the root view controller of the window.
  ///
  /// - Returns: The top view controller in the window.
  static func topViewController() -> UIViewController? {
    guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else { return nil }

    return topViewController(forViewController: rootViewController)
  }
}
