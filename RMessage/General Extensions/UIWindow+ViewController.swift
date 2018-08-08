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
  static func topViewController(forViewController viewController: UIViewController) -> UIViewController {
    if viewController.presentedViewController != nil {
      return topViewController(forViewController: viewController.presentedViewController!)
    } else if let navigationController = viewController as? UINavigationController,
      let visibleVCInNavigationVC = navigationController.visibleViewController {
      return topViewController(forViewController: visibleVCInNavigationVC)
    } else if let tabBarController = viewController as? UITabBarController,
      let selectedVCInTabBarVC = tabBarController.selectedViewController {
      return topViewController(forViewController: selectedVCInTabBarVC)
    }
    return viewController
  }

  static func topViewController() -> UIViewController? {
    guard let rootViewController = UIApplication.shared.keyWindow?.rootViewController else {
      return nil
    }
    return topViewController(forViewController: rootViewController)
  }

  static func defaultViewControllerForPresentation() -> UIViewController {
    guard let defaultViewController = UIWindow.topViewController() else {
      assert(false, "Key window should always have a root view controller")
      return UIViewController()
    }
    return defaultViewController
  }
}
