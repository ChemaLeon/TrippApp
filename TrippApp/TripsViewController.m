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
#import "MockDataModel.h"
#import "Trip.h"

@implementation TripsViewController

NSArray* trips;

// Update every cell in the Table View with the appropiate data from the 'trips' NSArray. Make an instance of the TripTableViewCell class and populate its properties.
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"tripTableCell";
    TripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.tripTitleLabel.text = [trips[[indexPath row]] locationName];
    cell.tripDetailLabel.text = [trips[[indexPath row]] details];
    cell.tripDateLabel.text = [trips[[indexPath row]] dateOfTrip];
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
    }
}

- (void) newTripButtonPressed {
    NSLog(@"New Trip Button Pressed");
}

// Populate the NSArray of the trip data with the MockDataModel class. A temporal encapsulation of the Trips that the mock user has created on the device.
- (void)viewDidLoad {
    [super viewDidLoad];
    trips = [MockDataModel GetAllTrips];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(newTripButtonPressed)];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
