//
//  ExtrasViewController.h
//  action
//
//  Created by Andrew Boryk on 2/1/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreGraphics/CoreGraphics.h>
#import <StoreKit/StoreKit.h> 

@interface ExtrasViewController : UIViewController <SKProductsRequestDelegate, SKPaymentTransactionObserver>

//Properties
@property (strong, nonatomic) IBOutlet UIButton *adButton;
@property (strong, nonatomic) IBOutlet UIButton *reviveButton;
@property (strong, nonatomic) IBOutlet UIButton *orangeButton;
@property (strong, nonatomic) IBOutlet UIButton *purpleButton;
@property (strong, nonatomic) IBOutlet UIButton *confirmButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutlet UILabel *titlePurch;
@property (strong, nonatomic) IBOutlet UILabel *subtitlePurch;
@property (strong, nonatomic) IBOutlet UIButton *restoreButton;


//Actions
- (IBAction)adAction:(id)sender;
- (IBAction)reviveAction:(id)sender;
- (IBAction)orangeAction:(id)sender;
- (IBAction)purpleAction:(id)sender;
- (IBAction)confirmAction:(id)sender;
- (IBAction)cancelAction:(id)sender;
- (IBAction)redWeapon:(id)sender;
- (IBAction)swishLink:(id)sender;
- (IBAction)alienLink:(id)sender;
- (IBAction)restoreAction:(id)sender;

@end
