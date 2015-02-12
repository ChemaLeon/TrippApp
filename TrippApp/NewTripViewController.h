//
//  ViewController.h
//  TrippApp
//
//  Created by Chema Leon on 2015-02-03.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface NewTripViewController : UIViewController <UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (weak, nonatomic) IBOutlet UIProgressView* progressView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *progressImageViews;
@property (nonatomic, strong) IBOutlet UITableView* cityTableView;
@property int progressInt;
@property (nonatomic, strong) NSMutableArray* cityNames;
@property (nonatomic, strong) NSMutableArray* filteredCityNames;
@property (nonatomic, strong) UITableView* tableView;
@property (weak, nonatomic) IBOutlet UILabel* questionLabel;
@property bool makeTextFieldEditable;
@property (weak, nonatomic) IBOutlet UIDatePicker* datePicker;
@property (weak, nonatomic) IBOutlet UIButton* nextButton;
@property Trip* theNewTrip;

-(void)dismissModalView;
-(IBAction)triggerNewTripScreenSegue:(id)sender;
-(IBAction) dateChanged:(id)sender;

@end