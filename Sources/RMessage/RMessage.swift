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

  private let titleTextView: UITextView = {
    let textView = UITextView(frame: .zero)
    textView.isEditable = false
    textView.backgroundColor = .clear
    textView.isScrollEnabled = false
    textView.textContainerInset = .zero
    textView.isSelectable = false
    textView.setContentHuggingPriority(.required, for: .vertical)
    return textView
  }()

  private let bodyTextView: UITextView = {
    let textView = UITextView(frame: .zero)
    textView.isEditable = false
    textView.backgroundColor = .clear
    textView.isScrollEnabled = false
    textView.textContainerInset = .zero
    textView.isSelectable = false
    textView.setContentHuggingPriority(.required, for: .vertical)
    return textView
  }()

  private var messageSpecIconImageViewSet = false
  private var messageSpecBackgroundImageViewSet = false

  let leftViewLeading: CGFloat = 15
  let leftViewTrailing: CGFloat = 8
  let rightViewLeading: CGFloat = 8
  let rightViewTrailing: CGFloat = 15

  let contentViewLeadingSpace: CGFloat = 12
  let contentViewTrailingSpace: CGFloat = 15

  // MARK: - Constraint Vars

  private lazy var titleLeadingConstraint = titleTextView.leadingAnchor.constraint(
    equalTo: contentView.leadingAnchor
  )

  private lazy var titleTrailingConstraint = titleTextView.trailingAnchor.constraint(
    equalTo: contentView.trailingAnchor
  )

  private lazy var bodyZeroHeightConstraint = bodyTextView.heightAnchor.constraint(equalToConstant: 0)

  private lazy var bodyLeadingConstraint = bodyTextView.leadingAnchor.constraint(
    equalTo: contentView.leadingAnchor
  )

  private lazy var bodyTrailingConstraint = bodyTextView.trailingAnchor.constraint(
    equalTo: contentView.trailingAnchor
  )

  private lazy var contentViewTrailingConstraint: NSLayoutConstraint = {
    let constraint = contentView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -contentViewTrailingSpace)
    constraint.priority = .defaultHigh
    return constraint
  }()

  private lazy var titleBodyVerticalSpacingConstraint = bodyTextView.topAnchor.constraint(
    equalTo: titleTextView.bottomAnchor, constant: 5
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

    titleTextView.text = title
    bodyTextView.text = body

    setupContentView()
    layoutViews()

    accessibilityIdentifier = String(describing: type(of: self))

    setupComponents(withMessageSpec: spec)
    setupDesign(withMessageSpec: spec, titleTextView: titleTextView, bodyTextView: bodyTextView)
  }

  @available(*, unavailable) required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  private func setupContentView() {
    for sub in [titleTextView, bodyTextView] {
      contentView.addSubview(sub)
      sub.translatesAutoresizingMaskIntoConstraints = false
    }

    let dynamicBodyConstraints: [NSLayoutConstraint] = {
      var constraints: [NSLayoutConstraint] = [titleBodyVerticalSpacingConstraint]

      // Check if body is empty and modify our constraints
      if bodyTextView.text == "" || bodyTextView.attributedText.string == "" {
        constraints.append(bodyZeroHeightConstraint)
        // Remove extra spacing added when the body text is set
        titleBodyVerticalSpacingConstraint.constant = 0
      }

      return constraints
    }()

    NSLayoutConstraint.activate([
      titleTextView.topAnchor.constraint(equalTo: contentView.topAnchor),
      titleLeadingConstraint,
      titleTrailingConstraint,
      titleTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),

      bodyLeadingConstraint,
      bodyTrailingConstraint,
      bodyTextView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
      bodyTextView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
    ] + dynamicBodyConstraints)
  }

  private func layoutViews() {
    addSubview(contentView)
    contentView.translatesAutoresizingMaskIntoConstraints = false

    let sag = safeAreaLayoutGuide

    let contentViewOptLeading = contentView.leadingAnchor.constraint(
      equalTo: leadingAnchor, constant: contentViewLeadingSpace
    )

    contentViewOptLeading.priority = .defaultHigh

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
      titleLeadingConstraint, titleTrailingConstraint,
      bodyLeadingConstraint, bodyTrailingConstraint,
    ].compactMap { $0 }
    )

    titleLeadingConstraint = titleTextView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
    titleTrailingConstraint = titleTextView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)
    bodyLeadingConstraint = bodyTextView.leadingAnchor.constraint(greaterThanOrEqualTo: contentView.leadingAnchor)
    bodyTrailingConstraint = bodyTextView.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor)

    NSLayoutConstraint.activate(
      [
        titleLeadingConstraint, titleTrailingConstraint,
        bodyLeadingConstraint, bodyTrailingConstraint,
      ]
    )
  }

  // MARK: - Respond to Layout Changes

  override public func layoutSubviews() {
    super.layoutSubviews()

    if titleTextView.text == nil || bodyTextView.text == nil { titleBodyVerticalSpacingConstraint.constant = 0 }

    if let leftView = leftView, messageSpecIconImageViewSet, spec.iconImageRelativeCornerRadius > 0 {
      leftView.layer.cornerRadius = spec.iconImageRelativeCornerRadius * leftView.bounds.size.width
    }

    if spec.cornerRadius >= 0 { layer.cornerRadius = spec.cornerRadius }
  }
}
