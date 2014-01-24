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
#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>

@interface HalfViewController()

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
@property (weak, nonatomic) IBOutlet UIButton *OKButton;
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
@property int owned;
@property NSURLConnection* allyConnection;
@property NSURLConnection* changePriceConnection;
@property NSURLConnection* buyConnection;
@property NSURLConnection* captureConnection;
@property NSMutableData* responseData;
@property NSMutableArray* pickerData;
@property (strong, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic)          NSMutableArray *colorArray;
@property NSString* userID;
@property int pickedPrice;
@property int wheel;
@property Territory* pointedTerritory;
@property (strong, nonatomic) FBProfilePictureView *profilePictureView;
@property ViewController* viewController;


@end

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]


@implementation HalfViewController

- (IBAction)OKButtonPressed:(id)sender {
    
    _picker.hidden = true;
    _OKButton.hidden = true;
    _priceLabel.hidden = false;
    _ownerLabel.hidden = true;
    _alliedLabel.hidden = true;
    _revenueLabel.hidden = false;
    _totalGainLabel.hidden = false;
    _purchasingPriceLabel.hidden = false;
    _captureButton.hidden = true;
    _buyButton.hidden = true;
    _askAllianceButton.hidden = true;
    _changePriceButton.hidden = false;
    
    _wheel = 0;
    
    
    
    
    NSString* changePriceURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=changePrice&identifier=";
    changePriceURL = [changePriceURL stringByAppendingString:_identifier];
    changePriceURL = [changePriceURL stringByAppendingString:@"&lat="];
    changePriceURL = [changePriceURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lat]];
    changePriceURL = [changePriceURL stringByAppendingString:@"&lng="];
    changePriceURL = [changePriceURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lng]];
    changePriceURL = [changePriceURL stringByAppendingString:@"&newPrice=500"];
    changePriceURL = [changePriceURL stringByAppendingString:[NSString stringWithFormat:@"%d", _pickedPrice]];
    
    
    NSURLRequest *changePriceRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:changePriceURL]];
    _changePriceConnection = [[NSURLConnection alloc] initWithRequest:changePriceRequest delegate:self];
}

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
    
    [_parentPointer getProfileFromServer];
    
}
- (IBAction)changeSalePrice:(id)sender
{
    if(_wheel == 0)
    {
        _picker.hidden = false;
        _OKButton.hidden = false;
        _priceLabel.hidden = true;
        _ownerLabel.hidden = true;
        _alliedLabel.hidden = true;
        _revenueLabel.hidden = true;
        _totalGainLabel.hidden = true;
        _purchasingPriceLabel.hidden = true;
        _captureButton.hidden = true;
        _buyButton.hidden = true;
        _askAllianceButton.hidden = true;
        _changePriceButton.hidden = false;
        
        _wheel = 1;
    }
    else
    {
        _picker.hidden = true;
        _OKButton.hidden = true;
        _priceLabel.hidden = false;
        _ownerLabel.hidden = true;
        _alliedLabel.hidden = true;
        _revenueLabel.hidden = false;
        _totalGainLabel.hidden = false;
        _purchasingPriceLabel.hidden = false;
        _captureButton.hidden = true;
        _buyButton.hidden = true;
        _askAllianceButton.hidden = true;
        _changePriceButton.hidden = false;
        
        _wheel = 0;
    }
    
}

- (IBAction)buyButton:(id)sender {
    
    NSString* buyURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=purchaseTerritory&identifier=";
    if(_owned == 1)
    {
        buyURL = [buyURL stringByAppendingString:_identifier];
        buyURL = [buyURL stringByAppendingString:@"&lat="];
        buyURL = [buyURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lat]];
        buyURL = [buyURL stringByAppendingString:@"&lng="];
        buyURL = [buyURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lng]];
        buyURL = [buyURL stringByAppendingString:@"&owner="];
        buyURL = [buyURL stringByAppendingString:_owner];
        buyURL = [buyURL stringByAppendingString:@"&price="];
        buyURL = [buyURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", _sellingPrice]];
    }
    else
    {
        NSLog(@"identifier: %@", _identifier);
        buyURL = [buyURL stringByAppendingString:_identifier];
        buyURL = [buyURL stringByAppendingString:@"&lat="];
        buyURL = [buyURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lat]];
        buyURL = [buyURL stringByAppendingString:@"&lng="];
        buyURL = [buyURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", _lng]];
        buyURL = [buyURL stringByAppendingString:@"&owner=-1"];
        buyURL = [buyURL stringByAppendingString:@"&price="];
        buyURL = [buyURL stringByAppendingString:[NSString stringWithFormat:@"%.20d", _sellingPrice]];
        
    }
    
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

