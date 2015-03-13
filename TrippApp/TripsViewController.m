//
//  TripsViewController.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "TripsViewController.h"
#import "TripTableViewCell.h"
#import "DetailTripViewController.h"
#import "DataModel.h"
#import "Trip.h"
#import "UrlRequester.h"
#import "NewTripViewController.h"
#import "APIServiceManager.h"
#import "GlobalsManager.h"
//#import "BackGroundManager.h"

NSString *const getTrips = @"getTrips";

@implementation TripsViewController

NSMutableArray* trips;

#pragma mark LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeNotifications];
    NSString* key = [GlobalsManager sharedInstance].userKey;
    [APIServiceManager getTripsFromUser: key withObserver:getTrips];
    self.tableView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];


    //self.imgView.image = [BackGroundManager getBGImage];
    
    // changing the unselected image color, you should change the selected image
    // color if you want them to be different
    
    self.tabBarItem.image = [[UIImage imageNamed:@"Trips"]
                             imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];

    //trips = [DataModel getAllTrips];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTripButtonPressed)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark TableView

// Update every cell in the Table View with the appropiate data from the 'trips' NSArray. Make an instance of the TripTableViewCell class and populate its properties.
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"tripTableCell";
    TripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tripTitleLabel.text = [trips[[indexPath row]] city_name];
    cell.tripDetailLabel.text = [trips[[indexPath row]] country_name];
    cell.tripDateLabel.text = [trips[[indexPath row]] date_arrival];

    cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor clearColor];
    UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(5,5,cell.frame.size.width-10,cell.frame.size.height-10)];
    whiteRoundedCornerView.layer.masksToBounds = NO;
    whiteRoundedCornerView.layer.cornerRadius = 3.0;
    whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    whiteRoundedCornerView.layer.shadowOpacity = 0.3;
    whiteRoundedCornerView.layer.borderColor = [[UIColor blackColor] CGColor];
    whiteRoundedCornerView.layer.borderWidth = 0.5f;
    whiteRoundedCornerView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.8];
    [cell.contentView addSubview:whiteRoundedCornerView];
    [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
    
    return cell;
}

// This function lets the device know how many rows are we filling out on the Table View.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return trips.count;
}

// When the user taps on an element of the Table View, update the UI Navigation Item of the destination View Controller with the name of the trip. Finally, Pass on the Trip object from the trips NSArray to the destination View Controller.
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showTripDetails"]) {
        DetailTripViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailViewController.detailUINavItem.title = [trips[[indexPath row]] locationName];
        detailViewController.trip = trips[[indexPath row]];
    } else if ([[segue identifier] isEqualToString:@"showTripDetails"]) {
        
    }
}

- (void) newTripButtonPressed {
    [self performSegueWithIdentifier:@"showNewTrip" sender:self];
    //[UrlRequester GetJsonObjectsFrom:@"http://trippapp-salsastudio.rhcloud.com/profile/newUser/" WithCallback:@selector(finishedCall:) FromSource:self];
}

// Populate the NSArray of the trip data with the MockDataModel class. A temporal encapsulation of the Trips that the mock user has created on the device.


- (void) finishedCall:(NSArray*)jsonArray {
    for (int i = 0; i < jsonArray.count; i++) {
        //NSLog(@"Received: %@", [[jsonArray objectAtIndex:i] objectForKey:@"key"] );
        //NSLog(@"Received: %@", jsonArray[i]);
    }
    NSLog(@"Received: %@", jsonArray);
}



#pragma mark Notifications

- (void) initializeNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTripsNotification:) name:getTrips object:nil];
    
}

-(void) receivedTripsNotification:(NSNotification*) notification
{
    NSLog(@"Trip Man Controller");
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        trips = [theData objectForKey:@"trips"];
        [self.tableView reloadData];
    }
    
}

@end
