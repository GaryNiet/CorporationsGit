//
//  HalfViewController.h
//  Corporations
//
//  Created by Gary Nietlispach on 11.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"
#import "Territory.h"

@interface HalfViewController : UIViewController

- (void)setAttr: (Territory*)territory;
-(void)setID:(NSString*)ID;
-(void)setParentPointer :(ViewController*)vc;

@end
