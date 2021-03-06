//
//  DetailTripViewController.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//


#import "DetailTripViewController.h"
#import "DayPhase.h"
#import "DateHelper.h"
#import "GlobalsManager.h"
#import "EventAnnotation.h"
#import "EventDetailViewController.h"
#import "APIServiceManager.h"

@interface DetailTripViewController ()

@end

@implementation DetailTripViewController

NSArray* phases;
NSMutableArray* days;
NSInteger current_day;
NSInteger trip_day_length;
BOOL backbuttonHide;
BOOL nextbuttonHide;
CLLocationCoordinate2D sourceCoords;
CLLocationCoordinate2D destinationCoords;
UIColor* phaseColor;
MBXRasterTileOverlay* tileSource;
NSIndexPath* refreshIndexPath;
NSMutableDictionary* ignore_list;
int counter = 0;


NSString *const getNewSuggestedLocation = @"getNewSuggestedLocation";
NSString *const dismissLocation = @"dismissLocation";

#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    phases = [DayPhase getDayPhases];
    
    current_day = 0;
    backbuttonHide = YES;
    nextbuttonHide = NO;
    ignore_list = [[NSMutableDictionary alloc] init];
    [self initializeDaysArray];
    [self initializeNotifications];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    //Set BackGround Transparent
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Set Header
    UIView *blueFrameView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 15)];
    [blueFrameView setBackgroundColor:[UIColor colorWithRed:46/255.0 green:154/255.0 blue:202/255.0 alpha:1.0]];
    
    self.tableView.tableHeaderView = blueFrameView;
    
    _mapView.delegate = self;

    [MBXMapKit setAccessToken:@"pk.eyJ1Ijoidml0b3JwZW5hIiwiYSI6InNwRmhVd2sifQ.6r7HugaInKFZjJJFYqu7MA"];
    
    tileSource = [[MBXRasterTileOverlay alloc] initWithMapID:@"vitorpena.l9mn2gj1"];
    
    [_mapView addOverlay:tileSource];
    
    CLLocationCoordinate2D targetLocation;
    targetLocation.latitude = [_trip.lat_arrival doubleValue];
    targetLocation.longitude = [_trip.lng_arrival doubleValue];
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(targetLocation, 9000, 9000);
    [_mapView setRegion:viewRegion animated:YES];
    
    [self initiateMapforDay];

}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow: 2 inSection:0];
    [[self tableView] scrollToRowAtIndexPath:scrollIndexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Scroll Navigation

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    self.tableView.contentInset = UIEdgeInsetsMake(self.mapView.frame.size.height-40, 0, 0, 0);
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y < self.mapView.frame.size.height*-1 ) {
        [scrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, self.mapView.frame.size.height*-1)];
    }
}

