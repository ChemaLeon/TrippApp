//
//  DetailTripViewController.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <MBXMapKit/MBXMapKit.h>
#import "UIMapTableView.h"
#import "Trip.h"
#import "Event.h"

@interface DetailTripViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MKMapViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *detailUINavItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIMapTableView *tableView;
@property Trip* trip;

@end