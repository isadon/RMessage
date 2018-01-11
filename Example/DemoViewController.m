//
//  DemoViewController.m
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Adonis Peralta. All rights reserved.
//

#import "DemoViewController.h"
#import "RMessage.h"
#import "RMessageView.h"

NSString *const StyleWarning = @"alternate-warning";
NSString *const StyleNeutral = @"alternate-neutral";

@interface DemoViewController () <RMessageProtocol>

@end

@implementation DemoViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationController.navigationBar setTranslucent:YES];
  self.extendedLayoutIncludesOpaqueBars = YES;
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
  [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
  [coordinator animateAlongsideTransition:nil completion:^(id<UIViewControllerTransitionCoordinatorContext>  _Nonnull context) {
     [RMessage interfaceDidRotate];
  }];
}

- (void)viewDidAppear:(BOOL)animated
{
  [super viewDidAppear:animated];
  /* Normally we would set the default view controller and delegate in viewDidLoad
     but since we are using this view controller for our modal view also it is important to properly
     re-set the variables once the modal dismisses. */
  [RMessage setDefaultViewController:self];
  [RMessage setDelegate:self];
}

- (IBAction)didTapError:(id)sender
{
  [RMessage
    showNotificationWithTitle:NSLocalizedString(@"Something failed", nil)
                     subtitle:NSLocalizedString(@"The internet connection seems to be down. Please check it!", nil)
                         type:RMessageTypeError
               customTypeName:nil
                     callback:nil];
}

- (IBAction)didTapWarning:(id)sender
{
  [RMessage showNotificationWithTitle:NSLocalizedString(@"Some random warning", nil)
                             subtitle:NSLocalizedString(@"Look out! Something is happening there!", nil)
                                 type:RMessageTypeWarning
                       customTypeName:nil
                             callback:nil];
}

- (IBAction)didTapMessage:(id)sender
{
  [RMessage showNotificationWithTitle:NSLocalizedString(@"Tell the user something", nil)
                             subtitle:NSLocalizedString(@"This is a neutral notification!", nil)
                                 type:RMessageTypeNormal
                       customTypeName:nil
                             callback:nil];
}

- (IBAction)didTapSuccess:(id)sender
{
  [RMessage showNotificationWithTitle:NSLocalizedString(@"Success", nil)
                             subtitle:NSLocalizedString(@"Some task was successfully completed!", nil)
                                 type:RMessageTypeSuccess
                       customTypeName:nil
                             callback:nil];
}

- (IBAction)didTapButton:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:NSLocalizedString(@"New version available", nil)
                                    subtitle:NSLocalizedString(@"Please update our app. We would be very thankful", nil)
                                   iconImage:nil
                                        type:RMessageTypeNormal
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                 buttonTitle:NSLocalizedString(@"Update", nil)
                              buttonCallback:^{
                                [RMessage showNotificationWithTitle:NSLocalizedString(@"Thanks for updating", nil)
                                                               type:RMessageTypeSuccess
                                                     customTypeName:nil
                                                           callback:nil];
                              }
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapCustomImage:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:NSLocalizedString(@"Custom image", nil)
                                    subtitle:NSLocalizedString(@"This uses an image you can define", nil)
                                   iconImage:[UIImage imageNamed:@"NotificationButtonBackground.png"]
                                        type:RMessageTypeNormal
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapEndless:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:NSLocalizedString(@"Endless", nil)
                                    subtitle:NSLocalizedString(@"This message can not be dismissed and will not be "
                                                               @"hidden automatically. Tap the 'Dismiss' button "
                                                               @"to dismiss the currently shown message",
                                                               nil)
                                   iconImage:nil
                                        type:RMessageTypeSuccess
                              customTypeName:nil
                                    duration:RMessageDurationEndless
                                    callback:nil
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:NO];
}

- (IBAction)didTapLong:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:NSLocalizedString(@"Long", nil)
                                    subtitle:NSLocalizedString(@"This message is displayed 10 seconds "
                                                               @"instead of the calculated value",
                                                               nil)
                                   iconImage:nil
                                        type:RMessageTypeWarning
                              customTypeName:nil
                                    duration:10.0
                                    callback:nil
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapBottom:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:NSLocalizedString(@"Hu!", nil)
                                    subtitle:NSLocalizedString(@"I'm down here :)", nil)
                                   iconImage:nil
                                        type:RMessageTypeSuccess
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionBottom
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapText:(id)sender
{
  [RMessage
    showNotificationWithTitle:NSLocalizedString(@"With 'Text' I meant a long text, so here it is", nil)
                     subtitle:NSLocalizedString(@"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed "
                                                @"diam nonumy eirmod tempor invidunt ut labore et dolore magna "
                                                @"aliquyam erat, sed diam voluptua. At vero eos et accusam et "
                                                @"justo duo dolores et ea rebum. Stet clita kasd gubergren, no "
                                                @"sea takimata sanctus.At vero eos et accusam et justo duo "
                                                @"dolores et ea rebum. Stet clita kasd gubergren, no sea takimata "
                                                @"sanctus.Lorem ipsum dolor sit amet, consetetur sadipscing "
                                                @"elitr, sed diam nonumy eirmod tempor invidunt ut labore et "
                                                @"dolore magna aliquyam erat, sed diam voluptua. At vero eos et "
                                                @"accusam et justo duo dolores et ea rebum. Stet clita kasd "
                                                @"gubergren, no sea takimata sanctus.At vero eos et accusam et "
                                                @"justo duo dolores et ea rebum. Stet clita kasd gubergren, no "
                                                @"sea takimata sanctus.",
                                                nil)
                         type:RMessageTypeWarning
               customTypeName:nil
                     callback:nil];
}

