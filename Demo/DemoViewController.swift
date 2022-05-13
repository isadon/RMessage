//
//  DemoViewController.swift
//  RMessage
//
//  Created by Adonis Peralta on 8/2/18.
//  Copyright © 2018 None. All rights reserved.
//

import RMessage
import UIKit

class DemoViewController: UIViewController, RMControllerDelegate {
  // override var prefersStatusBarHidden = true
  private let rControl = RMController()

  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.view.backgroundColor = .white
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
    var config: RMessage.Config = .init(design: .error)
    config.content.title = "Something failed"
    config.content.body = "The internet connection seems to be down. Please check it!"

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapWarning(_: Any) {
    var config: RMessage.Config = .init(design: .warning)
    config.content.title = "Some random warning"
    config.content.body = "Look out! Something is happening there!"

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapMessage(_: Any) {
    var config: RMessage.Config = .init(design: .normal)
    config.content.title = "Tell the user something"
    config.content.body = "This is a neutral notification!"

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapSuccess(_: Any) {
    var config: RMessage.Config = .init(design: .success)
    config.content.title = "Success"
    config.content.body = "Some task was successfully completed!"

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapButton(_: Any) {
    let button = UIButton(type: .custom)
    button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
    button.setTitle("Update", for: .normal)

    if let buttonResizeableImage =
      UIImage(named: "TestButtonBackground")?.resizableImage(withCapInsets: UIEdgeInsets(top: 15, left: 12, bottom: 15, right: 11))
    {
      button.setBackgroundImage(buttonResizeableImage, for: .normal)
      button.contentEdgeInsets = UIEdgeInsets(top: 0.0, left: 5.0, bottom: 0.0, right: 5.0)
    }

    button.setTitleColor(.black, for: .normal)
    button.sizeToFit()
    button.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)

    var config: RMessage.Config = .init(design: .normal)
    config.content.title = "New version available"
    config.content.body = "Please update our app. We would be very thankful"
    config.content.rightView = button

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapCustomImage(_: Any) {
    var config: RMessage.Config = .init(design: .normal)
    config.content.title = "Custom image"
    config.content.body = "This uses an image you can define"
    config.design.iconImage = UIImage(named: "TestButtonBackground.png")

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapEndless(_: Any) {
    var config: RMessage.Config = .init(design: .success)
    config.content.title = "Endless"
    config.content.body = """
    This message can not be dismissed and will not be hidden automatically. Tap the 'Dismiss' button to dismiss the\
     currently shown message.
    """
    config.presentation.durationType = .endless
    config.presentation.didTapCompletion = { print("tapped") }
    config.presentation.didPresentCompletion = { print("presented") }
    config.presentation.didDismissCompletion = { print("dismissed") }

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapAttributed(_: Any) {
    var config: RMessage.Config = .init(design: .warning)
    let title = "Attributed for real"
    let body = """
    Enjoy some attributed text:
    Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed\
     diam nonumy eirmod tempor invidunt ut labore et dolore magna\
     aliquyam erat, sed diam voluptua.
    """

    config.content.attributedTitle = .init(string: title, attributes: [
      .font: config.design.titleFont, .backgroundColor: UIColor.red, .foregroundColor: UIColor.white,
    ])

    config.content.attributedBody = .init(string: body, attributes: [
      .font: config.design.bodyFont, .backgroundColor: UIColor.blue, .foregroundColor: UIColor.white,
      .underlineStyle: NSUnderlineStyle.single.rawValue,
    ])

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapLong(_: Any) {
    var config: RMessage.Config = .init(design: .warning)
    config.content.title = "Long"
    config.content.title = "This message is displayed for 10 seconds"
    config.presentation.durationType = .timed
    config.presentation.timeToDismiss = 10.0
    config.presentation.didTapCompletion = { print("tapped") }
    config.presentation.didPresentCompletion = { print("presented") }
    config.presentation.didDismissCompletion = { print("dismissed") }

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapBottom(_: Any) {
    var config: RMessage.Config = .init(design: .success)
    config.content.title = "Hi!"
    config.content.body = "I'm down here 😃"
    config.presentation.position = .bottom

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapText(_: Any) {
    var config: RMessage.Config = .init(design: .warning)
    config.content.title = "With 'Text' I meant a long text, so here it is"
    config.content.body = """
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

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapCustomDesign(_: Any) {
    var config: RMessage.Config = .init(design: .error)
    config.design.backgroundColor = UIColor(hexString: "#008AFC")!
    config.design.titleColor = UIColor(hexString: "#48FCEB")!
    config.design.bodyColor = .white
    config.design.targetAlpha = 0.95
    config.design.iconImage = UIImage(named: "ErrorMessageIcon.png")
    config.content.title = "A different error message"
    config.content.body = "This background is blue while the body is white. Yes this is an alternate error!"

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction private func didTapTapOnlyDismissal(_: Any) {
    var config: RMessage.Config = .init(design: .normal)
    config.design.backgroundColor = UIColor(hexString: "#CF00F8")!
    config.design.titleColor = .white
    config.design.bodyColor = .white
    config.content.title = "Tap Tap"
    config.content.body = "This message can only be dismissed by tapping on it. Not swiping or anything else."
    config.presentation.durationType = .tap
    config.presentation.didTapCompletion = { print("tapped") }
    config.presentation.didPresentCompletion = { print("presented") }
    config.presentation.didDismissCompletion = { print("dismissed") }

    let message = RMessage(config)
    rControl.showMessage(message)
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

    var config: RMessage.Config = .init(design: .success)
    config.content.title = "Whoa!"
    config.content.body = "Over the Navigation Bar!"
    config.presentation.position = .navBarOverlay
    config.presentation.presentationViewController = navigationController

    let message = RMessage(config)
    rControl.showMessage(message)
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

    var config: RMessage.Config = .init(design: .normal)
    config.content.title = "Showing whilst an alert is visible"

    let message = RMessage(config)

    DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {
      self.rControl.showMessage(message)
    }
  }

  @objc private func buttonPressed() {
    _ = rControl.dismissOnScreenMessage()

    var config: RMessage.Config = .init(design: .success)
    config.content.title = "Thanks for updating"

    let message = RMessage(config)
    rControl.showMessage(message)
  }

  @IBAction func didTapHtmlEmbed(_ sender: UIButton) {
    let html = """
    <!doctype html>
    <html>
      <head>
        <style>
          body {
            font-family: -apple-system;
            font-size: 14px;
            color: white;
          }
        </style>
      </head>
      <body>
        Here is an html <b><a href=\"https://www.w3schools.com\">link</a></b>
      </body>
    </html>
    """

    let htmlData = html.data(using: .utf8)!

    var config = RMessage.Config()
    config.design.backgroundColor = UIColor(hexString: "3c3c3c")!
    config.design.titleColor = .white

    config.content.title = "Tap Tap"

    config.content.attributedBody = try! NSMutableAttributedString(
      data: htmlData, options: [.documentType: NSAttributedString.DocumentType.html],
      documentAttributes: nil
    )

    let message = RMessage(config)
    rControl.showMessage(message)
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
