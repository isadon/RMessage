//
//  RMessageView.m
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Adonis Peralta. All rights reserved.
//

#import "RMessageView.h"
#import "HexColors.h"
#import "UIViewController+PPTopMostController.h"

static NSString *const RDesignFileName = @"RMessageDefaultDesign";

/** animation constants */
static double const kRMessageAnimationDuration = 0.3f;
static double const kRMessageDisplayTime = 1.5f;
static double const kRMessageExtraDisplayTimePerPixel = 0.04f;

/** Contains the global design dictionary specified in the entire design RDesignFile */
static NSMutableDictionary *globalDesignDictionary;

@interface RMessageView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) IBOutlet UIImageView *iconImageView;
@property (nonatomic, weak) IBOutlet UIImageView *backgroundImageView;
@property (nonatomic, weak) IBOutlet UIView *titleSubtitleContainerView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleSubtitleContainerViewTopLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleSubtitleContainerViewCenterYConstraint;

@property (nonatomic, strong) UIImage *iconImage;

/** Contains the appropriate design dictionary for the specified message view type */
@property (nonatomic, strong) NSDictionary *messageViewDesignDictionary;

/** The displayed title of this message */
@property (nonatomic, strong) NSString *title;

/** The displayed subtitle of this message view */
@property (nonatomic, strong) NSString *subtitle;

/** The title of the added button */
@property (nonatomic, strong) NSString *buttonTitle;

/** The view controller this message is displayed in */
@property (nonatomic, strong) UIViewController *viewController;

/** The vertical space between the message view top to its view controller top */
@property (nonatomic, strong) NSLayoutConstraint *topToVCLayoutConstraint;

@property (nonatomic, copy) void (^callback)();

@property (nonatomic, copy) void (^buttonCallback)();

/** The starting constant value that should be set for the topToVCTopLayoutConstraint when animating */
@property (nonatomic, assign) CGFloat topToVCStartConstant;

/** The final constant value that should be set for the topToVCTopLayoutConstraint when animating */
@property (nonatomic, assign) CGFloat topToVCFinalConstant;

@property (nonatomic, assign) CGFloat iconRelativeCornerRadius;
@property (nonatomic, assign) RMessageType messageType;
@property (nonatomic, copy) NSString *customTypeName;

@end

@implementation RMessageView

#pragma mark - Class Methods

+ (NSError *)setupGlobalDesignDictionary
{
    if (!globalDesignDictionary) {
        NSString *path = [[NSBundle bundleForClass:[self class]] pathForResource:RDesignFileName ofType:@"json"];
        NSData *data = [NSData dataWithContentsOfFile:path];
        NSAssert(data != nil, @"Could not read RMessage config file from main bundle with name %@.json", RDesignFileName);
        if (!data) {
            NSString *configFileErrorMessage = [NSString stringWithFormat:@"There seems to be an error with the %@ configuration file", RDesignFileName];
            return [NSError errorWithDomain:[NSBundle bundleForClass:[self class]].bundleIdentifier code:0 userInfo:@{NSLocalizedDescriptionKey:configFileErrorMessage}];
        }
        globalDesignDictionary = [NSMutableDictionary
                                  dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data
                                                                                           options:kNilOptions
                                                                                             error:nil]];
    }
    return nil;
}

+ (void)addDesignsFromFileWithName:(NSString *)filename inBundle:(NSBundle *)bundle;
{
    [RMessageView setupGlobalDesignDictionary];
    NSString *path = [bundle pathForResource:filename ofType:@"json"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
        NSDictionary *newDesignStyle = [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path]
                                                                       options:kNilOptions
                                                                         error:nil];
        [globalDesignDictionary addEntriesFromDictionary:newDesignStyle];
    } else {
        NSAssert(NO, @"Error loading design file with name %@", filename);
    }
}

+ (BOOL)isNavigationBarHiddenForNavigationController:(UINavigationController *)navController
{
    if (navController.navigationBarHidden) {
        return YES;
    } else if (navController.navigationBar.isHidden) {
        return YES;
    } else {
        return NO;
    }
}

