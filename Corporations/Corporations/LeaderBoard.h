//
//  LeaderBoard.h
//  Corporations
//
//  Created by Gary Nietlispach on 20.01.14.
//  Copyright (c) 2014 Gary Nietlispach. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeaderBoard : UITableViewController<UITableViewDelegate, UITableViewDataSource>
-(void)setIdentifier: (NSString*)id;
@end
