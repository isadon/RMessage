//
//  RMessageView.m
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Adonis Peralta. All rights reserved.
//

#import "RMessageView.h"
#import "UIWindow+TopViewController.h"
#import <HexColors/HexColors.h>

static NSString *const RDesignFileName = @"RMessageDefaultDesign";

/** Animation constants */
static double const kRMessageAnimationDuration = 0.3f;
static double const kRMessageDisplayTime = 1.5f;
static double const kRMessageExtraDisplayTimePerPixel = 0.04f;

/** Contains the global design dictionary specified in the entire design RDesignFile */
static NSMutableDictionary *globalDesignDictionary;

@interface RMessageView () <UIGestureRecognizerDelegate>

@property (nonatomic, weak) id<RMessageViewProtocol> delegate;

@property (nonatomic, weak) IBOutlet UIView *titleSubtitleContainerView;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleSubtitleContainerViewCenterYConstraint;

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, strong) UIView *backgroundView;

/** Contains the appropriate design dictionary for the specified message view type */
@property (nonatomic, strong) NSDictionary *messageViewDesignDictionary;

/** The displayed title of this message */
@property (nonatomic, strong) NSAttributedString *title;

/** The displayed subtitle of this message view */
@property (nonatomic, strong) NSAttributedString *subtitle;

/** The view controller this message is displayed in */
@property (nonatomic, strong) UIViewController *viewController;

/** The vertical space between the message view top to its view controller top */
@property (nonatomic, strong) NSLayoutConstraint *topToVCLayoutConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleSubtitleContainerViewLeadingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleSubtitleContainerViewTrailingConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *bottomSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *topSpaceConstraint;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *titleSubtitleVerticalSpacingConstraint;

@property (nonatomic, strong) NSMutableArray *interElementMarginConstraints;

@property (nonatomic, copy) void (^dismissalBlock)();
@property (nonatomic, copy) void (^tapBlock)();
@property (nonatomic, copy) void (^completionBlock)();

/** The starting constant value that should be set for the topToVCTopLayoutConstraint when animating */
@property (nonatomic, assign) CGFloat topToVCStartConstant;

/** The final constant value that should be set for the topToVCTopLayoutConstraint when animating */
@property (nonatomic, assign) CGFloat topToVCFinalConstant;

@property (nonatomic, assign) CGFloat leftViewRelativeCornerRadius;
@property (nonatomic, assign) CGFloat rightViewRelativeCornerRadius;

@property (nonatomic, assign) RMessageType messageType;
@property (nonatomic, copy) NSString *customTypeName;

@property (nonatomic, assign) BOOL shouldBlurBackground;

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
      NSString *configFileErrorMessage = [NSString stringWithFormat:@"There seems to be an error"
                                                                    @"with the %@ configuration file",
                                                                    RDesignFileName];
      return [NSError errorWithDomain:[NSBundle bundleForClass:[self class]].bundleIdentifier
                                 code:0
                             userInfo:@{ NSLocalizedDescriptionKey: configFileErrorMessage }];
    }
    globalDesignDictionary = [NSMutableDictionary
      dictionaryWithDictionary:[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil]];
  }
  return nil;
}

