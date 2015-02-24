//
//  BackGroundManager.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-23.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "BackGroundManager.h"

@implementation BackGroundManager


+ (UIImage *)getBGImage
{
    NSArray* _bgImgs = @[@"bg01",@"bg02",@"bg04",@"bg07",@"bg010",@"bg012",@"bg013"];
    
    NSUInteger randomIndex = arc4random() % [_bgImgs count];

    return [UIImage imageNamed:_bgImgs[randomIndex]];
}



@end
