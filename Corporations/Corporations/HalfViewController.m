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
@property NSMutableData* responseData;
@property NSMutableArray* pickerData;
@property (strong, nonatomic) IBOutlet UILabel *color;
@property (weak, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic)          NSArray *colorArray;


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
    _picker.hidden = false;
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
    self.picker.hidden = true;
    self.view.frame = CGRectMake(0,self.view.frame.size.height/2, self.view.frame.size.width, self.view.frame.size.height/2);
    self.colorArray  = [[NSArray alloc]         initWithObjects:@"Blue",@"Green",@"Orange",@"Purple",@"Red",@"Yellow" , nil];
}

// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
    
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 6;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.colorArray objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    NSLog(@"Selected Row %d", row);
    switch(row)
    {
            
        case 0:
            self.color.text = @"Blue #0000FF";
            self.color.textColor = [UIColor colorWithRed:0.0f/255.0f green: 0.0f/255.0f blue:255.0f/255.0f alpha:255.0f/255.0f];
            break;
        case 1:
            self.color.text = @"Green #00FF00";
            self.color.textColor = [UIColor colorWithRed:0.0f/255.0f green: 255.0f/255.0f blue:0.0f/255.0f alpha:255.0f/255.0f];
            break;
        case 2:
            self.color.text = @"Orange #FF681F";
            self.color.textColor = [UIColor colorWithRed:205.0f/255.0f green:   140.0f/255.0f blue:31.0f/255.0f alpha:255.0f/255.0f];
            break;
        case 3:
            self.color.text = @"Purple #FF00FF";
            self.color.textColor = [UIColor colorWithRed:255.0f/255.0f green:   0.0f/255.0f blue:255.0f/255.0f alpha:255.0f/255.0f];
            break;
        case 4:
            self.color.text = @"Red #FF0000";
            self.color.textColor = [UIColor colorWithRed:255.0f/255.0f green:   0.0f/255.0f blue:0.0f/255.0f alpha:255.0f/255.0f];
            break;
        case 5:
            self.color.text = @"Yellow #FFFF00";
            self.color.textColor = [UIColor colorWithRed:255.0f/255.0f green:   255.0f/255.0f blue:0.0f/255.0f alpha:255.0f/255.0f];
            break;
    }
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
    self.responseData = [NSMutableData data];
    
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
                    territory.ownerID = _identifier;
                    
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
    }
    
    if(connection == _captureConnection)
    {
        if([[res valueForKeyPath:@"status"]  isEqual: @"OK"])
        {
            for(Territory *territory in [_parentPointer territoryList])
            {
                if(territory.latitude == _lat && territory.longitude == _lng)
                {
                    territory.ownerID = _identifier;
                }
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Captured!" message:@"The territory was successfully captured" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }
    
    if(connection == _changePriceConnection)
    {
        
    }
    
    [[_parentPointer mapView_] clear];
    [_parentPointer createRects];
}


@end
