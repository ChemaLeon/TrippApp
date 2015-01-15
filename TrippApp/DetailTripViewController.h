//
//  DetailTripViewController.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Trip.h"
#import "Event.h"

@interface DetailTripViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UINavigationItem *detailUINavItem;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property Trip* trip;

@end