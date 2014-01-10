//
//  ViewController.m
//  Corporations
//
//  Created by Gary Nietlispach on 24.10.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "ViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import "HalfViewController.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import <FacebookSDK/FacebookSDK.h>
#import "Territory.h"
#import "ProfileView.h"
#import "Player.h"
#import "JourneyViewController.h"

@interface ViewController ()<GMSMapViewDelegate>
{
    NSMutableArray* territoryList;
}
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, strong) NSDictionary *terri;
@property (strong, nonatomic) FBProfilePictureView *profilePictureView;

@property __block NSString* facebookID;
@property UIStoryboard* sb;
@property HalfViewController *hf;
@property ProfileView *profileViewController;
@property bool isJustMap;
@property GMSOverlay* shownOverlay;
@property NSString* identifier;
@property NSMutableArray* rectTab;
@property NSMutableData* allTerritories;
@property NSURLConnection* territoryConnection;
@property NSURLConnection* profileConnection;
@property double squareSize;
@property NSMutableArray* territoryList;
@property Player* playerProfile;
@property GMSMapView* mv;
@property float shownTerritoryLat;
@property float shownTerritoryLng;
@property float basicZoom;
@property Territory* selectedTerritory;
@property NSString* userID;
@property Territory* lastEmptyTerritory;
@property JourneyViewController* journeyViewController;
@property CLLocation* currentLocation;
@property CLLocation* houseLocation;
@property NSTimer* timer;
@property int distanceTraveled;
@property bool hasTraveled;
@property NSDate* journeyStart;



@end

@implementation ViewController{
    GMSMapView *mapView_;
    GMSCameraPosition *camera;
    
    
}
@synthesize profilePictureView = _profilePictureView;
@synthesize responseData = _responseData;

- (void)createRects{
    
    
    self.rectTab = [NSMutableArray array];
    int latitude = (int)[self mapView_].camera.target.latitude;
    int longitude = (int)[self mapView_].camera.target.longitude;
    
    
    
    for(Territory *territory in territoryList)
    {
        if(territory.latitude<latitude+10 && territory.latitude > latitude-10)
        {
            if(territory.longitude<longitude+10 && territory.longitude > longitude-10)
            {
                
                GMSMutablePath *rect = [GMSMutablePath path];
                [rect addCoordinate:CLLocationCoordinate2DMake(territory.latitude, territory.longitude + _squareSize)];
                [rect addCoordinate:CLLocationCoordinate2DMake(territory.latitude + _squareSize, territory.longitude + _squareSize)];
                [rect addCoordinate:CLLocationCoordinate2DMake(territory.latitude + _squareSize, territory.longitude)];
                [rect addCoordinate:CLLocationCoordinate2DMake(territory.latitude, territory.longitude)];
                
                GMSPolygon *polygon = [GMSPolygon polygonWithPath:rect];
                polygon.tappable = false;
                
                if([territory.ownerID isEqualToString: _userID])
                {
                    polygon.fillColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.15];
                }
                else if(territory.owned == 0)
                {
                    polygon.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.05];
                }
                else
                {
                    if(territory.isAllied == 1)
                    {
                        polygon.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.15];
                    }
                    else
                    {
                        polygon.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.15];
                    }
                }
                
                if(territory.selected == true)
                {
                    polygon.strokeColor = [UIColor redColor];
                    polygon.strokeWidth = 8;
                }
                else
                {
                    polygon.strokeColor = [UIColor blackColor];
                    polygon.strokeWidth = 2;
                }
                
                
                polygon.map = [self mapView_];
                
            }
        }

    }

}

- (void)loadView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.s
    _basicZoom = 12.0;
    camera = [GMSCameraPosition cameraWithLatitude:47.048878
                                         longitude:6.816487
                                              zoom:_basicZoom];
    [self setMapView_: [GMSMapView mapWithFrame:CGRectZero camera:camera]];
    [self mapView_].myLocationEnabled = YES;
    [self mapView_].delegate = self;
    self.view = [self mapView_];
    self.isJustMap = true;
    self.sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.hf = [self.sb instantiateViewControllerWithIdentifier:@"halfView"];
    [self.hf setParentPointer:self];
    _mv = [self mapView_];
    self.distanceTraveled = 0;
     
    self.profileViewController = [self.sb instantiateViewControllerWithIdentifier: @"profileView"];
    self.squareSize = 0.01;
    self.territoryList = [[NSMutableArray alloc] init];
    self.playerProfile = [[Player alloc] init];
    self.userID = [[NSString alloc] init];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget: self action:@selector(didPan:)];
    mapView_.gestureRecognizers = @[panRecognizer];
    
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenHeight = screenSize.height;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(showJourneyView)
     forControlEvents:UIControlEventTouchDown];
    [button setTitle:@"" forState:UIControlStateNormal];
    button.frame = CGRectMake(0.0, screenHeight - 50.0, 50.0, 50.0);
    [self.view addSubview:button];
    
    
    
}