+ (void)addDesignsFromFileWithName:(NSString *)filename inBundle:(NSBundle *)bundle;
{
  [RMessageView setupGlobalDesignDictionary];
  NSString *path = [bundle pathForResource:filename ofType:@"json"];
  if ([[NSFileManager defaultManager] fileExistsAtPath:path]) {
    NSDictionary *newDesignStyle =
      [NSJSONSerialization JSONObjectWithData:[NSData dataWithContentsOfFile:path] options:kNilOptions error:nil];
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

/**
 Method which determines if viewController edges extend under top bars
 (navigation bars for example). There are various scenarios and even iOS bugs in which view
 controllers that ask to present under top bars don't truly do but this method hopes to properly
 catch all these bugs and scenarios and let its caller know.
 @return YES if viewController
 */
+ (BOOL)viewControllerEdgesExtendUnderTopBars:(UIViewController *)viewController
{
  BOOL vcAskedToExtendUnderTopBars = NO;

  if (viewController.edgesForExtendedLayout == UIRectEdgeTop ||
      viewController.edgesForExtendedLayout == UIRectEdgeAll) {
    vcAskedToExtendUnderTopBars = YES;
  } else {
    vcAskedToExtendUnderTopBars = NO;
    return NO;
  }

  /* When a table view controller asks to extend under top bars, if the navigation bar is
   translucent iOS will not extend the edges of the table view controller under the top bars. */
  if ([viewController isKindOfClass:[UITableViewController class]] && vcAskedToExtendUnderTopBars &&
      !viewController.navigationController.navigationBar.translucent) {
    return NO;
  }

  return YES;
}

+ (UIImage *)bundledImageNamed:(NSString *)name
{
  NSString *imagePath = [[NSBundle bundleForClass:[self class]] pathForResource:name ofType:nil];
  return [[UIImage alloc] initWithContentsOfFile:imagePath];
}

+ (void)activateConstraints:(NSArray *)constraints inSuperview:(UIView *)superview
{
  if ([RMessageView compilingForHigherThanIosVersion:8.f]) {
    for (NSLayoutConstraint *constraint in constraints) constraint.active = YES;
  } else {
    [superview addConstraints:constraints];
  }
}

#pragma mark - Init Methods

- (instancetype)initWithDelegate:(id<RMessageViewProtocol>)delegate
                           title:(NSAttributedString *)title
                        subtitle:(NSAttributedString *)subtitle
                            type:(RMessageType)messageType
                  customTypeName:(NSString *)customTypeName
                        duration:(CGFloat)duration
                inViewController:(UIViewController *)viewController
                      atPosition:(RMessagePosition)position
            canBeDismissedByUser:(BOOL)dismissingEnabled
                        leftView:(UIView *)leftView
                       rightView:(UIView *)rightView
                  backgroundView:(UIView *)backgroundView
                       tapAction:(void (^)(void))tapBlock
                       dismissal:(void (^)(void))dismissalBlock
                      completion:(void (^)(void))completionBlock
{
  self = [[NSBundle bundleForClass:[self class]] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil]
           .firstObject;
  if (self) {
    _title = title ? title : [[NSAttributedString alloc] initWithString:@""];
    _subtitle = subtitle ? subtitle : [[NSAttributedString alloc] initWithString:@""];
    NSError *error = [self setupDefaultsWithDelegate:delegate
                                                type:messageType
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
    if (error) return nil;
  }
  return self;
}

#pragma mark Setter methods

- (void)setMessageOpacity:(CGFloat)messageOpacity
{
  _messageOpacity = messageOpacity;
  self.alpha = _messageOpacity;
}

- (void)setTitleFont:(UIFont *)aTitleFont
{
  _titleFont = aTitleFont;
  [self.titleLabel setFont:_titleFont];
}

- (void)setTitleAlignment:(NSTextAlignment)titleAlignment
{
  _titleAlignment = titleAlignment;
  self.titleLabel.textAlignment = _titleAlignment;
}

- (void)setTitleTextColor:(UIColor *)aTextColor
{
  _titleTextColor = aTextColor;
  [self.titleLabel setTextColor:_titleTextColor];
}

- (void)setSubtitleFont:(UIFont *)subtitleFont
{
  _subtitleFont = subtitleFont;
  [self.subtitleLabel setFont:subtitleFont];
}

- (void)setSubtitleAlignment:(NSTextAlignment)subtitleAlignment
{
  _subtitleAlignment = subtitleAlignment;
  self.subtitleLabel.textAlignment = _subtitleAlignment;
}

- (void)setSubtitleTextColor:(UIColor *)subtitleTextColor
{
  _subtitleTextColor = subtitleTextColor;
  [self.subtitleLabel setTextColor:_subtitleTextColor];
}

- (void)setInterElementMargin:(CGFloat)interElementMargin
{
  _interElementMargin = interElementMargin;
  for (NSLayoutConstraint *c in self.interElementMarginConstraints) {
    if (c.constant > 0) {
      c.constant = _interElementMargin;
    } else {
      c.constant = -_interElementMargin;
    }
  }
  [self setupFinalAnimationConstants];
}

#pragma mark View Methods

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
  if (self.leftViewRelativeCornerRadius > 0) {
    self.leftView.layer.cornerRadius = self.leftViewRelativeCornerRadius * self.leftView.bounds.size.width;
  }
  if (self.rightViewRelativeCornerRadius > 0) {
    self.rightView.layer.cornerRadius = self.rightViewRelativeCornerRadius * self.rightView.bounds.size.width;
  }
}

#pragma mark Setup Methods

- (NSError *)setupDefaultsWithDelegate:(id<RMessageViewProtocol>)delegate
                                  type:(RMessageType)messageType
                        customTypeName:(NSString *)customTypeName
                              duration:(CGFloat)duration
                      inViewController:(UIViewController *)viewController
                            atPosition:(RMessagePosition)position
                  canBeDismissedByUser:(BOOL)dismissingEnabled
                              leftView:(UIView *)leftView
                             rightView:(UIView *)rightView
                        backgroundView:(UIView *)backgroundView
                             tapAction:(void (^)(void))tapBlock
                             dismissal:(void (^)(void))dismissalBlock
                            completion:(void (^)(void))completionBlock

{
  _delegate = delegate;
  _duration = duration;
  viewController ? _viewController = viewController : (_viewController = [UIWindow topViewController]);
  _messagePosition = position;
  _dismissalBlock = dismissalBlock;
  _completionBlock = completionBlock;
  _messageType = messageType;
  _customTypeName = customTypeName;
  _interElementMargin = 10.f;

  _interElementMarginConstraints = [NSMutableArray
    arrayWithObjects:self.titleSubtitleContainerViewLeadingConstraint, self.titleSubtitleVerticalSpacingConstraint,
                     self.titleSubtitleContainerViewTrailingConstraint, self.bottomSpaceConstraint,
                     self.topSpaceConstraint, nil];
  if (leftView) {
    _leftView = leftView;
    [self setupLeftView];
  }
  if (rightView) {
    _rightView = rightView;
    [self setupRightView];
  }
  if (backgroundView) {
    _backgroundView = backgroundView;
    [self setupBackgroundView];
  }

  NSError *designError = [self setupDesignDictionariesWithMessageType:_messageType customTypeName:customTypeName];
  if (designError) return designError;

  [self setupDesign];
  [self setupLayout];
  if (dismissingEnabled) [self setupGestureRecognizers];
  return nil;
}

- (NSError *)setupDesignDictionariesWithMessageType:(RMessageType)messageType customTypeName:(NSString *)customTypeName
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
    NSParameterAssert(![customTypeName isEqualToString:@""]);
    if (!customTypeName || [customTypeName isEqualToString:@""]) {
      return
        [NSError errorWithDomain:[NSBundle bundleForClass:[self class]].bundleIdentifier
                            code:0
                        userInfo:@{
                          NSLocalizedDescriptionKey: @"When specifying a type RMessageTypeCustom make sure to pass in "
                                                     @"a valid argument for customTypeName parameter. This string "
                                                     @"should match a Key in your custom design file."
                        }];
    }
    messageTypeDesignString = customTypeName;
    break;
  default:
    break;
  }

  _messageViewDesignDictionary = globalDesignDictionary[messageTypeDesignString];
  NSParameterAssert(_messageViewDesignDictionary != nil);
  if (!_messageViewDesignDictionary) {
    return
      [NSError errorWithDomain:[NSBundle bundleForClass:[self class]].bundleIdentifier
                          code:0
                      userInfo:@{
                        NSLocalizedDescriptionKey: @"When specifying a type RMessageTypeCustom make sure to pass in a "
                                                   @"valid argument for customTypeName parameter. This string should "
                                                   @"match a Key in your custom design file."
                      }];
  }
  return nil;
}

