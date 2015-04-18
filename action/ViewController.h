//
//  ViewController.h
//  action
//
//  Created by Andrew Boryk on 1/30/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h> 
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@class GADBannerView;


@interface ViewController : UIViewController <UIGestureRecognizerDelegate, GADInterstitialDelegate>
{
    SystemSoundID swipeSound;
    SystemSoundID downSwipe;
    SystemSoundID leftSwipe;
    SystemSoundID upSwipe;
    SystemSoundID loseSwipe;
}

@property(nonatomic, strong) GADInterstitial *interstitial;

//Properties
@property (strong, nonatomic) IBOutlet UIButton *swipeRight;
@property (strong, nonatomic) IBOutlet UIButton *swipeLeft;
@property (strong, nonatomic) IBOutlet UIButton *swipeUp;
@property (strong, nonatomic) IBOutlet UIButton *swipeDown;
@property (strong, nonatomic) IBOutlet UIButton *startOverButton;
@property (strong, nonatomic) IBOutlet UILabel *score;
@property (strong, nonatomic) IBOutlet UILabel *highLabel;
@property (strong, nonatomic) IBOutlet UILabel *reviveNum;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (strong, nonatomic) IBOutlet UIButton *reviveButton;
@property (strong, nonatomic) IBOutlet UILabel *subtitle;
@property (strong, nonatomic) IBOutlet UIButton *bottomRight;
@property (strong, nonatomic) IBOutlet UIButton *bottomLeft;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;

@property (strong, nonatomic) IBOutlet UIButton *rotate;

//Actions
- (IBAction)startOver:(id)sender;
- (IBAction)reviveAction:(id)sender;

@end

