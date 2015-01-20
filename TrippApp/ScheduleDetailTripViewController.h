//
//  ScheduleDetailTripViewController.h
//  TrippApp
//
//  Created by Chema Leon on 2015-01-19.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "Event.h"

@interface ScheduleDetailTripViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property Trip* trip;

@end