- (void)setupDesign
{
  [self setupDesignDefaults];
  [self setupImagesAndBackground];
  [self setupTitleLabel];
  [self setupSubtitleLabel];
}

- (void)setupLayout
{
  self.translatesAutoresizingMaskIntoConstraints = NO;

  // Add RMessage to superview and prepare the ending y position constants
  [self layoutMessageForPresentation];
  [self setupLabelPreferredMaxLayoutWidth];

  // Prepare the starting y position constants
  if (self.messagePosition != RMessagePositionBottom) {
    [self layoutIfNeeded];
    self.topToVCStartConstant = -self.bounds.size.height;
    self.topToVCLayoutConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.superview
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1.f
                                                                 constant:self.topToVCStartConstant];
  } else {
    self.topToVCStartConstant = 0;
    self.topToVCLayoutConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:self.superview
                                                                attribute:NSLayoutAttributeBottom
                                                               multiplier:1.f
                                                                 constant:0.f];
  }

  NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeCenterX
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeCenterX
                                                                      multiplier:1.f
                                                                        constant:0.f];
  NSLayoutConstraint *leadingConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                       attribute:NSLayoutAttributeLeading
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self.superview
                                                                       attribute:NSLayoutAttributeLeading
                                                                      multiplier:1.f
                                                                        constant:0.f];
  NSLayoutConstraint *trailingConstraint = [NSLayoutConstraint constraintWithItem:self
                                                                        attribute:NSLayoutAttributeTrailing
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.superview
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1.f
                                                                         constant:0.f];
  [[self class]
    activateConstraints:@[centerXConstraint, leadingConstraint, trailingConstraint, self.topToVCLayoutConstraint]
            inSuperview:self.superview];
  if (self.shouldBlurBackground) [self setupBlurBackground];
}

- (void)setupDesignDefaults
{
  self.backgroundColor = nil;
  self.messageOpacity = 0.97f;
  _shouldBlurBackground = NO;
  _titleLabel.numberOfLines = 0;
  _titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _titleLabel.font = [UIFont boldSystemFontOfSize:14.f];
  _titleLabel.textAlignment = NSTextAlignmentLeft;
  _titleLabel.textColor = [UIColor blackColor];
  _titleLabel.shadowColor = nil;
  _titleLabel.shadowOffset = CGSizeZero;
  _titleLabel.backgroundColor = nil;

  _subtitleLabel.numberOfLines = 0;
  _subtitleLabel.lineBreakMode = NSLineBreakByWordWrapping;
  _subtitleLabel.font = [UIFont boldSystemFontOfSize:12.f];
  _subtitleLabel.textAlignment = NSTextAlignmentLeft;
  _subtitleLabel.textColor = [UIColor darkGrayColor];
  _subtitleLabel.shadowColor = nil;
  _subtitleLabel.shadowOffset = CGSizeZero;
  _subtitleLabel.backgroundColor = nil;
}