-(void) showJourneyView
{
    [self.journeyViewController setAttr:_journeyStart :_distanceTraveled];
    
    [self.view addSubview: _journeyViewController.view];
}

- (void) didPan:(UIPanGestureRecognizer*) gestureRecognizer
{
    if(fabsf([gestureRecognizer translationInView:mapView_].x) + fabsf([gestureRecognizer translationInView:mapView_].x) >= 250)
    {
        [self.hf.view removeFromSuperview];
    }
    
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view setMultipleTouchEnabled:YES];
    
    
    
    __block NSString* loginURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=connection&identifier=";
    
    
    [FBRequestConnection startForMeWithCompletionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error)
     {
         NSDictionary *userInfo = (NSDictionary *)result;
         _facebookID = [userInfo objectForKey:@"id"];
         
         NSString* toHash = (NSString*)[UIDevice currentDevice].identifierForVendor;
         NSString* hash = [self hashedValue:@"string" andData:@"string2"];
         
         
         loginURL = [loginURL stringByAppendingString:hash];
         self.identifier = hash;
         loginURL = [loginURL stringByAppendingString:@"&user_id="];
         loginURL = [loginURL stringByAppendingString:_facebookID];
         
         
         
         NSString *fbToken = (NSString*)[[[FBSession activeSession] accessTokenData] accessToken];
         
         
         loginURL = [loginURL stringByAppendingString:@"&token="];
         loginURL = [loginURL stringByAppendingString:fbToken];
         loginURL = [loginURL stringByAppendingString:@"&lat=0&lng=0"];
         
         self.responseData = [NSMutableData data];
         NSURLRequest *request = [NSURLRequest requestWithURL:
                                  [NSURL URLWithString:loginURL]];
         [[NSURLConnection alloc] initWithRequest:request delegate:self];
         
         
         NSString* getTerritoriesURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=territories&identifier=";
         getTerritoriesURL = [getTerritoriesURL stringByAppendingString:self.identifier];
         getTerritoriesURL = [getTerritoriesURL stringByAppendingString:@"&lat="];
         getTerritoriesURL = [getTerritoriesURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", camera.targetAsCoordinate.latitude]];
         getTerritoriesURL = [getTerritoriesURL stringByAppendingString:@"&lng="];
         getTerritoriesURL = [getTerritoriesURL stringByAppendingString:[NSString stringWithFormat:@"%.20f", camera.targetAsCoordinate.longitude]];
         getTerritoriesURL = [getTerritoriesURL stringByAppendingString:@"&limit=1"];
         
//         NSLog(getTerritoriesURL);
         self.terri = [NSMutableData data];
         NSURLRequest *territories = [NSURLRequest requestWithURL: [NSURL URLWithString:getTerritoriesURL]];
         
         _territoryConnection =[[NSURLConnection alloc] initWithRequest:territories delegate:self];
         
         
         
         NSString* getProfileURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=profile&identifier=";
         getProfileURL = [getProfileURL stringByAppendingString:self.identifier];
         NSURLRequest *profile = [NSURLRequest requestWithURL: [NSURL URLWithString:getProfileURL]];
         NSLog(getProfileURL);
         _profileConnection =[[NSURLConnection alloc] initWithRequest:profile delegate:self];
         
         _currentLocation = mapView_.myLocation;
         
         
         _timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(distanceManager) userInfo:nil repeats:YES];

         
         
         _journeyViewController = [self.sb instantiateViewControllerWithIdentifier:@"journeyviewcontroller"];
         
     }];
    

}

