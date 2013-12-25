//
//  ProfileView.m
//  Corporations
//
//  Created by Gary Nietlispach on 25.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "ProfileView.h"

@interface ProfileView ()

@end

@implementation ProfileView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[_backButton addTarget:self
               action:@selector(backToMainView)
     forControlEvents:UIControlEventTouchDown];
    
}



-(void)backToMainView
{
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
