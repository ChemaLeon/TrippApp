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



#pragma mark - LifeCycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    phases = [DayPhase getDayPhases];
    
    current_day = 0;
    backbuttonHide = YES;
    nextbuttonHide = NO;
    [self initializeDaysArray];
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

- (void)viewWillAppear:(BOOL)animated {
    

}

- (void)viewDidAppear:(BOOL)animated {
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
    if(indexPath.row == 0) return 100.0f;

    return 73.0f;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"tripDetailTableCell";
    SWTableViewCell *cell = (SWTableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.9];
    
    for (UIView *view in cell.contentView.subviews) {
        [view removeFromSuperview];
    }
    
    if (indexPath.row != 0)
    {
        cell.leftUtilityButtons = [self leftButtons];
        cell.delegate = self;
        cell.contentView.backgroundColor = [UIColor clearColor];
        UIView *whiteRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(15,10,cell.frame.size.width-25,cell.frame.size.height-10)];
        whiteRoundedCornerView.layer.masksToBounds = NO;
        whiteRoundedCornerView.layer.cornerRadius = 3.0;
        whiteRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
        whiteRoundedCornerView.layer.shadowOpacity = 0.3;
        whiteRoundedCornerView.layer.borderColor = [[UIColor blackColor] CGColor];
        whiteRoundedCornerView.layer.borderWidth = 0.5f;
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = whiteRoundedCornerView.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor whiteColor] CGColor],[[UIColor whiteColor] CGColor],[[UIColor whiteColor] CGColor], (id)[[phases[[indexPath row]] dark_color] CGColor], nil];
        [whiteRoundedCornerView.layer insertSublayer:gradient atIndex:0];
        
        //Event Type
        UIImageView* dayPhaseImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 30, 30)];
        UIImageView* eventTypeImage = [[UIImageView alloc] initWithFrame:CGRectMake(300, 15, 30, 30)];
        dayPhaseImage.image = [UIImage imageNamed:@"sun"];
        if([[[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] event_type] isEqualToString:@"M"])
        {
            eventTypeImage.image = [UIImage imageNamed:@"meeting"];
        }
        else if([[[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] event_type] isEqualToString:@"L"])
        {
            eventTypeImage.image = [UIImage imageNamed:@"location"];
        }
        else
        {
            eventTypeImage.image = [UIImage imageNamed:@"plane"];
        }
        
        
        //Event Name
        UILabel* eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 0, 200, 60)];
        UIFont *futura = [UIFont fontWithName:@"Futura" size:18];
        eventLabel.font = futura;
        eventLabel.lineBreakMode = NSLineBreakByWordWrapping;
        eventLabel.numberOfLines = 0;
        eventLabel.text = [[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] name];
        
        if(eventLabel.text.length == 0)
        {
            eventLabel.text = [@"Not in " stringByAppendingString: _trip.city_name];
        }
        [whiteRoundedCornerView addSubview:eventTypeImage];
        [whiteRoundedCornerView addSubview:eventLabel];
        [whiteRoundedCornerView addSubview:dayPhaseImage];
        [cell.contentView addSubview:whiteRoundedCornerView];
        [cell.contentView sendSubviewToBack:whiteRoundedCornerView];
        
    }
    else
    {
        UIButton* backButton = [[UIButton alloc] initWithFrame:CGRectMake(55, 25, 50, 50)];
        backButton.tag = 0;
        UIButton* nextButton = [[UIButton alloc] initWithFrame:CGRectMake(280, 25, 50, 50)];
        nextButton.tag = 1;
        
        [backButton addTarget:self action:@selector(changeDay:) forControlEvents:UIControlEventTouchUpInside];
        [nextButton addTarget:self action:@selector(changeDay:) forControlEvents:UIControlEventTouchUpInside];
        
        
        UILabel* dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(135, 0, 200, 100)];
        
        UIImage * buttonImage = [UIImage imageNamed:@"NextArrow"];
        
        [backButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        [nextButton setBackgroundImage:buttonImage forState:UIControlStateNormal];
        backButton.hidden = backbuttonHide;
        nextButton.hidden = nextbuttonHide;
        
        UIFont *futura = [UIFont fontWithName:@"Futura" size:36];
        dayLabel.font = futura;
        dayLabel.text = [@"DAY " stringByAppendingString: [NSString stringWithFormat: @"%02ld", (long)current_day+1]];
        
        
        [cell.contentView addSubview:backButton];
        [cell.contentView addSubview:nextButton];
        [cell.contentView addSubview:dayLabel];
    }

    
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return phases.count;
}