-(void)distanceManager
{
    CLLocation* newLocation = mapView_.myLocation;
    
    
    //if distance from home is freater than 20meters.
    if([newLocation distanceFromLocation:[[CLLocation alloc] initWithLatitude:_playerProfile.homeLatitude longitude:_playerProfile.homeLongitude]] > 20)
    {
        if(_hasTraveled == false)
        {
            _journeyStart = [[NSDate alloc] init];
        }
        
        CLLocation* newLocation = mapView_.myLocation;
        double distance = [newLocation distanceFromLocation:_currentLocation];
        _currentLocation = newLocation;
    
        _distanceTraveled += distance;
        NSLog(@"distance traveled: %d", _distanceTraveled);
        _hasTraveled = true;
    }
    else
    {
        if(_hasTraveled == true)
        {
            //end journey
            _hasTraveled = false;
        }
    }
    
}




- (NSString *) hashedValue :(NSString *) key andData: (NSString *) data {
    
    
    const char *cKey  = [key cStringUsingEncoding:NSUTF8StringEncoding];
    const char *cData = [data cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA256_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA256, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    NSString *hash;
    
    NSMutableString* output = [NSMutableString   stringWithCapacity:CC_SHA256_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", cHMAC[i]];
    hash = output;
    return hash;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) mapView: (GMSMapView *) mapView  didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"latitude: %f", coordinate.latitude);
    NSLog(@"longitude: %f", coordinate.longitude);
    
    
    CGPoint point = [mapView_.projection pointForCoordinate:coordinate];
    point.y = point.y + 100;
    GMSCameraUpdate *pos = [GMSCameraUpdate setTarget:[mapView_.projection coordinateForPoint:point]];
    [mapView_ animateWithCameraUpdate:pos];
    
    _selectedTerritory.selected = false;
    
    
    //NSDictionary *result = (NSDictionary*)[_terri objectForKey:@"results"];
    bool flag = false;
    
    for(Territory *territory in territoryList)
    {
        if([territory isInBounds:coordinate.latitude :coordinate.longitude ])
        {
            flag = true;
            territory.selected = true;
            _selectedTerritory = territory;
            
            
            [self.hf setAttr: territory];
            
            //juste là pour faire passe des informations
            [self.hf setID:_identifier];
            [self.hf setUserID:_userID];
            
            if(territory.latitude == _shownTerritoryLat && territory.longitude == _shownTerritoryLng)
            {
                [self.hf.view removeFromSuperview];
                _shownTerritoryLat = 0;
                _shownTerritoryLng = 0;
            }
            else
            {
                
                [self.view addSubview:self.hf.view];
                _shownTerritoryLat = territory.latitude;
                _shownTerritoryLng = territory.longitude;
            }
            
            
        }
    }
    
    if(flag == false)
    {
        
        int sign = (coordinate.latitude >= 0) ? 1 : -1;
        float newLat = round((coordinate.latitude - _squareSize*1.5 + _squareSize - fmod(coordinate.latitude - _squareSize*1.5,_squareSize) * sign) / _squareSize) * _squareSize;
        sign = (coordinate.longitude >= 0) ? 1 : -1;
        float newlong = round((coordinate.longitude+ _squareSize*1.5  - fmod(coordinate.longitude+ _squareSize*1.5 ,_squareSize) * sign) / _squareSize) * _squareSize- _squareSize;
        
        
        [territoryList removeObject:_lastEmptyTerritory];
        
        Territory* newEmptyTerritory = [[Territory alloc]initWithCoords:newLat +_squareSize/2 :newlong -_squareSize/2:_squareSize :0 :0 :@"unknown" :0 :1000 :1000 :0:0];
        _lastEmptyTerritory = newEmptyTerritory;
        [territoryList addObject:newEmptyTerritory];
        
        [self.hf setID:_identifier];
        [self.hf setAttr:newEmptyTerritory];
        [self.view addSubview:self.hf.view];
    }


    
    [[self mapView_] clear];
    [self createRects];
    
    
    
}




- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    
    [[self mapView_] clear];
    [self createRects];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSLog(@"didReceiveResponse");
    [self.responseData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.responseData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError");
    NSLog([NSString stringWithFormat:@"Connection failed: %@", [error description]]);
}


