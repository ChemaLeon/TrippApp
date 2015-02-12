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

@implementation TripsViewController

NSArray* trips;

// Update every cell in the Table View with the appropiate data from the 'trips' NSArray. Make an instance of the TripTableViewCell class and populate its properties.
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"tripTableCell";
    TripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tripTitleLabel.text = [trips[[indexPath row]] locationName];
    cell.tripDetailLabel.text = [trips[[indexPath row]] details];
    cell.tripDateLabel.text = [DataModel nsdateToNstring:[trips[[indexPath row]] arrivalDate]];
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
- (void)viewDidLoad {
    [super viewDidLoad];
    trips = [DataModel getAllTrips];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTripButtonPressed)];
}

- (void) finishedCall:(NSArray*)jsonArray {
    for (int i = 0; i < jsonArray.count; i++) {
        //NSLog(@"Received: %@", [[jsonArray objectAtIndex:i] objectForKey:@"key"] );
        //NSLog(@"Received: %@", jsonArray[i]);
    }
    NSLog(@"Received: %@", jsonArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
