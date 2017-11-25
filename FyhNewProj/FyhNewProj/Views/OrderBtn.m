//
//  OrderBtn.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "OrderBtn.h"

@implementation OrderBtn



-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel.font = APPFONT(13);
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        
        self.badge = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/5/2+2.5, 5, 20, 20)];
        _badge.backgroundColor = [UIColor whiteColor];
        [_badge setTitle:@"0" forState:UIControlStateNormal];
        _badge.titleLabel.font = APPFONT(11);
        [_badge setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
        _badge.layer.cornerRadius = 10;
        _badge.layer.borderWidth = 1;
        _badge.layer.borderColor = UIColorFromRGB(RedColorValue).CGColor;
        _badge.layer.masksToBounds = YES;
        //_badge.hidden = YES;
        [self addSubview:_badge];
    }
    return self;
}


- (void)setThebadgeNumber:(NSString *)numStr{

    [_badge setTitle:numStr forState:UIControlStateNormal];

    if ([numStr intValue]>99) {
        [_badge setTitle:@"99+" forState:UIControlStateNormal];
        _badge.frame = CGRectMake(ScreenWidth/5/2+2.5, 5, 30, 20);
    }else{
        _badge.frame = CGRectMake(ScreenWidth/5/2+2.5, 5, 20, 20);

    }


}




- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, 26+25+10, ScreenWidth/5, 13);
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(ScreenWidth/5/2-12.5, 15, 25, 25);
}

@end
