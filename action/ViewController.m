//
//  ViewController.m
//  action
//
//  Created by Andrew Boryk on 1/30/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "ViewController.h"
#import "GADInterstitial.h"
#import "GADBannerView.h"
#import "GADRequest.h"

@interface ViewController ()

@end

int choice;
int points;
int changer;
NSTimer *gameTimer;
float counter;
BOOL timeUp;
NSUserDefaults *defaults;
float run;
NSTimer *swagTimer;
float tracker;
int adCounter;
NSMutableArray *goalArray;
NSTimer *startTimer;
int startCount;

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([defaults boolForKey:@"showAds"]) {
        self.interstitial = [self createAndLoadInterstitial];
    }
    run = 0.01f;
    tracker = 0.00f;
    self.timeLabel.text = [NSString stringWithFormat:@"Time/n%.02f", tracker];
    self.subtitle.hidden = 1;
    self.bottomLeft.hidden = 1;
    self.bottomRight.hidden = 1;
    self.reviveButton.hidden = 1;
    self.reviveNum.hidden = 1;
    self.score.backgroundColor = nil;
    timeUp = false;
    NSURL *swipeURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"swipe2" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) swipeURL, &upSwipe);
    NSURL *rightURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"swipe" ofType:@"mp3"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) rightURL, &swipeSound);
    NSURL *loseSwipeURL = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"loseSwipe" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef) loseSwipeURL, &loseSwipe);
    defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"highScore"] == nil) {
        [defaults setInteger:0 forKey:@"highScore"];
        [defaults synchronize];
    }
    counter = 1.5f;
    changer = 3;
    //self.timeLabel.text = [NSString stringWithFormat:@"Time\n%i", counter-1];
    self.swipeRight.hidden = 1;
    self.swipeLeft.hidden = 1;
    self.swipeUp.hidden = 1;
    self.swipeDown.hidden = 1;
    self.startOverButton.hidden = 1;
    self.rotate.hidden = 1;
    self.highLabel.hidden = 1;
    self.backButton.hidden = 1;
    points = 0;
    self.score.text = [NSString stringWithFormat:@"Score\n%i",points];
    [self.swipeRight setBackgroundColor:[self colorWithHexString:@"FF8000"]]; //Tang
    [self.swipeLeft setBackgroundColor:[self colorWithHexString:@"FF0080"]]; //Red
    [self.swipeDown setBackgroundColor:[self colorWithHexString:@"8000FF"]]; //Purple
    [self.swipeUp setBackgroundColor:[self colorWithHexString:@"66CCFF"]]; //Blue
    [self gestureSet];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)random{
    [self.swipeRight setAlpha:1];
    [self.swipeLeft setAlpha:1];
    [self.swipeUp setAlpha:1];
    [self.swipeDown setAlpha:1];
    if (points <= 10) {
        counter = 1.25f;
        run = 1.0f/counter/100;
    }
    else if (points <= 25) {
        counter = 1.0f;
        run = 1.0f/counter/100;
    }
    else if (points <= 50){
        counter = 0.8f;
        run = 1.0f/counter/100;
    }
    else if (points <= 100){
        counter = 0.75f;
        run = 1.0f/counter/100;
    }
    else if (points <= 200){
        counter = 0.65f;
        run = 1.0f/counter/100;
    }
    else if (points <= 300){
        counter = 0.55f;
        run = 1.0f/counter/100;
    }
    gameTimer = [NSTimer scheduledTimerWithTimeInterval:run target:self selector:@selector(counterPlus) userInfo:nil repeats:YES];
    self.swipeRight.hidden = 1;
    self.swipeLeft.hidden = 1;
    self.swipeUp.hidden = 1;
    self.swipeDown.hidden = 1;
    self.rotate.hidden = 1;
    choice = arc4random() % 4;
    switch (choice) {
        case 0:
            self.swipeRight.hidden = 0;
            break;
        case 1:
            self.swipeLeft.hidden = 0;
            break;
        case 2:
            self.swipeUp.hidden = 0;
            break;
        case 3:
            self.swipeDown.hidden = 0;
            break;
        case 4:
            self.rotate.hidden = 0;
            break;
        default:
            break;
    }
}