#pragma mark - TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row == 0) return 75.0f;

    return 78.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"tripDetailTableCell";
    SWTableViewCell *cell = (SWTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.8];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row != 0)
    {
        if([[[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] event_type] isEqualToString:@"L"])
        {
            cell.leftUtilityButtons = [self leftButtons];
            cell.delegate = self;
        }
        else
        {
            cell.leftUtilityButtons = nil;
            cell.delegate = nil;
        }
        cell.contentView.backgroundColor = [UIColor colorWithRed:58/255.0 green:58/255.0 blue:58/255.0 alpha:0.8];

        //Event Type
        UIView* dayPhaseFrame = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 90, cell.frame.size.height)];
        UIImageView* dayPhaseImage = [[UIImageView alloc] initWithFrame:CGRectMake(27, 17, 40, 40)];
        dayPhaseImage.image = [phases[[indexPath row]] clock];
        dayPhaseFrame.backgroundColor = [phases[[indexPath row]] dark_color];
        [dayPhaseFrame addSubview:dayPhaseImage];

        
        UIImageView* eventTypeImage;
        if([[[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] event_type] isEqualToString:@"M"])
        {
            
            eventTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(320, 15, 35, 35)];
            eventTypeImage.image = [UIImage imageNamed:@"meeting"];
        }
        else if([[[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] event_type] isEqualToString:@"L"])
        {
            
            eventTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(325, 15, 20, 34)];
            eventTypeImage.image = [UIImage imageNamed:@"location"];
        }
        else
        {
            
            eventTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(320, 15, 35, 35)];
            eventTypeImage.image = [UIImage imageNamed:@"plane"];
        }
        
        
        //Event Name
        UILabel* eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(110, 0, 200, 60)];
        UIFont *futura = [UIFont fontWithName:@"Futura-Medium" size:20];
        eventLabel.font = futura;
        eventLabel.lineBreakMode = NSLineBreakByWordWrapping;
        eventLabel.numberOfLines = 0;
        eventLabel.textColor = [UIColor whiteColor];
        eventLabel.text = [[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] name];
        
        if(eventLabel.text.length == 0)
        {
            eventLabel.text = [@"Not in " stringByAppendingString: _trip.city_name];
        }
        [cell.contentView addSubview:eventTypeImage];
        [cell.contentView addSubview:eventLabel];
        [cell.contentView addSubview:dayPhaseFrame];
        
    }
    else
    {
        UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(15, 5, 50, 60)];
        backButton.tag = 0;
        UIButton* nextButton = [[UIButton alloc] initWithFrame:CGRectMake(325, 5, 50, 60)];
        nextButton.tag = 1;
        
        [backButton addTarget:self action:@selector(changeDay:) forControlEvents:UIControlEventTouchUpInside];
        [nextButton addTarget:self action:@selector(changeDay:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel* dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(115, -25, 250, 120)];
        
        UIImage * rightArrowImage = [UIImage imageNamed:@"rightArrow"];
        UIImage * leftArrowImage = [UIImage imageNamed:@"leftArrow"];
        
        [backButton setBackgroundImage:leftArrowImage forState:UIControlStateNormal];
        [nextButton setBackgroundImage:rightArrowImage forState:UIControlStateNormal];
        backButton.hidden = backbuttonHide;
        nextButton.hidden = nextbuttonHide;
        
        UIFont *futura = [UIFont fontWithName:@"Futura-Medium" size:55];
        dayLabel.font = futura;
        dayLabel.text = [@"DAY " stringByAppendingString: [NSString stringWithFormat: @"%01ld", (long)current_day+1]];
        dayLabel.textColor = [UIColor colorWithRed:52/255.0 green:52/255.0 blue:52/255.0 alpha:0.9];
        
        [cell.contentView addSubview:backButton];
        [cell.contentView addSubview:nextButton];
        [cell.contentView addSubview:dayLabel];
    }

    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return phases.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if([[[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] event_type] isEqualToString:@"L"])
    {
        [self performSegueWithIdentifier:@"showEventDetail" sender:[tableView cellForRowAtIndexPath:indexPath]];
    }

}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.backgroundColor = [UIColor colorWithRed:202/255.0 green:87/255.0 blue:97/255.0 alpha:0.8];
    UIImageView* removeImage = [[UIImageView alloc] initWithFrame:CGRectMake(30, 17, 36, 42)];
    removeImage.image = [UIImage imageNamed:@"remove"];
    [removeBtn addSubview:removeImage];
    //[removeBtn setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    //removeBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 30, 30);
    //removeBtn. = CGRectMake(25, 15, 30, 30);
    [leftUtilityButtons addObject:removeBtn];


    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.backgroundColor = [UIColor colorWithRed:202/255.0 green:139/255.0 blue:90/255.0 alpha:0.8];
    //[refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    //refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 30, 30);
    UIImageView* refreshImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 18, 49, 42)];
    refreshImage.image = [UIImage imageNamed:@"refresh"];
    [refreshBtn addSubview:refreshImage];
    [leftUtilityButtons addObject:refreshBtn];
    
    
    return leftUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerLeftUtilityButtonWithIndex:(NSInteger)index {
    switch (index) {
        case 0:
        {
            NSLog(@"Delete");
            
            refreshIndexPath = [_tableView indexPathForCell:cell];
            
            NSDictionary *parameters = @{
                                         @"key": [GlobalsManager sharedInstance].userKey,
                                         @"trip_location_id": [[days[current_day] objectForKey:[phases[[refreshIndexPath row]] phase_id]] trip_location_id]
                                         };
            
            [APIServiceManager dismissLocation:parameters forUser:[GlobalsManager sharedInstance].userKey withObserver:dismissLocation];
            
            break;
        }
        case 1:
        {
            NSLog(@"Refresh");
            
            refreshIndexPath = [_tableView indexPathForCell:cell];
            
            NSString* lat;
            NSString* lng;
            
            if(current_day == 0 )
            {
                lat = _trip.lat_arrival;
                lng = _trip.lng_arrival;
            }
            else
            {
                lat = _trip.lat_hotel;
                lng = _trip.lng_hotel;
            }
            
            
            if([refreshIndexPath row] - 1 > 1 )
            {
                if([[[days[current_day] objectForKey:[phases[[refreshIndexPath row]-1] phase_id]] event_type] isEqualToString: @"L"]
                   || [[[days[current_day] objectForKey:[phases[[refreshIndexPath row]-1] phase_id]] event_type] isEqualToString: @"M"])
                {
                    lat = [[days[current_day] objectForKey:[phases[[refreshIndexPath row]-1] phase_id]] lat];
                    lng = [[days[current_day] objectForKey:[phases[[refreshIndexPath row]-1] phase_id]] lng];
                }
            }
            
            [ignore_list setObject:[[days[current_day] objectForKey:[phases[[refreshIndexPath row]] phase_id]] location_id] forKey:[NSNumber numberWithInt:counter]];
            
            counter++;
            
            
            
            NSDictionary *parameters = @{
                                         @"key": [GlobalsManager sharedInstance].userKey,
                                         @"trip_location_id": [[days[current_day] objectForKey:[phases[[refreshIndexPath row]] phase_id]] trip_location_id],
                                         @"location_id": [[days[current_day] objectForKey:[phases[[refreshIndexPath row]] phase_id]] location_id],
                                         @"phase": [phases[[refreshIndexPath row]] phase_id],
                                         @"lat": lat,
                                         @"lng": lng,
                                         @"ignore_list": ignore_list
                                        };
            
            [APIServiceManager getNewSuggestLocation:parameters forUser:[GlobalsManager sharedInstance].userKey withObserver:getNewSuggestedLocation];
 
            break;
        }
        default:
            break;
    }
}

