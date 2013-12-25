//
//  HalfViewController.h
//  Corporations
//
//  Created by Gary Nietlispach on 11.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HalfViewController : UIViewController

- (void)setAttr:(int)revenue : (float)lat : (float)lng : (int)price : (NSString*)owner;
-(void)setID:(NSString*)ID;
@property (nonatomic)  UIViewController* mainViewPointer;

@end
