//
//  RMessageSpec.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/3/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

/** A value representing a position *to* which to present the message.

 - **top**: Position describing the top of the window.
 - **bottom**: Position describing the bottom of the window.
 - **navBarOverlay**: Position describing the top of the window but overlaying any present navigation bars.
 */
public enum RMessagePosition {
  case top, bottom, navBarOverlay
}

/** A value representing how long a message should stay presented.

 - **automatic**: Duration specifying that the message will self dismiss after some short time.
 - **endless**: Duration specifying that the message will never dismiss unless programmatically told to.
 - **tap**: Duration specifying that the message will dismiss but only when it is tapped.
 - **swipe**: Duration specifying that the message will dismiss but only when it is swiped.
 - **tapSwipe**: Duration specifying that the message will dismiss but only when it is tapped or swiped.
 - **timed**: Duration specifying that the message will dismiss after some duration specified by the *timeToDismiss*
 property.
 */
public enum RMessageDuration {
  case automatic, endless, tap, swipe, tapSwipe, timed
}

public protocol RMessageSpec {
  /// Background color for the message.
  var backgroundColor: UIColor { get set }

  /// The target opacity of the message after it finishes the presentation animation.
  var targetAlpha: CGFloat { get set }

  /// The corner radius of the message.
  var cornerRadius: CGFloat { get set }

  /// Vertical offset to apply to the message.
  /// Use this to vertically shift the messages position after it finishes presenting.
  var verticalOffset: CGFloat { get set }

  /// An icon image to display to the left of the message.
  var iconImage: UIImage? { get set }

  /// Icon image tint color to apply to icon images defined to be template images.
  /// Does nothing for icon images that are not template images.
  var iconImageTintColor: UIColor { get set }

  /// Corner radius percentage relative to icon image to apply to icon image.
  ///
  /// For example 0.5 (use 50% of icon image width as corner radius) would mask the icon image to always be a circle.
  var iconImageRelativeCornerRadius: CGFloat { get set }

  /// Background image to use for the message.
  var backgroundImage: UIImage? { get set }

  /// Attributes to apply to the title text to style as an attributed string. Styles applied with this property
  /// override stylings applied by other properties in the RMessageSpec.
  var titleAttributes: [NSAttributedString.Key: Any]? { get set }

  /// Font to apply to the title text.
  var titleFont: UIFont { get set }

  /// Color to apply to the title text.
  var titleColor: UIColor { get set }

  /// Color to apply to the title shadow.
  var titleShadowColor: UIColor { get set }

  /// Offset to apply to the title shadow.
  var titleShadowOffset: CGSize { get set }

  /// Text alingment of the title text.
  var titleTextAlignment: NSTextAlignment { get set }

  /// Attributes to apply to the body text to style as an attributed string. Styles applied with this property
  /// override stylings applied by other properties in the RMessageSpec.
  var bodyAttributes: [NSAttributedString.Key: Any]? { get set }

  /// Font to apply to the body text.
  var bodyFont: UIFont { get set }

  /// Color to the apply to the body text.
  var bodyColor: UIColor { get set }

  /// Color to apply to the body shadow.
  var bodyShadowColor: UIColor { get set }

  /// Offset to apply to the body shadow.
  var bodyShadowOffset: CGSize { get set }

  /// Text alingment of the body text.
  var bodyTextAlignment: NSTextAlignment { get set }

  /// The type of duration of the message.
  var durationType: RMessageDuration { get set }

  /// Time in seconds to dismiss the message. Use only in conjuction with a *durationType* of **timed**.
  var timeToDismiss: TimeInterval { get set }

  /// A boolean value specifying whether to blur the background of the message. If attempting to blur a background color
  // make sure the background color has alpha value less than 1 when enabling this feature.
  var blurBackground: Bool { get set }

  /// A boolean value specifying whether to size the title and body labels to fit their content.
  var titleBodyLabelsSizeToFit: Bool { get set }

  /** A boolean value specifying whether to enable/disable the addition of an extra padding to the message view so as
   to prevent a visual gap from being displayed when the message is presented with the default spring animation.

   You most likely want to disable the extra padding when using the following properties: *cornerRadius*.
   */
  var disableSpringAnimationPadding: Bool { get set }
}

/// Default RMessage specs and stylings from which to construct messages.
public struct DefaultRMessageSpec: RMessageSpec {
  public var backgroundColor = UIColor.white
  public var targetAlpha = CGFloat(1)
  public var cornerRadius = CGFloat(0)
  public var verticalOffset = CGFloat(0)
  public var iconImage: UIImage?
  public var iconImageTintColor = UIColor.clear
  public var iconImageRelativeCornerRadius = CGFloat(0)
  public var backgroundImage: UIImage?
  public var titleAttributes: [NSAttributedString.Key: Any]?
  public var titleFont = UIFont.boldSystemFont(ofSize: 14)
  public var titleColor = UIColor.black
  public var titleShadowColor = UIColor.clear
  public var titleShadowOffset = CGSize.zero
  public var titleTextAlignment = NSTextAlignment.left
  public var bodyAttributes: [NSAttributedString.Key: Any]?
  public var bodyFont = UIFont.boldSystemFont(ofSize: 12)
  public var bodyColor = UIColor.black
  public var bodyShadowColor = UIColor.clear
  public var bodyShadowOffset = CGSize.zero
  public var bodyTextAlignment = NSTextAlignment.left
  public var durationType = RMessageDuration.automatic
  public var timeToDismiss = TimeInterval(-1.0)
  public var blurBackground = false
  public var titleBodyLabelsSizeToFit = false
  public var disableSpringAnimationPadding = false

  public init() {}
}

// MARK: Implementation for the builtin message types
public var errorSpec: RMessageSpec {
  var errorSpec = DefaultRMessageSpec()
  errorSpec.backgroundColor = UIColor("#FF2D55") ?? UIColor.black
  errorSpec.titleColor = UIColor.white
  errorSpec.bodyColor = UIColor.white
  errorSpec.iconImage = UIImage(named: "ErrorMessageIcon", in: RMessage.bundle, compatibleWith: nil)
  return errorSpec
}

public var warningSpec: RMessageSpec {
  var warningSpec = DefaultRMessageSpec()
  warningSpec.backgroundColor = UIColor("#FFCC00") ?? UIColor.black
  warningSpec.titleColor = UIColor("#484638") ?? UIColor.white
  warningSpec.bodyColor = warningSpec.titleColor
  warningSpec.iconImage = UIImage(named: "WarningMessageIcon", in: RMessage.bundle, compatibleWith: nil)
  return warningSpec
}

public var normalSpec: RMessageSpec {
  var normalSpec = DefaultRMessageSpec()
  normalSpec.backgroundColor = UIColor("#E8E8E8") ?? UIColor.black
  normalSpec.titleColor = UIColor("#727C83") ?? UIColor.white
  normalSpec.bodyColor = normalSpec.titleColor
  return normalSpec
}

public var successSpec: RMessageSpec {
  var successSpec = DefaultRMessageSpec()
  successSpec.backgroundColor = UIColor("#00C060") ?? UIColor.black
  successSpec.titleColor = UIColor.white
  successSpec.bodyColor = successSpec.titleColor
  successSpec.iconImage = UIImage(named: "SuccessMessageIcon", in: RMessage.bundle, compatibleWith: nil)
  return successSpec
}
