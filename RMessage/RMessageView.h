//
//  RMessageView.h
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Adonis Peralta. All rights reserved.
//

#import "RMessage.h"
#import <UIKit/UIKit.h>

@protocol RMessageViewProtocol <NSObject>

@optional
- (void)messageViewIsPresenting:(RMessageView *)messageView;

- (void)messageViewDidPresent:(RMessageView *)messageView;

- (void)messageViewDidDismiss:(RMessageView *)messageView;

- (CGFloat)customVerticalOffsetForMessageView:(RMessageView *)messageView;

- (void)windowRemovedForEndlessDurationMessageView:(RMessageView *)messageView;

- (void)didSwipeMessageView:(RMessageView *)messageView;

- (void)didTapMessageView:(RMessageView *)messageView;

@end

@interface RMessageView : UIView

@property (nonatomic, weak) id<RMessageViewProtocol> delegate;

/** The displayed title of this message */
@property (nonatomic, readonly) NSString *title;

/** The displayed subtitle of this message */
@property (nonatomic, readonly) NSString *subtitle;

/** The displayed button of this message */
@property (nonatomic, readonly) UIButton *button;

/** The view controller this message is displayed in */
@property (nonatomic, readonly) UIViewController *viewController;

/** The duration of the displayed message. If it is 0.0, it will automatically be calculated */
@property (nonatomic, assign) NSTimeInterval duration;

/** The position of the message (top or bottom) */
@property (nonatomic, assign) RMessagePosition messagePosition;

/** The message type that the RMessageView was initialized with */
@property (nonatomic, assign, readonly) RMessageType messageType;

/** The customTypeName if any the RMessageView was initialized with */
@property (nonatomic, copy, readonly) NSString *customTypeName;

/** The opacity of the message view. When customizing RMessage always set this value to the desired opacity instead of
 the alpha property. Internally the alpha property is changed during animations; this property allows RMessage to
 always know the final alpha value.*/
@property (nonatomic, assign) CGFloat messageOpacity;

/** Is the message currently in the process of presenting, but not yet displayed? */
@property (nonatomic, assign) BOOL isPresenting;

/** Is the message currently on screen, fully displayed? */
@property (nonatomic, assign) BOOL messageIsFullyDisplayed;

/** Customize RMessage using Appearance proxy */
@property (nonatomic, strong) UIFont *titleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSTextAlignment titleAlignment UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *titleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont *subtitleFont UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) NSTextAlignment subtitleAlignment UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *subtitleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *messageIcon UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *errorIcon UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *successIcon UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIImage *warningIcon UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) BOOL titleSubtitleLabelsSizeToFit UI_APPEARANCE_SELECTOR;

/**
 Inits the message view. Do not call this from outside this library.
 @param title The title of the message view
 @param subtitle The subtitle of the message view (optional)
 @param iconImage A custom icon image (optional)
 @param messageType The type of message view
 @param duration The duration this notification should be displayed (optional)
 @param viewController The view controller this message should be displayed in
 @param callback The block that should be executed, when the user tapped on the message
 @param buttonTitle The title for button (optional)
 @param buttonCallback The block that should be executed, when the user tapped on the button
 @param position The position of the message on the screen
 @param dismissingEnabled Should this message be dismissed when the user taps/swipes it?
 */
- (instancetype)initWithDelegate:(id<RMessageViewProtocol>)delegate
                           title:(NSString *)title
                        subtitle:(NSString *)subtitle
                       iconImage:(UIImage *)iconImage
                            type:(RMessageType)messageType
                  customTypeName:(NSString *)customTypeName
                        duration:(NSTimeInterval)duration
                inViewController:(UIViewController *)viewController
                        callback:(void (^)(void))callback
                     buttonTitle:(NSString *)buttonTitle
                  buttonCallback:(void (^)(void))buttonCallback
                      atPosition:(RMessagePosition)position
            canBeDismissedByUser:(BOOL)dismissingEnabled;

/**
 Inits the message view. Do not call this from outside this library.
 @param title The title of the message view
 @param subtitle The subtitle of the message view (optional)
 @param iconImage A custom icon image (optional)
 @param messageType The type of message view
 @param duration The duration this notification should be displayed (optional)
 @param viewController The view controller this message should be displayed in
 @param callback The block that should be executed, when the user tapped on the message
 @param presentingCompletionCallback The block that should be executed on presentation of the message view
 @param dismissCompletionCallback The block that should be executed on dismissal of the message view
 @param buttonTitle The title for button (optional)
 @param buttonCallback The block that should be executed, when the user tapped on the button
 @param position The position of the message on the screen
 @param dismissingEnabled Should this message be dismissed when the user taps/swipes it?
 */
- (instancetype)initWithDelegate:(id<RMessageViewProtocol>)delegate
                           title:(NSString *)title
                        subtitle:(NSString *)subtitle
                       iconImage:(UIImage *)iconImage
                            type:(RMessageType)messageType
                  customTypeName:(NSString *)customTypeName
                        duration:(NSTimeInterval)duration
                inViewController:(UIViewController *)viewController
                        callback:(void (^)(void))callback
            presentingCompletion:(void (^)(void))presentingCompletionCallback
               dismissCompletion:(void (^)(void))dismissCompletionCallback
                     buttonTitle:(NSString *)buttonTitle
                  buttonCallback:(void (^)(void))buttonCallback
                      atPosition:(RMessagePosition)position
            canBeDismissedByUser:(BOOL)dismissingEnabled;

/** Use this method to load a custom design file on top of the base design file. Can be called
 multiple times to add designs from multiple files */
+ (void)addDesignsFromFileWithName:(NSString *)filename inBundle:(NSBundle *)bundle;

/** Pass in your own custom button if more customization is needed than provided in init methods.
 When calling this method, normally via customizeMessageView, design file properties will be ignored
 and a strong reference to the button will be made */
- (void)setButton:(UIButton *)button;

/** Execute the message view call back if set */
- (void)executeMessageViewCallBack;

/** Execute the message view button call back if set */
- (void)executeMessageViewButtonCallBack;

/** Present the message view */
- (void)present;

/** Dismiss the view with a completion block */
- (void)dismissWithCompletion:(void (^)(void))completionBlock;

- (void)interfaceDidRotate;

@end
