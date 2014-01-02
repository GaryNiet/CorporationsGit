//
//  Territory.m
//  Corporations
//
//  Created by Gary Nietlispach on 19.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "Territory.h"

@interface Territory()
-(id)initWithParams:(NSMutableDictionary *)params;
-(id)initWithCoords:(float)lat :(float)lng :(float)width :(int)isAllied :(int)revenue :(NSString*)userId;

@end


@implementation Territory




- (id)init
{
    self = [super init];
    if (self)
    {
        
    }
    return self;
}

-(id)initWithParams:(NSMutableDictionary *)params
{
    self = [super init];
    if (self) {
        //some init code
    }
    return self;
}


-(id)initWithCoords:(float)lat :(float)lng :(float)width :(int)isAllied :(int)revenue :(NSString *)userId{
    self = [super init];
    if (self)
    {
        _latitude = lat;
        _longitude = lng;
        _size = width;
        _revenue = revenue;
        ownerID = userId;
        _isAllied = isAllied;
        
        int sign = (_latitude >= 0) ? 1 : -1;
        _latTop = round((_latitude + _size - fmod(_latitude,_size) * sign) / _size) * _size;
        
        sign = (_longitude >= 0) ? 1 : -1;
        _lngLeft = round((_longitude - fmod(_longitude,_size) * sign) / _size) * _size;
        
        
        _isAllied = isAllied;
        
    }
    return self;
}

- (float)isInBounds:(float)lat : (float)lng
{
    return (lat < _latitude + _size && lat > _latitude && lng > _longitude && lng < _longitude + _size);
}


- (NSString *)ownerID {
    return ownerID;
}

- (void)setOwnerID:(NSString *)newValue {
    ownerID = newValue;
}

@end