- (void)setupImagesAndBackground
{
  UIColor *backgroundColor;
  if (_messageViewDesignDictionary[@"backgroundColor"] && _messageViewDesignDictionary[@"backgroundColorAlpha"]) {
    backgroundColor = [self colorForString:_messageViewDesignDictionary[@"backgroundColor"]
                                     alpha:[_messageViewDesignDictionary[@"backgroundColorAlpha"] floatValue]];
  } else if (_messageViewDesignDictionary[@"backgroundColor"]) {
    backgroundColor = [self colorForString:_messageViewDesignDictionary[@"backgroundColor"]];
  }

  if (backgroundColor) self.backgroundColor = backgroundColor;
  if (_messageViewDesignDictionary[@"opacity"]) {
    self.messageOpacity = [_messageViewDesignDictionary[@"opacity"] floatValue];
  }

  if ([_messageViewDesignDictionary[@"blurBackground"] floatValue] == 1) {
    _shouldBlurBackground = YES;
    /* As per apple docs when using UIVisualEffectView and blurring the superview of the blur view
    must have an opacity of 1.f */
    self.messageOpacity = 1.f;
  }

  [self setupLeftViewImageFromDesignFile];
  [self setupRightViewImageFromDesignFile];
  [self setupBackgroundImageFromDesignFile];
}

- (void)setupLeftViewImageFromDesignFile
{
  UIImage *leftViewImage;
  if (!leftViewImage && ((NSString *)_messageViewDesignDictionary[@"leftViewImage"]).length > 0) {
    leftViewImage = [RMessageView bundledImageNamed:_messageViewDesignDictionary[@"leftViewImage"]];
    if (!leftViewImage) {
      leftViewImage = [UIImage imageNamed:_messageViewDesignDictionary[@"leftViewImage"]];
    }
  }

  if (leftViewImage && !_leftView) {
    _leftView = [[UIImageView alloc] initWithImage:leftViewImage];
    _leftView.clipsToBounds = YES;
    _leftView.contentMode = UIViewContentModeScaleAspectFit;

    if (_messageViewDesignDictionary[@"leftViewRelativeCornerRadius"]) {
      _leftViewRelativeCornerRadius = [_messageViewDesignDictionary[@"leftViewRelativeCornerRadius"] floatValue];
    } else {
      _leftViewRelativeCornerRadius = 0.f;
    }
    [self setupLeftView];
  }
}

- (void)setupRightViewImageFromDesignFile
{
  UIImage *rightViewImage;
  if (!rightViewImage && ((NSString *)_messageViewDesignDictionary[@"rightViewImage"]).length > 0) {
    rightViewImage = [RMessageView bundledImageNamed:_messageViewDesignDictionary[@"rightViewImage"]];
    if (!rightViewImage) {
      rightViewImage = [UIImage imageNamed:_messageViewDesignDictionary[@"rightViewImage"]];
    }
  }

  if (rightViewImage && !_rightView) {
    _rightView = [[UIImageView alloc] initWithImage:rightViewImage];
    _rightView.clipsToBounds = YES;
    _rightView.contentMode = UIViewContentModeScaleAspectFit;

    if (_messageViewDesignDictionary[@"rightViewRelativeCornerRadius"]) {
      _rightViewRelativeCornerRadius = [_messageViewDesignDictionary[@"rightViewRelativeCornerRadius"] floatValue];
    } else {
      _rightViewRelativeCornerRadius = 0.f;
    }
    [self setupRightView];
  }
}

- (void)setupBackgroundImageFromDesignFile
{
  BOOL resizeableImageFound = NO;

  UIImage *backgroundImage = [RMessageView bundledImageNamed:_messageViewDesignDictionary[@"backgroundViewImage"]];
  if (!backgroundImage) {
    backgroundImage = [RMessageView bundledImageNamed:_messageViewDesignDictionary[@"backgroundViewResizeableImage"]];
    if (backgroundImage) resizeableImageFound = YES;
  }

  if (backgroundImage && !_backgroundView) {
    _backgroundView.clipsToBounds = YES;
    if (resizeableImageFound) {
      backgroundImage = [backgroundImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)
                                                        resizingMode:UIImageResizingModeStretch];
    }
    _backgroundView = [[UIImageView alloc] initWithImage:backgroundImage];
    // When initializing the background view with an image from the json design file
    // dont allow the stretchable image to dictate the size of the view
    [self.backgroundView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                         forAxis:UILayoutConstraintAxisHorizontal];
    [self.backgroundView setContentCompressionResistancePriority:UILayoutPriorityDefaultLow
                                                         forAxis:UILayoutConstraintAxisVertical];
    [self setupBackgroundView];
  }
}

