//
//  RMAnimationOptions.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/11/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

protocol RMAnimationOptions {
  var presentationDuration: Double { get set }
  var dismissalDuration: Double { get set }
}

struct DefaultRMAnimationOptions: RMAnimationOptions {
  var presentationDuration = 0.5
  var dismissalDuration = 0.3
}
