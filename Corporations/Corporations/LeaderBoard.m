//
//  LeaderBoard.m
//  Corporations
//
//  Created by Gary Nietlispach on 20.01.14.
//  Copyright (c) 2014 Gary Nietlispach. All rights reserved.
//

#import "LeaderBoard.h"

@interface LeaderBoard ()

@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic)  NSString* identifier;
@property NSURLConnection* leaderBoardConnection;
@property (nonatomic, retain)NSMutableArray* result;
@property NSString* test;

@end

@implementation LeaderBoard
{
    NSMutableArray* tableData;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    
    
    [super viewDidLoad];
    
    self.responseData = [NSMutableData data];
    _result = [[NSMutableArray alloc] init];
    tableData = [[NSMutableArray alloc] init];

    NSString* getLeaderBoardURL = @"https://corporation-perezapp.rhcloud.com/api.php?what=leaderboard&identifier=";
    getLeaderBoardURL = [getLeaderBoardURL stringByAppendingString:self.identifier];
    getLeaderBoardURL = [getLeaderBoardURL stringByAppendingString:@"&start=1"];
    getLeaderBoardURL = [getLeaderBoardURL stringByAppendingString:@"&limit=1"];
    
    NSURLRequest *leaderBoardRequest = [NSURLRequest requestWithURL: [NSURL URLWithString:getLeaderBoardURL]];
    NSLog(getLeaderBoardURL);
    _leaderBoardConnection =[[NSURLConnection alloc] initWithRequest:leaderBoardRequest delegate:self];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
- (IBAction)backButtonPressed:(id)sender
{
    [self.view removeFromSuperview];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [_result count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell=[self.tableView cellForRowAtIndexPath:indexPath];
    if(cell==nil){
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }

    
    cell.textLabel.text= [tableData objectAtIndex: indexPath.row];
    
    return cell;
}

-(void)setIdentifier:(NSString *)id
{
    _identifier = id;
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

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"connectionDidFinishLoading");
    NSLog(@"Succeeded! Received %lu bytes of data",(unsigned long)[self.responseData length]);
    
    // convert to JSON
    NSError *myError = nil;
    NSDictionary *res = [NSJSONSerialization JSONObjectWithData:self.responseData options:NSJSONReadingMutableLeaves error:&myError];
    _result = [res objectForKey:@"results"];
    
    for(id key in _result)
    {
        _test = (NSString*)[key objectForKey:@"id"];
        [tableData addObject:_test];
    }
    
    [self.tableView reloadData];
    
}




@end