- (void)setupTitleLabel
{
  if (_messageViewDesignDictionary[@"titleTextAlignment"]) {
    _titleLabel.textAlignment = [self textAlignmentForString:_messageViewDesignDictionary[@"titleTextAlignment"]];
  }

  CGFloat titleFontSize = [_messageViewDesignDictionary[@"titleFontSize"] floatValue];
  NSString *titleFontName = _messageViewDesignDictionary[@"titleFontName"];
  if (titleFontName) {
    _titleLabel.font = [UIFont fontWithName:titleFontName size:titleFontSize];
  } else if (titleFontSize) {
    _titleLabel.font = [UIFont boldSystemFontOfSize:titleFontSize];
  }

  UIColor *titleTextColor = [self colorForString:_messageViewDesignDictionary[@"titleTextColor"]];
  if (titleTextColor) _titleLabel.textColor = titleTextColor;

  UIColor *titleShadowColor = [self colorForString:_messageViewDesignDictionary[@"titleShadowColor"]];
  if (titleShadowColor) _titleLabel.shadowColor = titleShadowColor;
  id titleShadowOffsetX = _messageViewDesignDictionary[@"titleShadowOffsetX"];
  id titleShadowOffsetY = _messageViewDesignDictionary[@"titleShadowOffsetY"];
  if (titleShadowOffsetX && titleShadowOffsetY) {
    _titleLabel.shadowOffset = CGSizeMake([titleShadowOffsetX floatValue], [titleShadowOffsetY floatValue]);
  }
  _titleLabel.attributedText = _title;
}

- (void)setupSubtitleLabel
{
  NSString *subtitleTextAlignment = _messageViewDesignDictionary[@"subtitleTextAlignment"];
  if (subtitleTextAlignment) self.subtitleLabel.textAlignment = [self textAlignmentForString:subtitleTextAlignment];

  id subtitleFontSizeValue = _messageViewDesignDictionary[@"subtitleFontSize"];

  CGFloat subtitleFontSize = [subtitleFontSizeValue floatValue];
  NSString *subtitleFontName = _messageViewDesignDictionary[@"subtitleFontName"];

  if (subtitleFontName) {
    _subtitleLabel.font = [UIFont fontWithName:subtitleFontName size:subtitleFontSize];
  } else if (subtitleFontSize) {
    _subtitleLabel.font = [UIFont systemFontOfSize:subtitleFontSize];
  }

  UIColor *subtitleTextColor = [self colorForString:_messageViewDesignDictionary[@"subtitleTextColor"]];
  if (subtitleTextColor) _subtitleLabel.textColor = subtitleTextColor;

  UIColor *subtitleShadowColor = [self colorForString:_messageViewDesignDictionary[@"subtitleShadowColor"]];

  if (subtitleShadowColor) _subtitleLabel.shadowColor = subtitleShadowColor;
  id subtitleShadowOffsetX = _messageViewDesignDictionary[@"subtitleShadowOffsetX"];
  id subtitleShadowOffsetY = _messageViewDesignDictionary[@"subtitleShadowOffsetY"];
  if (subtitleShadowOffsetX && subtitleShadowOffsetY) {
    _subtitleLabel.shadowOffset = CGSizeMake([subtitleShadowOffsetX floatValue], [subtitleShadowOffsetY floatValue]);
  }
  _subtitleLabel.attributedText = _subtitle;
}

- (void)setupLabelPreferredMaxLayoutWidth
{
  CGFloat leftViewWidthAndPadding = 0.f;
  CGFloat rightViewWidthAndPadding = 0.f;
  if (_leftView) leftViewWidthAndPadding = _leftView.bounds.size.width + _interElementMargin;
  if (_rightView) rightViewWidthAndPadding = _rightView.bounds.size.width + _interElementMargin;
  _titleLabel.preferredMaxLayoutWidth =
    self.superview.bounds.size.width - leftViewWidthAndPadding - rightViewWidthAndPadding - 2 * _interElementMargin;
  _subtitleLabel.preferredMaxLayoutWidth = _titleLabel.preferredMaxLayoutWidth;
}

- (void)setupBlurBackground
{
  UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
  UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
  blurView.translatesAutoresizingMaskIntoConstraints = NO;
  [self insertSubview:blurView atIndex:0];
  NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[blurBackgroundView]-0-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{
                                                                      @"blurBackgroundView": blurView
                                                                    }];
  NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[blurBackgroundView]-0-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{
                                                                      @"blurBackgroundView": blurView
                                                                    }];
  [[self class] activateConstraints:hConstraints inSuperview:self];
  [[self class] activateConstraints:vConstraints inSuperview:self];
}

