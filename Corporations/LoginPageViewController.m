//
//  LoginPageViewController.m
//  Corporations
//
//  Created by Gary Nietlispach on 05.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "LoginPageViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface LoginPageViewController ()

-(IBAction)buttonClickHandler:(id)sender;

@end

@implementation LoginPageViewController

@synthesize loginButton = _loginButton;




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
    
    
    FBLoginView *loginView = [[FBLoginView alloc] init];
    // Align the button in the center horizontally
    loginView.frame = CGRectOffset(loginView.frame,
                                   (loginView.frame.size.width/3),
                                   loginView.frame.size.height/2);
    [self.view addSubview:loginView];
    [loginView sizeToFit];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonClickHandler:(id)sender
{
    
}

- (IBAction)buttonClicked:(id)sender {
}
@end
