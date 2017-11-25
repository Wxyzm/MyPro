//
//  sellerBtn.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "sellerBtn.h"

@implementation sellerBtn

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = APPFONT(13);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
//        self.badge = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/4/2+2.5, 5, 20, 20)];
//        _badge.backgroundColor = [UIColor whiteColor];
//        [_badge setTitle:@"18" forState:UIControlStateNormal];
//        _badge.titleLabel.font = APPFONT(11);
//        [_badge setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
//        _badge.layer.cornerRadius = 10;
//        _badge.layer.borderWidth = 1;
//        _badge.layer.borderColor = UIColorFromRGB(RedColorValue).CGColor;
//        _badge.layer.masksToBounds = YES;
//        //_badge.hidden = YES;
//        [self addSubview:_badge];
    }
    return self;
}




- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 36+25+12, ScreenWidth/4, 13);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(ScreenWidth/4/2-12.5, 36, 25, 25);
}

@end
