//
//  UIViewController+TopMostController.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/3/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension UIWindow {
  func topViewController(forViewController viewController: UIViewController) -> UIViewController {
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

  func topViewController() -> UIViewController? {
    guard let rootViewController = rootViewController else {
      return nil
    }
    return topViewController(forViewController: rootViewController)
  }
}