+ (BOOL)compilingForHigherThanIosVersion:(CGFloat)version
{
#if __IPHONE_OS_VERSION_MAX_ALLOWED >= version * 10000
    return YES;
#else
    return NO;
#endif
}

+ (UIViewController *)defaultViewController
{
    UIViewController *viewController = [UIViewController topMostController];
    if (!viewController) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    return viewController;
}

/**
 *  Method which determines if viewController edges extend under top bars (navigation bars for example).
 *  There are various scenarios and even iOS bugs in which view controllers that ask to
 *  present under top bars don't truly do but this method hopes to properly catch all these bugs and scenarios and
 *  let its caller know.
 *
 *  @return YES if viewController
 */
+ (BOOL)viewControllerEdgesExtendUnderTopBars:(UIViewController *)viewController
{
    BOOL vcAskedToExtendUnderTopBars = NO;

    if (viewController.edgesForExtendedLayout == UIRectEdgeTop || viewController.edgesForExtendedLayout == UIRectEdgeAll) {
        vcAskedToExtendUnderTopBars = YES;
    } else {
        vcAskedToExtendUnderTopBars = NO;
        return NO;
    }

    // When a table view controller asks to extend under top bars, if the navigation bar is translucent iOS will not
    // extend the edges of the table view controller under the top bars.
    if ([viewController isKindOfClass:[UITableViewController class]] && vcAskedToExtendUnderTopBars && !viewController.navigationController.navigationBar.translucent) {
        return NO;
    }

    return YES;
}

#pragma mark - Get Image From Resource Bundle

+ (UIImage *)bundledImageNamed:(NSString*)name
{
    NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:nil];
    return [[UIImage alloc] initWithContentsOfFile:imagePath];
}

#pragma mark - Instance Methods

- (instancetype)initWithDelegate:(id<RMessageViewProtocol>)delegate
                           title:(NSString *)title
                        subtitle:(NSString *)subtitle
                       iconImage:(UIImage *)iconImage
                            type:(RMessageType)messageType
                customTypeName:(NSString *)customTypeName
                        duration:(CGFloat)duration
                inViewController:(UIViewController *)viewController
                        callback:(void (^)())callback
                     buttonTitle:(NSString *)buttonTitle
                  buttonCallback:(void (^)())buttonCallback
                      atPosition:(RMessagePosition)position
            canBeDismissedByUser:(BOOL)dismissingEnabled
{
    self = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class])
                                                          owner:self
                                                        options:nil].firstObject;
    if (self) {
        _delegate = delegate;
        _title = title;
        _subtitle = subtitle;
        _messageOpacity = 0.97f;
        _iconImage = iconImage;
        _duration = duration;
        viewController ? _viewController = viewController : (_viewController = [RMessageView defaultViewController]);
        _messagePosition = position;
        _callback = callback;
        _messageType = messageType;
        _customTypeName = customTypeName;
        _buttonCallback = buttonCallback;

        NSError *designError = [self setupDesignDictionariesWithMessageType:_messageType customTypeName:customTypeName];
        if (designError) {
            return nil;
        }

        [self setupDesign];
        [self setupLayout];
        if (dismissingEnabled) {
            [self setupGestureRecognizers];
        }
    }
    return self;
}

- (CGSize)intrinsicContentSize
{
    return CGSizeMake(self.viewController.view.bounds.size.width, self.titleSubtitleContainerView.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height);
}

- (void)setSubtitleFont:(UIFont *)subtitleFont
{
    _subtitleFont = subtitleFont;
    [self.subtitleLabel setFont:subtitleFont];
}

- (void)setSubtitleTextColor:(UIColor *)subtitleTextColor
{
    _subtitleTextColor = subtitleTextColor;
    [self.subtitleLabel setTextColor:_subtitleTextColor];
}