#pragma mark - Actions

- (void)changeDay:(UIButton *)sender
{
    if(sender.tag == 1) {
        backbuttonHide = NO;
        current_day++;
        if(current_day+1 == trip_day_length)
        {
            nextbuttonHide = YES;
            
        }
    }
    else {
        nextbuttonHide = NO;
        current_day--;
        if(current_day == 0)
        {
            backbuttonHide = YES;
        }
        
    }
    [self clearDay];
    [self initiateMapforDay];
    [self.tableView reloadData];
}

- (void)clearDay
{
    [self removeRoutesOnMap];
    [_mapView removeAnnotations:_mapView.annotations];

}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showEventDetail"]) {
        EventDetailViewController *eventViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        eventViewController.detailUINavItem.title = @"";
        NSString* phase_key = [phases[[indexPath row]] phase_id];
        eventViewController.event = [days[current_day] objectForKey:phase_key];
        eventViewController.phase = phases[[indexPath row]];
//        eventViewController.trip = trips[[indexPath row]];

    }
}

#pragma mark - Utilitary

- (void) initializeDaysArray
{
    days = [[NSMutableArray alloc] init];
    
    NSDate* beginDate = [DateHelper convertStrToDate:_trip.date_arrival];
    NSDate* endDate = [DateHelper convertStrToDate:_trip.date_departure];
    
    trip_day_length = [DateHelper daysBetweenDate:beginDate andDate:endDate]+1;
    
    for (int i = 0; i < trip_day_length; i++)
    {
        NSMutableDictionary* day = [[NSMutableDictionary alloc] init];
        
        for (id phase in phases)
        {
            if([[phase phase_id ] isEqualToString:@"menu"]) continue;
            
            for(Event *trip_event in _trip.trip_events)
            {
                NSDate* eventDate = [DateHelper convertStrToDate: trip_event.event_date];
                if([[phase phase_id ] isEqualToString: [trip_event period]] && [DateHelper daysBetweenDate:beginDate andDate:eventDate] == i)
                {
                    [day setObject:trip_event forKey:[phase phase_id]];
                    break;
                }
            }
        }
        [days addObject:[NSDictionary dictionaryWithDictionary:day]];
    }
}


