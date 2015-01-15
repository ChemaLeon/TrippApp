//
//  DetailTripViewController.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "DetailTripViewController.h"
#import "TripDetailTableViewCell.h"

@interface DetailTripViewController ()

@end

@implementation DetailTripViewController

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"tripDetailTableCell";
    TripDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.locationNameLabel.text = [_trip.events[[indexPath row]] locationName];
    cell.eventDescriptionLabel.text = [_trip.events[[indexPath row]] details];
    cell.hourLabel.text = [_trip.events[[indexPath row]] hourOfEvent];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _trip.events.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated {
    CLLocationCoordinate2D targetLocation;
    targetLocation.latitude = [_trip.locationCoordinates.latitude doubleValue];
    targetLocation.longitude = [_trip.locationCoordinates.longitude doubleValue];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(targetLocation, 20000, 20000);
    [_mapView setRegion:viewRegion animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
