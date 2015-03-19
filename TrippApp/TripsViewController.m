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
#import "Trip.h"
#import "UrlRequester.h"
#import "NewTripViewController.h"
#import "APIServiceManager.h"
#import "GlobalsManager.h"
#import "DateHelper.h"
#import "BackGroundManager.h"

NSString *const getTrips = @"getTrips";

@implementation TripsViewController

NSMutableArray* trips;
NSIndexPath* prevCell;

#pragma mark LifeCycle

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initializeNotifications];
    NSString* key = [GlobalsManager sharedInstance].userKey;
    [APIServiceManager getTripsFromUser: key withObserver:getTrips];
    _notripLayer.hidden = YES;
   
    _top_view.backgroundColor = [UIColor colorWithRed:33/255.0 green:134/255.0 blue:193/255.0 alpha:0.7];
    //self.tableView.backgroundColor = [UIColor clearColor];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];    
    [_tableView setBounces:NO];
    
//    self.imgView.image = [BackGroundManager getBGImage];
    self.imgView.image = [UIImage imageNamed:@"vancouver"];

    
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
    static NSString *cellIdentifier = @"tripTableCell";
    
    
    TripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tripTitleLabel.text = [trips[[indexPath row]] city_name];
   // cell.tripDetailLabel.text = [trips[[indexPath row]] country_name];
    cell.tripDateLabel.text = [DateHelper formatStrDatetoShow:[trips[[indexPath row]] date_arrival]];

    //cell.backgroundColor = [UIColor clearColor];
    cell.contentView.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:0.8];
    
    return cell;
}

// This function lets the device know how many rows are we filling out on the Table View.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return trips.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71.0f;
}

// When the user taps on an element of the Table View, update the UI Navigation Item of the destination View Controller with the name of the trip. Finally, Pass on the Trip object from the trips NSArray to the destination View Controller.
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showTripDetails"]) {
        DetailTripViewController *detailViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        detailViewController.detailUINavItem.title = [trips[[indexPath row]] city_name];
        detailViewController.trip = trips[[indexPath row]];
    }
}

- (void) newTripButtonPressed {
    [self performSegueWithIdentifier:@"showNewTrip" sender:self];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    _trip_city.text = [trips[[indexPath row]] city_name];
    _arrival_date.text = [DateHelper formatStrDatetoShow:[trips[[indexPath row]] date_arrival]];
    _departure_date.text = [DateHelper formatStrDatetoShow:[trips[[indexPath row]] date_departure]];
    
    if(prevCell != nil)
    {
        [tableView cellForRowAtIndexPath:prevCell].contentView.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:0.8];
    }
    
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    cell.contentView.backgroundColor = [UIColor colorWithRed:88/255.0 green:88/255.0 blue:88/255.0 alpha:1.0];
    
    prevCell = indexPath;
    
    //    _number_meetings.text = [trips[[indexPath row]] city_name];
    
}

- (IBAction)seeTripDetails:(id)sender {

    NSLog(@"Click new trip");
    [self performSegueWithIdentifier:@"showTripDetails" sender:self];
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
        
        if(trips.count > 0)
        {
            _notripLayer.hidden = YES;
            [self.tableView reloadData];
            if(((NSIndexPath*)[[_tableView indexPathsForVisibleRows] lastObject]).row > 0)
            {
                NSIndexPath *indexPath=[NSIndexPath indexPathForRow:1 inSection:0];
                [self.tableView selectRowAtIndexPath:indexPath
                                            animated:NO
                                      scrollPosition:UITableViewScrollPositionNone];
                [[self.tableView delegate] tableView:self.tableView didSelectRowAtIndexPath:indexPath];
            }
            else
            {
                _trip_city.text = [trips[0] city_name];
                _arrival_date.text = [DateHelper formatStrDatetoShow:[trips[0] date_arrival]];
                _departure_date.text = [DateHelper formatStrDatetoShow:[trips[0] date_departure]];
            }
        }
        else
        {
            _notripLayer.hidden = NO;
            [self newTripButtonPressed];
        }
    }
    
}

@end
