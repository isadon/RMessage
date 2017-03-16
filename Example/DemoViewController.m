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

@interface DemoViewController () <RMessageProtocol>

@end

@implementation DemoViewController

- (void)viewDidLoad
{
  [super viewDidLoad];
  [self.navigationController.navigationBar setTranslucent:YES];
  self.extendedLayoutIncludesOpaqueBars = YES;
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
  UIImage *downloadImage = [UIImage imageNamed:@"downloadIcon"];
  UIButton *downloadButton = [UIButton buttonWithType:UIButtonTypeCustom];
  downloadButton.frame = CGRectMake(0.f, 0.f, downloadImage.size.width, downloadImage.size.height);
  [downloadButton setImage:[UIImage imageNamed:@"downloadIcon"] forState:UIControlStateNormal];
  downloadButton.clipsToBounds = YES;
  [downloadButton addTarget:self action:@selector(downloadButtonPushed) forControlEvents:UIControlEventTouchUpInside];

  [RMessage showNotificationInViewController:self
                                       title:NSLocalizedString(@"New version available", nil)
                                    subtitle:NSLocalizedString(@"Please update our app. We would be very thankful", nil)
                                   iconImage:nil
                                        type:RMessageTypeNormal
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                      button:downloadButton
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:YES];
}

- (void)downloadButtonPushed
{
  [RMessage dismissActiveNotificationWithCompletion:^{
    [RMessage showNotificationInViewController:self
                                         title:NSLocalizedString(@"Download Finished", nil)
                                      subtitle:NSLocalizedString(@"Thanks!", nil)
                                     iconImage:nil
                                          type:RMessageTypeSuccess
                                customTypeName:nil
                                      duration:RMessageDurationAutomatic
                                      callback:nil
                                        button:nil
                                    atPosition:RMessagePositionTop
                          canBeDismissedByUser:YES];
  }];
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
                                      button:nil
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapEndless:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:NSLocalizedString(@"Endless", nil)
                                    subtitle:NSLocalizedString(@"This message can not be dismissed and will not be "
                                                               @"hidden automatically. Tap the 'Dismiss' button to "
                                                               @"dismiss the currently shown message",
                                                               nil)
                                   iconImage:nil
                                        type:RMessageTypeSuccess
                              customTypeName:nil
                                    duration:RMessageDurationEndless
                                    callback:nil
                                      button:nil
                                  atPosition:RMessagePositionTop
                        canBeDismissedByUser:NO];
}

- (IBAction)didTapLong:(id)sender
{
  [RMessage
    showNotificationInViewController:self
                               title:NSLocalizedString(@"Long", nil)
                            subtitle:NSLocalizedString(
                                       @"This message is displayed 10 seconds instead of the calculated value", nil)
                           iconImage:nil
                                type:RMessageTypeWarning
                      customTypeName:nil
                            duration:10.0
                            callback:nil
                              button:nil
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
                                      button:nil
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
  // this is an example on how to apply a custom design
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
                                      button:nil
                                  atPosition:RMessagePositionNavBarOverlay
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapNavbarHidden:(id)sender
{
  self.navigationController.navigationBarHidden = !self.navigationController.navigationBarHidden;
}

//- (CGFloat)customVerticalOffsetForMessageView:(RMessageView *)messageView
//{
//    return 88.f; // specify an additional offset here.
//}

//- (void)customizeMessageView:(RMessageView *)messageView
//{
//    messageView.messageOpacity = 0.5f;
//}

@end
