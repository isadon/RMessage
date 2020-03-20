//
//  RMessage.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import HexColors
import UIKit

public class RMessage: UIView, RMessageAnimatorDelegate {
  static let bundle = Bundle(for: RMessage.self)

  private(set) var spec: RMessageSpec

  @IBOutlet private(set) var containerView: UIView!

  @IBOutlet private(set) var contentView: UIView!

  private(set) var leftView: UIView?
  private(set) var rightView: UIView?
  private(set) var backgroundView: UIView?

  @IBOutlet private(set) var titleLabel: UILabel!
  @IBOutlet private(set) var bodyLabel: UILabel!

  @IBOutlet private var titleBodyVerticalSpacingConstraint: NSLayoutConstraint!
  @IBOutlet private var titleLabelLeadingConstraint: NSLayoutConstraint!
  @IBOutlet private var titleLabelTrailingConstraint: NSLayoutConstraint!
  @IBOutlet private var bodyLabelLeadingConstraint: NSLayoutConstraint!
  @IBOutlet private var bodyLabelTrailingConstraint: NSLayoutConstraint!

  @IBOutlet private var contentViewTrailingConstraint: NSLayoutConstraint!

  private var messageSpecIconImageViewSet = false

  private var messageSpecBackgroundImageViewSet = false

  // MARK: Instance Methods

  init?(
    spec: RMessageSpec, title: String, body: String?, leftView: UIView? = nil, rightView: UIView? = nil,
    backgroundView: UIView? = nil
  ) {
    self.spec = spec
    self.leftView = leftView
    self.rightView = rightView
    self.backgroundView = backgroundView

    super.init(frame: CGRect.zero)

    guard RMessage.bundle.loadNibNamed("RMessage", owner: self, options: nil) != nil else {
      assertionFailure("Error loading the RMessage nib file for the RMessage class")
      return
    }

    layoutViews()

    titleLabel.text = title
    bodyLabel.text = body

    accessibilityIdentifier = String(describing: type(of: self))

    setupComponents(withMessageSpec: spec)
    setupDesign(withMessageSpec: spec, titleLabel: titleLabel, bodyLabel: bodyLabel)
  }

  public required init?(coder aDecoder: NSCoder) {
    spec = DefaultRMessageSpec()
    super.init(coder: aDecoder)
  }

  private func layoutViews() {
    addSubview(containerView)
    containerView.translatesAutoresizingMaskIntoConstraints = false

    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: topAnchor),
      containerView.bottomAnchor.constraint(equalTo: bottomAnchor),
      containerView.leadingAnchor.constraint(equalTo: leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: trailingAnchor)
      ])
  }

  private func setupComponents(withMessageSpec spec: RMessageSpec) {
    if let image = spec.iconImage, leftView == nil {
      leftView = iconImageView(withImage: image, imageTintColor: spec.iconImageTintColor, superview: self)
    }

    // Let any left view passed in programmatically override any icon image view initiated via a message spec
    if let leftView = leftView {
      setup(leftView: leftView, inSuperview: self)
    }

    if let rightView = rightView {
      setup(rightView: rightView, inSuperview: self)
    }

    if let backgroundImage = spec.backgroundImage, backgroundView == nil {
      backgroundView = backgroundImageView(withImage: backgroundImage, superview: self)
    }

    // Let any background view passed in programmatically override any background image view initiated
    // via a message spec
    if let backgroundView = backgroundView {
      setup(backgroundView: backgroundView, inSuperview: self)
    }

    if spec.blurBackground {
      setupBlurBackgroundView(inSuperview: self)
    }
  }

  func setupLabelConstraintsToSizeToFit() {
    assert(superview != nil, "RMessage instance must have a superview by this point!")
    guard spec.titleBodyLabelsSizeToFit else {
      return
    }

    NSLayoutConstraint.deactivate(
      [
        contentViewTrailingConstraint,
        titleLabelLeadingConstraint, titleLabelTrailingConstraint,
        bodyLabelLeadingConstraint, bodyLabelTrailingConstraint,
        ].compactMap { $0 }
    )

    titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
    titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
    bodyLabelLeadingConstraint = bodyLabel.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
    bodyLabelTrailingConstraint = bodyLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)

    NSLayoutConstraint.activate(
      [
        titleLabelLeadingConstraint, titleLabelTrailingConstraint,
        bodyLabelLeadingConstraint, bodyLabelTrailingConstraint,
      ]
    )
  }

  // MARK: - Respond to Layout Changes

  public override func layoutSubviews() {
    super.layoutSubviews()

    if titleLabel.text == nil || bodyLabel.text == nil { titleBodyVerticalSpacingConstraint.constant = 0 }

    if let leftView = leftView, messageSpecIconImageViewSet, spec.iconImageRelativeCornerRadius > 0 {
      leftView.layer.cornerRadius = spec.iconImageRelativeCornerRadius * leftView.bounds.size.width
    }

    if spec.cornerRadius >= 0 { layer.cornerRadius = spec.cornerRadius }

    guard let superview = superview else { return }

    setPreferredLayoutWidth(
      forTitleLabel: titleLabel, bodyLabel: bodyLabel, inSuperview: superview,
      sizingToFit: spec.titleBodyLabelsSizeToFit
    )
  }
}