- (void)setupLeftView
{
  UIViewContentMode contentMode = [self contentModeForString:_messageViewDesignDictionary[@"leftViewContentMode"]];
  if (contentMode) _leftView.contentMode = contentMode;

  if (self.titleSubtitleContainerViewLeadingConstraint) self.titleSubtitleContainerViewLeadingConstraint.active = NO;
  self.leftView.translatesAutoresizingMaskIntoConstraints = NO;
  [self.leftView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
  [self.leftView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];

  NSLayoutConstraint *leftViewCenterY = [NSLayoutConstraint constraintWithItem:self.leftView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self.titleSubtitleContainerView
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1.f
                                                                      constant:0.f];
  NSLayoutConstraint *leftViewLeading = [NSLayoutConstraint constraintWithItem:self.leftView
                                                                     attribute:NSLayoutAttributeLeading
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeLeading
                                                                    multiplier:1.f
                                                                      constant:_interElementMargin];
  NSLayoutConstraint *leftViewTrailing = [NSLayoutConstraint constraintWithItem:self.leftView
                                                                      attribute:NSLayoutAttributeTrailing
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.titleSubtitleContainerView
                                                                      attribute:NSLayoutAttributeLeading
                                                                     multiplier:1.f
                                                                       constant:-_interElementMargin];
  NSLayoutConstraint *leftViewBottom = [NSLayoutConstraint constraintWithItem:self.leftView
                                                                    attribute:NSLayoutAttributeBottom
                                                                    relatedBy:NSLayoutRelationLessThanOrEqual
                                                                       toItem:self
                                                                    attribute:NSLayoutAttributeBottom
                                                                   multiplier:1.f
                                                                     constant:-_interElementMargin];
  NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.leftView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.f
                                                            constant:self.leftView.bounds.size.width];
  NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.leftView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.f
                                                             constant:self.leftView.bounds.size.height];

  [self.interElementMarginConstraints addObjectsFromArray:@[leftViewLeading, leftViewTrailing, leftViewBottom]];

  [self addSubview:self.leftView];
  [[self class] activateConstraints:@[leftViewCenterY, leftViewLeading, leftViewTrailing, leftViewBottom, width, height]
                        inSuperview:self];
}

- (void)setupRightView
{
  UIViewContentMode contentMode = [self contentModeForString:_messageViewDesignDictionary[@"rightViewContentMode"]];
  if (contentMode) _rightView.contentMode = contentMode;

  self.rightView.translatesAutoresizingMaskIntoConstraints = NO;
  if (self.titleSubtitleContainerViewTrailingConstraint) self.titleSubtitleContainerViewTrailingConstraint.active = NO;
  [self.rightView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisHorizontal];
  [self.rightView setContentHuggingPriority:UILayoutPriorityDefaultHigh forAxis:UILayoutConstraintAxisVertical];

  NSLayoutConstraint *rightViewCenterY = [NSLayoutConstraint constraintWithItem:self.rightView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.titleSubtitleContainerView
                                                                      attribute:NSLayoutAttributeCenterY
                                                                     multiplier:1.f
                                                                       constant:0.f];
  NSLayoutConstraint *rightViewLeading = [NSLayoutConstraint constraintWithItem:self.rightView
                                                                      attribute:NSLayoutAttributeLeading
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.titleSubtitleContainerView
                                                                      attribute:NSLayoutAttributeTrailing
                                                                     multiplier:1.f
                                                                       constant:_interElementMargin];
  NSLayoutConstraint *rightViewTrailing = [NSLayoutConstraint constraintWithItem:self.rightView
                                                                       attribute:NSLayoutAttributeTrailing
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTrailing
                                                                      multiplier:1.f
                                                                        constant:-_interElementMargin];
  NSLayoutConstraint *rightViewTop = [NSLayoutConstraint constraintWithItem:self.rightView
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                     toItem:self
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.f
                                                                   constant:_interElementMargin];
  NSLayoutConstraint *rightViewBottom = [NSLayoutConstraint constraintWithItem:self.rightView
                                                                     attribute:NSLayoutAttributeBottom
                                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                                        toItem:self
                                                                     attribute:NSLayoutAttributeBottom
                                                                    multiplier:1.f
                                                                      constant:-_interElementMargin];
  NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self.rightView
                                                           attribute:NSLayoutAttributeWidth
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1.f
                                                            constant:self.rightView.bounds.size.width];
  NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.rightView
                                                            attribute:NSLayoutAttributeHeight
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:nil
                                                            attribute:NSLayoutAttributeNotAnAttribute
                                                           multiplier:1.f
                                                             constant:self.rightView.bounds.size.height];

  [self.interElementMarginConstraints
    addObjectsFromArray:@[rightViewLeading, rightViewTrailing, rightViewTop, rightViewBottom]];

  [self addSubview:self.rightView];
  [[self class] activateConstraints:@[
    rightViewCenterY, rightViewLeading, rightViewTrailing, rightViewTop, rightViewBottom, width, height
  ]
                        inSuperview:self];
}

- (void)setupBackgroundView
{
  UIViewContentMode contentMode =
    [self contentModeForString:_messageViewDesignDictionary[@"backgroundViewContentMode"]];
  if (contentMode) _backgroundView.contentMode = contentMode;

  _backgroundView.translatesAutoresizingMaskIntoConstraints = NO;
  [self insertSubview:_backgroundView atIndex:0];
  NSArray *hConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[backgroundView]-0-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{
                                                                      @"backgroundView": _backgroundView
                                                                    }];
  NSArray *vConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[backgroundView]-0-|"
                                                                  options:0
                                                                  metrics:nil
                                                                    views:@{
                                                                      @"backgroundView": _backgroundView
                                                                    }];
  [[self class] activateConstraints:hConstraints inSuperview:self];
  [[self class] activateConstraints:vConstraints inSuperview:self];
}

