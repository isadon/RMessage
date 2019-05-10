//
//  RMessage+Components.swift
//
//  Created by Adonis Peralta on 8/6/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

extension RMessage {
  func iconImageView(withImage image: UIImage, imageTintColor: UIColor?, superview: UIView) -> UIImageView {
    let iconImageView = UIImageView(image: image)
    iconImageView.clipsToBounds = true
    iconImageView.tintColor = imageTintColor
    iconImageView.contentMode = .scaleAspectFit

    setup(leftView: iconImageView, inSuperview: superview)
    return iconImageView
  }

  func setup(leftView view: UIView, inSuperview superview: UIView) {
    superview.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      view.leadingAnchor.constraint(greaterThanOrEqualTo: superview.leadingAnchor, constant: 15),
      view.trailingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: -15),
      view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: 10),
      view.bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor, constant: -10)
      ])
  }

  func setup(rightView view: UIView, inSuperview superview: UIView) {
    superview.addSubview(view)
    view.translatesAutoresizingMaskIntoConstraints = false

    let viewTrailingOptConstraint = view.trailingAnchor.constraint(
      equalTo: contentView.trailingAnchor,
      constant: -15
    )
    viewTrailingOptConstraint.priority = UILayoutPriority(rawValue: 749)

    NSLayoutConstraint.activate([
      view.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      view.leadingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: 15),
      view.trailingAnchor.constraint(lessThanOrEqualTo: superview.trailingAnchor, constant: -15),
      view.topAnchor.constraint(greaterThanOrEqualTo: superview.topAnchor, constant: 10),
      view.bottomAnchor.constraint(lessThanOrEqualTo: superview.bottomAnchor, constant: -10),
      viewTrailingOptConstraint
      ])
  }

  func backgroundImageView(withImage image: UIImage, superview: UIView) -> UIImageView {
    let resizeableImage = image.resizableImage(withCapInsets: .zero, resizingMode: .stretch)
    let backgroundImageView = UIImageView(image: resizeableImage)
    backgroundImageView.clipsToBounds = true
    backgroundImageView.contentMode = .scaleToFill
    setup(backgroundView: backgroundImageView, inSuperview: superview)
    return backgroundImageView
  }

  func setup(backgroundView view: UIView, inSuperview superview: UIView) {
    superview.insertSubview(view, at: 0)
    view.translatesAutoresizingMaskIntoConstraints = false

    let hConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "H:|-0-[backgroundView]-0-|",
      options: [], metrics: nil,
      views: ["backgroundView": view]
    )
    let vConstraints = NSLayoutConstraint.constraints(
      withVisualFormat: "V:|-0-[backgroundView]-0-|",
      options: [], metrics: nil,
      views: ["backgroundView": view]
    )
    NSLayoutConstraint.activate([hConstraints, vConstraints].flatMap { $0 })
  }

  func setupBlurBackgroundView(inSuperview superview: UIView) {
    let blurEffect = UIBlurEffect(style: .light)
    let blurView = UIVisualEffectView(effect: blurEffect)

    superview.insertSubview(blurView, at: 0)
    blurView.translatesAutoresizingMaskIntoConstraints = false

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
