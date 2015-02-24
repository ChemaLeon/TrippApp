//
//  UIMapTableView.m
//  TrippApp
//
//  Created by Vitor Pires Pena on 2015-02-19.
//  Copyright (c) 2015 Chema Leon. All rights reserved.
//

#import "UIMapTableView.h"

@implementation UIMapTableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    id hitView = [super hitTest:point withEvent:event];
    if (point.y<0) {
        return nil;
    }
    return hitView;
}

@end
