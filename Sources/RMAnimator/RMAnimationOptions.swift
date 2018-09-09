//
//  RMAnimationOptions.swift
//
//  Created by Adonis Peralta on 8/11/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

protocol RMAnimationOptions {
  /// The duration of the message presentation animation.
  var presentationDuration: Double { get set }

  /// The duration of the message dismissal animation.
  var dismissalDuration: Double { get set }
}

/// Default RManimationOptions constructor object.
struct DefaultRMAnimationOptions: RMAnimationOptions {
  var presentationDuration = 0.5
  var dismissalDuration = 0.3
}
