//
//  LoginPageViewController.m
//  Corporations
//
//  Created by Gary Nietlispach on 05.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "LoginPageViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface LoginPageViewController ()

@property bool loginState;
-(IBAction)buttonClickHandler:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *LogoImage;

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
    
    loginView.delegate = self;
    [_LogoImage setImage:[UIImage imageNamed:@"logo.png" ]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)buttonClickHandler:(id)sender
{
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] changeView];

}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    _loginState = true;
    _loginButton.hidden = false;
}
- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    _loginState = false;
    _loginButton.hidden = true;
}

- (IBAction)buttonClicked:(id)sender {
}

- (NSUInteger) supportedInterfaceOrientations {
    // Return a bitmask of supported orientations. If you need more,
    // use bitwise or (see the commented return).
    return UIInterfaceOrientationMaskPortrait;
    // return UIInterfaceOrientationMaskPortrait | UIInterfaceOrientationMaskPortraitUpsideDown;
}

- (UIInterfaceOrientation) preferredInterfaceOrientationForPresentation {
    // Return the orientation you'd prefer - this is what it launches to. The
    // user can still rotate. You don't have to implement this method, in which
    // case it launches in the current orientation
    return UIDeviceOrientationPortrait;
}

@end