#pragma mark - MKMapViewDelegate protocol implementation

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    // This is boilerplate code to connect tile overlay layers with suitable renderers
    //
    if ([overlay isKindOfClass:[MBXRasterTileOverlay class]])
    {
        MBXRasterTileRenderer *renderer = [[MBXRasterTileRenderer alloc] initWithTileOverlay:overlay];
        return renderer;
    }
    
    if ([overlay isKindOfClass:[MKPolyline class]])
    {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        
        renderer.strokeColor = [phaseColor colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 3;
        
        return renderer;
    }
    
    
    
    return nil;
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    /* MapBox Annotation Implementation
    // This is boilerplate code to connect annotations with suitable views
    //
    if ([annotation isKindOfClass:[MBXPointAnnotation class]])
    {
        static NSString *MBXSimpleStyleReuseIdentifier = @"MBXSimpleStyleReuseIdentifier";
        MKAnnotationView *view = [mapView dequeueReusableAnnotationViewWithIdentifier:MBXSimpleStyleReuseIdentifier];
        if (!view)
        {
            view = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:MBXSimpleStyleReuseIdentifier];
        }
        view.image = ((MBXPointAnnotation *)annotation).image;
        view.canShowCallout = YES;
        return view;
    }*/
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[EventAnnotation class]])
    {
        // Try to dequeue an existing pin view first.
        MKAnnotationView *pinView = (MKAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:@"CustomPinAnnotationView"];
        if (!pinView)
        {

            // If an existing pin view was not available, create one.
            pinView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomPinAnnotationView"];
            
        }
            
        pinView.canShowCallout = YES;
        pinView.image = ((EventAnnotation *)annotation).annotationIcon;
        pinView.frame = CGRectMake(0, 0, 25, 40);
        pinView.calloutOffset = CGPointMake(0, 0);
        
        // Add a detail disclosure button to the callout.
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        
        // Add an image to the left callout.
        UIImageView *iconView = [[UIImageView alloc] initWithFrame: CGRectMake(5, 10, 25, 40)];
        iconView.image = ((EventAnnotation *)annotation).annotationIcon;
        pinView.leftCalloutAccessoryView = iconView;
        pinView.annotation = annotation;

        return pinView;
    }

    return nil;
}


#pragma mark - Map Directions

- (void)initiateMapforDay
{
    bool lastTripPhase = false;
    if(current_day == 0)
    {
        //Set the Initial Coord
        sourceCoords = CLLocationCoordinate2DMake([_trip.lat_arrival doubleValue], [_trip.lng_arrival doubleValue]);
        //Map Annotation
        EventAnnotation *arrivalAnnotation = [[EventAnnotation alloc]init];
        arrivalAnnotation.coordinate = sourceCoords;
        arrivalAnnotation.title = @"Arrival";
        arrivalAnnotation.annotationIcon = [UIImage imageNamed:@"plane"];
        
        [_mapView addAnnotation:arrivalAnnotation];
    }
    else
    {
        //Set the Initial Coord
        sourceCoords = CLLocationCoordinate2DMake([_trip.lat_hotel doubleValue], [_trip.lng_hotel doubleValue]);
        //Map Annotation
        EventAnnotation *hotelAnnotation = [[EventAnnotation alloc]init];
        hotelAnnotation.coordinate = sourceCoords;
        hotelAnnotation.title = @"Hotel";
        hotelAnnotation.annotationIcon = [UIImage imageNamed:@"location"];
        
        [_mapView addAnnotation:hotelAnnotation];
        
    }

    //Phases Loop
    for (id phase in phases)
    {
        if([[phase phase_id ] isEqualToString:@"menu"]) continue;
        
        UIColor* routeColor = [phase route_color];
        
        
        if(([[[days[current_day] objectForKey:[phase phase_id]] event_type] isEqualToString:@"M"] || [[[days[current_day] objectForKey:[phase phase_id]] event_type] isEqualToString:@"L"]) && [[[days[current_day] objectForKey:[phase phase_id]] dismissed] isEqualToString:@"0"] )
        {
            destinationCoords = CLLocationCoordinate2DMake([[[days[current_day] objectForKey:[phase phase_id]] lat] doubleValue], [[[days[current_day] objectForKey:[phase phase_id]] lng] doubleValue]);
            
            //Map Annotation
            EventAnnotation *eventAnnotation = [[EventAnnotation alloc]init];
            eventAnnotation.coordinate = destinationCoords;
            eventAnnotation.title = [[days[current_day] objectForKey:[phase phase_id]] name];
            eventAnnotation.subtitle = [[days[current_day] objectForKey:[phase phase_id]] period];
            eventAnnotation.annotationIcon = [phase marker];

            
            [_mapView addAnnotation:eventAnnotation];
            
            [self mapDirectionsFromSource:sourceCoords ToDestination: destinationCoords withColor:routeColor];
            
            sourceCoords = destinationCoords;
            
            if([[phase phase_id] isEqualToString:@"evening"])
            {
                routeColor = [UIColor blackColor];
                destinationCoords = CLLocationCoordinate2DMake([_trip.lat_hotel doubleValue], [_trip.lng_hotel doubleValue]);
                [self mapDirectionsFromSource:sourceCoords ToDestination:destinationCoords withColor:routeColor];
                //Map Annotation
                EventAnnotation *hotelAnnotation = [[EventAnnotation alloc]init];
                hotelAnnotation.coordinate = destinationCoords;
                hotelAnnotation.title = @"Hotel";
                hotelAnnotation.annotationIcon = [UIImage imageNamed:@"location"];
                
                [_mapView addAnnotation:hotelAnnotation];
            }
        }
        else if(current_day+1 == trip_day_length)
        {
            if(!lastTripPhase)
            {
                //Set the Initial Coord
                destinationCoords = CLLocationCoordinate2DMake([_trip.lat_departure doubleValue], [_trip.lng_departure doubleValue]);
                [self mapDirectionsFromSource:sourceCoords ToDestination:destinationCoords withColor:[UIColor blackColor]];
                //Map Annotation
                EventAnnotation *departureAnnotation = [[EventAnnotation alloc]init];
                departureAnnotation.coordinate = destinationCoords;
                departureAnnotation.title = @"Departure";
                departureAnnotation.annotationIcon = [UIImage imageNamed:@"plane"];
                
                [_mapView addAnnotation:departureAnnotation];
                
                lastTripPhase = true;
            }
        }

    }
    
    
}