- (IBAction)startOver:(id)sender {
    tracker = 0.00f;
    self.timeLabel.text = [NSString stringWithFormat:@"%f", tracker];
    self.bottomLeft.hidden = 1;
    self.bottomRight.hidden = 1;
    self.reviveButton.hidden = 1;
    timeUp = false;
    self.score.backgroundColor = nil;
    self.subtitle.hidden = 1;
    [self.swipeRight setBackgroundColor:[self colorWithHexString:@"FF8000"]]; //Tang
    [self.swipeLeft setBackgroundColor:[self colorWithHexString:@"FF0080"]]; //Red
    [self.swipeDown setBackgroundColor:[self colorWithHexString:@"8000FF"]]; //Purple
    [self.swipeUp setBackgroundColor:[self colorWithHexString:@"66CCFF"]]; //Blue
    self.highLabel.hidden = 1;
    self.backButton.hidden = 1;
    self.reviveNum.hidden = 1;
    counter = 1.5f;
    //self.timeLabel.text = [NSString stringWithFormat:@"Time\n%i",counter-1];
    //self.timeLabel.hidden = 0;
    self.startOverButton.hidden = 1;
    points = 0;
    self.score.text = [NSString stringWithFormat:@"Score\n%i",points];
    swagTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timeItUp) userInfo:nil repeats:YES];
    [self random];
}

- (IBAction)reviveAction:(id)sender {
    if ((int)[defaults integerForKey:@"revives"] > 0) {
        int newRiv = (int)[defaults integerForKey:@"revives"] - 1;
        [defaults setInteger:newRiv forKey:@"revives"];
        [defaults synchronize];
        self.timeLabel.text = [NSString stringWithFormat:@"%f", tracker];
        self.bottomLeft.hidden = 1;
        self.bottomRight.hidden = 1;
        timeUp = false;
        self.score.backgroundColor = nil;
        self.subtitle.hidden = 1;
        [self.swipeRight setBackgroundColor:[self colorWithHexString:@"FF8000"]]; //Tang
        [self.swipeLeft setBackgroundColor:[self colorWithHexString:@"FF0080"]]; //Red
        [self.swipeDown setBackgroundColor:[self colorWithHexString:@"8000FF"]]; //Purple
        [self.swipeUp setBackgroundColor:[self colorWithHexString:@"66CCFF"]]; //Blue
        self.highLabel.hidden = 1;
        self.backButton.hidden = 1;
        self.reviveButton.hidden = 1;
        self.reviveNum.hidden = 1;
        counter = 1.5f;
        //self.timeLabel.text = [NSString stringWithFormat:@"Time\n%i",counter-1];
        //self.timeLabel.hidden = 0;
        self.startOverButton.hidden = 1;
        self.score.text = [NSString stringWithFormat:@"Score\n%i",points];
        swagTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timeItUp) userInfo:nil repeats:YES];
        [self random];
    }
    else{
        
    }
}