- (void)layoutMessageForPresentation
{
  self.titleSubtitleContainerViewCenterYConstraint.constant = 0.f;
  UINavigationController *messageNavigationController;
  if ([self.viewController isKindOfClass:[UINavigationController class]]) {
    messageNavigationController = (UINavigationController *)self.viewController;
  } else if ([self.viewController.parentViewController isKindOfClass:[UINavigationController class]]) {
    messageNavigationController = (UINavigationController *)self.viewController.parentViewController;
  }

  if (messageNavigationController) {
    BOOL messageNavigationBarHidden =
      [RMessageView isNavigationBarHiddenForNavigationController:messageNavigationController];

    if (self.messagePosition != RMessagePositionBottom) {
      if (!messageNavigationBarHidden && self.messagePosition == RMessagePositionTop) {
        // Present from below nav bar when presenting from the top and navigation bar is present
        [messageNavigationController.view insertSubview:self belowSubview:messageNavigationController.navigationBar];
      } else {
        /* Navigation bar hidden or being asked to present as nav bar overlay, so present above status bar and/or
         navigation bar */
        self.titleSubtitleContainerViewCenterYConstraint.constant =
          [UIApplication sharedApplication].statusBarFrame.size.height / 2.f;
      }
    }
  } else {
    if (self.messagePosition != RMessagePositionBottom) {
      self.titleSubtitleContainerViewCenterYConstraint.constant =
        [UIApplication sharedApplication].statusBarFrame.size.height / 2.f;
    }
  }
  if (!self.superview) [self.viewController.view addSubview:self];
  [self setupFinalAnimationConstants];
}

- (void)setupFinalAnimationConstants
{
  [self layoutIfNeeded];
  UINavigationController *messageNavigationController;
  if ([self.viewController isKindOfClass:[UINavigationController class]]) {
    messageNavigationController = (UINavigationController *)self.viewController;
  } else if ([self.viewController.parentViewController isKindOfClass:[UINavigationController class]]) {
    messageNavigationController = (UINavigationController *)self.viewController.parentViewController;
  }

  if (messageNavigationController) {
    BOOL messageNavigationBarHidden =
      [RMessageView isNavigationBarHiddenForNavigationController:messageNavigationController];

    if (self.messagePosition != RMessagePositionBottom) {
      if (!messageNavigationBarHidden && self.messagePosition == RMessagePositionTop) {
        /* If view controller edges dont extend under top bars (navigation bar in our case) we must not factor in the
         navigation bar frame when animating RMessage's final position */
        if ([[self class] viewControllerEdgesExtendUnderTopBars:messageNavigationController]) {
          self.topToVCFinalConstant = [UIApplication sharedApplication].statusBarFrame.size.height +
                                      messageNavigationController.navigationBar.bounds.size.height +
                                      [self customVerticalOffset];
        } else {
          self.topToVCFinalConstant = [self customVerticalOffset];
        }
      } else {
        /* Navigation bar hidden or being asked to present as nav bar overlay, so present above status bar and/or
         navigation bar */
        self.topToVCFinalConstant = [self customVerticalOffset];
      }
    } else {
      CGFloat offset = -self.bounds.size.height - [self customVerticalOffset];
      if (messageNavigationController && !messageNavigationController.isToolbarHidden) {
        // If tool bar present animate above toolbar
        offset -= messageNavigationController.toolbar.bounds.size.height;
      }
      self.topToVCFinalConstant = offset;
    }
  } else {
    if (self.messagePosition == RMessagePositionBottom) {
      self.topToVCFinalConstant = -self.bounds.size.height - [self customVerticalOffset];
    } else {
      self.topToVCFinalConstant = [self customVerticalOffset];
    }
  }
}

#pragma mark - Gesture Recognizers

- (void)setupGestureRecognizers
{
  UISwipeGestureRecognizer *gestureRecognizer =
    [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(didSwipeToDismissMessageView:)];
  [gestureRecognizer
    setDirection:(self.messagePosition == RMessagePositionTop ? UISwipeGestureRecognizerDirectionUp :
                                                                UISwipeGestureRecognizerDirectionDown)];
  [self addGestureRecognizer:gestureRecognizer];

  UITapGestureRecognizer *tapRecognizer =
    [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTapMessageView:)];
  [self addGestureRecognizer:tapRecognizer];
}

/* called after the following gesture depending on message position during initialization
 UISwipeGestureRecognizerDirectionUp when message position set to Top,
 UISwipeGestureRecognizerDirectionDown when message position set to bottom */
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
    self.duration =
      kRMessageAnimationDuration + kRMessageDisplayTime + self.frame.size.height * kRMessageExtraDisplayTimePerPixel;
  }

  if (self.duration != RMessageDurationEndless) {
    dispatch_async(dispatch_get_main_queue(), ^{
      [self performSelector:@selector(dismiss) withObject:self afterDelay:self.duration];
    });
  }
}

