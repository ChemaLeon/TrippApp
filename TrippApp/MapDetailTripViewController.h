//
//  MapDetailTripViewController.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-19.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>

@interface MapDetailTripViewController : UIViewController

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property MKCoordinateRegion mapRegion;

@end
