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
@property (weak, nonatomic) IBOutlet UILabel *ownerLabel;
@property (weak, nonatomic) IBOutlet UILabel *alliedLabel;
@property (weak, nonatomic) IBOutlet UILabel *revenueLabel;
@property (weak, nonatomic) IBOutlet UILabel *totalGainLabel;
@property (weak, nonatomic) IBOutlet UILabel *purchasingPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *captureButton;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@property (weak, nonatomic) IBOutlet UIButton *askAllianceButton;
@property (weak, nonatomic) IBOutlet UIButton *changePriceButton;
@property NSString* identifier;
@property float lat;
@property float lng;
@property int price;
@property NSString* owner;
@property ViewController* parentPointer;
@property int isAllied;
@property int buyingPrice;
@property int sellingPrice;
@property int isSpecialTerritory;
@property int ownedTime;
@property int revenue;
@property NSURLConnection* allyConnection;
@property NSURLConnection* changePriceConnection;
@property NSURLConnection* buyConnection;
@property NSURLConnection* captureConnection;


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
    _allyConnection = [[NSURLConnection alloc] initWithRequest:allyRequest delegate:self];
    
}
- (IBAction)changeSalePrice:(id)sender
{
    NSLog(@"change price");
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
    
    NSURLRequest *buyRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:buyURL]];
    _buyConnection = [[NSURLConnection alloc] initWithRequest:buyRequest delegate:self];
    
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
    
    NSURLRequest *captureRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:captureURL]];
    _captureConnection = [[NSURLConnection alloc] initWithRequest:captureRequest delegate:self];
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


- (void)setAttr:(Territory*)territory;
{
    
    _lat = territory.latitude;
    _lng = territory.longitude;
    _price = territory.revenue;
    _owner = territory.ownerID;
    _revenue = territory.revenue;
    _isAllied = territory.isAllied;
    _buyingPrice = territory.buyingPrice;
    _sellingPrice = territory.sellingPrice;
    _isSpecialTerritory = territory.isSpecialItem;
    _ownedTime = territory.ownedTime;
    
    
    self.priceLabel.text = [NSString stringWithFormat:@"selling price : $ %d",_sellingPrice];
    
    if(_isAllied == true)
    {
        self.alliedLabel.text = @"Is Allied : yes";
    }
    else
    {
        self.alliedLabel.text = @"Is Allied: no";
    }
    
    self.ownerLabel.text = [NSString stringWithFormat:@"owner : %@", _owner];
    self.revenueLabel.text = [NSString stringWithFormat:@"revenue : $ %d",_revenue];
    self.totalGainLabel.text = [NSString stringWithFormat:@"total gain : $ %d", _ownedTime*_revenue];
    self.purchasingPriceLabel.text = [NSString stringWithFormat:@"price : $ %d",_buyingPrice];
    
    
    
    if(_owner == 0)
    {
        self.priceLabel.hidden = true;
        self.alliedLabel.hidden = true;
        self.ownerLabel.hidden = true;
        self.revenueLabel.hidden = true;
        self.totalGainLabel.hidden = true;
        
        _changePriceButton.hidden = true;
        _captureButton.hidden = true;
        _askAllianceButton.hidden = true;
        
    }
    else if(_isSpecialTerritory)
    {
        self.priceLabel.hidden = true;
        self.totalGainLabel.hidden = true;
        self.purchasingPriceLabel.hidden = true;
        
        _buyButton.hidden = true;
        _changePriceButton.hidden = true;
        _askAllianceButton.hidden = true;
    }
    else if(_owner == _identifier)
    {
        self.alliedLabel.hidden = true;
        self.ownerLabel.hidden = true;
        
        _buyButton.hidden = true;
        _captureButton.hidden = true;
        _askAllianceButton.hidden = true;
    }
    else
    {
        self.totalGainLabel.hidden = true;
        self.purchasingPriceLabel.hidden = true;
        
        
        _changePriceButton.hidden = true;
        _captureButton.hidden = true;
    }
    
    
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    if(connection == _allyConnection)
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
    }
    
    if(connection == _buyConnection)
    {
        for(Territory *territory in [_parentPointer territoryList])
        {
            if(territory.latitude == _lat && territory.longitude == _lng)
            {
                territory.ownerID = _identifier;
            }
        }
    }
    
    if(connection == _captureConnection)
    {
        for(Territory *territory in [_parentPointer territoryList])
        {
            if(territory.latitude == _lat && territory.longitude == _lng)
            {
                territory.ownerID = _identifier;
            }
        }
    }
    
    if(connection == _changePriceConnection)
    {
        
    }
    
    [[_parentPointer mapView_] clear];
    [_parentPointer createRects];
}


@end
