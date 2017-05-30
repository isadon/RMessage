//
//  RMessage.m
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Adonis Peralta. All rights reserved.
//

#import "RMessage.h"
#import "RMessageView.h"
#import "RMessageViewProtocol.h"

static UIViewController *_defaultViewController;

@interface RMessage () <RMessageViewProtocol>

/** The queued messages (RMessageView objects) */
@property (nonatomic, strong) NSMutableArray *messages;

@property (nonatomic, assign) BOOL notificationActive;

@end

@implementation RMessage

#pragma mark - Class Methods

+ (instancetype)sharedMessage
{
  static RMessage *sharedMessage;
  static dispatch_once_t onceToken;
  dispatch_once(&onceToken, ^{
    sharedMessage = [RMessage new];
  });
  return sharedMessage;
}

+ (void)showNotificationWithTitle:(NSAttributedString *)title
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                        tapAction:(void (^)(void))tapBlock
{
  [self showNotificationInViewController:_defaultViewController
                                   title:title
                                subtitle:nil
                                    type:type
                          customTypeName:customTypeName
                                duration:RMessageDurationAutomatic
                              atPosition:RMessagePositionTop
                    canBeDismissedByUser:YES
                                leftView:nil
                               rightView:nil
                          backgroundView:nil
                               tapAction:tapBlock
                               dismissal:nil
                              completion:nil];
}

+ (void)showNotificationWithTitle:(NSAttributedString *)title
                         subtitle:(NSAttributedString *)subtitle
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                        tapAction:(void (^)(void))tapBlock
{
  [self showNotificationInViewController:_defaultViewController
                                   title:title
                                subtitle:subtitle
                                    type:type
                          customTypeName:customTypeName
                                duration:RMessageDurationAutomatic
                              atPosition:RMessagePositionTop
                    canBeDismissedByUser:YES
                                leftView:nil
                               rightView:nil
                          backgroundView:nil
                               tapAction:tapBlock
                               dismissal:nil
                              completion:nil];
}

+ (void)showNotificationWithTitle:(NSAttributedString *)title
                         subtitle:(NSAttributedString *)subtitle
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                         duration:(NSTimeInterval)duration
                       atPosition:(RMessagePosition)position
             canBeDismissedByUser:(BOOL)dismissingEnabled
                        tapAction:(void (^)(void))tapBlock
{
  [self showNotificationInViewController:_defaultViewController
                                   title:title
                                subtitle:subtitle
                                    type:type
                          customTypeName:customTypeName
                                duration:duration
                              atPosition:position
                    canBeDismissedByUser:dismissingEnabled
                                leftView:nil
                               rightView:nil
                          backgroundView:nil
                               tapAction:tapBlock
                               dismissal:nil
                              completion:nil];
}

+ (void)showNotificationWithTitle:(NSAttributedString *)title
                         subtitle:(NSAttributedString *)subtitle
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                         duration:(NSTimeInterval)duration
                       atPosition:(RMessagePosition)position
             canBeDismissedByUser:(BOOL)dismissingEnabled
                         leftView:(UIView *)leftView
                        rightView:(UIView *)rightView
                   backgroundView:(UIView *)backgroundView
                        tapAction:(void (^)(void))tapBlock
{
  [self showNotificationInViewController:_defaultViewController
                                   title:title
                                subtitle:subtitle
                                    type:type
                          customTypeName:customTypeName
                                duration:duration
                              atPosition:position
                    canBeDismissedByUser:dismissingEnabled
                                leftView:leftView
                               rightView:rightView
                          backgroundView:backgroundView
                               tapAction:tapBlock
                               dismissal:nil
                              completion:nil];
}

+ (void)showNotificationWithTitle:(NSAttributedString *)title
                         subtitle:(NSAttributedString *)subtitle
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                         duration:(NSTimeInterval)duration
                       atPosition:(RMessagePosition)position
             canBeDismissedByUser:(BOOL)dismissingEnabled
                         leftView:(UIView *)leftView
                        rightView:(UIView *)rightView
                   backgroundView:(UIView *)backgroundView
                        tapAction:(void (^)(void))tapBlock
                        dismissal:(void (^)(void))dismissalBlock
                       completion:(void (^)(void))completionBlock
{
  [self showNotificationInViewController:_defaultViewController
                                   title:title
                                subtitle:subtitle
                                    type:type
                          customTypeName:customTypeName
                                duration:duration
                              atPosition:position
                    canBeDismissedByUser:dismissingEnabled
                                leftView:leftView
                               rightView:rightView
                          backgroundView:backgroundView
                               tapAction:tapBlock
                               dismissal:dismissalBlock
                              completion:completionBlock];
}

