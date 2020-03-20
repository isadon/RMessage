//
//  DemoViewController.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import HexColors
import RMessage
import UIKit

class DemoViewController: UIViewController, RMControllerDelegate {
  // override var prefersStatusBarHidden = true
  private let rControl = RMController()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.navigationBar.isTranslucent = true
    extendedLayoutIncludesOpaqueBars = true
    // RMessageController.appearance.setTitleSubtitleLabelsSizeToFit = true
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    /* Normally we would set the default view controller and delegate in viewDidLoad
     but since we are using this view controller for our modal view also it is important to properly
     re-set the variables once the modal dismisses. */
    rControl.delegate = self
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    coordinator.animate(alongsideTransition: nil) { _ in
      self.rControl.interfaceDidRotate()
    }
  }

  @IBAction private func didTapError(_: Any) {
    rControl.showMessage(
      withSpec: errorSpec,
      title: "Something failed",
      body: "The internet connection seems to be down. Please check it!"
    )
  }

  @IBAction private func didTapWarning(_: Any) {
    rControl.showMessage(
      withSpec: warningSpec,
      title: "Some random warning",
      body: "Look out! Something is happening there!"
    )
  }

  @IBAction private func didTapMessage(_: Any) {
    rControl.showMessage(
      withSpec: normalSpec,
      title: "Tell the user something",
      body: "This is a neutral notification!"
    )
  }

  @IBAction private func didTapSuccess(_: Any) {
    rControl.showMessage(
      withSpec: successSpec,
      title: "Success",
      body: "Some task was successfully completed!"
    )
  }

  @IBAction private func didTapButton(_: Any) {
    let button = UIButton(type: .custom)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitle("Update", for: .normal)

    if let buttonResizeableImage =
      UIImage(named: "TestButtonBackground")?.resizableImage(withCapInsets: UIEdgeInsets.init(top: 15, left: 12, bottom: 15, right: 11)) {
      button.setBackgroundImage(buttonResizeableImage, for: .normal)
      button.contentEdgeInsets = UIEdgeInsets.init(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    }

    button.setTitleColor(.black, for: .normal)
    button.sizeToFit()
    button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

    rControl.showMessage(
      withSpec: normalSpec,
      title: "New version available",
      body: "Please update our app. We would be very thankful", rightView: button
    )
  }

  @IBAction private func didTapCustomImage(_: Any) {
    var iconSpec = normalSpec
    iconSpec.iconImage = UIImage(named: "TestButtonBackground.png")

    rControl.showMessage(
      withSpec: iconSpec,
      title: "Custom image",
      body: "This uses an image you can define"
    )
  }

  @IBAction private func didTapEndless(_: Any) {
    var endlessSpec = successSpec
    endlessSpec.durationType = .endless

    rControl.showMessage(
      withSpec: endlessSpec,
      title: "Endless",
      body: """
      This message can not be dismissed and will not be hidden automatically. Tap the 'Dismiss' button to dismiss the
      currently shown message
      """,
      tapCompletion: { print("tapped") },
      presentCompletion: { print("presented") },
      dismissCompletion: { print("dismissed") }
    )
  }

  @IBAction private func didTapAttributed(_: Any) {
    var attributedSpec = warningSpec
    attributedSpec.titleAttributes = [.backgroundColor: UIColor.red, .foregroundColor: UIColor.white]
    attributedSpec.bodyAttributes = [
      .backgroundColor: UIColor.blue, .foregroundColor: UIColor.white,
      .underlineStyle: NSUnderlineStyle.single.rawValue,
    ]

    rControl.showMessage(
      withSpec: attributedSpec,
      title: "Attributed for real",
      body: """
      Enjoy some attributed text:
      Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed \
      diam nonumy eirmod tempor invidunt ut labore et dolore magna \
      aliquyam erat, sed diam voluptua.
      """
    )
  }

  @IBAction private func didTapLong(_: Any) {
    var durationSpec = warningSpec
    durationSpec.durationType = .timed
    durationSpec.timeToDismiss = 10.0

    rControl.showMessage(
      withSpec: durationSpec, title: "Long",
      body: "This message is displayed for 10 seconds",
      tapCompletion: { print("tapped") },
      presentCompletion: { print("presented") },
      dismissCompletion: { print("dismissed") }
    )
  }

  @IBAction private func didTapBottom(_: Any) {
    rControl.showMessage(withSpec: successSpec, atPosition: .bottom, title: "Hi!", body: "I'm down here :)")
  }

  @IBAction private func didTapText(_: Any) {
    rControl.showMessage(
      withSpec: warningSpec,
      title: "With 'Text' I meant a long text, so here it is",
      body: """
      Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed \
      diam nonumy eirmod tempor invidunt ut labore et dolore magna \
      aliquyam erat, sed diam voluptua. At vero eos et accusam et \
      justo duo dolores et ea rebum. Stet clita kasd gubergren, no \
      sea takimata sanctus.At vero eos et accusam et justo duo \
      dolores et ea rebum. Stet clita kasd gubergren, no sea takimata \
      sanctus.Lorem ipsum dolor sit amet, consetetur sadipscing \
      elitr, sed diam nonumy eirmod tempor invidunt ut labore et \
      dolore magna aliquyam erat, sed diam voluptua. At vero eos et \
      accusam et justo duo dolores et ea rebum. Stet clita kasd \
      gubergren, no sea takimata sanctus.At vero eos et accusam et \
      justo duo dolores et ea rebum. Stet clita kasd gubergren, no \
      sea takimata sanctus.
      """
    )
  }

  @IBAction private func didTapCustomDesign(_: Any) {
    guard let buttonBackgroundImage = UIImage(named: "TestButtonBackground.png") else {
      print("Unable to find button background image 'NotificationButtonBackground.png' in the app bundle")
      return
    }

    let button = UIButton(type: .custom)
    button.setTitleColor(UIColor("#FF0040")!, for: .normal)
    button.setImage(buttonBackgroundImage, for: .normal)
    button.sizeToFit()
    button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

    var alternateErr = errorSpec
    alternateErr.backgroundColor = UIColor("#008AFC")!
    alternateErr.titleColor = UIColor("#48FCEB")!
    alternateErr.bodyColor = .white
    alternateErr.targetAlpha = 0.95
    alternateErr.iconImage = UIImage(named: "ErrorMessageIcon.png")

    rControl.showMessage(
      withSpec: alternateErr,
      title: "A different error message",
      body: "This background is blue while the body is white. Yes this is an alternate error!"
    )
  }

  @IBAction private func didTapTapOnlyDismissal(_: Any) {
    var tapOnlySpec = normalSpec
    tapOnlySpec.durationType = .tap
    tapOnlySpec.backgroundColor = UIColor("#CF00F8")!
    tapOnlySpec.titleColor = .white
    tapOnlySpec.bodyColor = .white

    rControl.showMessage(
      withSpec: tapOnlySpec,
      title: "Tap Tap",
      body: """
      This message can only be dismissed by tapping on it. Not swiping or anything else.
      """,
      tapCompletion: { print("tapped") },
      presentCompletion: { print("presented") },
      dismissCompletion: { print("dismissed") }
    )
  }

  @IBAction private func didTapDismissCurrentMessage(_: Any) {
    _ = rControl.dismissOnScreenMessage()
  }

  @IBAction private func didTapDismissModal(_: Any) {
    dismiss(animated: true, completion: nil)
  }

  @IBAction private func didTapToggleNavigationBar(_: Any) {
    guard let navigationController = navigationController else { return }
    navigationController.setNavigationBarHidden(!navigationController.isNavigationBarHidden, animated: true)
  }

  @IBAction private func didTapToggleNavigationBarAlpha(_: Any) {
    guard let navigationController = navigationController else { return }

    let alpha = navigationController.navigationBar.alpha
    navigationController.navigationBar.alpha = (alpha == 1) ? 0.5 : 1
  }

  @IBAction private func didTapToggleWantsFullscreen(_: Any) {
    extendedLayoutIncludesOpaqueBars = !extendedLayoutIncludesOpaqueBars
    if let navigationController = navigationController {
      navigationController.navigationBar.isTranslucent = !navigationController.navigationBar.isTranslucent
    }
  }

  @IBAction private func didTapNavBarOverlay(_: Any) {
    guard let navigationController = navigationController else { return }

    navigationController.isNavigationBarHidden = false

    rControl.showMessage(
      withSpec: successSpec,
      atPosition: .navBarOverlay,
      title: "Whoa!",
      body: "Over the Navigation Bar!",
      viewController: navigationController
    )
  }

  @IBAction private func didTapNavbarHidden(_: Any) {
    guard let navigationController = navigationController else { return }
    navigationController.isNavigationBarHidden = !navigationController.isNavigationBarHidden
  }

  @IBAction private func didTapTimedMessage(_: Any) {
    perform(#selector(didTapMessage), with: nil, afterDelay: 3.0)
  }

  @IBAction func whilstAlertTapped(_: Any) {
    let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
    let alert = UIAlertController(title: "Alert!", message: "Something is going on.", preferredStyle: .alert)
    alert.addAction(action)

    present(alert, animated: true, completion: nil)

    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
      self.rControl.showMessage(withSpec: normalSpec, title: "Showing whilst an alert is visible")
    }
  }

  @objc private func buttonPressed() {
    _ = rControl.dismissOnScreenMessage()
    rControl.showMessage(withSpec: successSpec, title: "Thanks for updating")
  }

  //  private func customize(message: RMessage) {
  //    guard let button = message.button else {
  //      return
  //    }
  //    button.contentEdgeInsets = UIEdgeInsetsMake(250, 25, 250, 25)
  //    button.setTitle("hey there", for: .normal)
  //    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 12)
  //    button.titleLabel?.textColor = .white
  //    button.backgroundColor = .blue
  //    button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
  //    message.layer.cornerRadius = 20
  //  }

//  @objc func buttonTapped() {
//    print("button was tapped")
//  }
}
