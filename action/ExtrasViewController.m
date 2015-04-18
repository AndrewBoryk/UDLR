//
//  ExtrasViewController.m
//  action
//
//  Created by Andrew Boryk on 2/1/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "ExtrasViewController.h"

@interface ExtrasViewController ()

@end


NSUserDefaults *defaults;
BOOL aboutAds;
BOOL trans;
@implementation ExtrasViewController

#define kRemoveAdsProductIdentifier @"com.forword.noads"
#define kRevivesProductIdentifier @"com.forword.revives"

- (void)viewDidLoad {
    defaults = [NSUserDefaults standardUserDefaults];
    [super viewDidLoad];
    self.confirmButton.layer.borderWidth = 1.0f;
    self.cancelButton.layer.borderWidth = 1.0f;
    if ([defaults boolForKey:@"showAds"]) {
        [self.adButton setTitle:@"Ads: Yes" forState:UIControlStateNormal];
        self.adButton.enabled = YES;
    }
    else{
        [self.adButton setTitle:@"Ads: No" forState:UIControlStateNormal];
        self.adButton.enabled = NO;
    }
    if (aboutAds) {
        self.restoreButton.hidden = 0;
        self.titlePurch.text = @"Remove Ads";
        self.subtitlePurch.text = @"For $1.00 USD, you may remove ads from this app.";
        self.view.backgroundColor = [self colorWithHexString:@"FF0080"]; //Red
        self.confirmButton.backgroundColor = [self colorWithHexString:@"66CCFF"];
        self.cancelButton.backgroundColor = [self colorWithHexString:@"66CCFF"];
    }
    else{
        self.restoreButton.hidden = 1;
        self.titlePurch.text = @"Purchase Revives";
        self.subtitlePurch.text = @"For $1.00 USD, you will receive 2 revives. If you lose a game, you may use a revive to continue from where you left off.";
        self.view.backgroundColor = [self colorWithHexString:@"66CCFF"]; //Blue
        self.confirmButton.backgroundColor = [self colorWithHexString:@"FF0080"];
        self.cancelButton.backgroundColor = [self colorWithHexString:@"FF0080"];
    }
}

- (IBAction)adAction:(id)sender {
    aboutAds = true;
}

- (IBAction)reviveAction:(id)sender {
    aboutAds = false;
}

- (IBAction)orangeAction:(id)sender {
}
- (IBAction)purpleAction:(id)sender {
}

- (IBAction)confirmAction:(id)sender {
    trans = true;
    if (aboutAds) {
        if([SKPaymentQueue canMakePayments]){
            NSLog(@"User can make payments");
            
            SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRemoveAdsProductIdentifier]];
            productsRequest.delegate = self;
            [productsRequest start];
            
        }
        else{
            NSLog(@"User cannot make payments due to parental controls");
            //this is called the user cannot make payments, most likely due to parental controls
        }
    }
    else{
        if([SKPaymentQueue canMakePayments]){
            NSLog(@"User can make payments");
            
            SKProductsRequest *productsRequest = [[SKProductsRequest alloc] initWithProductIdentifiers:[NSSet setWithObject:kRevivesProductIdentifier]];
            productsRequest.delegate = self;
            [productsRequest start];
            
        }
        else{
            NSLog(@"User cannot make payments due to parental controls");
            //this is called the user cannot make payments, most likely due to parental controls
        }
    }
}

- (IBAction)cancelAction:(id)sender {
    aboutAds = false;
}

- (IBAction)redWeapon:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.freesound.org/people/Yap_Audio_Production/sounds/219005/"]];
}

- (IBAction)swishLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.freesound.org/people/ra_gun/sounds/75544/"]];
}

- (IBAction)alienLink:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString: @"https://www.freesound.org/people/AlienXXX/sounds/81860/"]];
}

- (IBAction)restoreAction:(id)sender {
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue]restoreCompletedTransactions];
}
-(UIColor*)colorWithHexString:(NSString*)hex
{
    NSString *cString = [[hex stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor grayColor];
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    
    if ([cString length] != 6) return  [UIColor grayColor];
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
    SKProduct *validProduct = nil;
    int count = (int)[response.products count];
    if(count > 0){
        validProduct = [response.products objectAtIndex:0];
        NSLog(@"Products Available!");
        [self purchase:validProduct];
    }
    else if(!validProduct){
        NSLog(@"No products available");
        //this is called if your product id is not valid, this shouldn't be called unless that happens.
    }
}

- (void)purchase:(SKProduct *)product{
    SKPayment *payment = [SKPayment paymentWithProduct:product];
    [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
    [[SKPaymentQueue defaultQueue] addPayment:payment];
}

- (void) restore{
    //this is called when the user restores purchases, you should hook this up to a button
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
}

- (void) paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    NSLog(@"received restored transactions: %lu", (unsigned long)queue.transactions.count);
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        if(SKPaymentTransactionStateRestored){
            NSLog(@"Transaction state -> Restored");
            //called when the user successfully restores a purchase
            [self didPurchase];
            [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
            break;
        }
        
    }
    
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    for(SKPaymentTransaction *transaction in transactions){
        switch (transaction.transactionState){
            case SKPaymentTransactionStatePurchasing: NSLog(@"Transaction state -> Purchasing");
                //called when the user is in the process of purchasing, do not add any of your own code here.
                break;
            case SKPaymentTransactionStatePurchased:
                //this is called when the user has successfully purchased the package (Cha-Ching!)
                [self didPurchase]; //you can add your code for what you want to happen when the user buys the purchase here, for this tutorial we use removing ads
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                NSLog(@"Transaction state -> Purchased");
                break;
            case SKPaymentTransactionStateRestored:
                NSLog(@"Transaction state -> Restored");
                if (aboutAds) {
                    if ([defaults boolForKey:@"showAds"]) {
                        [self.adButton setTitle:@"Ads: No" forState:UIControlStateNormal];
                        [defaults setBool:false forKey:@"showAds"];
                        [defaults synchronize];
                        [self performSegueWithIdentifier:@"return" sender:self];
                    }
                    else{
                        [self.adButton setTitle:@"Ads: Yes" forState:UIControlStateNormal];
                        [defaults setBool:true forKey:@"showAds"];
                        [defaults synchronize];
                        [self performSegueWithIdentifier:@"return" sender:self];
                    }
                    [self performSegueWithIdentifier:@"return" sender:self];
                }
                //add the same code as you did from SKPaymentTransactionStatePurchased here
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            case SKPaymentTransactionStateFailed:
                //called when the transaction does not finnish
                if(transaction.error.code != SKErrorPaymentCancelled){
                    NSLog(@"Transaction state -> Cancelled");
                    //the user cancelled the payment ;(
                }
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

- (void)didPurchase{
    if (trans) {
        trans = false;
        if (aboutAds) {
            if ([defaults boolForKey:@"showAds"]) {
                [self.adButton setTitle:@"Ads: No" forState:UIControlStateNormal];
                [defaults setBool:false forKey:@"showAds"];
                [defaults synchronize];
                [self performSegueWithIdentifier:@"return" sender:self];
            }
            else{
                [self.adButton setTitle:@"Ads: Yes" forState:UIControlStateNormal];
                [defaults setBool:true forKey:@"showAds"];
                [defaults synchronize];
                [self performSegueWithIdentifier:@"return" sender:self];
            }
            [self performSegueWithIdentifier:@"return" sender:self];
        }
        else{
            int revives = (int)[defaults integerForKey:@"revives"];
            revives+=2;
            [defaults setInteger:revives forKey:@"revives"];
            [defaults synchronize];
        }
    }
}


@end