#pragma mark inViewController functions

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSAttributedString *)title
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                               tapAction:(void (^)(void))tapBlock
{
  [self showNotificationInViewController:viewController
                                   title:title
                                subtitle:nil
                                    type:type
                          customTypeName:customTypeName
                                duration:RMessageDurationAutomatic
                              atPosition:RMessagePositionTop
                    canBeDismissedByUser:YES
                                leftView:nil
                               rightView:nil
                          backgroundView:nil
                               tapAction:tapBlock
                               dismissal:nil
                              completion:nil];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSAttributedString *)title
                                subtitle:(NSAttributedString *)subtitle
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                               tapAction:(void (^)(void))tapBlock
{
  [self showNotificationInViewController:viewController
                                   title:title
                                subtitle:subtitle
                                    type:type
                          customTypeName:customTypeName
                                duration:RMessageDurationAutomatic
                              atPosition:RMessagePositionTop
                    canBeDismissedByUser:YES
                                leftView:nil
                               rightView:nil
                          backgroundView:nil
                               tapAction:tapBlock
                               dismissal:nil
                              completion:nil];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSAttributedString *)title
                                subtitle:(NSAttributedString *)subtitle
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                                duration:(NSTimeInterval)duration
                              atPosition:(RMessagePosition)position
                    canBeDismissedByUser:(BOOL)dismissingEnabled
                               tapAction:(void (^)(void))tapBlock
{
  [self showNotificationInViewController:viewController
                                   title:title
                                subtitle:subtitle
                                    type:type
                          customTypeName:customTypeName
                                duration:duration
                              atPosition:position
                    canBeDismissedByUser:dismissingEnabled
                                leftView:nil
                               rightView:nil
                          backgroundView:nil
                               tapAction:tapBlock
                               dismissal:nil
                              completion:nil];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSAttributedString *)title
                                subtitle:(NSAttributedString *)subtitle
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                                duration:(NSTimeInterval)duration
                              atPosition:(RMessagePosition)position
                    canBeDismissedByUser:(BOOL)dismissingEnabled
                                leftView:(UIView *)leftView
                               rightView:(UIView *)rightView
                          backgroundView:(UIView *)backgroundView
                               tapAction:(void (^)(void))tapBlock
{
  [self showNotificationInViewController:viewController
                                   title:title
                                subtitle:subtitle
                                    type:type
                          customTypeName:customTypeName
                                duration:duration
                              atPosition:position
                    canBeDismissedByUser:dismissingEnabled
                                leftView:leftView
                               rightView:rightView
                          backgroundView:backgroundView
                               tapAction:tapBlock
                               dismissal:nil
                              completion:nil];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSAttributedString *)title
                                subtitle:(NSAttributedString *)subtitle
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                                duration:(NSTimeInterval)duration
                              atPosition:(RMessagePosition)position
                    canBeDismissedByUser:(BOOL)dismissingEnabled
                                leftView:(UIView *)leftView
                               rightView:(UIView *)rightView
                          backgroundView:(UIView *)backgroundView
                               tapAction:(void (^)(void))tapBlock
                               dismissal:(void (^)(void))dismissalBlock
                              completion:(void (^)(void))completionBlock

{
  RMessageView *messageView = [[RMessageView alloc] initWithDelegate:[RMessage sharedMessage]
                                                               title:title
                                                            subtitle:subtitle
                                                                type:type
                                                      customTypeName:customTypeName
                                                            duration:duration
                                                    inViewController:viewController
                                                          atPosition:position
                                                canBeDismissedByUser:dismissingEnabled
                                                            leftView:leftView
                                                           rightView:rightView
                                                      backgroundView:backgroundView
                                                           tapAction:tapBlock
                                                           dismissal:dismissalBlock
                                                          completion:completionBlock];
  [self prepareNotificationForPresentation:messageView];
}

+ (void)prepareNotificationForPresentation:(RMessageView *)messageView
{
  [[RMessage sharedMessage].messages addObject:messageView];

  if (![RMessage sharedMessage].notificationActive) {
    [[RMessage sharedMessage] presentMessageView];
  }
}

