//
//  RMVDesignSpec.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/3/18.
//  Copyright © 2018 None. All rights reserved.
//

import Foundation
import UIKit

protocol RMessageSpec {
  var backgroundColor: UIColor { get set }
  var targetAlpha: CGFloat { get set }
  var cornerRadius: CGFloat { get set }
  var verticalOffset: CGFloat { get set }
  var iconImage: UIImage? { get set }
  var iconImageTintColor: UIColor { get set }
  var iconImageRelativeCornerRadius: CGFloat { get set }
  var backgroundImage: UIImage? { get set }
  var titleAttributes: [NSAttributedStringKey: Any]? { get set }
  var titleFont: UIFont { get set }
  var titleColor: UIColor { get set }
  var titleShadowColor: UIColor { get set }
  var titleShadowOffset: CGSize { get set }
  var titleTextAlignment: NSTextAlignment { get set }
  var bodyAttributes: [NSAttributedStringKey: Any]? { get set }
  var bodyFont: UIFont { get set }
  var bodyColor: UIColor { get set }
  var bodyShadowColor: UIColor { get set }
  var bodyShadowOffset: CGSize { get set }
  var bodyTextAlignment: NSTextAlignment { get set }
  var durationType: RMessageDuration { get set }
  var timeToDismiss: TimeInterval { get set }
  var blurBackground: Bool { get set }
  var titleBodyLabelsSizeToFit: Bool { get set }
  var disableSpringAnimationPadding: Bool { get set }
}

struct DefaultRMessageSpec: RMessageSpec {
  var backgroundColor = UIColor.white
  var targetAlpha = CGFloat(1)
  var cornerRadius = CGFloat(0)
  var verticalOffset = CGFloat(0)
  var iconImage: UIImage?
  var iconImageTintColor = UIColor.clear
  var iconImageRelativeCornerRadius = CGFloat(0)
  var backgroundImage: UIImage?
  var titleAttributes: [NSAttributedStringKey: Any]?
  var titleFont = UIFont.boldSystemFont(ofSize: 14)
  var titleColor = UIColor.black
  var titleShadowColor = UIColor.clear
  var titleShadowOffset = CGSize.zero
  var titleTextAlignment = NSTextAlignment.left
  var bodyAttributes: [NSAttributedStringKey: Any]?
  var bodyFont = UIFont.boldSystemFont(ofSize: 12)
  var bodyColor = UIColor.black
  var bodyShadowColor = UIColor.clear
  var bodyShadowOffset = CGSize.zero
  var bodyTextAlignment = NSTextAlignment.left
  var durationType = RMessageDuration.automatic
  var timeToDismiss = TimeInterval(-1.0)
  var blurBackground = false
  var titleBodyLabelsSizeToFit = false
  var disableSpringAnimationPadding = false
}

// MARK: Implementation for the builtin message types

let errorSpec: RMessageSpec = {
  var errorSpec = DefaultRMessageSpec()
  errorSpec.backgroundColor = UIColor("#FF2D55") ?? UIColor.black
  errorSpec.titleColor = UIColor.white
  errorSpec.bodyColor = UIColor.white
  errorSpec.iconImage = UIImage(named: "ErrorMessageIcon.png")
  return errorSpec
}()

let warningSpec: RMessageSpec = {
  var warningSpec = DefaultRMessageSpec()
  warningSpec.backgroundColor = UIColor("#FFCC00") ?? UIColor.black
  warningSpec.titleColor = UIColor("#484638") ?? UIColor.white
  warningSpec.bodyColor = warningSpec.titleColor
  warningSpec.iconImage = UIImage(named: "WarningMessageIcon.png")
  return warningSpec
}()

let normalSpec: RMessageSpec = {
  var normalSpec = DefaultRMessageSpec()
  normalSpec.backgroundColor = UIColor("#E8E8E8") ?? UIColor.black
  normalSpec.titleColor = UIColor("#727C83") ?? UIColor.white
  normalSpec.bodyColor = normalSpec.titleColor
  return normalSpec
}()

let successSpec: RMessageSpec = {
  var successSpec = DefaultRMessageSpec()
  successSpec.backgroundColor = UIColor("#00C060") ?? UIColor.black
  successSpec.titleColor = UIColor.white
  successSpec.bodyColor = successSpec.titleColor
  successSpec.iconImage = UIImage(named: "SuccessMessageIcon.png")
  return successSpec
}()
