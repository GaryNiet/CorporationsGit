//
//  ViewController.h
//  Corporations
//
//  Created by Gary Nietlispach on 04.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController
- (void)createRects;

- (GMSMapView *)mapView_;

- (void)setMapView_:(GMSMapView *)newValue;
- (NSMutableArray *)territoryList;

- (void)setTerritoryList:(NSMutableArray *)newValue;
@end
