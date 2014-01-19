//
//  JourneyViewController.h
//  Corporations
//
//  Created by Gary Nietlispach on 09.01.14.
//  Copyright (c) 2014 Gary Nietlispach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JourneyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyEarnedLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceEarnedLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

-(void)setAttr :(NSDate*)journeyStartDate :(int)journeyDistance :(int)journeyMoney :(int)journeyXP;

@end
