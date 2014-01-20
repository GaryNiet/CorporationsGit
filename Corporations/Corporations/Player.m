//
//  Player.m
//  Corporations
//
//  Created by Gary Nietlispach on 31.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "Player.h"

@implementation Player

- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}


- (void)updateDataBase: (int)xpCost
{
    
    NSString* updateURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=updateProfile&identifier=";
    updateURL = [updateURL stringByAppendingString:self.userID];
    updateURL = [updateURL stringByAppendingString:@"&experiencePointsPrice="];
    updateURL = [updateURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", xpCost]];
    updateURL = [updateURL stringByAppendingString:@"&purchasePriceSkillLevel="];
    updateURL = [updateURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", _purchasePriceLvl]];
    updateURL = [updateURL stringByAppendingString:@"&purchaseDistanceSkillLevel="];
    updateURL = [updateURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", _purchaseDistanceLvl]];
    updateURL = [updateURL stringByAppendingString:@"&experienceLimitSkillLevel="];
    updateURL = [updateURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", _experienceLimitLvl]];
    updateURL = [updateURL stringByAppendingString:@"&moneyLimitSkillLevel="];
    updateURL = [updateURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", _moneyLimitLvl]];
    updateURL = [updateURL stringByAppendingString:@"&experienceQuantityFoundSkillLevel="];
    updateURL = [updateURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", _experienceQteLvl]];
    updateURL = [updateURL stringByAppendingString:@"&alliancePriceSkillLevel="];
    updateURL = [updateURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", _alliancePriceLvl]];
    
    NSLog(updateURL);
    
}


@end
