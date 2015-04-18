//
//  MedalView.m
//  action
//
//  Created by Andrew Boryk on 1/30/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "MedalView.h"

@interface MedalView ()

@end

NSMutableArray *medals;
int ind;
NSUserDefaults *defaults;
@implementation MedalView

- (void)viewDidLoad {
    [super viewDidLoad];
    ind = 0;
    self.medalImage.backgroundColor = nil;
    defaults = [NSUserDefaults standardUserDefaults];
    medals = [[defaults objectForKey:@"goals"] mutableCopy];
    NSLog(@"Medals: %@", medals);
    UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(rightChecker)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(leftChecker)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *up = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(backToMain)];
    up.direction = UISwipeGestureRecognizerDirectionUp;
    [self.swipeCheck addGestureRecognizer:right];
    [self.swipeCheck addGestureRecognizer:left];
    [self.swipeCheck addGestureRecognizer:up];
    self.titleLabel.text = [[medals objectAtIndex:ind] objectForKey:@"Title"];
    self.subtitleLabel.text = [[medals objectAtIndex:ind] objectForKey:@"Subtitle"];
    if ([[[medals objectAtIndex:ind] objectForKey:@"Done"] isEqualToString:@"No"]) {
        self.medalImage.image = [UIImage imageNamed:@"Bad"];
        self.yesNoLabel.text = @"NO";
    }
    else{
        self.medalImage.image = [UIImage imageNamed:@"Good"];
        self.yesNoLabel.text = @"YES";
    }
    if ([defaults boolForKey:@"checkRight"] && [defaults boolForKey:@"checkLeft"] && [defaults boolForKey:@"checkUp"]) {
        self.swipeLabel.text = [NSString stringWithFormat:@"%li Swipes", (long)[defaults integerForKey:@"swipes"]];
        self.swipeLabel.font= [self.swipeLabel.font fontWithSize:25];
    }
    [self viewBackColor];
}

-(void)rightChecker{
    if (ind > 0) {
        if (![defaults boolForKey:@"checkRight"]) {
            [defaults setBool:true forKey:@"checkRight"];
        }
        if ([defaults boolForKey:@"checkRight"] && [defaults boolForKey:@"checkLeft"] && [defaults boolForKey:@"checkUp"]) {
            self.swipeLabel.text = [NSString stringWithFormat:@"%li Swipes", (long)[defaults integerForKey:@"swipes"]];
            self.swipeLabel.font= [self.swipeLabel.font fontWithSize:25];
        }
        [UIView animateWithDuration:0.5f animations:^{
            [self.swipeLabel setAlpha:0];
            [self.swipeLabel setAlpha:1];
            [self.medalImage setAlpha:0];
            [self.medalImage setAlpha:1];
            [self.titleLabel setAlpha:0];
            [self.titleLabel setAlpha:1];
            [self.subtitleLabel setAlpha:0];
            [self.subtitleLabel setAlpha:1];
            [self.yesNoLabel setAlpha:0];
            [self.yesNoLabel setAlpha:1];
        }];
        ind --;
        self.titleLabel.text = [[medals objectAtIndex:ind] objectForKey:@"Title"];
        self.subtitleLabel.text = [[medals objectAtIndex:ind] objectForKey:@"Subtitle"];
        if ([[[medals objectAtIndex:ind] objectForKey:@"Done"] isEqualToString:@"No"]) {
            self.medalImage.image = [UIImage imageNamed:@"Bad"];
            self.yesNoLabel.text = @"NO";
        }
        else{
            self.medalImage.image = [UIImage imageNamed:@"Good"];
            self.yesNoLabel.text = @"YES";
        }
        [self viewBackColor];
    }
}

-(void)leftChecker{
    if (ind < medals.count - 1) {
        if (![defaults boolForKey:@"checkLeft"]) {
            [defaults setBool:true forKey:@"checkLeft"];
        }
        if ([defaults boolForKey:@"checkRight"] && [defaults boolForKey:@"checkLeft"] && [defaults boolForKey:@"checkUp"]) {
            self.swipeLabel.text = [NSString stringWithFormat:@"%li Swipes", (long)[defaults integerForKey:@"swipes"]];
            self.swipeLabel.font= [self.swipeLabel.font fontWithSize:25];
        }
        [UIView animateWithDuration:0.5f animations:^{
            [self.swipeLabel setAlpha:0];
            [self.swipeLabel setAlpha:1];
            [self.medalImage setAlpha:0];
            [self.medalImage setAlpha:1];
            [self.titleLabel setAlpha:0];
            [self.titleLabel setAlpha:1];
            [self.subtitleLabel setAlpha:0];
            [self.subtitleLabel setAlpha:1];
            [self.yesNoLabel setAlpha:0];
            [self.yesNoLabel setAlpha:1];
        }];
        ind ++;
        self.titleLabel.text = [[medals objectAtIndex:ind] objectForKey:@"Title"];
        self.subtitleLabel.text = [[medals objectAtIndex:ind] objectForKey:@"Subtitle"];
        if ([[[medals objectAtIndex:ind] objectForKey:@"Done"] isEqualToString:@"No"]) {
            self.medalImage.image = [UIImage imageNamed:@"Bad"];
            self.yesNoLabel.text = @"NO";
        }
        else{
            self.medalImage.image = [UIImage imageNamed:@"Good"];
            self.yesNoLabel.text = @"YES";
        }
        [self viewBackColor];
    }
}

-(void)backToMain{
    if (![defaults boolForKey:@"checkUp"]) {
        [defaults setBool:true forKey:@"checkUp"];
    }
    [self performSegueWithIdentifier:@"menu" sender:self];
}

-(void)viewBackColor{
    if (ind == 3 || ind == 7 || ind == 11) {
        self.view.backgroundColor = [self colorWithHexString:@"8000FF"]; //Purple
    }
    else if (ind == 2 || ind == 6 || ind == 10) {
        self.view.backgroundColor = [self colorWithHexString:@"FF8000"]; //Tang
    }
    else if (ind == 1 || ind == 5 || ind == 9) {
        self.view.backgroundColor = [self colorWithHexString:@"66CCFF"]; //Blue
    }
    else if (ind == 0 || ind == 4 || ind == 8 || ind == 12) {
        self.view.backgroundColor = [self colorWithHexString:@"FF0080"]; //Red
    }
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

@end
