//
//  TripsViewController.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIImageView *imgView;
@property (weak, nonatomic) IBOutlet UIView *top_view;
@property (weak, nonatomic) IBOutlet UIView *notripLayer;

    //trip info
@property (weak, nonatomic) IBOutlet UILabel *trip_city;
@property (weak, nonatomic) IBOutlet UILabel *arrival_date;
@property (weak, nonatomic) IBOutlet UILabel *departure_date;
@property (weak, nonatomic) IBOutlet UILabel *number_meetings;

@end

