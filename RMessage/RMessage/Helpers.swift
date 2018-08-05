//
//  Helpers.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

func bundledImage(withName name: String, forClass classObj: AnyClass) -> UIImage? {
  guard let imagePath = Bundle(for: classObj).path(forResource: name, ofType: nil) else {
    return UIImage(named: name)
  }
  return UIImage(contentsOfFile: imagePath)
}

func defaultViewControllerForPresentation() -> UIViewController {
  guard let defaultViewController = UIApplication.shared.keyWindow?.topViewController() else {
    assert(false, "Key window should always have a root view controller")
    return UIViewController()
  }
  return defaultViewController
}
