//
//  UIApplication+Window.swift
//  RMessage
//
//  Created by Adonis Peralta on 6/27/25.
//

import UIKit

extension UIApplication {
  var connectedScenesFirstKeyWindow: UIWindow? {
    connectedScenes
      .flatMap { ($0 as? UIWindowScene)?.windows ?? [] }
      .first { $0.isKeyWindow }
  }
}
