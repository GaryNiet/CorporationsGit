//
//  ProfileView.m
//  Corporations
//
//  Created by Gary Nietlispach on 25.12.13.
//  Copyright (c) 2013 Gary Nietlispach. All rights reserved.
//

#import "ProfileView.h"
#import "Player.h"
#import "LeaderBoard.h"

@interface ProfileView ()
@property ViewController* vc;
@property UIAlertView* alert1;
@property UIAlertView* alert2;
@property UIAlertView* alert3;
@property UIAlertView* alert4;
@property UIAlertView* alert5;
@property UIAlertView* alert6;
@property int xpCost;

@end

@implementation ProfileView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (IBAction)leaderBoardButtonPressed:(id)sender {
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    LeaderBoard *lb = [sb instantiateViewControllerWithIdentifier:@"leaderboard"];
    [lb setIdentifier:_vc.getIdentifier];
    
    [self.view addSubview:lb.view];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	[_backButton addTarget:self
               action:@selector(backToMainView)
     forControlEvents:UIControlEventTouchDown];
    
}


- (IBAction)dropPurchasePriceButtonPressed:(id)sender {
    _xpCost = _playerPointer.purchasePriceLvl * _playerPointer.purchasePriceLvl;
    NSLog(@"%d", _xpCost);
    
    
     if(_xpCost<= [_experiencePointsLabel.text intValue])
     {
         NSString* message = [NSString stringWithFormat:@"This action will cost you %dxp and will reduce buying costs by 1.8%%", _xpCost];
         _alert1 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
         [_alert1 show];
     }
     else
     {
         UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough experience" message:@"You do not have enough experience to learn this ability" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
         [alert show];
     }
    
}
- (IBAction)increasePurchaseDistanceButtonPressed:(id)sender {
    _xpCost = _playerPointer.purchaseDistanceLvl * _playerPointer.purchaseDistanceLvl;
    
    if(_xpCost<= [_experiencePointsLabel.text intValue])
    {
        NSString* message = [NSString stringWithFormat:@"This action will cost you %dxp and you will be able to buy territories 20 square further", _xpCost];
        _alert2 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [_alert2 show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough experience" message:@"You do not have enough experience to learn this ability" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)increaseMaxExperienceEarnedQteButtonPressed:(id)sender {
    
    _xpCost = _playerPointer.experienceLimitLvl * _playerPointer.experienceLimitLvl;
    
    
    if(_xpCost<= [_experiencePointsLabel.text intValue])
    {
        NSString* message = [NSString stringWithFormat:@"This action will cost you %dxp and will increase your experience limit by 25", _xpCost];
        _alert3 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [_alert3 show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough experience" message:@"You do not have enough experience to learn this ability" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
}
- (IBAction)increaseMaxMoneyEarnedButtonPressed:(id)sender {
    
    _xpCost = _playerPointer.moneyLimitLvl * _playerPointer.moneyLimitLvl;
    
    
    if(_xpCost<= [_experiencePointsLabel.text intValue])
    {
        NSString* message = [NSString stringWithFormat:@"This action will cost you %dxp and will increase your money limit by 10000", _xpCost];
        _alert4 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [_alert4 show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough experience" message:@"You do not have enough experience to learn this ability" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    
}
- (IBAction)increaseXPQteFoundButtonPressed:(id)sender {
    
    _xpCost = _playerPointer.experienceQteLvl * _playerPointer.experienceQteLvl;
    
    
    if(_xpCost<= [_experiencePointsLabel.text intValue])
    {
        NSString* message = [NSString stringWithFormat:@"This action will cost you %dxp and will increase your earned experience by 2%%", _xpCost];
        _alert5 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [_alert5 show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough experience" message:@"You do not have enough experience to learn this ability" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    
}
- (IBAction)dropAlliancePriceButtonPressed:(id)sender {
    
    _xpCost = _playerPointer.alliancePriceLvl * _playerPointer.alliancePriceLvl;
    
    
    if(_xpCost<= [_experiencePointsLabel.text intValue])
    {
        NSString* message = [NSString stringWithFormat:@"This action will cost you %dxp and alliances will cost you 1.5%% less", _xpCost];
        _alert6 = [[UIAlertView alloc] initWithTitle:@"Are you sure?" message:message delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
        [_alert6 show];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Not enough experience" message:@"You do not have enough experience to learn this ability" delegate:self cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [alert show];
    }
    
}



-(void)backToMainView
{
    [self.view removeFromSuperview];
    [_playerPointer updateDataBase: _xpCost];
    [_vc getProfileFromServer];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)displayInfo:(Player *)player :(ViewController*)parent
{
    _vc = parent;
    _playerPointer = player;
    
    
    NSLog(@"max xp: %d", player.experienceQteLvl);
    NSLog(@"max QTE xp: %d", player.experienceLimitLvl);
    
    [self.rankLabel setText:[NSString stringWithFormat:@"%d", player.rank]];
    [self.revenueLabel setText:[NSString stringWithFormat:@"%d", player.revenue]];
    [self.tripMoneyLabel setText:[NSString stringWithFormat:@"%d", player.totalMoneyEarnedFromTravel]];
    [self.totalGainLabel setText:[NSString stringWithFormat:@"%d", player.totalGain]];
    [self.alliesLabel setText:[NSString stringWithFormat:@"%d", player.allianceCount]];
    [self.territoriesOwnedLabel setText:[NSString stringWithFormat:@"%d", player.territoryCount]];
    [self.experiencePointsLabel setText:[NSString stringWithFormat:@"%d", player.xp]];
    [self.currentMoneyLabel setText:[NSString stringWithFormat:@"%d", player.money]];
    [self.purchasePriceLabel setText:[NSString stringWithFormat:@"%d", player.purchasePriceLvl]];
    [self.purchaseDistanceLabel setText:[NSString stringWithFormat:@"%d", player.purchaseDistanceLvl]];
    [self.maxXPLVLLabel setText:[NSString stringWithFormat:@"%d", player.experienceLimitLvl]];
    [self.maxMoneyLVLLabel setText:[NSString stringWithFormat:@"%d", player.moneyLimitLvl]];
    [self.xpFoundLVLLabel setText:[NSString stringWithFormat:@"%d", player.experienceQteLvl]];
    [self.dropAlliancePriceLabel setText:[NSString stringWithFormat:@"%d", player.alliancePriceLvl]];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 0){
        if(alertView == _alert1)
        {
            
            _playerPointer.purchasePriceLvl +=1;
            _purchasePriceLabel.text = [NSString stringWithFormat: @"%d",_playerPointer.purchasePriceLvl];
            _experiencePointsLabel.text = [NSString stringWithFormat:@"%d",[_experiencePointsLabel.text intValue] - _xpCost];
        }
        if(alertView == _alert2)
        {
            
            _playerPointer.purchaseDistanceLvl +=1;
            _purchaseDistanceLabel.text = [NSString stringWithFormat: @"%d",_playerPointer.purchaseDistanceLvl];
            _experiencePointsLabel.text = [NSString stringWithFormat:@"%d",[_experiencePointsLabel.text intValue] - _xpCost];
        }
        if(alertView == _alert3)
        {
            _playerPointer.experienceLimitLvl +=1;
            _maxXPLVLLabel.text = [NSString stringWithFormat: @"%d",_playerPointer.experienceLimitLvl];
            _experiencePointsLabel.text = [NSString stringWithFormat:@"%d",[_experiencePointsLabel.text intValue] - _xpCost];
        }
        if(alertView == _alert4)
        {
            _playerPointer.moneyLimitLvl +=1;
            _maxMoneyLVLLabel.text = [NSString stringWithFormat: @"%d",_playerPointer.moneyLimitLvl];
            _experiencePointsLabel.text = [NSString stringWithFormat:@"%d",[_experiencePointsLabel.text intValue] - _xpCost];
        }
        if(alertView == _alert5)
        {
            _playerPointer.experienceQteLvl +=1;
            _xpFoundLVLLabel.text = [NSString stringWithFormat: @"%d",_playerPointer.experienceQteLvl];
            _experiencePointsLabel.text = [NSString stringWithFormat:@"%d",[_experiencePointsLabel.text intValue] - _xpCost];
        }
        if(alertView == _alert6)
        {
            _playerPointer.alliancePriceLvl +=1;
            _dropAlliancePriceLabel.text = [NSString stringWithFormat: @"%d",_playerPointer.alliancePriceLvl];
            _experiencePointsLabel.text = [NSString stringWithFormat:@"%d",[_experiencePointsLabel.text intValue] - _xpCost];
        }
    }
}


@end