-(void)setUserID:(NSString *)userID
{
    _userID = userID;
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
    self.picker.hidden = true;
    self.OKButton.hidden = true;
    self.wheel = 0;
    self.view.frame = CGRectMake(0,self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
    self.colorArray  = [[NSMutableArray alloc]init];
    
    for(int i = 100; i<10100; i+=100)
    {
        [self.colorArray addObject: [NSString stringWithFormat:@"%d", i]];
    }
    
}

- (void)initializeProfilePic {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    
    // Initialize the profile picture
    self.profilePictureView = [[FBProfilePictureView alloc] init];
    self.profilePictureView.layer.cornerRadius = 40;
    // Set the size
    self.profilePictureView.frame = CGRectMake(0.0, 0.0, 80.0, 80.0);
    // Show the profile picture for a user
    self.profilePictureView.profileID = _owner;
    // Add the profile picture view to the main view
    [self.view addSubview:self.profilePictureView];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 100;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.colorArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    _pickedPrice = (row+1)*100;
    
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


- (void)setAttr:(Territory*)territory :(bool)buyable;
{
    self.responseData = [NSMutableData data];
    self.profilePictureView = nil;
    [self initializeProfilePic];
    _pointedTerritory = territory;
    
    _lat = territory.latitude;
    _lng = territory.longitude;
    _revenue = territory.revenue;
    _owner = territory.ownerID;
    _isAllied = territory.isAllied;
    _buyingPrice = territory.buyingPrice;
    _sellingPrice = territory.sellingPrice;
    _isSpecialTerritory = territory.isSpecialItem;
    _ownedTime = territory.ownedTime;
    _owned = territory.owned;
    
    self.priceLabel.text = [NSString stringWithFormat:@"selling price : $ %d",_sellingPrice];
    
    if(_isAllied == true)
    {
        self.alliedLabel.text = @"Is Allied : yes";
    }
    else
    {
        self.alliedLabel.text = @"Is Allied: no";
    }
    
    self.revenueLabel.text = [NSString stringWithFormat:@"revenue : $ %d",_revenue];
    self.totalGainLabel.text = [NSString stringWithFormat:@"total gain : $ %d", _ownedTime*_revenue];
    
    
    
    if(_purchasingPriceLabel == 0)
    {
        self.purchasingPriceLabel.text = @"not for sale";
    }
    else
    {
        self.purchasingPriceLabel.text = [NSString stringWithFormat:@"bought for: $ %d",_buyingPrice];
    }
    
//    if(_sellingPrice == 0)
//    {
//        self.priceLabel.text = @"not for sale";
//    }
//    else
//    {
//        self.priceLabel.text = @"selling for:";
//    }
    
    
    if([_owner  isEqual: @"unknown"])
    {
        self.view.backgroundColor = UIColorFromRGB(0x3a3f44);
        
        self.priceLabel.hidden = false;
        self.alliedLabel.hidden = true;
        self.ownerLabel.hidden = true;
        self.revenueLabel.hidden = true;
        self.totalGainLabel.hidden = true;
        self.purchasingPriceLabel.hidden = true;
        self.buyButton.hidden = false;
        _changePriceButton.hidden = true;
        _captureButton.hidden = true;
        _askAllianceButton.hidden = true;
        
    }
    else if(_isSpecialTerritory)
    {
        self.view.backgroundColor = UIColorFromRGB(0x2980b9);
        
        _buyButton.hidden = true;
        _captureButton.hidden = false;
        _changePriceButton.hidden = true;
        _askAllianceButton.hidden = false;
        
        self.priceLabel.hidden = true;
        self.alliedLabel.hidden = false;
        self.ownerLabel.hidden = false;
        self.revenueLabel.hidden = false;
        self.totalGainLabel.hidden = true;
        self.purchasingPriceLabel.hidden = true;

    }
    else if([_owner isEqualToString: _userID])
    {
        self.view.backgroundColor = UIColorFromRGB(0x399a48);
        
        _buyButton.hidden = true;
        
        self.priceLabel.hidden = false;
        self.alliedLabel.hidden = true;
        self.ownerLabel.hidden = true;
        self.revenueLabel.hidden = false;
        self.totalGainLabel.hidden = false;
        self.purchasingPriceLabel.hidden = false;
        
        _changePriceButton.hidden = false;
        _captureButton.hidden = true;
        _askAllianceButton.hidden = true;
    }
    else
    {
        self.view.backgroundColor = UIColorFromRGB(0xdf5d07);
        
        _buyButton.hidden = false;
        _captureButton.hidden = true;
        _changePriceButton.hidden = true;
        _askAllianceButton.hidden = false;
        
        self.priceLabel.hidden = false;
        self.alliedLabel.hidden = false;
        self.ownerLabel.hidden = false;
        self.revenueLabel.hidden = false;
        self.totalGainLabel.hidden = true;
        self.purchasingPriceLabel.hidden = true;
    }
    
    if(!buyable)
    {
        self.buyButton.hidden = true;
        self.priceLabel.text = @"not for sale";
    }
    
    
    NSString* url = _owner;
    [url stringByAppendingString: @"/?fields=name"];
    
    FBRequest *request = [FBRequest requestForGraphPath:url];
    
    [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if([result objectForKey:@"name"] != nil)
        {
            self.ownerLabel.text = [result objectForKey:@"name"];
        }
        else
        {
            self.ownerLabel.text = territory.ownerID;
        }
    }];
    
    
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    
    if(connection == _allyConnection)
    {
        int flag = 0;
        if([[res valueForKeyPath:@"status"]  isEqual: @"OK"])
        {
            for(Territory *territory in [_parentPointer territoryList])
            {
                if([[territory ownerID] isEqualToString:_owner])
                {            if(territory.isAllied == 0)
                {
                    territory.isAllied = 1;
                    flag = 1;
                }
                else
                {
                    territory.isAllied = 0;
                    flag = 0;
                }
                    
                }
            }
        }
        
        if(flag == 1)
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Allied!" message:@"The Alliance was accepted" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }
        else
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Alliance destroyed!" message:@"The Alliance was destroyed" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }
    }
    
    if(connection == _buyConnection)
    {
        if([[res valueForKeyPath:@"status"]  isEqual: @"OK"])
        {
            for(Territory *territory in [_parentPointer territoryList])
            {
                if(territory.latitude == _lat && territory.longitude == _lng)
                {
                    territory.ownerID = _userID;
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"transaction OK" message:@"You now own a new territory" delegate:self cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                    
                    
                }
            }
        }
        else if([[res valueForKeyPath:@"status"]  isEqual: @"NOT_ENOUGTH_MONEY"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"not enough money" message:@"You don't have enough money to buy this territory" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
            [alert show];
        }
        else if([[res valueForKeyPath:@"status"]  isEqual: @"OWNER_CHANGE"])
        {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"The owner has changed" message:@"You weren't fast enough and somebody else grabbed this territory" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [_parentPointer getProfileFromServer];
    }
    
    if(connection == _captureConnection)
    {
        if([[res valueForKeyPath:@"status"]  isEqual: @"OK"])
        {
            for(Territory *territory in [_parentPointer territoryList])
            {
                if(territory.latitude == _lat && territory.longitude == _lng)
                {
                    territory.ownerID = _userID;
                }
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Captured!" message:@"The territory was successfully captured" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
        [_parentPointer getProfileFromServer];
    }
    
    if(connection == _changePriceConnection)
    {
        if([[res valueForKeyPath:@"status"]  isEqual: @"OK"])
        {
            _pointedTerritory.sellingPrice = _pickedPrice;
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Changed!" message:@"The selling price has successfully been changed" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            
            _priceLabel.text = [NSString stringWithFormat:@"sellgin price: %d",_pickedPrice ];
            
        }
    }
    
    [[_parentPointer mapView_] clear];
    [_parentPointer createRects];
}





@end
