//
//  RMessage.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import UIKit

public class RMessage: UIView, RMessageAnimatorDelegate {
  private(set) var spec: RMessageSpec

  private(set) lazy var contentView = UIView(frame: .zero)

  private(set) var leftView: UIView?
  private(set) var rightView: UIView?
  private(set) var backgroundView: UIView?

  private let titleLabel = UILabel(frame: .zero)
  private let bodyLabel = UILabel(frame: .zero)

  private var messageSpecIconImageViewSet = false
  private var messageSpecBackgroundImageViewSet = false

  // MARK: - Constraint Vars

  private lazy var titleLabelLeadingConstraint = titleLabel.leadingAnchor.constraint(
    equalTo: contentView.leadingAnchor
  )

  private lazy var titleLabelTrailingConstraint = titleLabel.trailingAnchor.constraint(
    equalTo: contentView.trailingAnchor
  )

  private lazy var bodyLabelLeadingConstraint = bodyLabel.leadingAnchor.constraint(
    equalTo: contentView.leadingAnchor
  )

  private lazy var bodyLabelTrailingConstraint = bodyLabel.trailingAnchor.constraint(
    equalTo: contentView.trailingAnchor
  )

  private lazy var contentViewTrailingConstraint: NSLayoutConstraint = {
    let constraint = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15)
    constraint.priority = .init(rawValue: 749)
    return constraint
  }()

  private lazy var titleBodyVerticalSpacingConstraint = bodyLabel.topAnchor.constraint(
    equalTo: titleLabel.bottomAnchor, constant: 5
  )

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

    setupContentView()
    layoutViews()

    titleLabel.text = title
    bodyLabel.text = body

    accessibilityIdentifier = String(describing: type(of: self))

    setupComponents(withMessageSpec: spec)
    setupDesign(withMessageSpec: spec, titleLabel: titleLabel, bodyLabel: bodyLabel)
  }

  @available(*, unavailable) required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupContentView() {
    for sub in [titleLabel, bodyLabel] {
      contentView.addSubview(sub)
      sub.translatesAutoresizingMaskIntoConstraints = false
    }

    NSLayoutConstraint.activate([
      titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor),
      titleLabelLeadingConstraint,
      titleLabelTrailingConstraint,
      titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      titleBodyVerticalSpacingConstraint,
      bodyLabelLeadingConstraint,
      bodyLabelTrailingConstraint,
      bodyLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      bodyLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ])
  }

  private func layoutViews() {
    addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false

    let sag = safeAreaLayoutGuide

    let contentViewOptLeading = contentView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15)
    contentViewOptLeading.priority = .init(rawValue: 749)

    let contentViewOptTop = contentView.topAnchor.constraint(equalTo: sag.topAnchor, constant: 10)
    contentViewOptTop.priority = .init(rawValue: 249)

    let contentViewOptBottom = contentView.bottomAnchor.constraint(equalTo: sag.bottomAnchor, constant: -10)
    contentViewOptBottom.priority = .init(rawValue: 249)

    let contentViewCenterXOpt = contentView.centerXAnchor.constraint(equalTo: centerXAnchor)
    contentViewCenterXOpt.priority = .init(rawValue: 748)

    let contentViewCenterYOpt = contentView.centerYAnchor.constraint(equalTo: centerYAnchor)
    contentViewCenterYOpt.priority = .init(rawValue: 248)

    NSLayoutConstraint.activate([
      contentViewCenterXOpt,
      contentView.leadingAnchor.constraint(greaterThanOrEqualTo: leadingAnchor),
      contentViewOptLeading,
      contentView.trailingAnchor.constraint(lessThanOrEqualTo: trailingAnchor),
      contentViewTrailingConstraint,

      contentViewCenterYOpt,
      contentView.topAnchor.constraint(greaterThanOrEqualTo: safeAreaLayoutGuide.topAnchor, constant: 10),
      contentViewOptTop,
      contentView.bottomAnchor.constraint(lessThanOrEqualTo: safeAreaLayoutGuide.bottomAnchor, constant: -10),
      contentViewOptBottom,
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

    NSLayoutConstraint.deactivate([
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

  override public func layoutSubviews() {
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
