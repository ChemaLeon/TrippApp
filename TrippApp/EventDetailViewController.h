//
//  EventDetailViewController.h
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-23.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *detailUINavItem;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UILabel *eventFirstDesc;
@property (weak, nonatomic) IBOutlet UILabel *eventSecondDesc;
@property (weak, nonatomic) IBOutlet UIImageView *eventBGImgView;
@property (weak, nonatomic) IBOutlet UIView *viewFirstDesc;
@property (weak, nonatomic) IBOutlet UIView *viewSecondDesc;

@property (weak, nonatomic) IBOutlet Event *event;

@end
