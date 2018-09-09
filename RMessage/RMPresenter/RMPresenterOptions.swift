//
//  RMPresenterOptions.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/11/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation

/** Protocol describing options to be passed to presenters of messages for customizing presentation details.

 - NOTE: Presenters are different than animators in that animators simply animate the message's presentation or dismissal,
 while presenters handle other details such as *how long* a message stays presented etc.
 */
protocol RMPresenterOptions {
  var onScreenTime: Double { get set }
  var extraOnScreenTimePerPixel: Double { get set }
}

/// Default RMPresenterOptions constructor object.
struct DefaultRMPresenterOptions: RMPresenterOptions {
  var onScreenTime = 1.5
  var extraOnScreenTimePerPixel = 0.04
}
