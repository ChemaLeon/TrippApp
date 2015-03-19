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
#import "City.h"
#import "Event.h"
#import "GlobalsManager.h"
#import "DateHelper.h"
#import "LocationHelper.h"
#import "APIServiceManager.h"

@interface NewTripViewController ()

@end

@implementation NewTripViewController

int progressSteps = 5;                                  // The amount of screens the questionaire should show.
int nextProgressInt;                                    // Update next progress int and validate it.
bool processedLocation = false;

NSString *const createNewTrip = @"createNewTrip";


- (void) dismissModalView {                             // Close questionaire and return to Trip Management.
    [self dismissViewControllerAnimated:YES completion:nil];
    //[self.navigationController popViewControllerAnimated:YES];
}

- (void) viewDidLoad {                                  // Do any additional setup after loading the view.
    [super viewDidLoad];
    
    // Delegates setup
    self.searchBar.delegate = self;
    
    // Override Back button to say 'Back' instead of the previous View Controller's title.
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:nil action:nil];
    
    // Override default's Title color and Status Bar to white.
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    // Tag subviews.
    self.positiveButton.tag = 1;
    self.negativeButton.tag = 2;
    
    //Get Cities
    self.cities = [GlobalsManager sharedInstance].cities;
    
    // Update all UI Elements and Subviews to reflect the current progress of the questionare.
    switch (self.progressInt) {
        case 0:
            self.questionLabel.text = @"What city are you going?";
            self.makeTextFieldEditable = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = YES;
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            self.theNewTrip = [[Trip alloc] init];
            _theNewTrip.trip_events = [[NSMutableArray alloc] init];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalView)];
            [self updateProgressTo:self.progressInt];
            break;
        case 1:
            self.questionLabel.text = [@"When are you arriving to " stringByAppendingString:[_theNewTrip.city_name stringByAppendingString:@" ?"]];
            self.makeTextFieldEditable = NO;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = NO;
            self.searchBar.placeholder = @"Arrival Time";
            self.datePicker.viewForBaselineLayout.hidden = NO;
            self.nextButton.hidden = NO;
            [self updateProgressTo:self.progressInt];
            break;
        case 2:
            self.questionLabel.text = [@"When are you departing from " stringByAppendingString:[_theNewTrip.city_name stringByAppendingString:@" ?"]];
            self.makeTextFieldEditable = NO;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = NO;
            self.searchBar.placeholder = @"Departure Time";
            self.datePicker.viewForBaselineLayout.hidden = NO;
            self.nextButton.hidden = NO;
            [self.datePicker setMinimumDate:[[DateHelper convertStrToDate:self.theNewTrip.date_arrival] dateByAddingTimeInterval:60*60*4]];
            [self updateProgressTo:self.progressInt];
            break;
        case 3:
             break;
        case 4:
            self.questionLabel.text = @"Please give your Meeting an Identifier";
            self.makeTextFieldEditable = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = YES;
            self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
            self.searchBar.returnKeyType = UIReturnKeyGo;
            self.searchBar.placeholder = @"e.g. Staff Interview";
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            [self updateProgressTo:4];
             break;
        case 5:
            self.questionLabel.text = @"Is there any appointments or meetings scheduled for your trip?";
            self.makeTextFieldEditable = NO;
            self.searchBar.viewForBaselineLayout.hidden = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = NO;
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            self.positiveButton.hidden = NO;
            self.negativeButton.hidden = NO;
            [self updateProgressTo:4];
            break;
        case 6: // Hotel
            self.questionLabel.text = @"What is your hotel address?";
            self.makeTextFieldEditable = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = YES;
            self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
            self.searchBar.returnKeyType = UIReturnKeyGo;
            self.searchBar.placeholder = @"e.g. 845 Hornby St";
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            [self updateProgressTo:3];
            break;
        case 7:
            self.questionLabel.text = @"When is your meeting?";
            self.makeTextFieldEditable = NO;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = NO;
            self.searchBar.placeholder = @"Meeting time";
            self.datePicker.viewForBaselineLayout.hidden = NO;
            self.nextButton.hidden = NO;
            [self.datePicker setMinimumDate:[DateHelper convertStrToDate:self.theNewTrip.date_arrival]];
            [self.datePicker setMaximumDate:[DateHelper convertStrToDate:self.theNewTrip.date_departure]];
            [self updateProgressTo:4];
            break;
        case 8:
            self.questionLabel.text = @"Where is your meeting?";
            self.makeTextFieldEditable = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = YES;
            self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
            self.searchBar.returnKeyType = UIReturnKeyGo;
            self.searchBar.placeholder = @"e.g. 701 West Georgia Street";
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            [self updateProgressTo:4];
            break;
        case 9: // End
        {
            self.activityIndicator.hidden = NO;
            [self.activityIndicator startAnimating];
            self.questionLabel.text = @"Generating your trip...";
            self.makeTextFieldEditable = NO;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = NO;
            self.searchBar.viewForBaselineLayout.hidden = YES;
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            [self updateProgressTo:5];
            //[self performSelector:@selector(dismissModalView) withObject:nil afterDelay:3.0];
//            NSMutableString* tripdetails = [NSMutableString stringWithString:self.theNewTrip.locationName];
//            [tripdetails appendString:@"'s Trip"];
//            self.theNewTrip.details = tripdetails;
//            [DataModel AddTrip:self.theNewTrip];
            [self initializeNotifications];
            [APIServiceManager createNewTrip:_theNewTrip forUser:[GlobalsManager sharedInstance].userKey withObserver:createNewTrip];
            
        }
            break;
        default:
            break;
    }
    
    // TODO: Update the city list population from server side.

}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.needsToLogEvent = NO;
    
    // Whenever there's a text field show the Keyboard so the user knows to write information.
    if (self.makeTextFieldEditable) {
        [self.searchBar becomeFirstResponder];
    }
}

