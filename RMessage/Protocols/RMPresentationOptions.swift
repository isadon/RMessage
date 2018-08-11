//
//  RPresentationOptions.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/11/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

protocol RMPresentationOptions {
  var onScreenTime: Double { get set }
  var extraOnScreenTimePerPixel: Double { get set }
}

struct RMPresentationOptionsDefault: RMPresentationOptions {
  var onScreenTime = 1.5
  var extraOnScreenTimePerPixel = 0.04
}