- (void)initializeProfilePic {
    CGRect screenBound = [[UIScreen mainScreen] bounds];
    CGSize screenSize = screenBound.size;
    CGFloat screenWidth = screenSize.width;
    
    // Initialize the profile picture
    self.profilePictureView = [[FBProfilePictureView alloc] init];
    self.profilePictureView.layer.cornerRadius = 25;
    // Set the size
    self.profilePictureView.frame = CGRectMake(screenWidth -50.0, 0.0, 50.0, 50.0);
    // Show the profile picture for a user
    self.profilePictureView.profileID = _facebookID;
    // Add the profile picture view to the main view
    [self.view addSubview:self.profilePictureView];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self
               action:@selector(showProfileView)
     forControlEvents:UIControlEventTouchDown];
    button.frame = CGRectMake(screenWidth -50.0, 0.0, 50.0, 50.0);
    [self.view addSubview:button];
}

- (void)showProfileView
{
    
    [_profileViewController displayInfo: _playerProfile];
    [self.view addSubview:self.profileViewController.view];
    
}




- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    

    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    
    if(connection == _territoryConnection)
    {
        _terri = res;
        
        
        
        
        NSArray *result = [res objectForKey:@"results"];
        
        for(id key in result)
        {
            
            
            
            NSString *latitudeAsString = (NSString*)[key objectForKey:@"la"] ;
            NSString *longitudeAsString = (NSString*)[key objectForKey:@"lo"] ;
            NSString *isAlliedAsString = (NSString*)[key objectForKey:@"a"] ;
            NSString *revenueAsString = (NSString*)[key objectForKey:@"r"] ;
            NSString *userIdAsString = (NSString*)[key objectForKey:@"o"] ;
            NSString *isSpecialTerritory = (NSString*)[key objectForKey:@"s"] ;
            NSString *buyingPrice = (NSString*)[key objectForKey:@"pp"] ;
            NSString *sellingPrice = (NSString*)[key objectForKey:@"sp"] ;
            NSString *ownedTime = (NSString*)[key objectForKey:@"t"] ;

            [territoryList addObject:[[Territory alloc]initWithCoords:[latitudeAsString floatValue] :[longitudeAsString floatValue] :(float)_squareSize :[isAlliedAsString intValue] :[revenueAsString intValue] :userIdAsString :[isSpecialTerritory intValue] :[buyingPrice intValue] :[sellingPrice intValue] :[ownedTime intValue]:1]];
            
        }

        
    
    }
    
    if(connection == _profileConnection)
    {
        

            _userID = (NSString*)[res valueForKeyPath:@"results.id"];
            _playerProfile.userID = (NSString*)[res valueForKeyPath:@"results.id"] ;
            _playerProfile.allianceCount = [[res valueForKeyPath:@"results.na"] integerValue];
            _playerProfile.territoryCount = [[res valueForKeyPath:@"results.nt"] integerValue] ;
            _playerProfile.rank = [[res valueForKeyPath:@"results.r"] integerValue] ;
            _playerProfile.money = [[res valueForKeyPath:@"results.cm"] integerValue] ;
            _playerProfile.revenue = [[res valueForKeyPath:@"results.cr"] integerValue] ;
            _playerProfile.totalGain = [[res valueForKeyPath:@"results.tg"] integerValue] ;
            _playerProfile.xp = [[res valueForKeyPath:@"results.ep"] integerValue] ;
            _playerProfile.homeLatitude = [[res valueForKeyPath:@"results.hlat"] floatValue];
            _playerProfile.homeLongitude = [[res valueForKeyPath:@"results.hlng"] floatValue];
            _playerProfile.purchasePriceLvl = [[res valueForKeyPath:@"results.ppl"] integerValue];
            _playerProfile.purchaseDistanceLvl = [[res valueForKeyPath:@"results.pdl"] integerValue];
            _playerProfile.experienceLimitLvl = [[res valueForKeyPath:@"results.ell"] integerValue];
            _playerProfile.moneyLimitLvl = [[res valueForKeyPath:@"results.mll"] integerValue];
            _playerProfile.experienceQteLvl = [[res valueForKeyPath:@"results.eqfl"] integerValue];
            _playerProfile.alliancePriceLvl = [[res valueForKeyPath:@"results.apl"] integerValue] ;
        
        
        

    }

    
    
    [[self mapView_] clear];
    [self createRects];

    [self initializeProfilePic];
 
}



- (GMSMapView *)mapView_ {
    return mapView_;
}

- (void)setMapView_:(GMSMapView *)newValue {
    mapView_ = newValue;
}

- (NSMutableArray *)territoryList {
    return territoryList;
}

- (void)setTerritoryList:(NSMutableArray *)newValue {
    territoryList = newValue;
}

@end