//
//  RMessageTests.m
//  RMessageTests
//
//  Created by Adonis Peralta on 12/4/17.
//

#import "RMessage.h"
#import <XCTest/XCTest.h>

@interface RMessageTests : XCTestCase

@end

@implementation RMessageTests
{
  UIApplication *app;
}

- (void)setUp
{
  [super setUp];
  app = [UIApplication sharedApplication];
}

- (void)tearDown
{
  app = nil;
  [super tearDown];
}

- (void)testMessageInit
{
  XCTAssertNotNil([RMessage sharedMessage]);
}

- (void)testQueuedMessages
{
  for (int i = 0; i < 6; i++) {
    [RMessage showNotificationWithTitle:@"title" type:RMessageTypeError customTypeName:nil callback:nil];
  }
  NSArray *queuedMessages = [RMessage queuedMessages];
  XCTAssert(queuedMessages.count == 6);
}

@end
