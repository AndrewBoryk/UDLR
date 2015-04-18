//
//  HomeViewController.m
//  action
//
//  Created by Andrew Boryk on 1/31/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

NSUserDefaults *defaults;
@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"goals"]) {
    }
    else{
        int riv = 0;
        [defaults setInteger:riv forKey:@"revives"];
        BOOL adsShow = true;
        [defaults setBool:adsShow forKey:@"showAds"];
        NSNumber *swipes = [NSNumber numberWithInt:0];
        NSDictionary *bronzeGoal = [NSDictionary dictionaryWithObjectsAndKeys:@"Bronze", @"Title", @"Reach a score of 100", @"Subtitle", @"bronzeSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *silverGoal = [NSDictionary dictionaryWithObjectsAndKeys:@"Silver", @"Title", @"Reach a score of 225", @"Subtitle", @"silverSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *goldGoal = [NSDictionary dictionaryWithObjectsAndKeys:@"Gold", @"Title", @"Reach a score of 350", @"Subtitle", @"goldSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *platinumGoal = [NSDictionary dictionaryWithObjectsAndKeys:@"Platinum", @"Title", @"Reach a score of 350", @"Subtitle", @"platSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *lowTime = [NSDictionary dictionaryWithObjectsAndKeys:@"Rabbit", @"Title", @"Hit 25 in 13 Seconds", @"Subtitle", @"purpleSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *midTime = [NSDictionary dictionaryWithObjectsAndKeys:@"Human", @"Title", @"Hit 50 in 25 Seconds", @"Subtitle", @"purpleSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *highTime = [NSDictionary dictionaryWithObjectsAndKeys:@"Cheetah", @"Title", @"Hit 100 in 50 Seconds", @"Subtitle", @"purpleSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *novice = [NSDictionary dictionaryWithObjectsAndKeys:@"Novice", @"Title", @"Swipe 1,000 Times", @"Subtitle", @"blueSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *average = [NSDictionary dictionaryWithObjectsAndKeys:@"Average", @"Title", @"Swipe 5,000 Times", @"Subtitle", @"orangeSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *pretty = [NSDictionary dictionaryWithObjectsAndKeys:@"Pretty Good", @"Title", @"Swipe 10,000 Times", @"Subtitle", @"pinkSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *prof = [NSDictionary dictionaryWithObjectsAndKeys:@"Professional", @"Title", @"Swipe 50,000 Times", @"Subtitle", @"purpleSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *master = [NSDictionary dictionaryWithObjectsAndKeys:@"Master", @"Title", @"Swipe 100,000 Times", @"Subtitle", @"purpleSmall", @"Icon", @"No", @"Done", nil];
        NSDictionary *final = [NSDictionary dictionaryWithObjectsAndKeys:@"Greatest Ever", @"Title", @"Earn All Medals", @"Subtitle", @"purpleSmall", @"Icon", @"No", @"Done", nil];
        [defaults setObject:[NSArray arrayWithObjects:bronzeGoal, silverGoal, goldGoal,platinumGoal, lowTime, midTime, highTime, novice, average,pretty,prof, master,final, nil] forKey:@"goals"];
        [defaults setObject:swipes forKey:@"swipes"];
        [defaults synchronize];
    }
}

@end
