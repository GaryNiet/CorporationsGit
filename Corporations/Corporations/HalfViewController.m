//
//  HalfViewController.m
//  Corporations
//
//  Created by Gary Nietlispach on 11.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "HalfViewController.h"
#import "ViewController.h"

@interface HalfViewController ()

- (void)setAttr:(int)revenue : (float)lat : (float)lng : (int)price : (NSString*)owner;
-(void)setID:(NSString*)ID;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property NSString* identifier;
@property float lat;
@property float lng;
@property int price;
@property NSString* owner;

@end

@implementation HalfViewController

- (IBAction)buyButton:(id)sender {
    NSString* buyURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=purchaseTerritory&identifier=";
    buyURL = [buyURL stringByAppendingString:_identifier];
    buyURL = [buyURL stringByAppendingString:@"&lat="];
    buyURL = [buyURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lat]];
    buyURL = [buyURL stringByAppendingString:@"&lng="];
    buyURL = [buyURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lng]];
    buyURL = [buyURL stringByAppendingString:@"&owner="];
    buyURL = [buyURL stringByAppendingString:_owner];
    buyURL = [buyURL stringByAppendingString:@"&price="];
    buyURL = [buyURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", _price]];
    
    NSLog(buyURL);
    
}
- (IBAction)captureButton:(id)sender {
}

-(void)setID:(NSString *)ID
{
    _identifier = ID;
}



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.frame = CGRectMake(0,self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)setAttr:(int)revenue : (float)lat : (float)lng : (int)price : (NSString*)owner;
{
    self.priceLabel.text = [NSString stringWithFormat:@"price : $ %d",revenue];
    _lat = lat;
    _lng = lng;
    _price = price;
    _owner = owner;
}

@end
