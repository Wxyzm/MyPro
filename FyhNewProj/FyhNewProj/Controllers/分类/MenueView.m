//
//  MenueView.m
//  FyhNewProj
//
//  Created by yh f on 2017/8/21.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MenueView.h"
#import "AppDelegate.h" 
#import "DOTabBarController.h"

@interface MenueView()

@property (nonatomic, strong) UIButton      *backButton;

@property (nonatomic, strong) UIView        *sideView;      //此view上面根据ui制作


@end


@implementation MenueView{

    BOOL        _isShow;
    UIImageView *_bgImageView;
    CGFloat _Width;
    CGFloat _Height;

}
- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIView *)sideView
{
    if (!_sideView) {
        
        UIImage *bgImage = [UIImage imageNamed:@"iv_top_list"];
        CGFloat width = bgImage.size.width;
        _Width = width;
        CGFloat heigth = bgImage.size.height;
        _Height = heigth;
        _sideView = [[UIView alloc] initWithFrame:CGRectMake(ScreenWidth - _Width, 0, width, 0)];
        _sideView.clipsToBounds = YES;
        
        _bgImageView = [[UIImageView alloc]initWithImage:bgImage];
        [_sideView addSubview:_bgImageView];
        _bgImageView.frame = CGRectMake(0, 0, width, heigth);
        
        CGFloat BtnHeight = (heigth - 7)/5;
        
        NSArray *imageArr = @[@"iv_goto_home",@"iv_goto_message",@"iv_goto_person_center",@"iv_goto_shopping_cart",@"iv_goto_procurement"];
        NSArray *titleArr = @[@"首页",@"消息",@"个人中心",@"购物车",@"采购"];
        
        for (int i = 0 ; i<5; i++) {
            if (i!=0) {
                UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(5, 7+BtnHeight *i, width - 10, 1) color:UIColorFromRGB(LineColorValue)];
                [_bgImageView addSubview:lineview];
                
                

            }
            UIImageView *leftImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10,7+ (BtnHeight - 20)/2 +BtnHeight *i, 20, 20)];
            leftImageView.image = [UIImage imageNamed:imageArr[i]];
            [_bgImageView addSubview:leftImageView];
            
            UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(40, 7 +BtnHeight *i, width -40, BtnHeight) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:titleArr[i]];
            [_bgImageView addSubview:lab];
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(0, 7+BtnHeight*i, width, BtnHeight);
            btn.tag = 1000 +i;
            [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
            [_sideView addSubview:btn];

        }
        
        
    }
    return _sideView;
}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    [self addSubview:self.backButton];
    [self addSubview:self.sideView];




}
#pragma - mark public method
- (void)show
{
    if (_isShow) return;
    
    _isShow = YES;
    _sideView.frame  = CGRectMake(ScreenWidth - _Width, _OriginY, _Width, 0);

    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame = CGRectMake(ScreenWidth - _Width, _OriginY, _Width, _Height);
    }];
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
        
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame  = CGRectMake(ScreenWidth - _Width, _OriginY, _Width, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)btnClick:(UIButton *)btn{
    [self dismiss];

    
    if ([self.delegate respondsToSelector:@selector(didselectedBtnWithButton:)]) {
        [self.delegate didselectedBtnWithButton:btn];
    }
    
   

}

@end
