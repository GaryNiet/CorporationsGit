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

@interface ViewController ()<GMSMapViewDelegate>
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
@property double squareSize;
@property NSMutableArray* territoryList;

@end

@implementation ViewController{
    GMSMapView *mapView_;
    GMSCameraPosition *camera;
    
    
}
@synthesize profilePictureView = _profilePictureView;
@synthesize responseData = _responseData;

- (void)createRects:(GMSCameraPosition *)camera {
    
    
    
    self.rectTab = [NSMutableArray array];
    int latitude = (int)mapView_.camera.target.latitude;
    int longitude = (int)mapView_.camera.target.longitude;
    
    
    
    for(Territory *territory in _territoryList)
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
                if(territory.isAllied == true)
                {
                polygon.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:0.15];
                }
                else
                {
                    polygon.fillColor = [UIColor colorWithRed:0 green:1 blue:0 alpha:0.15];
                }
                polygon.strokeColor = [UIColor blackColor];
                polygon.strokeWidth = 2;
                polygon.map = mapView_;
                
            }
        }

    }

}

- (void)loadView {
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.s
    camera = [GMSCameraPosition cameraWithLatitude:47.048878
                                         longitude:6.816487
                                              zoom:9];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.myLocationEnabled = YES;
    mapView_.delegate = self;
    self.view = mapView_;
    self.isJustMap = true;
    self.sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.hf = [self.sb instantiateViewControllerWithIdentifier:@"halfView"];
     
    self.profileViewController = [self.sb instantiateViewControllerWithIdentifier: @"profileView"];
    self.squareSize = 0.01;
    self.territoryList = [[NSMutableArray alloc] init];
    
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
         
         
         
         
     }];
    
    
    

    
    
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

- (void) mapView: (GMSMapView *) mapView  didTapOverlay: (GMSPolygon *) overlay
{
    
    
    
    if(self.isJustMap == true)
    {
        
        [self.view addSubview:self.hf.view];
        self.isJustMap = false;
    }
    else if(self.isJustMap == false && overlay == self.shownOverlay)
    {
        [self.hf.view removeFromSuperview];
        self.isJustMap = true;
    }
    else
    {
        
        NSLog(@"update overlay");
    }
    self.shownOverlay = overlay;
    
}

- (void) mapView: (GMSMapView *) mapView  didTapAtCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSLog(@"latitude: %f", coordinate.latitude);
    NSLog(@"longitude: %f", coordinate.longitude);
    
    
    //NSDictionary *result = (NSDictionary*)[_terri objectForKey:@"results"];
    
    
    for(Territory *territory in _territoryList)
    {
        if([territory isInBounds:coordinate.latitude :coordinate.longitude ])
        {
            //territory.isAllied = true;
            [self.hf setAttr:territory.revenue :territory.latitude :territory.longitude :territory.revenue :territory.ownerID];
            
            
        }
    }

    
    
    if(self.isJustMap == true)
    {
        
        [self.view addSubview:self.hf.view];
        [self.hf setID:_identifier];
        self.isJustMap = false;
        
    }
    else
    {
        [self.hf.view removeFromSuperview];
        self.isJustMap = true;
    }
    
    [mapView_ clear];
    [self createRects:camera];
    
    
    

    
    
    
    
}


- (void)mapView:(GMSMapView *)mapView didChangeCameraPosition:(GMSCameraPosition *)position
{
    [mapView_ clear];
    [self createRects:camera];
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
            
            //NSLog(@"lat: %@ , long: %@", latitudeAsString, longitudeAsString);
            
            
//            Territory *newTerritory = [[Territory alloc]initWithCoords:[latitudeAsString floatValue] :[longitudeAsString floatValue] :(float)_squareSize];
//            [_territoryList addObject:newTerritory];
            [_territoryList addObject:[[Territory alloc]initWithCoords:[latitudeAsString floatValue] :[longitudeAsString floatValue] :(float)_squareSize :[isAlliedAsString intValue] :[revenueAsString intValue] :userIdAsString]];
        }

        
    
    }

    
    [mapView_ clear];
    [self createRects:camera];
    
    
    
    [self initializeProfilePic];

    

    
}



@end