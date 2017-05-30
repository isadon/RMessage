//
//  RMessageMain.h
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Adonis Peralta. All rights reserved.
//

@class RMessageView;

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RMessageType) {
  RMessageTypeNormal = 0,
  RMessageTypeWarning,
  RMessageTypeError,
  RMessageTypeSuccess,
  RMessageTypeCustom
};

typedef NS_ENUM(NSInteger, RMessagePosition) {
  RMessagePositionTop = 0,
  RMessagePositionNavBarOverlay,
  RMessagePositionBottom
};

/** This enum can be passed to the duration parameter */
typedef NS_ENUM(NSInteger, RMessageDuration) { RMessageDurationAutomatic = 0, RMessageDurationEndless = -1 };

/** Define on which position a specific RMessage should be displayed. */
@protocol RMessageProtocol <NSObject>

@optional

/** Tells the delegate when the message view has finished presenting. */
- (void)messageViewDidPresent:(RMessageView *)messageView;

/** Tells the delegate when the message view has finished dismissing. */
- (void)messageViewDidDismiss:(RMessageView *)messageView;

/** Allows the delegate to influence the vertifical offset for the message view. */
- (CGFloat)customVerticalOffsetForMessageView:(RMessageView *)messageView;

/** Tells the delegate when the window has been removed for an endless duration message view. */
- (void)windowRemovedForEndlessDurationMessageView:(RMessageView *)messageView;

/** Tells the delegate when the message view was swiped to for dismissal. */
- (void)didSwipeToDismissMessageView:(RMessageView *)messageView;

/** Tells the delegate when the message view was tapped. */
- (void)didTapMessageView:(RMessageView *)messageView;

/** Allows the delegate to to customize the RMessageView, like setting its alpha via (messageOpacity) or adding
 a subview. */
- (void)customizeMessageView:(RMessageView *)messageView;

@end

@interface RMessage : NSObject

@property (nonatomic, weak) id<RMessageProtocol> delegate;

+ (instancetype)sharedMessage;

/**
 Shows a notification message in the top-most view controller in the window or the default view controller if set via
 the +setDefaultViewController function
 @param title The title of the message view
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param tapBlock The block that should be executed when the user taps on the message
 */
+ (void)showNotificationWithTitle:(NSAttributedString *)title
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                        tapAction:(void (^)(void))tapBlock;
/**
 Shows a notification message in the top-most view controller in the window or the default view controller if set via
 the +setDefaultViewController function
 @param title The title of the message view
 @param subtitle The text that is displayed underneath the title
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param tapBlock The block that should be executed when the user taps on the message
 */
+ (void)showNotificationWithTitle:(NSAttributedString *)title
                         subtitle:(NSAttributedString *)subtitle
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                        tapAction:(void (^)(void))tapBlock;
/**
 Shows a notification message in the top-most view controller in the window or the default view controller if set via
 the +setDefaultViewController function
 @param title The title of the message view
 @param subtitle The text that is displayed underneath the title
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param duration The duration of the notification being displayed
 @param position The position of the message on the screen
 @param dismissingEnabled Should the message be dismissed when the user taps/swipes it
 @param tapBlock The block that should be executed when the user taps on the message
 */
+ (void)showNotificationWithTitle:(NSAttributedString *)title
                         subtitle:(NSAttributedString *)subtitle
                             type:(RMessageType)type
                   customTypeName:(NSString *)customTypeName
                         duration:(NSTimeInterval)duration
                       atPosition:(RMessagePosition)position
             canBeDismissedByUser:(BOOL)dismissingEnabled
                        tapAction:(void (^)(void))tapBlock;

/**
 Shows a notification message in the top-most view controller in the window or the default view controller if set via
 the +setDefaultViewController function
 @param title The title of the message view
 @param subtitle The text that is displayed underneath the title
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param duration The duration of the notification being displayed
 @param position The position of the message on the screen
 @param dismissingEnabled Should the message be dismissed when the user taps/swipes it
 @param leftView The view to position on the left of the title and subtitle labels
 @param rightView The view to position on the right of the title and subtitle labels
 @param backgroundView The view to position as the background view of the message
 @param tapBlock The block that should be executed when the user taps on the message
 */
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
                        tapAction:(void (^)(void))tapBlock;

/**
 Shows a notification message in the top-most view controller in the window or the default view controller if set via
 the +setDefaultViewController function
 @param title The title of the message view
 @param subtitle The text that is displayed underneath the title
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param duration The duration of the notification being displayed
 @param position The position of the message on the screen
 @param dismissingEnabled Should the message be dismissed when the user taps/swipes it
 @param leftView The view to position on the left of the title and subtitle labels
 @param rightView The view to position on the right of the title and subtitle labels
 @param backgroundView The view to position as the background view of the message
 @param tapBlock The block that should be executed when the user taps on the message
 @param dismissalBlock The block that should be executed, after the message is dismissed
 @param completionBlock The block that should be executed after the message finishes presenting
 */
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
                       completion:(void (^)(void))completionBlock;
