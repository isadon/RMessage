//
//  RMessageViewTests.m
//  RMessageTests
//
//  Created by Adonis Peralta on 2/22/18.
//

#import <XCTest/XCTest.h>
#import "RMessageView.h"

@interface RMessage(Tests) <RMessageViewProtocol>
@end

@interface RMessageView (Tests)
+ (NSError *)setupGlobalDesignDictionary;
+ (UIViewController *)defaultViewController;
+ (UIColor *)colorForString:(NSString *)string;
+ (UIColor *)colorForString:(NSString *)string alpha:(CGFloat)alpha;
- (void)setMessageOpacity:(CGFloat)messageOpacity;
+ (UIImage *)bundledImageNamed:(NSString *)name;
- (UILabel *)titleLabel;
- (UILabel *)subtitleLabel;
- (void)setTitleFont:(UIFont *)aTitleFont;
- (void)setTitleAlignment:(NSTextAlignment)titleAlignment;
- (void)setTitleTextColor:(UIColor *)aTextColor;
- (void)setSubtitleFont:(UIFont *)subtitleFont;
- (void)setSubtitleAlignment:(NSTextAlignment)subtitleAlignment;
- (void)setSubtitleTextColor:(UIColor *)subtitleTextColor;
- (NSTextAlignment)textAlignmentForString:(NSString *)textAlignment;
- (NSError *)setupDesignDictionariesWithMessageType:(RMessageType)messageType customTypeName:(NSString *)customTypeName;
@end

@interface RMessageViewTests : XCTestCase

@end

@implementation RMessageViewTests {
  UIApplication *app;
  RMessageView *messageView;
}

- (void)setUp {
  [super setUp];
  app = [UIApplication sharedApplication];
  messageView = [[RMessageView alloc] initWithDelegate:[RMessage sharedMessage]
                                                 title:@"title"
                                              subtitle:@"subtitle"
                                             iconImage:nil
                                                  type:RMessageTypeError
                                        customTypeName:nil
                                              duration:3.f
                                      inViewController:nil
                                              callback:nil
                                  presentingCompletion:nil
                                     dismissCompletion:nil
                                           buttonTitle:@"buttonTitle"
                                        buttonCallback:nil
                                            atPosition:RMessagePositionTop
                                  canBeDismissedByUser:YES];
}

- (void)testMessageViewInit
{
  XCTAssertNotNil(messageView);
}

- (void)testSetupGlobalDesignDictionary
{
  XCTAssertNil([RMessageView setupGlobalDesignDictionary]);
}

- (void)testSetupDesignDictionariesWithInvalidMessageType
{
  // Test getting the design dictionary for a name that doesn't exist should generate an NSError instance
  XCTAssertNotNil([messageView setupDesignDictionariesWithMessageType:RMessageTypeCustom customTypeName:@"customName"]);
}

- (void)testSetupDesignDictionariesWithValidMessageType
{
  [RMessageView addDesignsFromFileWithName:@"CustomDesignFile" inBundle:[NSBundle bundleForClass:[RMessageViewTests class]]];
  // Test getting the design dictionary for a name that doesn't exist should generate an NSError instance
  XCTAssertNil([messageView setupDesignDictionariesWithMessageType:RMessageTypeCustom customTypeName:@"custom"]);
}

- (void)testDefaultViewController
{
  XCTAssertNotNil([RMessageView defaultViewController]);
}

- (void)testColorForString
{
  CGFloat red, blue, green, alpha;
  [[RMessageView colorForString:@"#FF0000"] getRed: &red green:&green blue:&blue alpha:&alpha];

  XCTAssert(red == 1.0 && blue == 0 && green == 0 && alpha == 1.0,
            @"Incorrect color assigned");
}

- (void)testColorForStringWithAlpha
{
  CGFloat red, blue, green, alpha;
  [[RMessageView colorForString:@"#FF0000" alpha: 0.7] getRed: &red green:&green blue:&blue alpha:&alpha];

  XCTAssert(red == 1.0 && blue == 0 && green == 0 && alpha == 0.7,
            @"Incorrect color assigned");
}

- (void)testSetMessageOpacity
{
  [messageView setMessageOpacity: 0.6f];
  XCTAssert(messageView.alpha = 0.6f);
}

- (void)testBundledImageNamed
{
  XCTAssertNotNil([RMessageView bundledImageNamed:@"NotificationBackgroundSuccessIcon.png"]);
}

- (void)testSetTitleFont
{
  UIFont *titleFont = [UIFont systemFontOfSize:15.f];
  [messageView setTitleFont:titleFont];
  UILabel *titleLabel = [messageView titleLabel];
  XCTAssert(titleLabel.font == titleFont);
}

- (void)testSetTitleAlignment
{
  [messageView setTitleAlignment:NSTextAlignmentCenter];
  UILabel *titleLabel = [messageView titleLabel];
  XCTAssert(titleLabel.textAlignment == NSTextAlignmentCenter);
}

- (void)testSetTitleTextColor
{
  UIColor *redColor = [UIColor redColor];
  [messageView setTitleTextColor:redColor];
  UILabel *titleLabel = [messageView titleLabel];
  XCTAssert(titleLabel.textColor == redColor);
}

- (void)testSetSubtitleFont
{
  UIFont *subtitleFont = [UIFont systemFontOfSize:15.f];
  [messageView setSubtitleFont: subtitleFont];
  UILabel *subtitleLabel = [messageView subtitleLabel];
  XCTAssert(subtitleLabel.font == subtitleFont);
}

- (void)testSetSubtitleAlignment
{
  [messageView setSubtitleAlignment:NSTextAlignmentCenter];
  UILabel *subtitleLabel = [messageView subtitleLabel];
  XCTAssert(subtitleLabel.textAlignment == NSTextAlignmentCenter);
}

- (void)testSetSubtitleTextColor
{
  UIColor *redColor = [UIColor redColor];
  [messageView setSubtitleTextColor:redColor];
  UILabel *subtitleLabel = [messageView subtitleLabel];
  XCTAssert(subtitleLabel.textColor == redColor);
}

- (void)testTextAlignmentForString
{
  XCTAssert([messageView textAlignmentForString:@"left"] == NSTextAlignmentLeft);
  XCTAssert([messageView textAlignmentForString:@"right"] == NSTextAlignmentRight);
  XCTAssert([messageView textAlignmentForString:@"center"] == NSTextAlignmentCenter);
  XCTAssert([messageView textAlignmentForString:@"justified"] == NSTextAlignmentJustified);
  XCTAssert([messageView textAlignmentForString:@"natural"] == NSTextAlignmentNatural);
  XCTAssert([messageView textAlignmentForString:@"anything"] == NSTextAlignmentLeft);
}

@end
