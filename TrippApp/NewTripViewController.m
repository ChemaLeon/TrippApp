//
//  ViewController.m
//  TrippApp
//
//  Created by Chema Leon on 2015-02-03.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "NewTripViewController.h"
#import "NewTripTableViewCell.h"
#import "Trip.h"

@interface NewTripViewController ()

@end

@implementation NewTripViewController

-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

-(void)dismissModalView {
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.searchBar.delegate = self;
    self.cityNames = [NSMutableArray array];
    [self updateProgressTo:self.progressInt];
    
    switch (self.progressInt) {
        case 0:
            self.questionLabel.text = @"What city are you visiting?";
            self.makeTextFieldEditable = YES;
            self.theNewTrip = [[Trip alloc] initEmpty];
            break;
        case 1:
            self.questionLabel.text = @"When are you arriving to your destination?";
            self.makeTextFieldEditable = NO;
            self.searchBar.placeholder = @"Arrival Time";
            
            break;
        case 2:
            self.questionLabel.text = @"When are you departing back from your destination?";
            self.makeTextFieldEditable = NO;
            self.searchBar.placeholder = @"Departure Time";
            [self.datePicker setMinimumDate:self.theNewTrip.arrivalDate];
            break;
        case 3:
            self.questionLabel.text = @"Where are you arriving to?";
            self.makeTextFieldEditable = YES;
            self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
            self.searchBar.returnKeyType = UIReturnKeyGo;
            //[self.searchBar reloadInputViews];
            self.searchBar.placeholder = @"e.g. 88 Pender St. or YVR Intl Airport";
            break;
        case 4:
            self.questionLabel.text = @"Where are you departing from?";
            self.makeTextFieldEditable = YES;
            break;
        case 5:
            self.questionLabel.text = @"Is there something else scheduled for your trip?";
            self.makeTextFieldEditable = NO;
            break;
        default:
            break;
    }
    
    [self.cityNames addObject:@"Vancouver, BC"];
    [self.cityNames addObject:@"Chicago, IL"];
    [self.cityNames addObject:@"Orlando, FL"];
    
    self.searchBar.viewForBaselineLayout.userInteractionEnabled = self.makeTextFieldEditable;
    self.datePicker.viewForBaselineLayout.hidden = self.makeTextFieldEditable;
    self.nextButton.hidden = self.makeTextFieldEditable;
    
    if (self.progressInt < 1) {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalView)];
    }
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    if (self.makeTextFieldEditable) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void)updateProgressTo:(int)progress {
    if (progress > 4) {
        progress = 4;
    }
    self.progressView.progress = progress/4.0;
    ((UIImageView*)self.progressImageViews[progress]).image =[UIImage imageNamed:@"Circle_Selected"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"nextScreenNewTrip"]) {
        //Save data to new trip before continuing depending on which screen we are currently in
        [self saveDataToTripObject];
        
        NewTripViewController *nextScreen = segue.destinationViewController;
        int nextProgressInt = self.progressInt + 1;
        if (nextProgressInt > 5) {
            nextScreen.progressInt = 5;
        } else {
            nextScreen.progressInt = self.progressInt + 1;
        }
        nextScreen.theNewTrip = self.theNewTrip;
    }
}

-(IBAction)triggerNewTripScreenSegue:(id)sender
{
    [self performSegueWithIdentifier: @"nextScreenNewTrip" sender: self];
}

-(IBAction) dateChanged:(id)sender
{
    NSDate *date = self.datePicker.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy hh:mm a"];
    self.searchBar.placeholder = [df stringFromDate:date];
}

-(void) saveDataToTripObject {
    switch (self.progressInt) {
        case 0:
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            self.theNewTrip.locationName = [self.filteredCityNames objectAtIndex:[indexPath row]];
        }
            break;
        case 1:
            self.theNewTrip.arrivalDate = self.datePicker.date;
            break;
        case 2:
            self.theNewTrip.departureDate = self.datePicker.date;
            break;
        case 3:
            self.theNewTrip.arrivalLocation = self.searchBar.text;
            break;
        case 4:
            self.theNewTrip.departureLocation = self.searchBar.text;
            break;
        case 5:
            break;
        default:
            break;
    }
}

#pragma mark UITableViewDelegate & UITableDataSource functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    self.tableView = tableView;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.filteredCityNames.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CityCell";
    NewTripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];

    // Configure the cell...
    cell.viewForBaselineLayout.backgroundColor = [UIColor colorWithRed:0.773f green:0.761f blue:0.722f alpha:1.00f];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor lightGrayColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    cell.cityNameLabel.text = [self.filteredCityNames objectAtIndex:indexPath.row];
    return cell;
}

#pragma mark UISearchBarDelegate functions

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.progressInt == 0) {
        self.filteredCityNames = [NSMutableArray array];
        for (int i = 0; i < self.cityNames.count; i++) {
            if ([((NSString*)self.cityNames[i]) rangeOfString:searchText].location == NSNotFound) {
                //string does not contain range
                [self.tableView reloadData];
            } else {
                //string does contain range
                [self.filteredCityNames addObject:self.cityNames[i]];
                [self.tableView reloadData];
            }
        }
    }
    if (self.filteredCityNames.count > 0) {
        self.tableView.hidden = NO;
    } else {
        self.tableView.hidden = YES;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self performSegueWithIdentifier: @"nextScreenNewTrip" sender: self];
}

@end
