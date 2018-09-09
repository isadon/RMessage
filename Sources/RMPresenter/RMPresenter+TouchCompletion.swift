//
//  RMPresenter+TouchCompletion.swift
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension RMPresenter {
  func setupGestureRecognizers() {
    let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeMessage))
    gestureRecognizer.direction = (targetPosition == .bottom) ? .down : .up
    message.addGestureRecognizer(gestureRecognizer)

    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMessage))
    message.addGestureRecognizer(tapRecognizer)
  }

  @objc func didTapMessage() {
    delegate?.messageTapped?(forPresenter: self, message: message)
    tapCompletion?()
    if message.spec.durationType != .endless && message.spec.durationType != .swipe { dismiss() }
  }

  /* called after the following gesture depending on message position during initialization
   UISwipeGestureRecognizerDirectionUp when message position set to Top,
   UISwipeGestureRecognizerDirectionDown when message position set to bottom */
  @objc func didSwipeMessage() {
    delegate?.messageSwiped?(forPresenter: self, message: message)
    if message.spec.durationType != .endless && message.spec.durationType != .tap { dismiss() }
  }
}
