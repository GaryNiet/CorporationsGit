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

- (void)drawRect:(CGRect)rect
{
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    NSArray *gradientColors = [NSArray arrayWithObjects:(id) [UIColor redColor].CGColor, [UIColor yellowColor].CGColor, nil];
    
    CGFloat gradientLocations[] = {0, 0.50, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) gradientColors, gradientLocations);
    
    CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
    CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    CGGradientRelease(gradient);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setAttr:(NSDate *)journeyStartDate :(int)journeyDistance
{
    _distanceLabel.text = [NSString stringWithFormat:@"%d",journeyDistance];
    
    
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
}


- (IBAction)backButtonPressed:(id)sender
{
    [self.view removeFromSuperview];
}

@end