- (void)setTitleFont:(UIFont *)aTitleFont
{
    _titleFont = aTitleFont;
    [self.titleLabel setFont:_titleFont];
}

- (void)setTitleTextColor:(UIColor *)aTextColor
{
    _titleTextColor = aTextColor;
    [self.titleLabel setTextColor:_titleTextColor];
}

- (void)setMessageIcon:(UIImage *)messageIcon
{
    _messageIcon = messageIcon;
    [self updateCurrentIconIfNeeded];
}

- (void)setErrorIcon:(UIImage *)errorIcon
{
    _errorIcon = errorIcon;
    [self updateCurrentIconIfNeeded];
}

- (void)setSuccessIcon:(UIImage *)successIcon
{
    _successIcon = successIcon;
    [self updateCurrentIconIfNeeded];
}

- (void)setWarningIcon:(UIImage *)warningIcon
{
    _warningIcon = warningIcon;
    [self updateCurrentIconIfNeeded];
}

- (void)updateCurrentIconIfNeeded
{
    UIImage *image = nil;
    switch (self.messageType) {
        case RMessageTypeNormal:
        {
            image = _messageIcon;
            self.iconImageView.image = _messageIcon;
            break;
        }
        case RMessageTypeError:
        {
            image = _errorIcon;
            self.iconImageView.image = _errorIcon;
            break;
        }
        case RMessageTypeSuccess:
        {
            image = _successIcon;
            self.iconImageView.image = _successIcon;
            break;
        }
        case RMessageTypeWarning:
        {
            image = _warningIcon;
            self.iconImageView.image = _warningIcon;
            break;
        }
        default:
            break;
    }
}

- (NSError *)setupDesignDictionariesWithMessageType:(RMessageType)messageType
                                   customTypeName:(NSString *)customTypeName
{
    [RMessageView setupGlobalDesignDictionary];
    NSString *messageTypeDesignString;
    switch (messageType) {
        case RMessageTypeNormal:
            messageTypeDesignString = @"normal";
            break;
        case RMessageTypeError:
            messageTypeDesignString = @"error";
            break;
        case RMessageTypeSuccess:
            messageTypeDesignString = @"success";
            break;
        case RMessageTypeWarning:
            messageTypeDesignString = @"warning";
            break;
        case RMessageTypeCustom:
            NSParameterAssert(customTypeName != nil);
            NSParameterAssert(![customTypeName isEqualToString: @""]);
            if (!customTypeName || [customTypeName isEqualToString:@""]) {
                return [NSError errorWithDomain:[NSBundle bundleForClass:[self class]].bundleIdentifier code:0 userInfo:@{NSLocalizedDescriptionKey:@"When specifying a type RMessageTypeCustom make sure to pass in a valid argument for customTypeName parameter. This string should match a Key in your custom design file."}];
            }
            messageTypeDesignString = customTypeName;
            break;
        default:
            break;
    }

    _messageViewDesignDictionary = [globalDesignDictionary valueForKey:messageTypeDesignString];
    NSParameterAssert(_messageViewDesignDictionary != nil);
    if (!_messageViewDesignDictionary) {
        return [NSError errorWithDomain:[NSBundle bundleForClass:[self class]].bundleIdentifier code:0 userInfo:@{NSLocalizedDescriptionKey:@"When specifying a type RMessageTypeCustom make sure to pass in a valid argument for customTypeName parameter. This string should match a Key in your custom design file."}];
    }
    return nil;
}

- (void)setupDesign
{
    [self setupDesignDefaults];
    [self setupImagesAndBackground];
    [self setupTitleLabel];
    [self setupSubTitleLabel];
}