- (NSArray *)leftButtons
{
    NSMutableArray *leftUtilityButtons = [NSMutableArray new];
    
    UIButton *removeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    removeBtn.backgroundColor = [UIColor clearColor];
    UIImageView* removeImage = [[UIImageView alloc] initWithFrame:CGRectMake(35, 25, 30, 30)];
    removeImage.image = [UIImage imageNamed:@"remove"];
    [removeBtn addSubview:removeImage];
    //[removeBtn setImage:[UIImage imageNamed:@"remove"] forState:UIControlStateNormal];
    //removeBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 30, 30);
    //removeBtn. = CGRectMake(25, 15, 30, 30);
    [leftUtilityButtons addObject:removeBtn];


    
    UIButton *refreshBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    refreshBtn.backgroundColor = [UIColor clearColor];
    //[refreshBtn setImage:[UIImage imageNamed:@"refresh"] forState:UIControlStateNormal];
    //refreshBtn.imageEdgeInsets = UIEdgeInsetsMake(15, 15, 30, 30);
    UIImageView* refreshImage = [[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 50, 50)];
    refreshImage.image = [UIImage imageNamed:@"refresh"];
    [refreshBtn addSubview:refreshImage];
    [leftUtilityButtons addObject:refreshBtn];
    
    
    return leftUtilityButtons;
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

// When the user taps on an element of the Table View, update the UI Navigation Item of the destination View Controller with the name of the trip. Finally, Pass on the Trip object from the trips NSArray to the destination View Controller.
- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"showEventDetail"]) {
        EventDetailViewController *eventViewController = [segue destinationViewController];
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        eventViewController.detailUINavItem.title = @"";
        eventViewController.event = [days[current_day] objectForKey:[phases[[indexPath row]] phase_id]];
//        eventViewController.trip = trips[[indexPath row]];

    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{

    if ([identifier isEqualToString:@"showEventDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        if([[[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] event_type] isEqualToString:@"M"] || [[[days[current_day] objectForKey:[phases[[indexPath row]] phase_id]] event_type] isEqualToString:@"L"])
        {
            return YES;
        }
    }
    return NO;
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
    
    if ([overlay isKindOfClass:[MKPolygon class]])
    {
        MKPolygonRenderer *renderer = [[MKPolygonRenderer alloc] initWithPolygon:overlay];
        
        renderer.fillColor   = [[UIColor cyanColor] colorWithAlphaComponent:0.2];
        renderer.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        renderer.lineWidth   = 3;
        
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
    }
    
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
        pinView.frame = CGRectMake(0, 0, 30, 30);
        pinView.calloutOffset = CGPointMake(0, 0);
        
        // Add a detail disclosure button to the callout.
        UIButton* rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        pinView.rightCalloutAccessoryView = rightButton;
        
        // Add an image to the left callout.
        UIImageView *iconView = [[UIImageView alloc] initWithFrame: CGRectMake(5, 10, 30, 30)];
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
        
        
        if([[[days[current_day] objectForKey:[phase phase_id]] event_type] isEqualToString:@"M"] || [[[days[current_day] objectForKey:[phase phase_id]] event_type] isEqualToString:@"L"])
        {
            destinationCoords = CLLocationCoordinate2DMake([[[days[current_day] objectForKey:[phase phase_id]] lat] doubleValue], [[[days[current_day] objectForKey:[phase phase_id]] lng] doubleValue]);
            
            //Map Annotation
            EventAnnotation *eventAnnotation = [[EventAnnotation alloc]init];
            eventAnnotation.coordinate = destinationCoords;
            eventAnnotation.title = [[days[current_day] objectForKey:[phase phase_id]] name];
            eventAnnotation.subtitle = [[days[current_day] objectForKey:[phase phase_id]] period];
            if([[[days[current_day] objectForKey:[phase phase_id]] event_type] isEqualToString:@"M"])
            {
                eventAnnotation.annotationIcon = [UIImage imageNamed:@"meeting"];
            }
            else if([[[days[current_day] objectForKey:[phase phase_id]] event_type] isEqualToString:@"L"])
            {
                eventAnnotation.annotationIcon = [UIImage imageNamed:@"location"];
            }
            
            
            [_mapView addAnnotation:eventAnnotation];
            
            [self mapDirectionsFromSource:sourceCoords ToDestination: destinationCoords withColor:routeColor];
            
            sourceCoords = destinationCoords;
            
            if([[phase phase_id] isEqualToString:@"evening"])
            {
                routeColor = [UIColor magentaColor];
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
                [self mapDirectionsFromSource:sourceCoords ToDestination:destinationCoords withColor:[UIColor greenColor]];
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





@end
