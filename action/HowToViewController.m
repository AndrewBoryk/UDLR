//
//  HowToViewController.m
//  action
//
//  Created by Andrew Boryk on 1/31/15.
//  Copyright (c) 2015 Andrew Boryk. All rights reserved.
//

#import "HowToViewController.h"

@interface HowToViewController ()

@end

@implementation HowToViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UISwipeGestureRecognizer *play = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(toPlay)];
    play.direction = UISwipeGestureRecognizerDirectionUp;
    [self.goToPlay addGestureRecognizer:play];
}

-(void)toPlay{
    [self performSegueWithIdentifier:@"play" sender:self];
}
@end
