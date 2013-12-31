//
//  ProfileView.h
//  Corporations
//
//  Created by Gary Nietlispach on 25.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Player.h"

@interface ProfileView : UIViewController
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UILabel *rankLabel;
@property (weak, nonatomic) IBOutlet UILabel *revenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *tripMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalGainLabel;
@property (weak, nonatomic) IBOutlet UILabel *alliesLabel;
@property (weak, nonatomic) IBOutlet UILabel *territoriesOwnedLabel;
@property (weak, nonatomic) IBOutlet UILabel *experiencePointsLabel;
@property (weak, nonatomic) IBOutlet UILabel *currentMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchasePriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchaseDistanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxExperienceLabel;
@property (weak, nonatomic) IBOutlet UILabel *maxMoneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *experienceQteLabel;
@property (weak, nonatomic) IBOutlet UILabel *dropAlliancePriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *purchasePriceButton;
@property (weak, nonatomic) IBOutlet UIButton *purchaseDistanceButton;
@property (weak, nonatomic) IBOutlet UIButton *maxExperienceButton;
@property (weak, nonatomic) IBOutlet UIButton *maxMoneyButton;
@property (weak, nonatomic) IBOutlet UIButton *experienceQteButton;
@property (weak, nonatomic) IBOutlet UIButton *dropAlliancePriceButton;
@property Player* playerPointer;


- (void)displayInfo:(Player*)player;

@end