- (void)setupLayout
{
    self.translatesAutoresizingMaskIntoConstraints = NO;

    // Add RMessage to superview and prepare the ending y position constants
    if ([self.viewController isKindOfClass:[UINavigationController class]] || [self.viewController.parentViewController isKindOfClass:[UINavigationController class]]) {
        [self layoutMessageForNavigationControllerPresentation];
    } else {
        [self layoutMessageForStandardPresentation];
    }

    // Prepare the starting y position constants
    if (self.messagePosition != RMessagePositionBottom) {
        [self layoutIfNeeded];
        self.topToVCStartConstant = -self.bounds.size.height;
        self.topToVCLayoutConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.viewController.view
                                                                    attribute:NSLayoutAttributeTop
                                                                   multiplier:1.f
                                                                     constant:self.topToVCStartConstant];
    } else {
        self.topToVCStartConstant = 0;
        self.topToVCLayoutConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                    attribute:NSLayoutAttributeTop
                                                                    relatedBy:NSLayoutRelationEqual
                                                                       toItem:self.viewController.view
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.f
                                                                     constant:0.f];
    }

    NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                        attribute:NSLayoutAttributeCenterX
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.viewController.view
                                                                        attribute:NSLayoutAttributeCenterX
                                                                       multiplier:1.f
                                                                         constant:0.f];
    if ([RMessageView compilingForHigherThanIosVersion:8.f]) {
        centerXConstraint.active = YES;
        self.topToVCLayoutConstraint.active = YES;
    } else {
        [self.viewController.view addConstraints:@[centerXConstraint, self.topToVCLayoutConstraint]];
    }
}

- (void)executeMessageViewCallBack
{
    if (self.callback) {
        self.callback();
    }
}

- (void)executeMessageViewButtonCallBack
{
    if (self.buttonCallback) {
        self.buttonCallback();
    }
}

- (void)didMoveToWindow
{
    [super didMoveToWindow];
    if (self.duration == RMessageDurationEndless && self.superview && !self.window) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(windowRemovedForEndlessDurationMessageView:)]) {
            [self.delegate windowRemovedForEndlessDurationMessageView:self];
        }
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (self.iconRelativeCornerRadius > 0) {
        self.iconImageView.layer.cornerRadius = self.iconRelativeCornerRadius * self.iconImageView.bounds.size.width;
    }
}

- (void)setupDesignDefaults
{
    self.backgroundColor = [UIColor lightGrayColor];
    self.alpha = _messageOpacity;
    _titleLabel.numberOfLines = 0;
    _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.shadowColor = nil;
    _titleLabel.shadowOffset = CGSizeZero;
    _titleLabel.backgroundColor = nil;

    _subtitleLabel.numberOfLines = 0;
    _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _subtitleLabel.font = [UIFont boldSystemFontOfSize:12.f];
    _subtitleLabel.textColor = [UIColor darkGrayColor];
    _subtitleLabel.shadowColor = nil;
    _subtitleLabel.shadowOffset = CGSizeZero;
    _subtitleLabel.backgroundColor = nil;

    _iconImageView.clipsToBounds = NO;
}

- (void)setupImagesAndBackground
{
    UIColor *backgroundColor = [self colorForString:_messageViewDesignDictionary[@"backgroundColor"]];
    if (backgroundColor) self.backgroundColor = backgroundColor;
    id messageOpacity = _messageViewDesignDictionary[@"opacity"];
    if (messageOpacity) {
        _messageOpacity = [messageOpacity floatValue];
        self.alpha = _messageOpacity;
    }

    if (!_iconImage && ((NSString*)[_messageViewDesignDictionary valueForKey:@"iconImage"]).length > 0) {
        _iconImage = [RMessageView bundledImageNamed:[_messageViewDesignDictionary valueForKey:@"iconImage"]];
        if (!_iconImage) {
            _iconImage = [UIImage imageNamed:[_messageViewDesignDictionary valueForKey:@"iconImage"]];
        }
    }

    if (_iconImage) {
        _iconImageView.image = _iconImage;
        if ([_messageViewDesignDictionary valueForKey:@"iconImageRelativeCornerRadius"]) {
            self.iconRelativeCornerRadius = [[_messageViewDesignDictionary valueForKey:@"iconImageRelativeCornerRadius"] floatValue];
            _iconImageView.clipsToBounds = YES;
        } else {
             self.iconRelativeCornerRadius = 0.f;
            _iconImageView.clipsToBounds = NO;
        }
    }

    UIImage *backgroundImage = [RMessageView bundledImageNamed:[_messageViewDesignDictionary valueForKey:@"backgroundImage"]];
    if (backgroundImage) {
        backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0) resizingMode:UIImageResizingModeStretch];
        _backgroundImageView.image = backgroundImage;
    }
}

