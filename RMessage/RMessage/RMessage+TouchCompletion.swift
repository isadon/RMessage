//
//  RMessage+TouchCompletion.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension RMessage {
  func setupGestureRecognizers() {
    let gestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeMessageView))
    gestureRecognizer.direction = (targetPosition == .bottom) ? .down : .up
    addGestureRecognizer(gestureRecognizer)

    let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapMessageView))
    addGestureRecognizer(tapRecognizer)
  }

  @objc func didTapMessageView() {
    delegate?.messageViewTapped?(self)
    tapCompletion?()
    if spec.durationType != .endless && spec.durationType != .swipe { dismiss() }
  }

  /* called after the following gesture depending on message position during initialization
   UISwipeGestureRecognizerDirectionUp when message position set to Top,
   UISwipeGestureRecognizerDirectionDown when message position set to bottom */
  @objc func didSwipeMessage() {
    delegate?.messageSwiped?(self)
    if spec.durationType != .endless && spec.durationType != .tap { dismiss() }
  }
}
