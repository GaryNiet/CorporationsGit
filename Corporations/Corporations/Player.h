//
//  Player.h
//  Corporations
//
//  Created by Gary Nietlispach on 31.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject

@property NSString* userID;
@property int allianceCount;
@property int territoryCount;
@property int rank;
@property int money;
@property int revenue;
@property int totalGain;
@property int xp;
@property float homeLatitude;
@property float homeLongitude;
@property int purchasePriceLvl;
@property int purchaseDistanceLvl;
@property int experienceLimitLvl;
@property int moneyLimitLvl;
@property int experienceQteLvl;
@property int alliancePriceLvl;

- (void)updateDataBase;


@end