- (void)animateMessage
{
  [self.superview layoutIfNeeded];
  if (!self.shouldBlurBackground) self.alpha = 0.f;
  [UIView animateWithDuration:kRMessageAnimationDuration + 0.2f
    delay:0.f
    usingSpringWithDamping:0.7
    initialSpringVelocity:0.f
    options:UIViewAnimationOptionCurveEaseInOut | UIViewAnimationOptionBeginFromCurrentState |
            UIViewAnimationOptionAllowUserInteraction
    animations:^{
      if (!self.shouldBlurBackground) self.alpha = self.messageOpacity;
      self.topToVCLayoutConstraint.constant = self.topToVCFinalConstant;
      [self.superview layoutIfNeeded];
    }
    completion:^(BOOL finished) {
      self.messageIsFullyDisplayed = YES;
      if ([self.delegate respondsToSelector:@selector(messageViewDidPresent:)]) {
        if (self.completionBlock) self.completionBlock();
        [self.delegate messageViewDidPresent:self];
      }
    }];
}

- (void)dismiss
{
  [self dismissWithCompletion:nil];
}

- (void)dismissWithCompletion:(void (^)(void))completionBlock
{
  self.messageIsFullyDisplayed = NO;
  [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(dismiss) object:self];

  [UIView animateWithDuration:kRMessageAnimationDuration
    animations:^{
      if (!self.shouldBlurBackground) self.alpha = 0.f;
      self.topToVCLayoutConstraint.constant = self.topToVCStartConstant;
      [self.superview layoutIfNeeded];
    }
    completion:^(BOOL finished) {
      [self removeFromSuperview];
      if ([self.delegate respondsToSelector:@selector(messageViewDidDismiss:)]) {
        [self.delegate messageViewDidDismiss:self];
      }
      if (completionBlock) completionBlock();
      if (self.dismissalBlock) self.dismissalBlock();
    }];
}

#pragma mark - Misc methods

- (UIColor *)colorForString:(NSString *)string
{
  if (string) return [UIColor hx_colorWithHexRGBAString:string alpha:1.f];
  return nil;
}

/**
 Wrapper method to avoid getting a black color when passing a nil string to
 hx_colorWithHexRGBAString
 @param string A hex string representation of a color.
 @return nil or a color.
 */
- (UIColor *)colorForString:(NSString *)string alpha:(CGFloat)alpha
{
  if (string) return [UIColor hx_colorWithHexRGBAString:string alpha:alpha];
  return nil;
}

/**
 Get the custom vertical offset from the delegate if any
 @return a custom vertical offset or 0.f
 */
- (CGFloat)customVerticalOffset
{
  CGFloat customVerticalOffset = 0.f;
  if (self.delegate && [self.delegate respondsToSelector:@selector(customVerticalOffsetForMessageView:)]) {
    customVerticalOffset = [self.delegate customVerticalOffsetForMessageView:self];
  }
  return customVerticalOffset;
}

- (UIViewContentMode)contentModeForString:(NSString *)contentMode
{
  if ([contentMode isEqualToString:@"scaleToFill"]) {
    return UIViewContentModeScaleToFill;
  } else if ([contentMode isEqualToString:@"scaleAspectFill"]) {
    return UIViewContentModeScaleAspectFill;
  } else if ([contentMode isEqualToString:@"scaleAspectFit"]) {
    return UIViewContentModeScaleAspectFit;
  } else if ([contentMode isEqualToString:@"redraw"]) {
    return UIViewContentModeRedraw;
  } else if ([contentMode isEqualToString:@"center"]) {
    return UIViewContentModeCenter;
  } else if ([contentMode isEqualToString:@"top"]) {
    return UIViewContentModeTop;
  } else if ([contentMode isEqualToString:@"bottom"]) {
    return UIViewContentModeBottom;
  } else if ([contentMode isEqualToString:@"left"]) {
    return UIViewContentModeLeft;
  } else if ([contentMode isEqualToString:@"right"]) {
    return UIViewContentModeRight;
  } else if ([contentMode isEqualToString:@"topLeft"]) {
    return UIViewContentModeTopLeft;
  } else if ([contentMode isEqualToString:@"topRight"]) {
    return UIViewContentModeTopRight;
  } else if ([contentMode isEqualToString:@"bottomLeft"]) {
    return UIViewContentModeBottomLeft;
  } else if ([contentMode isEqualToString:@"bottomRight"]) {
    return UIViewContentModeBottomRight;
  } else {
    return UIViewContentModeScaleToFill;
  }
}
- (NSTextAlignment)textAlignmentForString:(NSString *)textAlignment
{
  if ([textAlignment isEqualToString:@"left"]) {
    return NSTextAlignmentLeft;
  } else if ([textAlignment isEqualToString:@"right"]) {
    return NSTextAlignmentRight;
  } else if ([textAlignment isEqualToString:@"center"]) {
    return NSTextAlignmentCenter;
  } else if ([textAlignment isEqualToString:@"justified"]) {
    return NSTextAlignmentJustified;
  } else if ([textAlignment isEqualToString:@"natural"]) {
    return NSTextAlignmentNatural;
  } else {
    return NSTextAlignmentLeft;
  }
}

- (void)executeMessageViewTapAction
{
  if (self.tapBlock) self.tapBlock();
}

@end
