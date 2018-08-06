//
//  RMessage+Components.swift
//  RMessageDemo
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension RMessage {
  func setupComponents() {
    setupLeftView()
    setupRightView()
    setupBackgroundView()
    setupBlurBackgroundView()

    // Instatiate left views and background views from iconImage and backgroundImage passed in through
    // message spec. These will only be generated if the user does not programmatically pass in a leftView
    // or background view.
    if leftView == nil, spec.iconImage != nil { setupIconImageView() }
    if backgroundView == nil, spec.backgroundImage != nil { setupBackgroundImageView() }
  }

  func setupLeftView() {
    guard let leftView = leftView else {
      return
    }

    leftView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(leftView)

    leftView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    leftView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 15).isActive = true
    leftView.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -15).isActive = true
    leftView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10).isActive = true
    leftView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true
  }

  func setupRightView() {
    guard let rightView = rightView else {
      return
    }

    rightView.translatesAutoresizingMaskIntoConstraints = false

    addSubview(rightView)

    rightView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    rightView.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15).isActive = true
    let rightViewTrailingOptConstraint = rightView.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -15
    )
    rightViewTrailingOptConstraint.priority = UILayoutPriority(rawValue: 749)
    rightViewTrailingOptConstraint.isActive = true

    rightView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15).isActive = true
    rightView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10).isActive = true
    rightView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true
  }

  func setupBackgroundView() {
    guard let backgroundView = backgroundView else {
      return
    }

    backgroundView.translatesAutoresizingMaskIntoConstraints = false

    insertSubview(backgroundView, at: 0)

    let hConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[backgroundView]-0-|",
      options: [], metrics: nil,
      views: ["backgroundView": backgroundView]
    )
    let vConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[backgroundView]-0-|",
      options: [], metrics: nil,
      views: ["backgroundView": backgroundView]
    )
    NSLayoutConstraint.activate([hConstraints, vConstraints].flatMap { $0 })
  }

  func setupBlurBackgroundView() {
    guard spec.blurBackground == true else {
      return
    }
    assert(superview != nil, "RMessage instance must have a superview by this point!")

    /* As per apple docs when using UIVisualEffectView and blurring the superview of the blur view
     must have an opacity of 1.f */
    targetAlpha = 1

    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)
    blurView.translatesAutoresizingMaskIntoConstraints = false

    insertSubview(blurView, at: 0)

    let hConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[blurBackgroundView]-0-|", options: [],
      metrics: nil, views: ["blurBackgroundView": blurView]
    )
    let vConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[blurBackgroundView]-0-|", options: [],
      metrics: nil, views: ["blurBackgroundView": blurView]
    )
    NSLayoutConstraint.activate([hConstraints, vConstraints].flatMap { $0 })
  }

  func setupIconImageView() {
    guard let iconImage = spec.iconImage else {
      return
    }

    assert(leftView == nil, "Background view must be nil, if user is programmatically passing in a leftView this function should not be called.")

    let iconImageView = UIImageView(image: iconImage)

    iconImageView.clipsToBounds = true
    iconImageView.tintColor = spec.iconImageTintColor
    iconImageView.contentMode = .scaleAspectFit
    iconImageView.translatesAutoresizingMaskIntoConstraints = false

    leftView = iconImageView
    messageSpecIconImageViewSet = true
    setupLeftView()
  }

  func setupBackgroundImageView() {
    guard let backgroundImage = spec.backgroundImage else {
      return
    }
    assert(backgroundView == nil, "Background view must be nil, if user is programmatically passing in a backgroundView this function should not be called.")

    let resizeableImage = backgroundImage.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
    let backgroundImageView = UIImageView(image: resizeableImage)
    backgroundImageView.clipsToBounds = true
    backgroundImageView.contentMode = .scaleToFill

    backgroundView = backgroundImageView
    messageSpecBackgroundImageViewSet = true
    setupBackgroundView()
  }
}
