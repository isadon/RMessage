//
//  RControllerDelegate.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

@objc protocol RControllerDelegate: class {
  /// You can customize the given RMessage, like setting its alpha via (messageOpacity) or adding a subview
  @objc optional func customize(message: RMessage)
}