+ (BOOL)dismissActiveNotification
{
  return [self dismissActiveNotificationWithCompletion:nil];
}

+ (BOOL)dismissActiveNotificationWithCompletion:(void (^)(void))completionBlock
{
  if ([RMessage sharedMessage].messages.count == 0 || ![RMessage sharedMessage].messages) return NO;

  dispatch_async(dispatch_get_main_queue(), ^{
    RMessageView *currentMessage = [RMessage sharedMessage].messages[0];
    if (currentMessage && currentMessage.messageIsFullyDisplayed) {
      [[RMessage sharedMessage] dismissMessageView:currentMessage completion:completionBlock];
    }
  });
  return YES;
}

#pragma mark Customizing RMessage

+ (void)setDefaultViewController:(UIViewController *)defaultViewController
{
  _defaultViewController = defaultViewController;
}

+ (void)setDelegate:(id<RMessageProtocol>)delegate
{
  [RMessage sharedMessage].delegate = delegate;
}

+ (void)addDesignsFromFileWithName:(NSString *)filename inBundle:(NSBundle *)bundle
{
  [RMessageView addDesignsFromFileWithName:filename inBundle:bundle];
}

#pragma mark - Misc Methods

+ (BOOL)isNotificationActive
{
  return [RMessage sharedMessage].notificationActive;
}

+ (NSArray *)queuedMessages
{
  return [[RMessage sharedMessage].messages copy];
}

#pragma mark - Instance Methods

- (instancetype)init
{
  self = [super init];
  if (self) {
    _messages = [NSMutableArray new];
  }
  return self;
}

- (void)presentMessageView
{
  if (self.messages.count == 0) return;
  RMessageView *messageView = self.messages[0];

  if (self.delegate && [self.delegate respondsToSelector:@selector(customizeMessageView:)]) {
    [self.delegate customizeMessageView:messageView];
  }
  [messageView present];
}

- (void)dismissMessageView:(RMessageView *)messageView completion:(void (^)(void))completionBlock
{
  [messageView dismissWithCompletion:^{
    // execute the completion block once the messageView has been truly dismissed
    if (completionBlock) {
      completionBlock();
    }
  }];
}

#pragma mark - RMessageView Delegate Methods

- (void)messageViewIsPresenting:(RMessageView *)messageView
{
  self.notificationActive = YES;
  if (self.delegate && [self.delegate respondsToSelector:@selector(messageViewDidPresent:)]) {
    [self.delegate messageViewDidPresent:messageView];
  }
}

- (void)messageViewDidDismiss:(RMessageView *)messageView
{
  if (self.messages.count > 0) {
    [self.messages removeObjectAtIndex:0];
  }
  self.notificationActive = NO;

  if (self.delegate && [self.delegate respondsToSelector:@selector(messageViewDidDismiss:)]) {
    [self.delegate messageViewDidDismiss:messageView];
  }

  if (self.messages.count > 0) {
    [self presentMessageView];
  }
}

- (CGFloat)customVerticalOffsetForMessageView:(RMessageView *)messageView
{
  if (self.delegate && [self.delegate respondsToSelector:@selector(customVerticalOffsetForMessageView:)]) {
    return [self.delegate customVerticalOffsetForMessageView:messageView];
  }
  return 0.f;
}

- (void)windowRemovedForEndlessDurationMessageView:(RMessageView *)messageView
{
  if (self.delegate && [self.delegate respondsToSelector:@selector(windowRemovedForEndlessDurationMessageView:)]) {
    [self.delegate windowRemovedForEndlessDurationMessageView:messageView];
  }
  [self dismissMessageView:messageView completion:nil];
}

- (void)didSwipeToDismissMessageView:(RMessageView *)messageView
{
  if (self.delegate && [self.delegate respondsToSelector:@selector(didSwipeToDismissMessageView:)]) {
    [self.delegate didSwipeToDismissMessageView:messageView];
  }
  [self dismissMessageView:messageView completion:nil];
}

- (void)didTapMessageView:(RMessageView *)messageView
{
  if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMessageView:)]) {
    [self.delegate didTapMessageView:messageView];
  }
  [self dismissMessageView:messageView
                completion:^{
                  [messageView executeMessageViewTapAction];
                }];
}

+ (void)interfaceDidRotate
{
  if ([RMessage sharedMessage].messages.count == 0) return;
  [[RMessage sharedMessage].messages[0] interfaceDidRotate];
}

@end
