//
//  ProfileView.m
//  Corporations
//
//  Created by Gary Nietlispach on 25.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "ProfileView.h"
#import "Player.h"

@interface ProfileView ()
-(void)displayInfo: (Player*)player;

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
    [_playerPointer updateDataBase];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayInfo:(Player *)player
{
    
    _playerPointer = player;
    
    [self.rankLabel setText:[NSString stringWithFormat:@"%d", player.rank]];
    [self.revenueLabel setText:[NSString stringWithFormat:@"%d", player.revenue]];
    //[self.tripMoneyLabel setText:[NSString stringWithFormat:@"%d", player.]];
    [self.totalGainLabel setText:[NSString stringWithFormat:@"%d", player.totalGain]];
    [self.alliesLabel setText:[NSString stringWithFormat:@"%d", player.allianceCount]];
    [self.territoriesOwnedLabel setText:[NSString stringWithFormat:@"%d", player.territoryCount]];
    [self.experiencePointsLabel setText:[NSString stringWithFormat:@"%d", player.xp]];
    [self.currentMoneyLabel setText:[NSString stringWithFormat:@"%d", player.money]];
    [self.purchasePriceLabel setText:[NSString stringWithFormat:@"%d", player.purchasePriceLvl]];
    [self.purchaseDistanceLabel setText:[NSString stringWithFormat:@"%d", player.purchaseDistanceLvl]];
    [self.maxExperienceLabel setText:[NSString stringWithFormat:@"%d", player.experienceLimitLvl]];
    [self.maxMoneyLabel setText:[NSString stringWithFormat:@"%d", player.moneyLimitLvl]];
    [self.experienceQteLabel setText:[NSString stringWithFormat:@"%d", player.experienceQteLvl]];
    [self.dropAlliancePriceLabel setText:[NSString stringWithFormat:@"%d", player.alliancePriceLvl]];
    
}


@end
