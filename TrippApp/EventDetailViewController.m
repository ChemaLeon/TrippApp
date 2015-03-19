//
//  EventDetailViewController.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-23.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "EventDetailViewController.h"
#import "BackGroundManager.h"
#import "DateHelper.h"
#import <SKTag.h>
#import <Masonry/Masonry.h>
#import <SKTagView.h>
#import "APIServiceManager.h"

@interface EventDetailViewController ()

@end

@implementation EventDetailViewController

SKTagView * tagsView;
NSArray * tags;
NSString *const getLocationTags = @"getLocationTags";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeNotifications];
    
    [APIServiceManager getTagsForLocation:_event.location_id withObserver:getLocationTags];
    
    self.eventBG.image = [BackGroundManager getBGImage];
    
    //top view Config
    _top_view.backgroundColor = [UIColor colorWithRed:33/255.0 green:134/255.0 blue:193/255.0 alpha:0.5];
    _top_view_clock.image = _phase.clock;
    UIFont *futura = [UIFont fontWithName:@"Futura-Medium" size:20];
    _top_view_phase.font = futura;
    _top_view_phase.text = _phase.phase_name;
    _top_view_date.font = futura;
    _top_view_date.text = [DateHelper formatStrDatetoShow: _event.event_date];
    
    _place_image.image = _event.event_img;
    
    //title view config
    _title_view.backgroundColor = [UIColor colorWithRed:10/255.0 green:10/255.0 blue:10/255.0 alpha:0.85];
    _title_view_lbl.font = futura;
    _title_view_lbl.text = [_event.name uppercaseString];
    
    if(_event.price != nil)
    {
        if([_event.price intValue] > 0)
        {
            _price1_img.hidden = NO;
            if([_event.price intValue] > 1)
            {
                _price2_img.hidden = NO;
                if([_event.price intValue] > 2)
                {
                    _price3_img.hidden = NO;
                    if([_event.price intValue] > 3)
                    {
                        _price4_img.hidden = NO;
                    }
                }
            }
        }
        if([_event.price intValue] > 4)
        {
            _freelbl.hidden = NO;
        }
    }
    
   
    
    //rate view
    UIImageView* likeImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 5, 35, 36)];
    likeImage.image = [UIImage imageNamed:@"like"];
    [_likeBtn addSubview:likeImage];
    _event.like = @"1529";
    [_likeBtn setTitle:_event.like forState:UIControlStateNormal];
    _likeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _likeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    UIImageView* dislikeImage = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 35, 36)];
    dislikeImage.image = [UIImage imageNamed:@"dislike"];
    [_dislikeBtn addSubview:dislikeImage];
    _event.dislike = @"21";
    [_dislikeBtn setTitle:_event.dislike forState:UIControlStateNormal];
    _dislikeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _dislikeBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 40);
    
    //phone view
    if([_event.phone length] != 0)
    {
        [_phone_btn setTitle:_event.phone forState:UIControlStateNormal];
    }
    else
    {
        [_phone_btn setTitle:@"N/A" forState:UIControlStateNormal];
    }
    
    
    //web view
    if([_event.website length] != 0)
    {
        [_site_btn setTitle:_event.website forState:UIControlStateNormal];
    }
    else
    {
        [_site_btn setTitle:@"N/A" forState:UIControlStateNormal];
    }
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)callPhone:(id)sender {
    
    if([_event.phone length] != 0)
    {
        NSString* phone = [NSString stringWithFormat:@"telprompt://%@", _event.phone];
        NSURL *url = [ [ NSURL alloc ] initWithString: phone];
        
        [[UIApplication sharedApplication] openURL:url];
    }
    
}
- (IBAction)accessWebpage:(id)sender {
    
    if([_event.website length] != 0)
    {
        NSURL *url = [ [ NSURL alloc ] initWithString: _event.website ];
    
        [[UIApplication sharedApplication] openURL:url];
    }
}

- (void)setupTagView
{
    tagsView = ({
        SKTagView *view = [SKTagView new];
        view.backgroundColor = [UIColor clearColor];
        view.padding    = UIEdgeInsetsMake(5, 15, 0, 0);
        view.insets    = 5;
        view.lineSpace = 4;
        //            __weak SKTagView *weakView = view;
        //Handle tag's click event
        view.didClickTagAtIndex = ^(NSUInteger index){
            //Remove tag
            //[weakView removeTagAtIndex:index];
        };
        view;
    });
    [self.desc_view addSubview:tagsView];
    [tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
        UIView *superView = _desc_view;
        make.center.equalTo(superView);
        make.leading.equalTo(superView.mas_leading);
        make.trailing.equalTo(superView.mas_trailing);
    }];
    
    //Add Tags
    [tags enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         SKTag *tag = [SKTag tagWithText:obj];
         tag.textColor = UIColor.whiteColor;
         tag.bgColor = [UIColor colorWithRed:33/255.0 green:134/255.0 blue:193/255.0 alpha:0.8];
         tag.cornerRadius = 3;
         tag.fontSize = 15;
         tag.padding = UIEdgeInsetsMake(13.5, 12.5, 13.5, 12.5);
         
         [tagsView addTag:tag];
     }];
    
}

#pragma mark Notifications
- (void) initializeNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTagsNotification:) name:getLocationTags object:nil];
    
}

-(void) receivedTagsNotification:(NSNotification*) notification
{
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        tags = [theData objectForKey:@"tags"];
        [self setupTagView];
    }
    
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
