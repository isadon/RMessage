//
//  ViewControllerTests.swift
//  RMessageUITests
//
//  Created by Adonis Peralta on 9/9/18.
//  Copyright © 2018 None. All rights reserved.
//

import XCTest

class ViewControllerTests: XCTestCase {
  let app = XCUIApplication()

  lazy var navBarElement = app.navigationBars.element
  lazy var windowElement = app.windows.element.firstMatch

  lazy var notHittablePredicate = NSPredicate(format: "hittable == FALSE")
  lazy var hittablePredicate = NSPredicate(format: "hittable == TRUE")

  // Check for message y position to hundredths place
  let kMsgYPositionScale = 2

  override func setUp() {
    super.setUp()
    continueAfterFailure = false
    XCUIApplication().launch()

    app.buttons["Present Modal"].tap()
  }

  func showMessageFromTopByPressingButton(withName buttonName: String, timeToShow displayTimeout: TimeInterval, timeToHide dismissTimeout: TimeInterval) {

    app.buttons[buttonName].firstMatch.tap()

    // The base view where all the elements reside. Here we grab this to get where the position of
    // the base view is relative to the window screen space. From this we can then calculate if the
    // position of RMessage views is correct.
    let baseView = app.otherElements["Modal"]
    let displayedMessage = app.otherElements["RMessage"]

    let messageDisplayed = displayedMessage.waitForExistence(timeout: displayTimeout)

    let padding = springAnimationPadding(forHeight: Float(displayedMessage.frame.size.height))
    let expectedMsgYPosition = padding

    XCTAssert(messageDisplayed, "\(buttonName) message failed to display")

    let expectedMessagePositionValid = validateFloatsToScale(
      Float(displayedMessage.frame.origin.y - baseView.frame.origin.y),
      expectedMsgYPosition, scale: kMsgYPositionScale
    )

    XCTAssert(expectedMessagePositionValid, "\(buttonName) message displayed in the wrong position")

    let exp = expectation(for: notHittablePredicate, evaluatedWith: displayedMessage, handler: nil)
    wait(for: [exp], timeout: dismissTimeout)
  }

  func showBottomMessage(withTimeout displayTimeout: TimeInterval, timeToHide dismissTimeout: TimeInterval) {

    let buttonName = "Bottom"
    app.buttons[buttonName].firstMatch.tap()

    // The base view where all the elements reside. Here we grab this to get where the position of
    // the base view is relative to the window screen space. From this we can then calculate if the
    // position of RMessage views is correct.
    let baseView = app.otherElements["Modal"]

    let displayedMessage = app.otherElements["RMessage"]

    let padding = springAnimationPadding(forHeight: Float(displayedMessage.frame.size.height))
    let expectedMsgYPosition = Float((baseView.frame.origin.y + baseView.frame.size.height) - displayedMessage.frame.size.height) - padding
    let messageDisplayed = displayedMessage.waitForExistence(timeout: displayTimeout)

    XCTAssert(messageDisplayed, "\(buttonName) message failed to display")

    let expectedMessagePositionValid = validateFloatsToScale(
      Float(displayedMessage.frame.origin.y),
      expectedMsgYPosition, scale: kMsgYPositionScale
    )

    XCTAssert(expectedMessagePositionValid, "\(buttonName) message displayed in the wrong position")

    let exp = expectation(for: notHittablePredicate, evaluatedWith: displayedMessage, handler: nil)
    wait(for: [exp], timeout: dismissTimeout)
  }

  func showEndlessMessage(withTimeout displayTimeout: TimeInterval) {
    let buttonName = "Endless"
    app.buttons[buttonName].firstMatch.tap()

    let displayedMessage = app.otherElements["RMessage"]

    // The base view where all the elements reside. Here we grab this to get where the position of
    // the base view is relative to the window screen space. From this we can then calculate if the
    // position of RMessage views is correct.
    let baseView = app.otherElements["Modal"]

    // The spring animation padding is calculated on the message size prior to accounting for the safe area layout
    // guides so to properly determine the position of the view we must remove any safe layout are guide sizing from
    // height of the view prior to attempting to calculate the spring animation padding.
    let padding = springAnimationPadding(forHeight: Float(displayedMessage.frame.size.height - 20.0))
    let expectedMsgYPosition = padding
    let messageDisplayed = displayedMessage.waitForExistence(timeout: displayTimeout)

    XCTAssert(messageDisplayed, "\(buttonName) message failed to display")

    let expectedMessagePositionValid = validateFloatsToScale(
      Float(displayedMessage.frame.origin.y - baseView.frame.origin.y),
      expectedMsgYPosition, scale: kMsgYPositionScale
    )

    XCTAssert(expectedMessagePositionValid, "\(buttonName) message displayed in the wrong position")

    sleep(10)

    XCTAssert(displayedMessage.isHittable, "\(buttonName) message no longer on screen")
  }

