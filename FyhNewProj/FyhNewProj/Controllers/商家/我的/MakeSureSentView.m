//
//  MakeSureSentView.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MakeSureSentView.h"
#import "SellerOrderModel.h"
@interface MakeSureSentView()<UITextFieldDelegate>

@property (nonatomic , strong) UIView       *payWaiView;

@property (nonatomic, strong) UIButton      *backButton;

@end


@implementation MakeSureSentView{
    
    BOOL        _isShow;
    
}
- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backButton.backgroundColor = [UIColor blackColor];
        _backButton.alpha = 0.3;
    }
    return _backButton;
}

#pragma mark ========= init
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
    
}
- (void)setUp{
    [self addSubview:self.backButton];
    
    _payWaiView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 200) color:UIColorFromRGB(WhiteColorValue)];
    [self addSubview:_payWaiView];
    
    UIButton *closeBtn = [BaseViewFactory  buttonWithWidth:16 imagePath:@"close"];
    [_payWaiView addSubview:closeBtn];
    closeBtn.frame = CGRectMake(ScreenWidth-26, 10, 16, 16);
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(10, 35, ScreenWidth - 20, 40) color:UIColorFromRGB(WhiteColorValue)];
    topView.layer.cornerRadius = 5;
    topView.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    topView.layer.borderWidth = 1;
    [_payWaiView addSubview:topView];

    UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectMake(10, 0, 80, 40) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"物流公司"];
    [topView addSubview:nameLab];
    _traNametxt  =  [BaseViewFactory textFieldWithFrame:CGRectMake(100, 0, topView.width -110 , 40) font:APPFONT(15) placeholder:@"请输入物流公司" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    [topView addSubview:_traNametxt];
    
    UIView *boomView = [BaseViewFactory viewWithFrame:CGRectMake(10, 85, ScreenWidth - 20, 40) color:UIColorFromRGB(WhiteColorValue)];
    boomView.layer.cornerRadius = 5;
    boomView.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    boomView.layer.borderWidth = 1;
    [_payWaiView addSubview:boomView];
    
    UILabel *numberLab = [BaseViewFactory labelWithFrame:CGRectMake(10, 0, 80, 40) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"配送单号"];
    [boomView addSubview:numberLab];
    _traNumbertxt  =  [BaseViewFactory textFieldWithFrame:CGRectMake(100, 0, topView.width -110 , 40) font:APPFONT(15) placeholder:@"请输入配送单号" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    [boomView addSubview:_traNumbertxt];
    
    SubBtn *sureBtn = [SubBtn buttonWithtitle:@"确认" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(sureBtnClick) andframe:CGRectMake(10, 135, ScreenWidth - 20, 50)];
    sureBtn.titleLabel.font = APPFONT(15);
    [_payWaiView addSubview:sureBtn];
    
    
}




- (void)sureBtnClick{
    if (_traNametxt.text.length <=0) {
        [self showtheTextHud:@"请输入物流公司"];
        return;
    }
    if (_traNumbertxt.text.length <=0) {
        [self showtheTextHud:@"请输入配送单号"];
        return;
    }
    
    if ([self.delegate respondsToSelector:@selector(DidSelectedMakeSureSentViewMakeSureBtnWithModel:)]) {
        [self dismiss];
        [self.delegate DidSelectedMakeSureSentViewMakeSureBtnWithModel:_model];
    }
    
    

}


#pragma - mark public method
- (void)showinView:(UIView *)view
{
    if (_isShow) return;
    
    _isShow = YES;
    
    [view addSubview:self];
    _payWaiView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _payWaiView.frame = CGRectMake(0, ScreenHeight-200-NaviHeight64, ScreenWidth, 200);
        
    }];
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
    
    //CGFloat duration = 0.4 * (ScreenWidth - _sideView.frame.origin.x)/_sideView.frame.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        _payWaiView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _backButton.alpha = 0.3;
    }];
}



- (void)showtheTextHud:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    // [hud hide:YES afterDelay:1.5];
    [hud hideAnimated:YES afterDelay:1.5];
}
@end
