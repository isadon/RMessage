//
//  RMControllerDelegate.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol RMControllerDelegate: class {
  /// Implement this function to have a chance in further customizing a message prior to presentation.
  ///
  /// - Parameter message: The message to customize.
  @objc optional func customize(message: RMessage, controller: RMController)
}
