//
//  JourneyViewController.m
//  Corporations
//
//  Created by Gary Nietlispach on 09.01.14.
//  Copyright (c) 2014 Gary Nietlispach. All rights reserved.
//

#import "JourneyViewController.h"
#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface JourneyViewController ()

@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@implementation JourneyViewController

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
    self.view.backgroundColor = UIColorFromRGB(0xf2d121);
    
	
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAttr:(NSDate *)journeyStartDate :(int)journeyDistance :(int)journeyMoney :(int)journeyXP;
{
    
    
    
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSGregorianCalendar];
    
    unsigned int unitFlags = NSHourCalendarUnit | NSMinuteCalendarUnit | NSDayCalendarUnit | NSMonthCalendarUnit;

    
    NSDateComponents *components = [gregorian components:unitFlags
                                                fromDate:journeyStartDate
                                                  toDate:[[NSDate alloc] init] options:0];
    NSInteger months = [components month];
    NSInteger days = [components day];
    NSInteger hours = [components hour];
    NSInteger minutes = [components minute];
    
    NSString* timeString = [NSString stringWithFormat:@"%dh %dm", hours, minutes];
    
    _tripTimeLabel.text = timeString;
    
    _distanceLabel.text = [NSString stringWithFormat:@"%d",journeyDistance];
    _experienceEarnedLabel.text = [NSString stringWithFormat:@"%d",journeyXP];
    _moneyEarnedLabel.text = [NSString stringWithFormat:@"%d",journeyMoney];
}


- (IBAction)backButtonPressed:(id)sender
{
    [self.view removeFromSuperview];
}

@end