- (void)setupTitleLabel
{
    UIColor *titleTextColor = [self colorForString:[_messageViewDesignDictionary valueForKey:@"titleTextColor"]];
    _titleLabel.text = _title ? _title : @"";
    if (titleTextColor) _titleLabel.textColor = titleTextColor;

    CGFloat titleFontSize = [[_messageViewDesignDictionary valueForKey:@"titleFontSize"] floatValue];
    NSString *titleFontName = [_messageViewDesignDictionary valueForKey:@"titleFontName"];
    if (titleFontName) {
        _titleLabel.font = [UIFont fontWithName:titleFontName size:titleFontSize];
    } else if (titleFontSize) {
        _titleLabel.font = [UIFont boldSystemFontOfSize:titleFontSize];
    }

    UIColor *titleShadowColor = [self colorForString:[_messageViewDesignDictionary valueForKey:@"titleShadowColor"]];
    if (titleShadowColor) _titleLabel.shadowColor = titleShadowColor;
    id titleShadowOffsetX = [_messageViewDesignDictionary valueForKey:@"titleShadowOffsetX"];
    id titleShadowOffsetY = [_messageViewDesignDictionary valueForKey:@"titleShadowOffsetY"];
    if (titleShadowOffsetX && titleShadowOffsetY) {
        _titleLabel.shadowOffset = CGSizeMake([titleShadowOffsetX floatValue], [titleShadowOffsetY floatValue]);
    }
    _titleLabel.preferredMaxLayoutWidth = self.viewController.view.bounds.size.width - _iconImage.size.width - 70.f;
}

- (void)setupSubTitleLabel
{
    UIColor *subTitleTextColor = [self colorForString:[_messageViewDesignDictionary valueForKey:@"subTitleTextColor"]];
    if (!subTitleTextColor) {
        subTitleTextColor = [self colorForString:[_messageViewDesignDictionary valueForKey:@"subtitleTextColor"]];
    }
    if (!subTitleTextColor) {
        subTitleTextColor = _titleLabel.textColor;
    }

    id subTitleFontSizeValue = [_messageViewDesignDictionary valueForKey:@"subTitleFontSize"];
    if (!subTitleFontSizeValue) {
        subTitleFontSizeValue = [_messageViewDesignDictionary valueForKey:@"subtitleFontSize"];
    }

    CGFloat subTitleFontSize = [subTitleFontSizeValue floatValue];
    NSString *subTitleFontName = [_messageViewDesignDictionary valueForKey:@"subTitleFontName"];
    if (!subTitleFontName) {
        subTitleFontName = [_messageViewDesignDictionary valueForKey:@"subtitleFontName"];
    }

    _subtitleLabel.numberOfLines = 0;
    _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    _subtitleLabel.text = _subtitle ? _subtitle : @"";
    if (subTitleTextColor) _subtitleLabel.textColor = subTitleTextColor;

    UIColor *subTitleShadowColor = [self colorForString:[_messageViewDesignDictionary valueForKey:@"subTitleShadowColor"]];
    if (!subTitleShadowColor) {
        subTitleShadowColor = [self colorForString:[_messageViewDesignDictionary valueForKey:@"subtitleShadowColor"]];
    }

    if (subTitleShadowColor) _subtitleLabel.shadowColor = subTitleShadowColor;
    id subTitleShadowOffsetX = [_messageViewDesignDictionary valueForKey:@"subTitleShadowOffsetX"];
    id subTitleShadowOffsetY = [_messageViewDesignDictionary valueForKey:@"subTitleShadowOffsetY"];
    if (!subTitleShadowOffsetX) {
        subTitleShadowOffsetX = [_messageViewDesignDictionary valueForKey:@"subtitleShadowOffsetX"];
    }
    if (!subTitleShadowOffsetY) {
        subTitleShadowOffsetY = [_messageViewDesignDictionary valueForKey:@"subtitleShadowOffsetY"];
    }
    if (subTitleShadowOffsetX && subTitleShadowOffsetY) {
        _subtitleLabel.shadowOffset = CGSizeMake([subTitleShadowOffsetX floatValue], [subTitleShadowOffsetY floatValue]);
    }

    if (subTitleFontName) {
        _subtitleLabel.font = [UIFont fontWithName:subTitleFontName size:subTitleFontSize];
    } else if (subTitleFontSize) {
        _subtitleLabel.font = [UIFont systemFontOfSize:subTitleFontSize];
    }
    _subtitleLabel.preferredMaxLayoutWidth = _titleLabel.preferredMaxLayoutWidth;
}

