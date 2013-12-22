//
//  AppDelegate.h
//  Corporation
//
//  Created by Gary Nietlispach on 04.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginPageViewController.h"
#import "ViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) LoginPageViewController *rootViewController;
@property (strong, nonatomic) ViewController *mapViewController;

@end
