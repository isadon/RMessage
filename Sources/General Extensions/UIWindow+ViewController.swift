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
    if let presented = viewController.presentedViewController {
      return topViewController(forViewController: presented)
    } else if let navigationController = viewController as? UINavigationController,
      let topVCInNavigationVC = navigationController.topViewController {
      return topViewController(forViewController: topVCInNavigationVC)
    } else if let tabBarController = viewController as? UITabBarController,
      let selectedVCInTabBarVC = tabBarController.selectedViewController {
      return topViewController(forViewController: selectedVCInTabBarVC)
    }
    
    return viewController
  }

  /// Returns the top view controller in the window going up from the root view controller of the window.
  ///
  /// - Returns: The top view controller in the window.
  static func topViewController() -> UIViewController? {
    guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
      return nil
    }
    return topViewController(forViewController: rootViewController)
  }
}