- (void)setupGestureRecognizers
{
    UISwipeGestureRecognizer *gestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self
                                                                                            action:@selector(didSwipeToDismissMessageView:)];
    [gestureRecognizer setDirection:(self.messagePosition == RMessagePositionTop ?
                                     UISwipeGestureRecognizerDirectionUp :
                                     UISwipeGestureRecognizerDirectionDown)];
    [self addGestureRecognizer:gestureRecognizer];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                    action:@selector(didTapMessageView:)];
    [self addGestureRecognizer:tapRecognizer];
}

#pragma mark - Gesture Recognizers

/** called after the following gesture depending on message position during initialization
 UISwipeGestureRecognizerDirectionUp when message position set to Top, UISwipeGestureRecognizerDirectionDown when
 message position set to Bottom */
- (void)didSwipeToDismissMessageView:(UISwipeGestureRecognizer *)swipeGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didSwipeToDismissMessageView:)]) {
        [self.delegate didSwipeToDismissMessageView:self];
    }
}

- (void)didTapMessageView:(UITapGestureRecognizer *)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(didTapMessageView:)]) {
        [self.delegate didTapMessageView:self];
    }
}

#pragma mark - Presentation Methods

- (void)present
{
    [self animateMessage];

    if (self.duration == RMessageDurationAutomatic) {
        self.duration = kRMessageAnimationDuration + kRMessageDisplayTime + self.frame.size.height * kRMessageExtraDisplayTimePerPixel;
    }

    if (self.duration != RMessageDurationEndless) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self performSelector:@selector(dismiss)
                       withObject:self
                       afterDelay:self.duration];
        });
    }
}

- (void)layoutMessageForNavigationControllerPresentation
{
    self.titleSubtitleContainerViewTopLayoutConstraint.constant = 10.f;
    self.titleSubtitleContainerViewCenterYConstraint.constant = 0.f;

    UINavigationController *messageNavigationController;

    if ([self.viewController isKindOfClass:[UINavigationController class]]) {
        messageNavigationController = (UINavigationController *)self.viewController;
    } else {
        messageNavigationController = (UINavigationController *)self.viewController.parentViewController;
    }

    BOOL messageNavigationBarHidden = [RMessageView isNavigationBarHiddenForNavigationController:messageNavigationController];

    // Navigation bar is shown and we are being asked to present from below nav bar (not as an overlay)
    if (!messageNavigationBarHidden && self.messagePosition != RMessagePositionNavBarOverlay) {
        // position notification below nav bar so it animates from below the nav bar
        [messageNavigationController.view insertSubview:self
                                        belowSubview:messageNavigationController.navigationBar];

        // If view controller edges dont extend under top bars (navigation bar in our case) we must not factor in the
        // navigation bar frame when animating RMessage's final position.
        if ([[self class] viewControllerEdgesExtendUnderTopBars:self.viewController]) {
            self.topToVCFinalConstant = [UIApplication sharedApplication].statusBarFrame.size.height + messageNavigationController.navigationBar.bounds.size.height + [self customVerticalOffset];
        } else {
            self.topToVCFinalConstant = [self customVerticalOffset];
        }
    } else {
        self.topToVCFinalConstant = [self customVerticalOffset];
        self.titleSubtitleContainerViewTopLayoutConstraint.constant = 10.f + [UIApplication sharedApplication].statusBarFrame.size.height;
        self.titleSubtitleContainerViewCenterYConstraint.constant = [UIApplication sharedApplication].statusBarFrame.size.height / 2.f;

        // Navigation bar hidden and we are being asked to show below just the status bar
        [self.viewController.view addSubview:self];
    }

    // Asking to animate from bottom up.. set the topToVCFinalConstant here.
    if (self.messagePosition == RMessagePositionBottom) {
        [self layoutIfNeeded];
        CGFloat offset = -self.bounds.size.height - [self customVerticalOffset];
        if (messageNavigationController && !messageNavigationController.isToolbarHidden) {
            // If tool bar present animate above toolbar
            offset -= messageNavigationController.toolbar.bounds.size.height;
        }
        self.topToVCFinalConstant = offset;
    }
}