- (IBAction)didTapCustomDesign:(id)sender
{
  // This is an example on how to apply a custom design
  [RMessage addDesignsFromFileWithName:@"AlternativeDesigns" inBundle:[NSBundle mainBundle]];
  [RMessage showNotificationWithTitle:NSLocalizedString(@"Added custom design file", nil)
                             subtitle:NSLocalizedString(@"This background is blue while the "
                                                        @"subtitles are white. Yes this is still "
                                                        @"an alternate error design :)",
                                                        nil)
                                 type:RMessageTypeCustom
                       customTypeName:@"alternate-error"
                             callback:nil];
}

- (IBAction)didTapDismissCurrentMessage:(id)sender
{
  [RMessage dismissActiveNotification];
}

- (IBAction)didTapDismissModal:(id)sender
{
  [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didTapToggleNavigationBar:(id)sender
{
  [self.navigationController setNavigationBarHidden:!self.navigationController.navigationBarHidden animated:YES];
}

- (IBAction)didTapToggleNavigationBarAlpha:(id)sender
{
  CGFloat alpha = self.navigationController.navigationBar.alpha;
  self.navigationController.navigationBar.alpha = (alpha == 1.f) ? 0.5 : 1;
}

- (IBAction)didTapToggleWantsFullscreen:(id)sender
{
  self.extendedLayoutIncludesOpaqueBars = !self.extendedLayoutIncludesOpaqueBars;
  [self.navigationController.navigationBar setTranslucent:!self.navigationController.navigationBar.isTranslucent];
}

- (IBAction)didTapNavBarOverlay:(id)sender
{
  if (self.navigationController.navigationBarHidden) {
    [self.navigationController setNavigationBarHidden:NO];
  }

  [RMessage showNotificationInViewController:self.navigationController
                                       title:NSLocalizedString(@"Whoa!", nil)
                                    subtitle:NSLocalizedString(@"Over the Navigation Bar!", nil)
                                   iconImage:nil
                                        type:RMessageTypeSuccess
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                 buttonTitle:nil
                              buttonCallback:nil
                                  atPosition:RMessagePositionNavBarOverlay
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapNavbarHidden:(id)sender
{
  self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}

/*- (CGFloat)customVerticalOffsetForMessageView:(RMessageView *)messageView
{
  return 88.f; // specify an additional offset here.
}
*/

/*- (void)customizeMessageView:(RMessageView *)messageView
{
  messageView.messageOpacity = 0.5f;
}
*/

- (IBAction)didTapCustomWarning:(id)sender
{
    [RMessage setDelegate:self];
    [RMessage addDesignsFromFileWithName:@"AlternativeDesigns" inBundle:[NSBundle mainBundle]];
    [RMessage showNotificationWithTitle:@"Warning! You are sitting too much!"
                               subtitle:nil
                                   type:RMessageTypeCustom
                         customTypeName:StyleWarning
                               callback:^{
                                   NSLog(@"Notification tapped.");
                               }];
}

- (IBAction)didTapCustomNeutral:(id)sender
{
    [RMessage setDelegate:self];
    [RMessage addDesignsFromFileWithName:@"AlternativeDesigns" inBundle:[NSBundle mainBundle]];
    [RMessage showNotificationWithTitle:@"Something neutral happened."
                               subtitle:nil
                                   type:RMessageTypeCustom
                         customTypeName:StyleNeutral
                               callback:^{
                                   NSLog(@"Notification tapped.");
                               }];
}

#pragma mark - RMessageProtocol

- (void)customizeMessageView:(RMessageView *)messageView
{
    messageView.dontDismissOnTap = NO;
    messageView.dontShowSubtitle = YES;
    
    messageView.titleFont = [UIFont systemFontOfSize:15 weight:UIFontWeightLight];
 
    if ([messageView.customTypeName isEqualToString:@"alternate-warning"]) {
        messageView.iconImageView.layer.cornerRadius = messageView.iconImageView.frame.size.width / 2.0;
        messageView.iconImageView.layer.masksToBounds = YES;
        messageView.iconImageView.image = [messageView.iconImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        messageView.iconImageView.backgroundColor = [UIColor whiteColor];
        messageView.iconImageView.tintColor = [UIColor colorWithRed:243.0/255.0 green:110.0/255.0 blue:84.0/255.0 alpha:1.0];
    } else {
        CGFloat width = [UIScreen mainScreen].bounds.size.width;
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, messageView.bounds.size.height - 1, width, 1)];
        lineView.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1.0];
        [messageView addSubview:lineView];
    }
}

@end
