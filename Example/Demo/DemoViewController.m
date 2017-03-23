//
//  DemoViewController.m
//  RMessage
//
//  Created by Adonis Peralta on 12/7/15.
//  Copyright © 2015 Adonis Peralta. All rights reserved.
//

#import "DemoViewController.h"
#import "NSString+NSAttributedString.h"
#import "RMessage.h"

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
  [RMessage showNotificationWithTitle:@"Something failed".attributedString
                             subtitle:@"The internet connection seems to be down. Please check it!".attributedString
                                 type:RMessageTypeError
                       customTypeName:nil
                             callback:nil];
}

- (IBAction)didTapAttributedStyling:(id)sender
{
  NSAttributedString *title = [[NSAttributedString alloc] initWithString:@"Look at me! I'm attributed."
                                                              attributes:@{
                                                                NSBackgroundColorAttributeName: [UIColor greenColor],
                                                                NSForegroundColorAttributeName: [UIColor blueColor]
                                                              }];
  NSAttributedString *subtitle =
    [[NSAttributedString alloc] initWithString:@"When are we going fishing?"
                                    attributes:@{
                                      NSBackgroundColorAttributeName: [UIColor purpleColor],
                                      NSForegroundColorAttributeName: [UIColor whiteColor],
                                      NSUnderlineStyleAttributeName: @(NSUnderlinePatternDash),
                                      NSUnderlineColorAttributeName: [UIColor whiteColor]
                                    }];

  [RMessage showNotificationWithTitle:title subtitle:subtitle type:RMessageTypeError customTypeName:nil callback:nil];
}

- (IBAction)didTapWarning:(id)sender
{
  [RMessage showNotificationWithTitle:@"Some random warning".attributedString
                             subtitle:@"Look out! Something is happening there!".attributedString
                                 type:RMessageTypeWarning
                       customTypeName:nil
                             callback:nil];
}

- (IBAction)didTapMessage:(id)sender
{
  [RMessage showNotificationWithTitle:@"Tell the user something".attributedString
                             subtitle:@"This is a neutral notification!".attributedString
                                 type:RMessageTypeNormal
                       customTypeName:nil
                             callback:nil];
}

- (IBAction)didTapSuccess:(id)sender
{
  [RMessage showNotificationWithTitle:@"Success".attributedString
                             subtitle:@"Some task was successfully completed!".attributedString
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
                                       title:@"New version available".attributedString
                                    subtitle:@"Please update our app. We would be very thankful".attributedString
                                        type:RMessageTypeNormal
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                  atPosition:RMessagePositionTop
                                    leftView:nil
                                   rightView:downloadButton
                              backgroundView:nil
                        canBeDismissedByUser:YES];
}

- (void)downloadButtonPushed
{
  [RMessage dismissActiveNotificationWithCompletion:^{
    [RMessage showNotificationInViewController:self
                                         title:@"Download Finished".attributedString
                                      subtitle:@"Thanks!".attributedString
                                          type:RMessageTypeSuccess
                                customTypeName:nil
                                      duration:RMessageDurationAutomatic
                                      callback:nil
                                    atPosition:RMessagePositionTop
                                      leftView:nil
                                     rightView:nil
                                backgroundView:nil
                          canBeDismissedByUser:YES];
  }];
}

- (IBAction)didTapCustomImage:(id)sender
{
  //
  [RMessage showNotificationInViewController:self
                                       title:@"Custom image".attributedString
                                    subtitle:@"This uses an image you can define".attributedString
                                        type:RMessageTypeNormal
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                  atPosition:RMessagePositionTop
                                    leftView:[[UIImageView alloc]
                                               initWithImage:[UIImage imageNamed:@"NotificationButtonBackground.png"]]
                                   rightView:nil
                              backgroundView:nil
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapEndless:(id)sender
{
  [RMessage
    showNotificationInViewController:self
                               title:@"Endless".attributedString
                            subtitle:@"This message can not be dismissed and will not be hidden automatically. Tap the "
                                     @"'Dismiss' button to dismiss the currently shown message".attributedString
                                type:RMessageTypeSuccess
                      customTypeName:nil
                            duration:RMessageDurationEndless
                            callback:nil
                          atPosition:RMessagePositionTop
                            leftView:nil
                           rightView:nil
                      backgroundView:nil
                canBeDismissedByUser:NO];
}

- (IBAction)didTapLong:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:@"Long".attributedString
                                    subtitle:@"This message is displayed 10 seconds instead of the calculated value"
                                               .attributedString
                                        type:RMessageTypeWarning
                              customTypeName:nil
                                    duration:10.0
                                    callback:nil
                                  atPosition:RMessagePositionTop
                                    leftView:nil
                                   rightView:nil
                              backgroundView:nil
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapBottom:(id)sender
{
  [RMessage showNotificationInViewController:self
                                       title:@"Hu!".attributedString
                                    subtitle:@"I'm down here :)".attributedString
                                        type:RMessageTypeSuccess
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                  atPosition:RMessagePositionBottom
                                    leftView:nil
                                   rightView:nil
                              backgroundView:nil
                        canBeDismissedByUser:YES];
}

- (IBAction)didTapText:(id)sender
{
  [RMessage
    showNotificationWithTitle:@"With 'Text' I meant a long text, so here it is".attributedString
                     subtitle:@"Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed  diam nonumy eirmod "
                              @"tempor invidunt ut labore et dolore magna  aliquyam erat, sed diam voluptua. At vero "
                              @"eos et accusam et  justo duo dolores et ea rebum. Stet clita kasd gubergren, no  sea "
                              @"takimata sanctus.At vero eos et accusam et justo duo dolores et ea rebum. Stet clita "
                              @"kasd gubergren, no sea takimata sanctus.Lorem ipsum dolor sit amet, consetetur "
                              @"sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna "
                              @"aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea "
                              @"rebum. Stet clita kasd gubergren, no sea takimata sanctus.At vero eos et accusam et "
                              @"justo duo dolores et ea rebum. Stet clita kasd gubergren, no sea takimata sanctus."
                                .attributedString
                         type:RMessageTypeWarning
               customTypeName:nil
                     callback:nil];
}

- (IBAction)didTapCustomDesign:(id)sender
{
  // this is an example on how to apply a custom design
  [RMessage addDesignsFromFileWithName:@"AlternativeDesigns" inBundle:[NSBundle mainBundle]];
  [RMessage showNotificationWithTitle:@"Added custom design file".attributedString
                             subtitle:@"This background is blue while the subtitles are white. Yes this is still an "
                                      @"alternate error design :)".attributedString
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
                                       title:@"Whoa!".attributedString
                                    subtitle:@"Over the Navigation Bar!".attributedString
                                        type:RMessageTypeSuccess
                              customTypeName:nil
                                    duration:RMessageDurationAutomatic
                                    callback:nil
                                  atPosition:RMessagePositionNavBarOverlay
                                    leftView:nil
                                   rightView:nil
                              backgroundView:nil
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
