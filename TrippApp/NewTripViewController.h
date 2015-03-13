//
//  ViewController.h
//  TrippApp
//
//  Created by Chema Leon on 2015-02-03.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "Event.h"

@interface NewTripViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property IBOutletCollection(UIImageView) NSArray* progressImageViews;
@property IBOutlet UISearchBar* searchBar;
@property IBOutlet UIProgressView* progressView;
@property IBOutlet UITableView* cityTableView;
@property IBOutlet UILabel* questionLabel;
@property IBOutlet UIDatePicker* datePicker;
@property IBOutlet UIButton* nextButton;
@property IBOutlet UIButton* positiveButton;
@property IBOutlet UIButton* negativeButton;
@property IBOutlet UIActivityIndicatorView* activityIndicator;
@property NSMutableArray* cityNames;
@property NSMutableArray* filteredCityNames;
@property UITableView* tableView;
@property Trip* theNewTrip;
@property NSDate* tempEventDate;
@property bool makeTextFieldEditable;
@property int progressInt;
@property bool needsToLogEvent;

- (void) dismissModalView;
- (IBAction) triggerNewTripScreenSegue:(id)sender;
- (IBAction) dateChanged:(id)sender;

@end