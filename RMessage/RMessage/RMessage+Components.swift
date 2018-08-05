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
    setupIconImageView()
    setupButton()
    setupBackgroundImageView()
    setupBlurBackground()
  }

  func setupIconImageView() {
    guard let iconImage = spec.iconImage else {
      return
    }

    self.iconImage = iconImage
    iconImageView = UIImageView(image: iconImage)

    iconImageView!.clipsToBounds = true
    iconImageView!.tintColor = spec.iconImageTintColor
    iconImageView!.contentMode = .scaleAspectFit
    iconImageView!.translatesAutoresizingMaskIntoConstraints = false

    addSubview(iconImageView!)

    iconImageView!.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    iconImageView!.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor, constant: 15).isActive = true
    iconImageView!.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -15).isActive = true
    iconImageView!.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10).isActive = true
    iconImageView!.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true
  }

  func setupButton() {
    guard let button = button else {
      return
    }

    button.translatesAutoresizingMaskIntoConstraints = false

    addSubview(button)

    button.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    button.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15).isActive = true
    let buttonTrailingOptConstraint = button.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -15
    )
    buttonTrailingOptConstraint.priority = UILayoutPriority(rawValue: 749)
    buttonTrailingOptConstraint.isActive = true

    button.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor, constant: -15).isActive = true
    button.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true
    button.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 10).isActive = true
  }

  func setupBackgroundImageView() {
    guard let backgroundImage = spec.backgroundImage else {
      return
    }
    assert(superview != nil, "RMessage instance must have a superview by this point!")

    let resizeableImage = backgroundImage.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
    backgroundImageView = UIImageView(image: resizeableImage)
    backgroundImageView!.translatesAutoresizingMaskIntoConstraints = false
    backgroundImageView!.contentMode = .scaleToFill

    insertSubview(backgroundImageView!, at: 0)

    let hConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[backgroundImageView]-0-|",
      options: [], metrics: nil,
      views: ["backgroundImageView": backgroundImageView!]
    )
    let vConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[backgroundImageView]-0-|",
      options: [], metrics: nil,
      views: ["backgroundImageView": backgroundImageView!]
    )
    NSLayoutConstraint.activate([hConstraints, vConstraints].flatMap { $0 })
  }

  func setupBlurBackground() {
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
}
