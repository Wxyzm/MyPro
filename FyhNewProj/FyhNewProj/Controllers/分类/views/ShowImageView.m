//
//  ShowImageView.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/9.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShowImageView.h"
#import "UIView+Layout.h"

@implementation ShowImageView


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        _imageView = [[UIImageView alloc] init];
        _imageView.backgroundColor = [UIColor colorWithWhite:1.000 alpha:0.500];
        _imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageView];
        self.clipsToBounds = YES;
        _imageView.frame = self.bounds;

        _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_deleteBtn setImage:[UIImage imageNamed:@"photo_delete"] forState:UIControlStateNormal];
        _deleteBtn.frame = CGRectMake(self.tz_width - 36, 0, 36, 36);
        _deleteBtn.imageEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, -10);
        _deleteBtn.alpha = 0.6;
        [self addSubview:_deleteBtn];

    

    }


    return self;
}

@end
