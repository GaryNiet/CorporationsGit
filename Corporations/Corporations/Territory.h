//
//  Territory.h
//  Corporations
//
//  Created by Gary Nietlispach on 19.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Territory : NSObject
{
    NSString* ownerID;
}

@property float latitude;
@property float longitude;
@property float size;
@property float latTop;
@property float lngLeft;
@property int isAllied;
@property int revenue;
@property int isSpecialItem;
@property int buyingPrice;
@property int sellingPrice;
@property int ownedTime;
@property int selected;

- (id)init;
- (id)initWithParams:(NSMutableDictionary *)params;
- (id)initWithCoords:(float)lat :(float)lng :(float)width :(int)isAllied :(int)revenue :(NSString*)userId :(int)isSpecialTerritory :(int)buyingPrice :(int)sellingPrice :(int)ownedTime;
- (float)isInBounds: (float)lat : (float)lng;

- (NSString *)ownerID;

- (void)setOwnerID:(NSString *)newValue;

@end
