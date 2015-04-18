//
//  MedalView.h
//  action
//
//  Created by Andrew Boryk on 1/30/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MedalView : UIViewController
@property (strong, nonatomic) IBOutlet UIButton *swipeCheck;
@property (strong, nonatomic) IBOutlet UILabel *swipeLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *medalImage;
@property (strong, nonatomic) IBOutlet UILabel *subtitleLabel;

@property (strong, nonatomic) IBOutlet UILabel *yesNoLabel;

@end