/**
 Shows a notification message in a specific view controller
 @param viewController The view controller to show the notification in.
 @param title The title of the message view
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param tapBlock The block that should be executed when the user taps on the message
 */
+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSAttributedString *)title
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                               tapAction:(void (^)(void))tapBlock;

/**
 Shows a notification message in a specific view controller
 @param viewController The view controller to show the notification in.
 @param title The title of the message view
 @param subtitle The text that is displayed underneath the title
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param tapBlock The block that should be executed when the user taps on the message
 */
+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSAttributedString *)title
                                subtitle:(NSAttributedString *)subtitle
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                               tapAction:(void (^)(void))tapBlock;

/**
 Shows a notification message in a specific view controller
 @param viewController The view controller to show the notification in.
 @param title The title of the message view
 @param subtitle The text that is displayed underneath the title
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param duration The duration of the notification being displayed
 @param position The position of the message on the screen
 @param dismissingEnabled Should the message be dismissed when the user taps/swipes it
 @param tapBlock The block that should be executed when the user taps on the message
 */
+ (void)showNotificationInViewController:(UIViewController *)viewController
                                   title:(NSAttributedString *)title
                                subtitle:(NSAttributedString *)subtitle
                                    type:(RMessageType)type
                          customTypeName:(NSString *)customTypeName
                                duration:(NSTimeInterval)duration
                              atPosition:(RMessagePosition)position
                    canBeDismissedByUser:(BOOL)dismissingEnabled
                               tapAction:(void (^)(void))tapBlock;

/**
 Shows a notification message in a specific view controller
 @param viewController The view controller to show the notification in.
 @param title The title of the message view
 @param subtitle The text that is displayed underneath the title
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param duration The duration of the notification being displayed
 @param position The position of the message on the screen
 @param dismissingEnabled Should the message be dismissed when the user taps/swipes it
 @param leftView The view to position on the left of the title and subtitle labels
 @param rightView The view to position on the right of the title and subtitle labels
 @param backgroundView The view to position as the background view of the message
 @param tapBlock The block that should be executed when the user taps on the message
 */
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
                               tapAction:(void (^)(void))tapBlock;

/**
 Shows a notification message in a specific view controller
 @param viewController The view controller to show the notification in.
 @param title The title of the message view
 @param subtitle The text that is displayed underneath the title
 @param type The message type (Message, Warning, Error, Success, Custom)
 @param customTypeName The string identifier/key for the custom style to use from specified custom
 design file. Only use when specifying an additional custom design file and when the type parameter in this call is
 RMessageTypeCustom
 @param duration The duration of the notification being displayed
 @param position The position of the message on the screen
 @param leftView The view to position on the left of the title and subtitle labels
 @param rightView The view to position on the right of the title and subtitle labels
 @param backgroundView The view to position as the background view of the message
 @param dismissingEnabled Should the message be dismissed when the user taps/swipes it
 @param tapBlock The block that should be executed when the user taps on the message
 @param dismissalBlock The block that should be executed, after the message is dismissed
 @param completionBlock The block that should be executed after the message finishes presenting
 */
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
                              completion:(void (^)(void))completionBlock;

/**
 Fades out the currently displayed notification. If another notification is in the queue,
 the next one will be displayed automatically
 @return YES if the currently displayed notification was successfully dismissed. NO if no
 notification was currently displayed.
 */
+ (BOOL)dismissActiveNotification;

/**
 Fades out the currently displayed notification with a completion block after the animation has
 finished. If another notification is in the queue, the next one will be displayed automatically
 @return YES if the currently displayed notification was successfully dismissed. NO if no
 notification was currently displayed.
 */
+ (BOOL)dismissActiveNotificationWithCompletion:(void (^)(void))completionBlock;

/** Use this method to set a default view controller to display the messages in */
+ (void)setDefaultViewController:(UIViewController *)defaultViewController;

/** Set a delegate to have full control over the position of the message view */
+ (void)setDelegate:(id<RMessageProtocol>)delegate;

/** Use this method to use custom designs in your messages. Must be a JSON formatted file - do not include the .json
 extension in the name*/
+ (void)addDesignsFromFileWithName:(NSString *)filename inBundle:(NSBundle *)bundle;

/** Indicates whether a notification is currently active. */
+ (BOOL)isNotificationActive;

/** Returns the currently queued array of RMessageView */
+ (NSArray *)queuedMessages;

/** Prepares the message view to be displayed in the future. It is queued and then displayed in
 fadeInCurrentNotification. You don't have to use this method. */
+ (void)prepareNotificationForPresentation:(RMessageView *)messageView;

/**
 Call this method to notify any presenting or on screen messages that the interface has rotated.
 Ideally should go inside the calling view controllers viewWillTransitionToSize:withTransitionCoordinator: method.
 */
+ (void)interfaceDidRotate;

@end
