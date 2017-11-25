//
//  SellerTopview.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SellerTopview.h"

@implementation SellerTopview

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self setUP];
    }
    
    return self;
}


- (void)setUP{
    
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = self.bounds;
    //  gradientLayer.cornerRadius = 10;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)UIColorFromRGB(0x1d69f1).CGColor,
                             (id)UIColorFromRGB(0x1c9cf6).CGColor,
                             (id)UIColorFromRGB(0x1ad1fc).CGColor];
    //  设置三种颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@(0.1f) ,@(0.5f),@(1.0f)];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  添加渐变色到创建的 UIView 上去
    [self.layer addSublayer:gradientLayer];
    
    _faceImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    _faceImageView.layer.cornerRadius = 40;
    _faceImageView.image = [UIImage imageNamed:@"member-big"];
    _faceImageView.clipsToBounds = YES;
    _faceImageView.contentMode =  UIViewContentModeScaleAspectFill;

    [self addSubview:_faceImageView];
    _faceImageView.sd_layout.leftSpaceToView(self,20).bottomSpaceToView(self,20).widthIs(80).heightIs(80);
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(18) textAligment:NSTextAlignmentLeft andtext:@""];
    [self addSubview:_nameLab];
    _nameLab.sd_layout.leftSpaceToView(_faceImageView,10).bottomSpaceToView(self,60).widthIs(ScreenWidth - 130).heightIs(20);
    
    UIImageView *vipImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    vipImageView.image  = [UIImage imageNamed:@"bus-din-white"];
    vipImageView.layer.cornerRadius = 8;
    vipImageView.clipsToBounds = YES;
    [self addSubview:vipImageView];
    vipImageView.sd_layout.leftEqualToView(_nameLab).bottomSpaceToView(self,35).widthIs(16).heightIs(16);
    
    
    _vipLab = [BaseViewFactory labelWithFrame:CGRectMake(131, 116.5, ScreenWidth-135, 13) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"普通会员"];
    [self addSubview:_vipLab];
    _vipLab.sd_layout.centerYEqualToView(vipImageView).leftSpaceToView(vipImageView,5).widthIs(ScreenWidth - 150).heightIs(14);
    
}


@end
