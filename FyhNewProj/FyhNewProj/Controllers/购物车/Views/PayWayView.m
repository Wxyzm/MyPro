//
//  PayWayView.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "PayWayView.h"

@interface PayWayView()

@property (nonatomic, strong) UIButton      *backButton;

@property (nonatomic , strong) UIView       *payWaiView;

@end


@implementation PayWayView{ 

    BOOL        _isShow;
    NSMutableArray  *_btnArr;

}
- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backButton.backgroundColor = [UIColor blackColor];
        _backButton.alpha = 0.3;
//        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}



#pragma mark ========= init
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        _btnArr = [NSMutableArray arrayWithCapacity:0];
        _isAilPayWay = YES;
        [self setUp];
    }
    return self;
    
}
- (void)setUp{
    [self addSubview:self.backButton];
    
    _payWaiView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 250) color:UIColorFromRGB(WhiteColorValue)];
    [self addSubview:_payWaiView];
    
    UILabel *toplab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, ScreenWidth, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"请选择支付方式"];
    [_payWaiView addSubview:toplab];
    
    UIButton *closeBtn = [BaseViewFactory  buttonWithWidth:16 imagePath:@"close"];
    [_payWaiView addSubview:closeBtn];
    closeBtn.frame = CGRectMake(ScreenWidth-36, 17, 16, 16);
    [closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    NSArray *imageArr = @[@"pay_alipay",@"pay_weixin"];
    NSArray *titleArr = @[@"支付宝",@"微信支付"];
    for (int i = 0; i<2; i++) {
        UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 50*(i+1)-1,  ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [_payWaiView addSubview:line];

        UIImageView *imageview = [BaseViewFactory icomWithWidth:20 imagePath:imageArr[i]];
        imageview.frame = CGRectMake(20, 12.5+50*(i+1), 25, 25);
        [_payWaiView addSubview:imageview];
        
        UILabel *titleLab = [BaseViewFactory labelWithFrame:CGRectMake(55, 50*(i+1), 200, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:titleArr[i]];
        [_payWaiView addSubview:titleLab];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth - 40, 15+50*(i+1), 20, 20);
        [_payWaiView addSubview:btn];
        [_btnArr addObject:btn];
        if (i == 0) {
            [btn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
        }else{
            [btn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
        }
        
        UIButton *topBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        topBtn.frame = CGRectMake(0, 50*(i+1), ScreenWidth, 50);
        topBtn.tag = 1000+i;
        [topBtn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
        [_payWaiView addSubview:topBtn];
        
        
    }
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 149,  ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [_payWaiView addSubview:line];
    
    
    
    
    SubBtn *comBtn = [SubBtn buttonWithtitle:@"完成" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(comBtnClick) andframe:CGRectMake(0, 200, ScreenWidth, 50)];
    [_payWaiView addSubview:comBtn];
}



- (void)btnclick:(UIButton *)btn{
//    [btn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
    if (btn.tag == 1000) {
        _isAilPayWay = YES;
        UIButton *btn0 = _btnArr[0];
        [btn0 setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];

        UIButton *btn1 = _btnArr[1];
        [btn1 setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];

    }else{
        
        _isAilPayWay = NO;
        UIButton *btn0 = _btnArr[0];
        [btn0 setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
        UIButton *btn1 = _btnArr[1];
        [btn1 setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
    }
    
    
}


- (void)comBtnClick{

    
    if ([self.delegate respondsToSelector:@selector(didSelectedSetUpBtn)]) {
        [self.delegate didSelectedSetUpBtn];
    }
    
    [self dismiss];
}


- (void)closeBtnClick{
    if ([self.delegate respondsToSelector:@selector(didSelectedCloseBtn)]) {
        [self.delegate didSelectedCloseBtn];
    }
    
    [self dismiss];


}

#pragma - mark public method
- (void)showinView:(UIView *)view
{
    if (_isShow) return;
    
    _isShow = YES;
    
    [view addSubview:self];
    _payWaiView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 250);
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _payWaiView.frame = CGRectMake(0, ScreenHeight-250-NaviHeight64, ScreenWidth, 250);
        
    }];
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
    
    //CGFloat duration = 0.4 * (ScreenWidth - _sideView.frame.origin.x)/_sideView.frame.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        _payWaiView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 250);
        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _backButton.alpha = 0.3;
    }];
}



@end