- (void) saveDataToTripObject {
    // Update our trip object with the corresponding information from the user.
    switch (self.progressInt) {
        case 0:
        {
            NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
            self.theNewTrip.city_id = [[self.filteredCities objectAtIndex:[indexPath row]] city_id];
            self.theNewTrip.city_name = [[self.filteredCities objectAtIndex:[indexPath row]] city_name];
            
            self.theNewTrip.lat_arrival = [[self.filteredCities objectAtIndex:[indexPath row]] lat_airport];
            self.theNewTrip.lng_arrival = [[self.filteredCities objectAtIndex:[indexPath row]] lng_airport];
            
            self.theNewTrip.lat_departure = [[self.filteredCities objectAtIndex:[indexPath row]] lat_airport];
            self.theNewTrip.lng_departure = [[self.filteredCities objectAtIndex:[indexPath row]] lng_airport];
            
            nextProgressInt = 1;
        }
            break;
        case 1:
            self.theNewTrip.date_arrival = [DateHelper convertDateToStr:self.datePicker.date];
            nextProgressInt = 2;
            break;
        case 2:
        {
            self.theNewTrip.date_departure = [DateHelper convertDateToStr:self.datePicker.date];
            
            // Check to see if user is staying for more than a day. (Day Changed or +15 hours (54,000 seconds) of difference)
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *arrivalDay = [dateFormatter stringFromDate:[DateHelper convertStrToDate:_theNewTrip.date_arrival]];
            NSString *departureDay = [dateFormatter stringFromDate:[DateHelper convertStrToDate:_theNewTrip.date_departure]];
            
            NSTimeInterval totalTimeinSeconds = [[DateHelper convertStrToDate:_theNewTrip.date_arrival] timeIntervalSinceDate:[DateHelper convertStrToDate:_theNewTrip.date_departure]];
            //NSLog(@"DIFF: From: %@ to: %@. Seconds: %f", arrivalDay, departureDay, totalTimeinSeconds);
            if (![arrivalDay isEqualToString:departureDay] || totalTimeinSeconds > 54000.0)
            {
                // Get a hotel
                nextProgressInt = 6;
            } else {
                // Skip the hotel
                nextProgressInt = 5;
            }
        }
            break;
        case 3:
            //self.theNewTrip.arrivalLocation = self.searchBar.text;
            nextProgressInt = 4;
            break;
        case 4:
            _tempEventName = self.searchBar.text;
            nextProgressInt = 7;
            break;
        case 5:
            // Check to see if user has any meetings scheduled
            if (self.needsToLogEvent) {
                nextProgressInt = 4;
            } else {
                nextProgressInt = 9;
            }
            break;
        case 6:
        {
            NSString *hotelAddress = self.searchBar.text;
            NSString *fullAddress = [NSString stringWithFormat:@"%@, %@", hotelAddress, _theNewTrip.city_name];
                
            CLLocationCoordinate2D location = [LocationHelper getLocationFromAddressString:fullAddress];
            
            NSNumber *lat = [NSNumber numberWithDouble:location.latitude];
            NSNumber *lng = [NSNumber numberWithDouble:location.longitude];
            
            _theNewTrip.lat_hotel = [lat stringValue];
            _theNewTrip.lng_hotel = [lng stringValue];
            
            nextProgressInt = 5;

            break;
        }
        case 7: // When (Meeting)
            self.tempEventDate = self.datePicker.date;
            nextProgressInt = 8;
            break;
        case 8: // Where (Meeting)
        {
            Event* newEvent = [Event alloc];
            
            newEvent.name = _tempEventName;
            
            NSString *meetingAddress = self.searchBar.text;
            NSString *fullAddress = [NSString stringWithFormat:@"%@, %@", meetingAddress, _theNewTrip.city_name];
            
            CLLocationCoordinate2D location = [LocationHelper getLocationFromAddressString:fullAddress];
            
            NSNumber *lat = [NSNumber numberWithDouble:location.latitude];
            NSNumber *lng = [NSNumber numberWithDouble:location.longitude];
            
            newEvent.lat = [lat stringValue];
            newEvent.lng = [lng stringValue];
            
            newEvent.begin_date_time =  [DateHelper convertDateToStr:self.tempEventDate];
            newEvent.end_date_time =  [DateHelper convertDateToStr:self.tempEventDate];

            //[self.theNewTrip.trip_events addObject: newEvent];                  //Add Event to trip
            [_theNewTrip.trip_events addObject:newEvent];
            nextProgressInt = 5;
        }
            break;
        case 9: // End
            break;
        default:
            break;
    }
}

