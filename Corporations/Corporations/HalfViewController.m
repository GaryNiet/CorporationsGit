//
//  HalfViewController.m
//  Corporations
//
//  Created by Gary Nietlispach on 11.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "HalfViewController.h"
#import "ViewController.h"
#import "Territory.h"

@interface HalfViewController ()

-(void)setID:(NSString*)ID;


@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property NSString* identifier;
@property float lat;
@property float lng;
@property int price;
@property NSString* owner;
@property ViewController* parentPointer;
@property int isAllied;

@end

@implementation HalfViewController
- (IBAction)askAlliancePress:(id)sender
{
    NSString* allyURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=updateAlliance&identifier=";
    allyURL = [allyURL stringByAppendingString:_identifier];
    allyURL = [allyURL stringByAppendingString:@"&ally="];
    allyURL = [allyURL stringByAppendingString:_owner];
    allyURL = [allyURL stringByAppendingString:@"&createOrDelete="];
    
    int createOrDestroy;
    if(_isAllied == 1)
    {
        createOrDestroy = 0;
    }
    else
    {
        createOrDestroy = 1;
    }
    
    allyURL = [allyURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", createOrDestroy]];
    
    
    NSURLRequest *allyRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:allyURL]];
    NSURLConnection* allyConnection = [[NSURLConnection alloc] initWithRequest:allyRequest delegate:self];
    
}

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
    
    NSURLRequest *buyResponse = [NSURLRequest requestWithURL: [NSURL URLWithString:buyURL]];
    
}
- (IBAction)captureButton:(id)sender
{
    NSString* captureURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=captureTerritory&identifier=";
    captureURL = [captureURL stringByAppendingString:_identifier];
    captureURL = [captureURL stringByAppendingString:@"&lat="];
    captureURL = [captureURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lat]];
    captureURL = [captureURL stringByAppendingString:@"&lng="];
    captureURL = [captureURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lng]];
    captureURL = [captureURL stringByAppendingString:@"&owner="];
    captureURL = [captureURL stringByAppendingString:_owner];
    
    NSLog(captureURL);
    
    NSURLRequest *captureResponse = [NSURLRequest requestWithURL: [NSURL URLWithString:captureURL]];
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


-(void)setParentPointer:(ViewController *)vc
{
    _parentPointer = vc;
}


- (void)setAttr:(int)revenue : (float)lat : (float)lng : (int)price : (NSString*)owner :(int)isAllied;
{
    self.priceLabel.text = [NSString stringWithFormat:@"price : $ %d",revenue];
    _lat = lat;
    _lng = lng;
    _price = price;
    _owner = owner;
    _isAllied = isAllied;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    for(Territory *territory in [_parentPointer territoryList])
    {
        if([[territory ownerID] isEqualToString:_owner])
        {            if(territory.isAllied == 0)
            {
                territory.isAllied = 1;
            }
            else
            {
                territory.isAllied = 0;
            }
        }
    }
    
    [[_parentPointer mapView_] clear];
    [_parentPointer createRects];
}


@end
