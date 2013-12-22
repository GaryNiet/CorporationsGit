//
//  Territory.m
//  Corporations
//
//  Created by Gary Nietlispach on 19.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "Territory.h"

@interface Territory()
-(id)initWithCoords:(float)lat :(float)lng :(float) width;
-(id)initWithParams:(NSMutableDictionary *)params;


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


-(id)initWithCoords:(float)lat :(float)lng :(float) width
{
    self = [super init];
    if (self)
    {
        _latitude = lat;
        _longitude = lng;
        _size = width;
        
        int sign = (_latitude >= 0) ? 1 : -1;
        _latTop = round((_latitude + _size - fmod(_latitude,_size) * sign) / _latitude) * _size;
        
        sign = (_longitude >= 0) ? 1 : -1;
        _lngLeft = round((_longitude - fmod(_longitude,_size) * sign) / _size) * _size;
        
    }
    return self;
}

- (float)isInBounds: (float)lat: (float)lng
{
    int sign = (_latitude >= 0) ? 1 : -1;
    if( lat > (_latTop - _size)*sign && lat < (_latTop)*sign)
    {
        if( lng > (_lngLeft-_size) * sign && lng < (_lngLeft)*sign)
        {
            return true;
        }
    }
    return false;
}


@end
