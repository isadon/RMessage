//
//  ViewControllerTests.m
//  RMessageUITests
//
//  Created by Adonis Peralta on 3/14/18.
//

#import <XCTest/XCTest.h>
#import "UITestHelpers.h"

// Check for message y position to hundredths place
static int const kMsgYPositionScale = 2;

@interface ViewControllerTests : XCTestCase

@end

@implementation ViewControllerTests
{
  XCUIApplication *app;
  XCUIElement *navBarElement;
  XCUIElement *windowElement;
  CGRect mainWindowFrame;
  NSPredicate *notHittablePredicate;
  NSPredicate *hittablePredicate;
}

- (void)setUp
{
  [super setUp];
  self.continueAfterFailure = NO;
  app = [XCUIApplication new];
  [app launch];
  navBarElement = app.navigationBars.element;
  windowElement = app.windows.element.firstMatch;
  mainWindowFrame = windowElement.frame;

  notHittablePredicate = [NSPredicate predicateWithFormat:@"hittable == FALSE"];
  hittablePredicate = [NSPredicate predicateWithFormat:@"hittable == TRUE"];
}

- (CGFloat)springAnimationPaddingForHeight:(CGFloat)height
{
  return ceilf(height / 120) * -10.f;
}

- (void)showMessageFromTopByPressingButtonWithName:(NSString *)buttonName
                                        timeToShow:(NSTimeInterval)displayTimeout
                                        timeToHide:(NSTimeInterval)dismissTimeout
{
  [app.buttons[@"Present Modal"] tap];
  [app.buttons[buttonName] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessageView"];

  CGFloat springAnimationPadding = [self springAnimationPaddingForHeight:displayedMessage.frame.size.height];
  CGFloat expectedMsgYPosition = springAnimationPadding;

  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:displayTimeout];
  XCTAssert(messageDisplayed, @"%@ message failed to display", buttonName);

  BOOL expectedMessagePositionValid = validateFloatsToScale(displayedMessage.frame.origin.y,
                                                            expectedMsgYPosition, kMsgYPositionScale);
  XCTAssert(expectedMessagePositionValid, "%@ message displayed in the wrong position", buttonName);

  XCTestExpectation *expectation = [self expectationForPredicate:notHittablePredicate
                                             evaluatedWithObject:displayedMessage
                                                         handler:nil];
  [self waitForExpectations:@[expectation] timeout:dismissTimeout];
}

- (void)showBottomMessageWithTimeout:(NSTimeInterval)displayTimeout
                           timeToHide:(NSTimeInterval)dismissTimeout
{
  [app.buttons[@"Present Modal"] tap];
  [app.buttons[@"Bottom"] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessageView"];

  CGFloat springAnimationPadding = [self springAnimationPaddingForHeight:displayedMessage.frame.size.height];
  CGFloat expectedMsgYPosition = mainWindowFrame.size.height - displayedMessage.frame.size.height - springAnimationPadding;

  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:displayTimeout];
  XCTAssert(messageDisplayed, @"Bottom message failed to display");

  BOOL expectedMessagePositionValid = validateFloatsToScale(displayedMessage.frame.origin.y,
                                                            expectedMsgYPosition, kMsgYPositionScale);
  XCTAssert(expectedMessagePositionValid, "Bottom message displayed in the wrong position");

  XCTestExpectation *expectation = [self expectationForPredicate:notHittablePredicate
                                             evaluatedWithObject:displayedMessage
                                                         handler:nil];
  [self waitForExpectations:@[expectation] timeout:dismissTimeout];
}

- (void)showEndlessMessageWithTimeout:(NSTimeInterval)displayTimeout
{
  [app.buttons[@"Present Modal"] tap];
  [app.buttons[@"Endless"] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessageView"];

  CGFloat springAnimationPadding = [self springAnimationPaddingForHeight:displayedMessage.frame.size.height];
  CGFloat expectedMsgYPosition = springAnimationPadding;

  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:displayTimeout];
  XCTAssert(messageDisplayed, @"Endless message failed to display");

  BOOL expectedMessagePositionValid = validateFloatsToScale(displayedMessage.frame.origin.y,
                                                            expectedMsgYPosition, kMsgYPositionScale);
  XCTAssert(expectedMessagePositionValid, "Endless message displayed in the wrong position");
  sleep(20);
  XCTAssert(displayedMessage.hittable, "Endless message no longer on screen");
}

- (void)testErrorMessage
{
  [self showMessageFromTopByPressingButtonWithName:@"Error" timeToShow:3.f timeToHide:8.f];
}

- (void)testNormalMessage
{
  [self showMessageFromTopByPressingButtonWithName:@"Message" timeToShow:3.f timeToHide:8.f];
}

- (void)testWarningMessage
{
  [self showMessageFromTopByPressingButtonWithName:@"Warning" timeToShow:3.f timeToHide:8.f];
}

