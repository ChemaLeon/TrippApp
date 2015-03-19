//
//  SettingsViewController.m
//  TrippApp
//
//  Created by Chema Leon on 2015-01-13.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "SettingsViewController.h"
#import "APIServiceManager.h"
#import "GlobalsManager.h"
#import <SKTag.h>
#import <Masonry/Masonry.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController

NSArray * lifestyles;
NSArray * tags;
NSArray * tastes;
NSArray *numbers;
NSString *const getUserTags = @"getUserTags";
NSString *const getUserTastes = @"getUserTastes";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initializeNotifications];
    
    [APIServiceManager getTagsFromUser:[GlobalsManager sharedInstance].userKey withObserver:getUserTags];
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setBounces:NO];
    _tableView.backgroundColor = [UIColor clearColor];
    
    [self initLifeStyles];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) initLifeStyles{
    
    lifestyles = @[@"Tourism",@"Sport",@"Food",@"Party",@"Culture"];
    
}

#pragma mark TableView

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return lifestyles.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellIdentifier = @"tasteCell";
    UITableViewCell *cell = (UITableViewCell *) [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
//    cell.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:240/255.0 alpha:0.8];
    
    CGRect frame = CGRectMake(150, 20, 200, 20);
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    slider.continuous = YES;
    numbers = @[@(0), @(1), @(2), @(3), @(4), @(5), @(6), @(7), @(8), @(9), @(10)];
    NSInteger numberOfSteps = ((float)[numbers count] - 1);
    slider.maximumValue = numberOfSteps;
    slider.minimumValue = 0;
    
    //Event Name
    UILabel* lifestyleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, 200, 20)];
    UIFont *futura = [UIFont fontWithName:@"Futura-Medium" size:20];
    lifestyleLabel.font = futura;
    lifestyleLabel.numberOfLines = 0;
    lifestyleLabel.textColor = [UIColor whiteColor];
    lifestyleLabel.text = [lifestyles objectAtIndex:[indexPath row]];
    lifestyleLabel.tag = [indexPath row];
    
    [cell.contentView addSubview:lifestyleLabel];
    [cell.contentView addSubview:slider];
    
    return cell;
}

#pragma mark Slider

-(void)sliderAction:(id)sender
{
    UISlider *slider = (UISlider*)sender;
    NSUInteger index = (NSUInteger)(slider.value + 0.5);
    [slider setValue:index animated:NO];
    NSNumber *value = numbers[index];
    NSString* lifestyle;
    switch (slider.tag) {
        case 0:
            lifestyle = @"turist";
            break;

        case 1:
            lifestyle = @"sport";
            break;

        case 2:
            lifestyle = @"food";
            break;
            
        case 3:
            lifestyle = @"party";
            break;

        case 4:
            lifestyle = @"culture";
            break;

        default:
            return;
            break;

    }
    
    [APIServiceManager updateUserTaste:lifestyle withValue:value forUser:[GlobalsManager sharedInstance].userKey withObserver:getUserTags];
    
    
    //-- Do further actions
}

#pragma mark TagView

- (void)setupTagView
{
        [self.tagsView removeFromSuperview];
        self.tagsView = nil;
        self.tagsView = ({
            SKTagView *view = [SKTagView new];
            view.backgroundColor = [UIColor clearColor];
            view.padding    = UIEdgeInsetsMake(10, 25, 10, 25);
            view.insets    = 5;
            view.lineSpace = 2;
//            __weak SKTagView *weakView = view;
            //Handle tag's click event
            view.didClickTagAtIndex = ^(NSUInteger index){
                //Remove tag
                //[weakView removeTagAtIndex:index];
            };
            view;
        });
        [self.tagView addSubview:self.tagsView];
        [self.tagsView mas_makeConstraints:^(MASConstraintMaker *make) {
            UIView *superView = self.tagView;
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
             
             [self.tagsView addTag:tag];
         }];
    
}


#pragma mark Notifications
- (void) initializeNotifications{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedTagsNotification:) name:getUserTags object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receivedUserTasteNotification:) name:getUserTastes object:nil];
    
}

-(void) receivedTagsNotification:(NSNotification*) notification
{
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        tags = [theData objectForKey:@"tags"];
        [self setupTagView];
    }
    
}

-(void) receivedUserTasteNotification:(NSNotification*) notification
{
    NSDictionary *theData = [notification userInfo];
    if (theData != nil) {
        tastes = [theData objectForKey:@"tastes"];
        

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