- (void)correct{
    if (!timeUp) {
        goalArray = [[defaults objectForKey:@"goals"] mutableCopy];
        if (points == 25 && tracker <= 13 && [[[goalArray objectAtIndex:4] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:4];
        }
        if (points == 50 && tracker <= 25 && [[[goalArray objectAtIndex:5] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:5];
        }
        if (points == 100 && tracker <= 50 && [[[goalArray objectAtIndex:6] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:6];
        }
        if (points == 150 && [[[goalArray objectAtIndex:0] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:0];
        }
        if (points == 225 && [[[goalArray objectAtIndex:1] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:1];
        }
        if (points == 350 && [[[goalArray objectAtIndex:2] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:2];
        }
        if (points == 500 && [[[goalArray objectAtIndex:3] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:3];
        }
        int num = (int)[defaults integerForKey:@"swipes"];
        num++;
        if (num % 1000 == 0) {
            int anotherRiv = (int)[defaults integerForKey:@"revives"] + 1;
            [defaults setInteger:anotherRiv forKey:@"revives"];
            [defaults synchronize];
        }
        [defaults setInteger:num forKey:@"swipes"];
        [defaults synchronize];
        if (num >= 1000 && [[[goalArray objectAtIndex:7] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:7];
        }
        if (num >= 5000 && [[[goalArray objectAtIndex:8] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:8];
        }
        if (num >= 10000 && [[[goalArray objectAtIndex:9] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:9];
        }
        if (num >= 50000 && [[[goalArray objectAtIndex:10] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:10];
        }
        if (num >= 100000 && [[[goalArray objectAtIndex:11] objectForKey:@"Done"] isEqualToString:@"No"]) {
            [self doTheRest:11];
        }
        if ([[[goalArray objectAtIndex:0] objectForKey:@"Done"] isEqualToString:@"Yes"] &&[[[goalArray objectAtIndex:1] objectForKey:@"Done"] isEqualToString:@"Yes"] && [[[goalArray objectAtIndex:2] objectForKey:@"Done"] isEqualToString:@"Yes"] && [[[goalArray objectAtIndex:3] objectForKey:@"Done"] isEqualToString:@"Yes"] && [[[goalArray objectAtIndex:4] objectForKey:@"Done"] isEqualToString:@"Yes"] && [[[goalArray objectAtIndex:5] objectForKey:@"Done"] isEqualToString:@"Yes"] && [[[goalArray objectAtIndex:6] objectForKey:@"Done"] isEqualToString:@"Yes"] && [[[goalArray objectAtIndex:7] objectForKey:@"Done"] isEqualToString:@"Yes"] &&
            [[[goalArray objectAtIndex:8] objectForKey:@"Done"] isEqualToString:@"Yes"] &&
            [[[goalArray objectAtIndex:9] objectForKey:@"Done"] isEqualToString:@"Yes"] &&
            [[[goalArray objectAtIndex:10] objectForKey:@"Done"] isEqualToString:@"Yes"] &&
            [[[goalArray objectAtIndex:11] objectForKey:@"Done"] isEqualToString:@"Yes"]) {
            [self doTheRest:12];
        }
        [gameTimer invalidate];
        if (choice == 0 || choice == 1) {
            AudioServicesPlaySystemSound(swipeSound);
            
        }
        else if (choice == 2 || choice == 3){
            AudioServicesPlaySystemSound(upSwipe);
        }
        points ++;
        if (points%10 == 0) {
            changer = arc4random() % 4;
            if (changer == 0) {
                [self.swipeRight setBackgroundColor:[self colorWithHexString:@"FF0080"]]; //Red
                [self.swipeLeft setBackgroundColor:[self colorWithHexString:@"66CCFF"]]; //Blue
                [self.swipeDown setBackgroundColor:[self colorWithHexString:@"FF8000"]]; //Tang
                [self.swipeUp setBackgroundColor:[self colorWithHexString:@"8000FF"]]; //Purple
            }
            else if (changer == 1)
            {
                [self.swipeRight setBackgroundColor:[self colorWithHexString:@"66CCFF"]]; //Blue
                [self.swipeLeft setBackgroundColor:[self colorWithHexString:@"8000FF"]]; //Purple
                [self.swipeDown setBackgroundColor:[self colorWithHexString:@"FF0080"]]; //Red
                [self.swipeUp setBackgroundColor:[self colorWithHexString:@"FF8000"]]; //Tang
            }
            else if (changer == 2) {
                [self.swipeRight setBackgroundColor:[self colorWithHexString:@"8000FF"]]; //Purple
                [self.swipeLeft setBackgroundColor:[self colorWithHexString:@"FF8000"]]; //Tang
                [self.swipeDown setBackgroundColor:[self colorWithHexString:@"66CCFF"]]; //Blue
                [self.swipeUp setBackgroundColor:[self colorWithHexString:@"FF0080"]]; //Red
            }
            else if (changer == 3)
            {
                [self.swipeRight setBackgroundColor:[self colorWithHexString:@"FF8000"]]; //Tang
                [self.swipeLeft setBackgroundColor:[self colorWithHexString:@"FF0080"]]; //Red
                [self.swipeDown setBackgroundColor:[self colorWithHexString:@"8000FF"]]; //Purple
                [self.swipeUp setBackgroundColor:[self colorWithHexString:@"66CCFF"]]; //Blue
            }
        }
        //self.timeLabel.text = [NSString stringWithFormat:@"Time\n%i", counter-1];
        self.score.text = [NSString stringWithFormat:@"Score\n%i",points];
        [self random];
    }
}

-(void)gameOver{
    adCounter++;
    self.startOverButton.enabled = NO;
    [gameTimer invalidate];
    [swagTimer invalidate];
    [self endingColors];
    
    if (timeUp) {
        self.subtitle.text = @"Time's Up!";
    }
    else{
        self.subtitle.text = @"Wrong Way!";
    }
    self.swipeRight.hidden = 1;
    self.swipeLeft.hidden = 1;
    self.swipeUp.hidden = 1;
    self.swipeDown.hidden = 1;
    self.rotate.hidden = 1;
    AudioServicesPlaySystemSound(loseSwipe);
    if (points > [defaults integerForKey:@"highScore"]) {
        [defaults setInteger:points forKey:@"highScore"];
        [defaults synchronize];
    }
    self.highLabel.text = [NSString stringWithFormat:@"High Score\n%li", (long)[defaults integerForKey:@"highScore"]];
    self.highLabel.hidden = 0;
    self.startOverButton.hidden = 0;
    self.backButton.hidden = 0;
    self.subtitle.hidden = 0;
    self.bottomLeft.hidden = 0;
    self.bottomRight.hidden = 0;
    self.reviveButton.hidden = 0;
    self.reviveNum.text = [NSString stringWithFormat:@"%li",(long)[defaults integerForKey:@"revives"]];
    self.reviveNum.hidden = 0;
    self.reviveButton.enabled = NO;
    [UIView animateWithDuration:1.1f animations:^{
        [self.timeLabel setAlpha:0];
        [self.timeLabel setAlpha:1];
        [self.bottomLeft setAlpha:0];
        [self.bottomLeft setAlpha:1];
        [self.bottomRight setAlpha:0];
        [self.bottomRight setAlpha:1];
        [self.subtitle setAlpha:0];
        [self.subtitle setAlpha:1];
        [self.backButton setAlpha:0];
        [self.backButton setAlpha:1];
        [self.highLabel setAlpha:0];
        [self.highLabel setAlpha:1];
        [self.score setAlpha:0];
        [self.score setAlpha:1];
        [self.reviveButton setAlpha:0];
        [self.reviveButton setAlpha:1];
        [self.reviveNum setAlpha:0];
        [self.reviveNum setAlpha:1];
        [self.startOverButton setAlpha:0];
        [self.startOverButton setAlpha:1];
        self.startOverButton.enabled = YES;
        self.reviveButton.enabled = YES;
    }];
    if (([self.interstitial isReady] && adCounter%3 == 0)&& [defaults boolForKey:@"showAds"]) {
        [self.interstitial presentFromRootViewController:self];
    }
}

-(void)gestureSet{
    //SwipeRight
    UISwipeGestureRecognizer *rightGood = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(correct)];
    rightGood.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *rightBad = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    rightBad.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *rightBad1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    rightBad1.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *rightBad2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    rightBad2.direction = UISwipeGestureRecognizerDirectionRight;
    UISwipeGestureRecognizer *rightBad3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    rightBad3.direction = UISwipeGestureRecognizerDirectionRight;
    
    //SwipeLeft
    UISwipeGestureRecognizer *leftGood = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(correct)];
    leftGood.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *leftBad = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    leftBad.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *leftBad1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    leftBad1.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *leftBad2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    leftBad2.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer *leftBad3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    leftBad3.direction = UISwipeGestureRecognizerDirectionLeft;
    
    //SwipeUp
    UISwipeGestureRecognizer *upGood = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(correct)];
    upGood.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *upBad = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    upBad.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *upBad1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    upBad1.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *upBad2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    upBad2.direction = UISwipeGestureRecognizerDirectionUp;
    UISwipeGestureRecognizer *upBad3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    upBad3.direction = UISwipeGestureRecognizerDirectionUp;
    
    //SwipeDown
    UISwipeGestureRecognizer *downGood = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(correct)];
    downGood.direction = UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer *downBad = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    downBad.direction = UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer *downBad1 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    downBad1.direction = UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer *downBad2 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    downBad2.direction = UISwipeGestureRecognizerDirectionDown;
    UISwipeGestureRecognizer *downBad3 = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(gameOver)];
    downBad3.direction = UISwipeGestureRecognizerDirectionDown;
    
    //Right Button
    [self.swipeRight addGestureRecognizer:rightGood];
    [self.swipeRight addGestureRecognizer:leftBad];
    [self.swipeRight addGestureRecognizer:upBad];
    [self.swipeRight addGestureRecognizer:downBad];
    
    //Left Button
    [self.swipeLeft addGestureRecognizer:leftGood];
    [self.swipeLeft addGestureRecognizer:rightBad];
    [self.swipeLeft addGestureRecognizer:upBad1];
    [self.swipeLeft addGestureRecognizer:downBad1];
    
    //Up Button
    [self.swipeUp addGestureRecognizer:upGood];
    [self.swipeUp addGestureRecognizer:rightBad1];
    [self.swipeUp addGestureRecognizer:leftBad1];
    [self.swipeUp addGestureRecognizer:downBad2];
    
    //Down Button
    [self.swipeDown addGestureRecognizer:downGood];
    [self.swipeDown addGestureRecognizer:rightBad2];
    [self.swipeDown addGestureRecognizer:leftBad2];
    [self.swipeDown addGestureRecognizer:upBad2];
    
    //Rotate Button
    [self.rotate addGestureRecognizer:downBad3];
    [self.rotate addGestureRecognizer:rightBad3];
    [self.rotate addGestureRecognizer:leftBad3];
    [self.rotate addGestureRecognizer:upBad3];
    
    swagTimer = [NSTimer scheduledTimerWithTimeInterval:0.01f target:self selector:@selector(timeItUp) userInfo:nil repeats:YES];
    [self random];
}
//
//-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
//    if (choice == 4) {
//        points ++;
//        self.score.text = [NSString stringWithFormat:@"Score\n%i",points];
//        [self random];
//    }
//    else{
//        [self gameOver];
//    }
//}

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

-(void)counterPlus{
    if (counter > 0) {
        counter-=run;
        if (choice == 0) {
            [self.swipeRight setAlpha:(self.swipeRight.alpha-0.01)];
        }
        else if (choice == 1) {
            [self.swipeLeft setAlpha:(self.swipeLeft.alpha-0.01)];
        }
        else if (choice == 2) {
            [self.swipeUp setAlpha:(self.swipeUp.alpha-0.01)];
        }
        else if (choice == 3) {
            [self.swipeDown setAlpha:(self.swipeDown.alpha-0.01)];
        }
        //self.timeLabel.text = [NSString stringWithFormat:@"Time\n%i", counter-1];
    }
    else if (counter <= 0)
    {
        timeUp = true;
        [self gameOver];
    }
}

-(void)endingColors{
    switch (choice) {
        case 0:
            self.subtitle.textColor = self.swipeRight.backgroundColor;
            self.highLabel.textColor = self.swipeRight.backgroundColor;
            self.backButton.backgroundColor = self.swipeRight.backgroundColor;
            self.score.backgroundColor = self.swipeRight.backgroundColor;
            self.bottomLeft.backgroundColor = self.swipeRight.backgroundColor;
            self.bottomRight.backgroundColor = self.swipeRight.backgroundColor;
            break;
        case 1:
            self.subtitle.textColor = self.swipeLeft.backgroundColor;
            self.highLabel.textColor = self.swipeLeft.backgroundColor;
            self.backButton.backgroundColor = self.swipeLeft.backgroundColor;
            self.score.backgroundColor = self.swipeLeft.backgroundColor;
            self.bottomLeft.backgroundColor = self.swipeLeft.backgroundColor;
            self.bottomRight.backgroundColor = self.swipeLeft.backgroundColor;
            break;
        case 2:
            self.subtitle.textColor = self.swipeUp.backgroundColor;
            self.highLabel.textColor = self.swipeUp.backgroundColor;
            self.backButton.backgroundColor = self.swipeUp.backgroundColor;
            self.score.backgroundColor = self.swipeUp.backgroundColor;
            self.bottomLeft.backgroundColor = self.swipeUp.backgroundColor;
            self.bottomRight.backgroundColor = self.swipeUp.backgroundColor;
            break;
        case 3:
            self.subtitle.textColor = self.swipeDown.backgroundColor;
            self.highLabel.textColor = self.swipeDown.backgroundColor;
            self.backButton.backgroundColor = self.swipeDown.backgroundColor;
            self.score.backgroundColor = self.swipeDown.backgroundColor;
            self.bottomLeft.backgroundColor = self.swipeDown.backgroundColor;
            self.bottomRight.backgroundColor = self.swipeDown.backgroundColor;
            break;
        default:
            break;
    }
}

-(void)timeItUp{
    tracker += 0.01f;
    self.timeLabel.text = [NSString stringWithFormat:@"Time\n%.02f", tracker];
}

-(void)doTheRest:(int)i{
    NSMutableDictionary *dict = [[[defaults objectForKey:@"goals"] objectAtIndex:i] mutableCopy];
    [dict setObject:@"Yes" forKey:@"Done"];
    [goalArray setObject:dict atIndexedSubscript:i];
    [defaults setObject:goalArray forKey:@"goals"];
    [defaults synchronize];
}

- (GADInterstitial *)createAndLoadInterstitial {
    GADInterstitial *interstitial = [[GADInterstitial alloc] init];
    interstitial.adUnitID = @"ca-app-pub-6233938597693711/1954540787";
    interstitial.delegate = self;
    [interstitial loadRequest:[GADRequest request]];
    return interstitial;
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)interstitial {
    self.interstitial = [self createAndLoadInterstitial];
}

//-(void)startCounter{
//    if (startCount == 3) {
//        startCount --;
//        
//    }
//}
@end
