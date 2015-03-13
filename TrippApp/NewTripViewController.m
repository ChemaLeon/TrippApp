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
#import "DataModel.h"
#import "Event.h"

@interface NewTripViewController ()

@end

@implementation NewTripViewController

int progressSteps = 5;                                  // The amount of screens the questionaire should show.
int nextProgressInt;                                    // Update next progress int and validate it.

- (UIStatusBarStyle) preferredStatusBarStyle {          // Set Status Bar to white.
    return UIStatusBarStyleLightContent;
}

- (void) dismissModalView {                             // Close questionaire and return to Trip Management.
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    [self dismissViewControllerAnimated:YES completion:nil];
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
    
    // Update all UI Elements and Subviews to reflect the current progress of the questionare.
    switch (self.progressInt) {
        case 0:
            self.questionLabel.text = @"What city are you visiting?";
            self.makeTextFieldEditable = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = YES;
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            self.theNewTrip = [[Trip alloc] initEmpty];
            self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(dismissModalView)];
            [self updateProgressTo:self.progressInt];
            break;
        case 1:
            self.questionLabel.text = @"When are you arriving to your destination?";
            self.makeTextFieldEditable = NO;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = NO;
            self.searchBar.placeholder = @"Arrival Time";
            self.datePicker.viewForBaselineLayout.hidden = NO;
            self.nextButton.hidden = NO;
            [self updateProgressTo:self.progressInt];
            break;
        case 2:
            self.questionLabel.text = @"When are you departing back from your destination?";
            self.makeTextFieldEditable = NO;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = NO;
            self.searchBar.placeholder = @"Departure Time";
            self.datePicker.viewForBaselineLayout.hidden = NO;
            self.nextButton.hidden = NO;
            [self.datePicker setMinimumDate:self.theNewTrip.arrivalDate];
            [self updateProgressTo:self.progressInt];
            break;
        case 3:
            self.questionLabel.text = @"Where are you arriving to?";
            self.makeTextFieldEditable = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = YES;
            self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
            self.searchBar.returnKeyType = UIReturnKeyGo;
            self.searchBar.placeholder = @"e.g. 88 Pender St. or YVR Intl Airport";
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            [self updateProgressTo:self.progressInt];
            break;
        case 4:
            self.questionLabel.text = @"Where are you departing from?";
            self.makeTextFieldEditable = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = YES;
            self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
            self.searchBar.returnKeyType = UIReturnKeyGo;
            self.searchBar.placeholder = @"e.g. 88 Pender St. or YVR Intl Airport";
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            [self updateProgressTo:self.progressInt];
            break;
        case 5:
            self.questionLabel.text = @"Is there something else scheduled for your trip?";
            self.makeTextFieldEditable = NO;
            self.searchBar.viewForBaselineLayout.hidden = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = NO;
            self.datePicker.viewForBaselineLayout.hidden = YES;
            self.nextButton.hidden = YES;
            self.positiveButton.hidden = NO;
            self.negativeButton.hidden = NO;
            [self updateProgressTo:5];
            break;
        case 6: // Hotel
            self.questionLabel.text = @"Which hotel are you arriving to?";
            self.makeTextFieldEditable = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = YES;
            self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
            self.searchBar.returnKeyType = UIReturnKeyGo;
            self.searchBar.placeholder = @"e.g. Fairmont Waterfront";
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
            [self updateProgressTo:4];
            break;
        case 8:
            self.questionLabel.text = @"Where is your meeting?";
            self.makeTextFieldEditable = YES;
            self.searchBar.viewForBaselineLayout.userInteractionEnabled = YES;
            self.searchBar.keyboardType = UIKeyboardTypeAlphabet;
            self.searchBar.returnKeyType = UIReturnKeyGo;
            self.searchBar.placeholder = @"e.g. Shangri-La Business Centre";
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
            [self updateProgressTo:4];
            [self performSelector:@selector(dismissModalView) withObject:nil afterDelay:3.0];
            NSMutableString* tripdetails = [NSMutableString stringWithString:self.theNewTrip.locationName];
            [tripdetails appendString:@"'s Trip"];
            self.theNewTrip.details = tripdetails;
            [DataModel AddTrip:self.theNewTrip];
        }
            break;
        default:
            break;
    }
    
    // TODO: Update the city list population from server side.
    self.cityNames = [NSMutableArray array];
    [self.cityNames addObject:@"Montreal"];
    [self.cityNames addObject:@"Vancouver"];
    [self.cityNames addObject:@"Ottawa"];
    [self.cityNames addObject:@"Calgary"];
    [self.cityNames addObject:@"Edmonton"];
    [self.cityNames addObject:@"Quebec"];
    [self.cityNames addObject:@"Winnipeg"];
    [self.cityNames addObject:@"Hamilton"];
    [self.cityNames addObject:@"Kitchener"];
    [self.cityNames addObject:@"London"];
    [self.cityNames addObject:@"Niagara"];
    [self.cityNames addObject:@"Halifax"];
    [self.cityNames addObject:@"Oshawa"];
    [self.cityNames addObject:@"Victoria"];
    [self.cityNames addObject:@"Windsor"];
    [self.cityNames addObject:@"Saskatoon"];
    [self.cityNames addObject:@"Regina"];
    [self.cityNames addObject:@"Sherbrooke"];
    [self.cityNames addObject:@"St. John's"];
    [self.cityNames addObject:@"Barrie"];
    [self.cityNames addObject:@"Kelowna"];
    [self.cityNames addObject:@"Abbotsford"];
    [self.cityNames addObject:@"Greater Sudbury"];
    [self.cityNames addObject:@"Kingston"];
    [self.cityNames addObject:@"Saguenay"];
    [self.cityNames addObject:@"Trois-Rivières"];
    [self.cityNames addObject:@"Guelph"];
    [self.cityNames addObject:@"Moncton"];
    [self.cityNames addObject:@"Brantford"];
    [self.cityNames addObject:@"Saint John"];
    [self.cityNames addObject:@"Thunder Bay"];
    [self.cityNames addObject:@"Peterborough"];
    [self.cityNames addObject:@"Lethbridge"];
    [self.cityNames addObject:@"Chatham-Kent"];
    [self.cityNames addObject:@"Cape Breton"];
    [self.cityNames addObject:@"Kamloops"];
    [self.cityNames addObject:@"Nanaimo"];
    [self.cityNames addObject:@"Fredericton"];
    [self.cityNames addObject:@"Belleville"];
    [self.cityNames addObject:@"Saint-Jean-sur-Richelieu"];
    [self.cityNames addObject:@"Chilliwack"];
    [self.cityNames addObject:@"Red Deer"];
    [self.cityNames addObject:@"Sarnia"];
    [self.cityNames addObject:@"Drummondville"];
    [self.cityNames addObject:@"Prince George"];
    [self.cityNames addObject:@"Sault Ste. Marie"];
    [self.cityNames addObject:@"Granby"];
    [self.cityNames addObject:@"Kawartha Lakes"];
    [self.cityNames addObject:@"Medicine Hat"];
    [self.cityNames addObject:@"Wood Buffalo"];
    [self.cityNames addObject:@"Charlottetown"];
    [self.cityNames addObject:@"North Bay"];
    [self.cityNames addObject:@"Norfolk"];
    [self.cityNames addObject:@"Cornwall"];
    [self.cityNames addObject:@"Vernon"];
    [self.cityNames addObject:@"Saint-Hyacinthe"];
    [self.cityNames addObject:@"Courtenay"];
    [self.cityNames addObject:@"Grande Prairie"];
    [self.cityNames addObject:@"Shawinigan"];
    [self.cityNames addObject:@"Brandon"];
    [self.cityNames addObject:@"Rimouski"];
    [self.cityNames addObject:@"Leamington"];
    [self.cityNames addObject:@"Sorel-Tracy"];
    [self.cityNames addObject:@"Joliette"];
    [self.cityNames addObject:@"Victoriaville"];
    [self.cityNames addObject:@"Truro"];
    [self.cityNames addObject:@"Duncan"];
    [self.cityNames addObject:@"Timmins"];
    [self.cityNames addObject:@"Prince Albert"];
    [self.cityNames addObject:@"Penticton"];
    [self.cityNames addObject:@"Rouyn-Noranda"];
    [self.cityNames addObject:@"Orillia"];
    [self.cityNames addObject:@"Salaberry-de-Valleyfield"];
    [self.cityNames addObject:@"Brockville"];
    [self.cityNames addObject:@"Woodstock"];
    [self.cityNames addObject:@"Campbell River"];
    [self.cityNames addObject:@"New Glasgow"];
    [self.cityNames addObject:@"Midland"];
    [self.cityNames addObject:@"Saint-Georges"];
    [self.cityNames addObject:@"Moose Jaw"];
    [self.cityNames addObject:@"Bathurst"];
    [self.cityNames addObject:@"Val-d'Or"];
    [self.cityNames addObject:@"Alma"];
    [self.cityNames addObject:@"Owen Sound"];
    [self.cityNames addObject:@"Stratford"];
    [self.cityNames addObject:@"Lloydminster"];
    [self.cityNames addObject:@"Baie-Comeau"];
    [self.cityNames addObject:@"Sept-Îles"];
    [self.cityNames addObject:@"Miramichi"];
    [self.cityNames addObject:@"Thetford Mines"];
    [self.cityNames addObject:@"Parksville"];
    [self.cityNames addObject:@"Rivière-du-Loup"];
    [self.cityNames addObject:@"Corner Brook"];
    [self.cityNames addObject:@"Centre Wellington"];
    [self.cityNames addObject:@"Fort St. John"];
    [self.cityNames addObject:@"Kentville"];
    [self.cityNames addObject:@"Whitehorse"];
    [self.cityNames addObject:@"Port Alberni"];
    [self.cityNames addObject:@"Cranbrook"];
    [self.cityNames addObject:@"Okotoks"];
    [self.cityNames addObject:@"Pembroke"];
    [self.cityNames addObject:@"Brooks"];
    [self.cityNames addObject:@"Quesnel"];
    [self.cityNames addObject:@"Edmundston"];
    [self.cityNames addObject:@"Collingwood"];
    [self.cityNames addObject:@"Yellowknife"];
    [self.cityNames addObject:@"North Battleford"];
    [self.cityNames addObject:@"Cobourg"];
    [self.cityNames addObject:@"Williams Lake"];
    [self.cityNames addObject:@"Matane"];
    [self.cityNames addObject:@"Yorkton"];
    [self.cityNames addObject:@"Campbellton"];
    [self.cityNames addObject:@"Salmon Arm"];
    [self.cityNames addObject:@"Swift Current"];
    [self.cityNames addObject:@"Squamish"];
    [self.cityNames addObject:@"Camrose"];
    [self.cityNames addObject:@"Amos"];
    [self.cityNames addObject:@"Powell River"];
    [self.cityNames addObject:@"Summerside"];
    [self.cityNames addObject:@"Port Hope"];
    [self.cityNames addObject:@"Dolbeau-Mistassini"];
    [self.cityNames addObject:@"Petawawa"];
    [self.cityNames addObject:@"Terrace"];
    [self.cityNames addObject:@"Kenora"];
    [self.cityNames addObject:@"Tillsonburg"];
    [self.cityNames addObject:@"Cold Lake"];
    [self.cityNames addObject:@"Grand Falls-Windsor"];
    [self.cityNames addObject:@"Temiskaming Shores"];
    [self.cityNames addObject:@"Steinbach"];
    [self.cityNames addObject:@"Prince Rupert"];
    [self.cityNames addObject:@"Portage la Prairie"];
    [self.cityNames addObject:@"Estevan"];
    [self.cityNames addObject:@"High River"];
    [self.cityNames addObject:@"Thompson"];
    [self.cityNames addObject:@"Sylvan Lake"];
    [self.cityNames addObject:@"Lachute"];
    [self.cityNames addObject:@"Wetaskiwin"];
    [self.cityNames addObject:@"Cowansville"];
    [self.cityNames addObject:@"Strathmore"];
    [self.cityNames addObject:@"Canmore"];
    [self.cityNames addObject:@"Ingersoll"];
    [self.cityNames addObject:@"Hawkesbury"];
    [self.cityNames addObject:@"Lacombe"];
    [self.cityNames addObject:@"Dawson Creek"];
    [self.cityNames addObject:@"Elliot Lake"];
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
            self.theNewTrip.locationName = [self.filteredCityNames objectAtIndex:[indexPath row]];
            nextProgressInt = 1;
        }
            break;
        case 1:
            self.theNewTrip.arrivalDate = self.datePicker.date;
            nextProgressInt = 2;
            break;
        case 2:
        {
            self.theNewTrip.departureDate = self.datePicker.date;
            
            // Check to see if user is staying for more than a day. (Day Changed or +15 hours (54,000 seconds) of difference)
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"dd"];
            
            NSString *arrivalDay = [dateFormatter stringFromDate:self.theNewTrip.arrivalDate];
            NSString *departureDay = [dateFormatter stringFromDate:self.theNewTrip.departureDate];
            
            NSTimeInterval totalTimeinSeconds = [self.theNewTrip.departureDate timeIntervalSinceDate:self.theNewTrip.arrivalDate];
            //NSLog(@"DIFF: From: %@ to: %@. Seconds: %f", arrivalDay, departureDay, totalTimeinSeconds);
            if (![arrivalDay isEqualToString:departureDay] || totalTimeinSeconds > 54000.0)
            {
                // Get a hotel
                nextProgressInt = 6;
            } else {
                // Skip the hotel
                nextProgressInt = 3;
            }
        }
            break;
        case 3:
            self.theNewTrip.arrivalLocation = self.searchBar.text;
            nextProgressInt = 4;
            break;
        case 4:
            self.theNewTrip.departureLocation = self.searchBar.text;
            nextProgressInt = 5;
            break;
        case 5:
            // Check to see if user has any meetings scheduled
            if (self.needsToLogEvent) {
                nextProgressInt = 7;
            } else {
                nextProgressInt = 9;
            }
            break;
        case 6: // Hotel
            self.theNewTrip.hotelName = self.searchBar.text;
            nextProgressInt = 3;
            break;
        case 7: // When (Meeting)
            self.tempEventDate = self.datePicker.date;
            nextProgressInt = 8;
            break;
        case 8: // Where (Meeting)
        {
            Event* newEvent = [[Event alloc] initWithLocationName:self.searchBar.text
                                                          Details:self.searchBar.text
                                                          AndDate:[DataModel nsdateToNstring:self.tempEventDate]];
            [self.theNewTrip addEvent:newEvent];                  //Add Event to trip
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
    return self.filteredCityNames.count;
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
    
    cell.cityNameLabel.text = [self.filteredCityNames objectAtIndex:indexPath.row];
    return cell;
}

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
