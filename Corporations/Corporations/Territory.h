//
//  Territory.h
//  Corporations
//
//  Created by Gary Nietlispach on 19.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Territory : NSObject

@property float latitude;
@property float longitude;
@property float size;
@property float latTop;
@property float lngLeft;

- (id)init;
- (id)initWithParams:(NSMutableDictionary *)params;
- (id)initWithCoords: (float)lat :(float)lng :(float) width;

@end
