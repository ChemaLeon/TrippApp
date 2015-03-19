//
//  EventDetailViewController.h
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-23.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "DayPhase.h"

@interface EventDetailViewController : UIViewController

@property (weak, nonatomic) IBOutlet UINavigationItem *detailUINavItem;
@property (weak, nonatomic) IBOutlet UILabel *eventName;
@property (weak, nonatomic) IBOutlet UIImageView *eventBG;

//Top_VIEW
@property (weak, nonatomic) IBOutlet UIView *top_view;
@property (weak, nonatomic) IBOutlet UILabel *top_view_date;
@property (weak, nonatomic) IBOutlet UILabel *top_view_phase;
@property (weak, nonatomic) IBOutlet UIImageView *top_view_clock;

//Middle Image
@property (weak, nonatomic) IBOutlet UIImageView *place_image;

//Title_view
@property (weak, nonatomic) IBOutlet UIView *title_view;
@property (weak, nonatomic) IBOutlet UILabel *title_view_lbl;
@property (weak, nonatomic) IBOutlet UIImageView *price1_img;
@property (weak, nonatomic) IBOutlet UIImageView *price2_img;
@property (weak, nonatomic) IBOutlet UIImageView *price3_img;
@property (weak, nonatomic) IBOutlet UIImageView *price4_img;
@property (weak, nonatomic) IBOutlet UILabel *freelbl;

//like_view
@property (weak, nonatomic) IBOutlet UIButton *likeBtn;
@property (weak, nonatomic) IBOutlet UIButton *dislikeBtn;

//Desc View
@property (weak, nonatomic) IBOutlet UIView *desc_view;


//phone_view
@property (weak, nonatomic) IBOutlet UIButton *phone_btn;

//site_view
@property (weak, nonatomic) IBOutlet UIButton *site_btn;


@property (weak, nonatomic) IBOutlet Event *event;
@property (weak, nonatomic) IBOutlet DayPhase *phase;

@end