  func testButtonMessageButtonPress() {
    let buttonName = "Button"
    app.buttons[buttonName].firstMatch.tap()

    let displayedMessage = app.otherElements["RMessage"]
    var messageDisplayed = displayedMessage.waitForExistence(timeout: 3.0)

    XCTAssert(messageDisplayed, "\(buttonName) message failed to display")

    let displayedMessageDismissedExpectation = expectation(for: notHittablePredicate, evaluatedWith: displayedMessage, handler: nil)
    app.buttons["Update"].tap()

    let updateMessage = app.otherElements["RMessage"]
    messageDisplayed = updateMessage.waitForExistence(timeout: 3.0)

    XCTAssert(messageDisplayed, "Update message failed to display")

    let updateMessageDismissedExpectation = expectation(for: notHittablePredicate, evaluatedWith: updateMessage, handler: nil)
    wait(for: [displayedMessageDismissedExpectation], timeout: 5.0)
    wait(for: [updateMessageDismissedExpectation], timeout: 5.0)
  }

  func testEndlessMessageDismiss() {
    let buttonName = "Endless"
    app.buttons[buttonName].firstMatch.tap()

    // The base view where all the elements reside. Here we grab this to get where the position of
    // the base view is relative to the window screen space. From this we can then calculate if the
    // position of RMessage views is correct.
    let baseView = app.otherElements["Modal"]

    let displayedMessage = app.otherElements["RMessage"]
    let padding = springAnimationPadding(forHeight: Float(displayedMessage.frame.size.height - 20.0))
    let expectedMsgYPosition = padding

    let messageDisplayed = displayedMessage.waitForExistence(timeout: 3.0)

    XCTAssert(messageDisplayed, "\(buttonName) message failed to display")

    let expectedMessagePositionValid = validateFloatsToScale(
      Float(displayedMessage.frame.origin.y - baseView.frame.origin.y),
      expectedMsgYPosition, scale: kMsgYPositionScale
    )

    XCTAssert(expectedMessagePositionValid, "\(buttonName) message displayed in the wrong position")

    sleep(20)

    XCTAssert(displayedMessage.isHittable, "\(buttonName) message no longer on screen")

    displayedMessage.tap()

    sleep(5)

    XCTAssert(displayedMessage.isHittable, "\(buttonName) message no longer on screen")

    app.buttons["Dismiss"].firstMatch.tap()

    let messageDidDismiss = expectation(for: notHittablePredicate, evaluatedWith: displayedMessage, handler: nil)
    wait(for: [messageDidDismiss], timeout: 5.0)
  }

  func testTapToDismiss() {
    let buttonName = "Error"
    app.buttons[buttonName].firstMatch.tap()

    // The base view where all the elements reside. Here we grab this to get where the position of
    // the base view is relative to the window screen space. From this we can then calculate if the
    // position of RMessage views is correct.
    let baseView = app.otherElements["Modal"]

    let displayedMessage = app.otherElements["RMessage"]
    let padding = springAnimationPadding(forHeight: Float(displayedMessage.frame.size.height))
    let expectedMsgYPosition = padding

    let messageDisplayed = displayedMessage.waitForExistence(timeout: 3.0)

    XCTAssert(messageDisplayed, "\(buttonName) message failed to display")

    let expectedMessagePositionValid = validateFloatsToScale(
      Float(displayedMessage.frame.origin.y - baseView.frame.origin.y),
      expectedMsgYPosition, scale: kMsgYPositionScale
    )

    XCTAssert(expectedMessagePositionValid, "\(buttonName) message displayed in the wrong position")

    displayedMessage.tap()

    let exp = expectation(for: notHittablePredicate, evaluatedWith: displayedMessage, handler: nil)
    wait(for: [exp], timeout: 2.0)
  }

  func testErrorMessage() {
    showMessageFromTopByPressingButton(withName: "Error", timeToShow: 3.0, timeToHide: 8.0)
  }

  func testNormalMessage() {
    showMessageFromTopByPressingButton(withName: "Message", timeToShow: 3.0, timeToHide: 8.0)
  }

  func testWarningMessage() {
    showMessageFromTopByPressingButton(withName: "Warning", timeToShow: 3.0, timeToHide: 8.0)
  }

  func testSuccessMessage() {
    showMessageFromTopByPressingButton(withName: "Success", timeToShow: 3.0, timeToHide: 8.0)
  }

  func testLongMessage() {
    showMessageFromTopByPressingButton(withName: "Text", timeToShow: 3.0, timeToHide: 12.0)
  }

  func testButtonMessage() {
    showMessageFromTopByPressingButton(withName: "Button", timeToShow: 3.0, timeToHide: 8.0)
  }

  func testBottomMessage() {
    showBottomMessage(withTimeout: 3.0, timeToHide: 8.0)
  }

  func testCustomMessage() {
    showMessageFromTopByPressingButton(withName: "Custom design", timeToShow: 3.0, timeToHide: 8.0)
  }

  func testImageMessage() {
    showMessageFromTopByPressingButton(withName: "Custom image", timeToShow: 3.0, timeToHide: 8.0)
  }

  func testEndlessMessage() {
    showEndlessMessage(withTimeout: 3.0)
  }

  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
}
