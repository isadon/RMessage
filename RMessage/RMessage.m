//
//  RMessage.m
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Adonis Peralta. All rights reserved.
//

#import "RMessage.h"
#import "RMessageView.h"

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

+ (void)showNotificationWithTitle:(NSString *)title
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                         callback:(void (^)())callback
{
    [self showNotificationWithTitle:title
                           subtitle:nil
                               type:type
                     customTypeName:customTypeName
                           callback:callback];
}

+ (void)showNotificationWithTitle:(NSString *)title
                         subtitle:(NSString *)subtitle
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                         callback:(void (^)())callback
{
    [self showNotificationInViewController:_defaultViewController
                                     title:title
                                  subtitle:subtitle
                                      type:type
                            customTypeName:customTypeName
                                  callback:callback];
}

+ (void)showNotificationWithTitle:(NSString *)title
                         subtitle:(NSString *)subtitle
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                         duration:(NSTimeInterval)duration
                         callback:(void (^)())callback
{
    [self showNotificationInViewController:_defaultViewController
                                     title:title
                                  subtitle:subtitle
                                      type:type
                            customTypeName:customTypeName
                                  duration:duration
                                  callback:callback];
}

+ (void)showNotificationWithTitle:(NSString *)title
                         subtitle:(NSString *)subtitle
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                         duration:(NSTimeInterval)duration
                         callback:(void (^)())callback
             canBeDismissedByUser:(BOOL)dismissingEnabled
{
    [self showNotificationInViewController:_defaultViewController
                                     title:title
                                  subtitle:subtitle
                                      type:type
                            customTypeName:customTypeName
                                  duration:duration
                                  callback:callback
                      canBeDismissedByUser:dismissingEnabled];
}

+ (void)showNotificationWithTitle:(NSString *)title
                         subtitle:(NSString *)subtitle
                        iconImage:(UIImage *)iconImage
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                         duration:(NSTimeInterval)duration
                         callback:(void (^)())callback
                      buttonTitle:(NSString *)buttonTitle
                   buttonCallback:(void (^)())buttonCallback
                       atPosition:(RMessagePosition)messagePosition
             canBeDismissedByUser:(BOOL)dismissingEnabled
{
    [self showNotificationInViewController:_defaultViewController
                                     title:title
                                  subtitle:subtitle
                                 iconImage:iconImage
                                      type:type
                            customTypeName:customTypeName
                                  duration:duration
                                  callback:callback
                               buttonTitle:buttonTitle
                            buttonCallback:buttonCallback
                                atPosition:messagePosition
                      canBeDismissedByUser:dismissingEnabled];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                                duration:(NSTimeInterval)duration
                                callback:(void (^)())callback
{
    [self showNotificationInViewController:viewController
                                     title:title
                                  subtitle:subtitle
                                 iconImage:nil
                                      type:type
                            customTypeName:customTypeName
                                  duration:duration
                                  callback:callback
                               buttonTitle:nil
                            buttonCallback:nil
                                atPosition:RMessagePositionTop
                      canBeDismissedByUser:YES];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                                duration:(NSTimeInterval)duration
                                callback:(void (^)())callback
                    canBeDismissedByUser:(BOOL)dismissingEnabled
{
    [self showNotificationInViewController:viewController
                                     title:title
                                  subtitle:subtitle
                                 iconImage:nil
                                      type:type
                            customTypeName:customTypeName
                                  duration:duration
                                  callback:callback
                               buttonTitle:nil
                            buttonCallback:nil
                                atPosition:RMessagePositionTop
                      canBeDismissedByUser:dismissingEnabled];
}

+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                                callback:(void (^)())callback
{
    [self showNotificationInViewController:viewController
                                     title:title
                                  subtitle:subtitle
                                 iconImage:nil
                                      type:type
                            customTypeName:customTypeName
                                  duration:RMessageDurationAutomatic
                                  callback:callback
                               buttonTitle:nil
                            buttonCallback:nil
                                atPosition:RMessagePositionTop
                      canBeDismissedByUser:YES];
}


+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSString *)title
                                subtitle:(NSString *)subtitle
                               iconImage:(UIImage *)iconImage
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                                duration:(NSTimeInterval)duration
                                callback:(void (^)())callback
                             buttonTitle:(NSString *)buttonTitle
                          buttonCallback:(void (^)())buttonCallback
                              atPosition:(RMessagePosition)messagePosition
                    canBeDismissedByUser:(BOOL)dismissingEnabled
{
    // Create the RMessageView
    RMessageView *messageView = [[RMessageView alloc] initWithDelegate:[RMessage sharedMessage]
                                                                 title:title
                                                              subtitle:subtitle
                                                             iconImage:iconImage
                                                                  type:type
                                                        customTypeName:customTypeName
                                                              duration:duration
                                                      inViewController:viewController
                                                              callback:callback
                                                           buttonTitle:buttonTitle
                                                        buttonCallback:buttonCallback
                                                            atPosition:messagePosition
                                                  canBeDismissedByUser:dismissingEnabled];
    [self prepareNotificationForPresentation:messageView];
}


+ (void)prepareNotificationForPresentation:(RMessageView *)messageView
{
    NSString *title = messageView.title;
    NSString *subtitle = messageView.subtitle;

    for (RMessageView *messageView in [RMessage sharedMessage].messages) {
        if (([messageView.title isEqualToString:title] || (!messageView.title && !title)) && ([messageView.subtitle isEqualToString:subtitle] || (!messageView.subtitle && !subtitle))) {
            return; // avoid showing the same messages twice in a row
        }
    }

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

# pragma mark - Instance Methods

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

- (void)dismissMessageView:(RMessageView *)messageView completion:(void (^) (void))completionBlock
{
    [messageView dismissWithCompletion:^{
        //execute the completion block once the messageView has been truly dismissed
        if (completionBlock) {
            completionBlock();
        }
    }];
}

# pragma mark - RMessageView Delegate Methods

- (void)messageViewDidPresent:(RMessageView *)messageView
{
    self.notificationActive = YES;
}

- (void)messageViewDidDismiss:(RMessageView *)messageView
{
    if (self.messages.count > 0) {
        [self.messages removeObjectAtIndex:0];
    }
    self.notificationActive = NO;
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
    [self dismissMessageView:messageView completion:nil];
}

- (void)didSwipeToDismissMessageView:(RMessageView *)messageView
{
    [self dismissMessageView:messageView completion:nil];
}

- (void)didTapMessageView:(RMessageView *)messageView
{
    [self dismissMessageView:messageView completion:^{
        [messageView executeMessageViewCallBack];
    }];
}

@end
