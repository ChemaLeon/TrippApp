//
//  EventDetailViewController.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-23.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "EventDetailViewController.h"
#import "BackGroundManager.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.eventBGImgView.image = [BackGroundManager getBGImage];
    self.viewFirstDesc.backgroundColor = [UIColor clearColor];
    UIView *firstRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(5,5,self.viewFirstDesc.frame.size.width-10,self.viewFirstDesc.frame.size.height-10)];
    firstRoundedCornerView.layer.masksToBounds = NO;
    firstRoundedCornerView.layer.cornerRadius = 3.0;
    firstRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    firstRoundedCornerView.layer.shadowOpacity = 0.3;
    firstRoundedCornerView.layer.borderColor = [[UIColor blackColor] CGColor];
    firstRoundedCornerView.layer.borderWidth = 0.5f;
    firstRoundedCornerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    [self.viewFirstDesc addSubview:firstRoundedCornerView];
    [self.viewFirstDesc sendSubviewToBack:firstRoundedCornerView];
    
    UIFont *futura = [UIFont fontWithName:@"Futura" size:36];
    self.eventName.textColor = [UIColor whiteColor];
    self.eventName.font = futura;
    self.eventName.textAlignment = NSTextAlignmentCenter;

    self.viewSecondDesc.backgroundColor = [UIColor clearColor];
    UIView *secondRoundedCornerView = [[UIView alloc] initWithFrame:CGRectMake(5,5,self.viewSecondDesc.frame.size.width-10,self.viewSecondDesc.frame.size.height-10)];
    secondRoundedCornerView.layer.masksToBounds = NO;
    secondRoundedCornerView.layer.cornerRadius = 3.0;
    secondRoundedCornerView.layer.shadowOffset = CGSizeMake(-1, 1);
    secondRoundedCornerView.layer.shadowOpacity = 0.3;
    secondRoundedCornerView.layer.borderColor = [[UIColor blackColor] CGColor];
    secondRoundedCornerView.layer.borderWidth = 0.5f;
    secondRoundedCornerView.backgroundColor = [[UIColor grayColor] colorWithAlphaComponent:0.4];
    [self.viewSecondDesc addSubview:secondRoundedCornerView];
    [self.viewSecondDesc sendSubviewToBack:secondRoundedCornerView];
    
    futura = [UIFont fontWithName:@"Futura" size:24];
    self.eventFirstDesc.textColor = [UIColor whiteColor];
    self.eventFirstDesc.font = futura;
    self.eventFirstDesc.textAlignment = NSTextAlignmentCenter;
    
    futura = [UIFont fontWithName:@"Futura" size:18];
    self.eventSecondDesc.textColor = [UIColor whiteColor];
    self.eventSecondDesc.font = futura;
    self.eventSecondDesc.textAlignment = NSTextAlignmentCenter;
    
    if([[_event event_type] isEqualToString:@"L"])
    {
        self.eventName.text = _event.name;
        self.eventFirstDesc.text = _event.phone;
        self.eventSecondDesc.text = _event.website;
    }
    else
    {
        self.eventName.text = _event.name;
        self.eventFirstDesc.text = _event.event_date;
        self.eventSecondDesc.text = @"";
    }

    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