- (void)layoutMessageForStandardPresentation
{
    self.topToVCFinalConstant = [self customVerticalOffset];
    self.titleSubtitleContainerViewTopLayoutConstraint.constant = 10.f + [UIApplication sharedApplication].statusBarFrame.size.height;
    self.titleSubtitleContainerViewCenterYConstraint.constant = [UIApplication sharedApplication].statusBarFrame.size.height / 2.f;
    [self.viewController.view addSubview:self];
}

- (void)animateMessage
{
    [self.superview layoutIfNeeded];
    self.alpha = 0.f;
    [UIView animateWithDuration:kRMessageAnimationDuration + 0.2f
                          delay:0.f
         usingSpringWithDamping:0.7
          initialSpringVelocity:0.f
                        options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionAllowUserInteraction
                     animations:^{
                         self.alpha = self.messageOpacity;
                         self.topToVCLayoutConstraint.constant = self.topToVCFinalConstant;
                         [self.superview layoutIfNeeded];
                     }
                     completion:^(BOOL finished) {
                         self.messageIsFullyDisplayed = YES;
                         if ([self.delegate respondsToSelector:@selector(messageViewDidPresent:)]) {
                             [self.delegate messageViewDidPresent:self];
                         }
                     }];
}

- (void)dismiss
{
    [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^) (void))completionBlock
{
    self.messageIsFullyDisplayed = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self
                                             selector:@selector(dismiss)
                                               object:self];

    [UIView animateWithDuration:kRMessageAnimationDuration animations:^{
        self.alpha = 0.f;
        self.topToVCLayoutConstraint.constant = self.topToVCStartConstant;
        [self.superview layoutIfNeeded];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if ([self.delegate respondsToSelector:@selector(messageViewDidDismiss:)]) {
            [self.delegate messageViewDidDismiss:self];
        }
        if (completionBlock) completionBlock();
    }];
}

#pragma mark - Misc methods

/**
 *  Get the custom vertical offset from the delegate if any
 *  @return a custom vertical offset or 0.f
 */
- (CGFloat)customVerticalOffset
{
    CGFloat customVerticalOffset = 0.f;
    if (self.delegate && [self.delegate respondsToSelector:@selector(customVerticalOffsetForMessageView:)]) {
        customVerticalOffset = [self.delegate customVerticalOffsetForMessageView:self];
    }
    return customVerticalOffset;
}

/**
 *  Wrapper method to avoid getting a black color when passing a nil string to hx_colorWithHexRGBAString
 *
 *  @param string A hex string representation of a color.
 *
 *  @return nil or a color.
 */
- (UIColor *)colorForString:(NSString *)string
{
    if (string) {
        return [UIColor hx_colorWithHexRGBAString:string];
    }
    return nil;
}

@end