- (void) updateProgressTo:(int)progress {
    if (progress > 4) {
        progress = 4;
    }
    self.progressView.progress = (float)progress/(float)(4);
    ((UIImageView*)self.progressImageViews[progress]).image =[UIImage imageNamed:@"Circle_Selected"];
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"nextScreenNewTrip"]) {
        [self saveDataToTripObject];                                            // Save data to new trip object and define next progress int.
        NewTripViewController *nextScreen = segue.destinationViewController;    // Get reference to next screen.
        nextScreen.progressInt = nextProgressInt;
        nextScreen.theNewTrip = self.theNewTrip;                                // Pass on the reference to the trip object.
        nextScreen.tempEventDate = self.tempEventDate;
        nextScreen.tempEventName = self.tempEventName;
        nextScreen.needsToLogEvent = self.needsToLogEvent;
    }
}

#pragma mark IB Actions

- (IBAction) triggerNewTripScreenSegue:(id)sender {                             // Go to the next screen.
    //NSLog(@"Tag: %tu",((UIButton*)sender).tag);
    if (((UIButton*)sender).tag == 1) {
        self.needsToLogEvent = YES;
    }
    [self performSegueWithIdentifier: @"nextScreenNewTrip" sender: sender];
}

- (IBAction) dateChanged:(id)sender {                                           // Update Search Bar subview with Date Picker's date.
    NSDate *date = self.datePicker.date;
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd/MM/yyyy hh:mm a"];
    self.searchBar.placeholder = [df stringFromDate:date];
}

#pragma mark Delegate & Prototype Functions

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    self.tableView = tableView;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return self.filteredCities.count;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"CityCell";
    NewTripTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    cell.viewForBaselineLayout.backgroundColor = [UIColor colorWithRed:0.773f green:0.761f blue:0.722f alpha:1.00f];
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor lightGrayColor];
    [cell setSelectedBackgroundView:bgColorView];
    
    cell.cityNameLabel.text = [[self.filteredCities objectAtIndex:indexPath.row] city_name];
    return cell;
}

- (void) searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (self.progressInt == 0) {
        self.filteredCities = [NSMutableArray array];
        for (int i = 0; i < self.cities.count; i++) {
            if ([[[_cities objectAtIndex:i] city_name] rangeOfString:searchText].location == NSNotFound) {
                //string does not contain range
                [self.tableView reloadData];
            } else {
                //string does contain range
                [self.filteredCities addObject:[_cities objectAtIndex:i]];
                [self.tableView reloadData];
            }
        }
    }
    if (self.filteredCities.count > 0) {
        self.tableView.hidden = NO;
    } else {
        self.tableView.hidden = YES;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [self performSegueWithIdentifier: @"nextScreenNewTrip" sender: self];

}

- (void) initializeNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNewTripNotification:) name:createNewTrip object:nil];
    
}

-(void) receivedNewTripNotification:(NSNotification*) notification
{

    NSString* key = [GlobalsManager sharedInstance].userKey;
    [APIServiceManager getTripsFromUser: key withObserver:@"getTrips"];
    [self performSelector:@selector(dismissModalView) withObject:nil afterDelay:0];
    
}


@end