- (void)testSuccessMessage
{
  [self showMessageFromTopByPressingButtonWithName:@"Success" timeToShow:3.f timeToHide:8.f];
}

- (void)testLongMessage
{
  [self showMessageFromTopByPressingButtonWithName:@"Text" timeToShow:3.f timeToHide:17.f];
}

- (void)testButtonMessage
{
  [self showMessageFromTopByPressingButtonWithName:@"Button" timeToShow:3.f timeToHide:8.f];
}

- (void)testBottomMessage
{
  [self showBottomMessageWithTimeout:3.f timeToHide:8.f];
}

- (void)testCustomMessage
{
  [self showMessageFromTopByPressingButtonWithName:@"Custom design" timeToShow:3.f timeToHide:8.f];
}

- (void)testImageMessage
{
  [self showMessageFromTopByPressingButtonWithName:@"Custom image" timeToShow:3.f timeToHide:8.f];
}

- (void)testEndlessMessage
{
  [self showEndlessMessageWithTimeout:3.f];
}

- (void)testButtonMessageButtonPress
{
  [app.buttons[@"Present Modal"] tap];
  [app.buttons[@"Button"] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessageView"];

  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:3.f];
  XCTAssert(messageDisplayed, @"Button message failed to display");

  XCTestExpectation *displayedMessageDismissedExpectation = [self expectationForPredicate:notHittablePredicate
                                                                      evaluatedWithObject:displayedMessage
                                                                                  handler:nil];
  [app.buttons[@"Update"] tap];

  XCUIElement *updateMessage = app.otherElements[@"RMessageView"];
  messageDisplayed = [updateMessage waitForExistenceWithTimeout:3.f];
  XCTAssert(messageDisplayed, @"Update message failed to display");

  XCTestExpectation *updateMessageDismissedExpectation = [self expectationForPredicate:notHittablePredicate
                                                                   evaluatedWithObject:updateMessage
                                                                               handler:nil];
  [self waitForExpectations:@[displayedMessageDismissedExpectation] timeout:5.f];
  [self waitForExpectations:@[updateMessageDismissedExpectation] timeout:5.f];
}

- (void)testEndlessMessageDismiss
{
  [app.buttons[@"Present Modal"] tap];
  [app.buttons[@"Endless"] tap];

  XCUIElement *displayedMessage = app.otherElements[@"RMessageView"];

  CGFloat springAnimationPadding = [self springAnimationPaddingForHeight:displayedMessage.frame.size.height];
  CGFloat expectedMsgYPosition = springAnimationPadding;

  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:3.f];
  XCTAssert(messageDisplayed, @"Endless message failed to display");

  BOOL expectedMessagePositionValid = validateFloatsToScale(displayedMessage.frame.origin.y,
                                                            expectedMsgYPosition, kMsgYPositionScale);
  XCTAssert(expectedMessagePositionValid, "Endless message displayed in the wrong position");
  sleep(20);
  XCTAssert(displayedMessage.hittable, "Endless message no longer on screen");

  [displayedMessage tap];
  sleep(5);
  XCTAssert(displayedMessage.hittable, "Endless message no longer on screen");

  [app.buttons[@"Dismiss"] tap];

  XCTestExpectation *messageDidDismiss = [self expectationForPredicate:notHittablePredicate
                                                   evaluatedWithObject:displayedMessage
                                                               handler:nil];
  [self waitForExpectations:@[messageDidDismiss] timeout:5.f];
}

- (void)testTapToDismiss
{
  [app.buttons[@"Present Modal"] tap];
  [app.buttons[@"Error"] tap];
  XCUIElement *displayedMessage = app.otherElements[@"RMessageView"];

  CGFloat springAnimationPadding = [self springAnimationPaddingForHeight:displayedMessage.frame.size.height];
  CGFloat expectedMsgYPosition = springAnimationPadding;

  BOOL messageDisplayed = [displayedMessage waitForExistenceWithTimeout:3.f];
  XCTAssert(messageDisplayed, @"Error message failed to display");

  BOOL expectedMessagePositionValid = validateFloatsToScale(displayedMessage.frame.origin.y,
                                                            expectedMsgYPosition, kMsgYPositionScale);
  XCTAssert(expectedMessagePositionValid, "Error message displayed in the wrong position");

  [displayedMessage tap];
  XCTestExpectation *expectation = [self expectationForPredicate:notHittablePredicate
                                             evaluatedWithObject:displayedMessage
                                                         handler:nil];
  [self waitForExpectations:@[expectation] timeout:2.f];
}

- (void)tearDown
{
  app = nil;
  navBarElement = nil;
  windowElement = nil;
  notHittablePredicate = nil;
  hittablePredicate = nil;
  [super tearDown];
}

@end
