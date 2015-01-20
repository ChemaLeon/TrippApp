//
//  MapDetailTripViewController.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-19.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "MapDetailTripViewController.h"

@interface MapDetailTripViewController ()

@end

@implementation MapDetailTripViewController

- (void)viewWillAppear:(BOOL)animated {
    [_mapView  setRegion:_mapRegion animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
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
