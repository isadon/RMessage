//
//  RMPresenterOptions.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/11/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

protocol RMPresenterOptions {
  var onScreenTime: Double { get set }
  var extraOnScreenTimePerPixel: Double { get set }
}

struct DefaultRMPresenterOptions: RMPresenterOptions {
  var onScreenTime = 1.5
  var extraOnScreenTimePerPixel = 0.04
}