- (void)mapDirectionsFromSource: (CLLocationCoordinate2D) sourceCoords ToDestination: (CLLocationCoordinate2D) destinationCoords withColor: (UIColor*) routeColor
{
    
    MKPlacemark *sourcePlacemark = [[MKPlacemark alloc] initWithCoordinate:sourceCoords addressDictionary:nil];
    MKMapItem *source = [[MKMapItem alloc] initWithPlacemark:sourcePlacemark];
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:destinationCoords addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];

    MKDirectionsRequest *request = [[MKDirectionsRequest alloc] init];
    request.source = source;
    request.destination = destination;

    MKDirections *directions = [[MKDirections alloc] initWithRequest:request];
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
    
        if (error) {
            NSLog(@"[Error] %@", error);
            return;
        }
    
        MKRoute* route = [response.routes firstObject];
        
        phaseColor = routeColor;
        
        [self plotRouteOnMap:route];
        
    }];
}

- (void)plotRouteOnMap:(MKRoute *)route
{
    
    // Add it to the map
    [_mapView addOverlay:route.polyline];
}

- (void)removeRoutesOnMap
{
    NSArray *pointsArray = [_mapView overlays];
    
    [_mapView removeOverlays:pointsArray];
    
    [_mapView addOverlay:tileSource];
}


- (void) initializeNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedNewLocationNotification:) name:getNewSuggestedLocation object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedDismissedNotification:) name:dismissLocation object:nil];
    
}

-(void) receivedNewLocationNotification:(NSNotification*) notification
{
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        
        //        _userKey = [theData objectForKey:@"userKey"];
        Event* newLocation = [[Event parseEventArray:[theData objectForKey:@"location"]] objectAtIndex:0];
        
        NSDate* beginDate = [DateHelper convertStrToDate:_trip.date_arrival];
        
        for(Event *trip_event in _trip.trip_events)
        {
            NSDate* eventDate = [DateHelper convertStrToDate: trip_event.event_date];
            if([ [phases[[refreshIndexPath row]] phase_id] isEqualToString: [trip_event period]] && [DateHelper daysBetweenDate:beginDate andDate:eventDate] == current_day)
            {
                //[days[current_day] setObject:newLocation forKey:[phases[[refreshIndexPath row]] phase_id]];
                
                trip_event.location_id = newLocation.location_id;
                trip_event.event_type = newLocation.event_type;
                trip_event.name = newLocation.name;
                trip_event.lat = newLocation.lat;
                trip_event.lng = newLocation.lng;
                trip_event.phone = newLocation.phone;
                trip_event.website = newLocation.website;
                
                [_tableView reloadRowsAtIndexPaths:@[refreshIndexPath] withRowAnimation:UITableViewRowAnimationFade];
                
                break;
            }
        }
        
    }
    
}

-(void) receivedDismissedNotification:(NSNotification*) notification
{
    
    NSDate* beginDate = [DateHelper convertStrToDate:_trip.date_arrival];

    for(Event *trip_event in _trip.trip_events)
    {
        NSDate* eventDate = [DateHelper convertStrToDate: trip_event.event_date];
        if([ [phases[[refreshIndexPath row]] phase_id] isEqualToString: [trip_event period]] && [DateHelper daysBetweenDate:beginDate andDate:eventDate] == current_day)
        {
            trip_event.dismissed = @"1";
            trip_event.name = @"Dismissed.";
            [self clearDay];
            [self initiateMapforDay];
            
            [_tableView reloadRowsAtIndexPaths:@[refreshIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            
            break;
        }
    }

}


@end
