//
//  RMessage+Config.Presentation.swift
//
//
//  Created by Adonis Peralta on 5/11/22.
//

import UIKit

public extension RMessage.Config {
  struct Presentation {
    /** A value representing a position *to* which to present the message.
     - **top**: Position describing the top of the window.
     - **bottom**: Position describing the bottom of the window.
     - **navBarOverlay**: Position describing the top of the window but overlaying any present navigation bars.
     */
    public enum Position {
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
    public enum DurationType {
      case automatic, endless, tap, swipe, tapSwipe, timed
    }

    public var position: Position = .top

    /// The type of duration of the message.
    public var durationType: DurationType = .automatic

    /// Time in seconds to dismiss the message. Use only in conjuction with a *durationType* of **timed**.
    public var timeToDismiss: TimeInterval = -1

    /** A boolean value specifying whether to enable/disable the addition of an extra padding to the message view so as
     to prevent a visual gap from being displayed when the message is presented with the default spring animation.

     You most likely want to disable the extra padding when using the following properties: *cornerRadius*.
     */
    public var disableSpringAnimationPadding: Bool = false

    var defaultPresentationViewController: UIViewController? { UIWindow.topViewController() }

    /// View controller in which to present the message. If not set message presents in the window's top view
    /// controller.
    public var presentationViewController: UIViewController?

    /// Completion to execute on message being tapped.
    public var didTapCompletion: (() -> Void)?

    /// Completion to execute when message presents.
    public var didPresentCompletion: (() -> Void)?

    /// Completion to execute when message dismisses.
    public var didDismissCompletion: (() -> Void)?
  }
}
