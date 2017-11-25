//
//  AddUnitView.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AddUnitView.h"

#define ViewWidth   305

@interface AddUnitView()<UITextFieldDelegate>

@property (nonatomic, strong) UIView        *sideView;      //此view上面根据ui制作

@property (nonatomic, strong) UIButton      *backButton;


@end

@implementation AddUnitView{

    BOOL        _isShow;

}

-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
    
}
#pragma mark ========= 控件
- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backButton.backgroundColor = [UIColor blackColor];
        _backButton.alpha = 0.3;
       // [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIView *)sideView
{
    if (!_sideView) {
        _sideView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ViewWidth, 155)];
        _sideView.backgroundColor = [UIColor whiteColor];
        _sideView.layer.cornerRadius = 5;
        _sideView.clipsToBounds = YES;
        
        UIButton *backBtn = [BaseViewFactory buttonWithWidth:16 imagePath:@"close"];
        [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_sideView addSubview:backBtn];
        backBtn.frame = CGRectMake(ViewWidth - 28, 12, 16, 16);
        
        UILabel *topLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 20, 305, 18) textColor:UIColorFromRGB(0x434a54) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext:@"输入规格名称"];
        [_sideView addSubview:topLab];
        
        _unitTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(20, 58, 275, 34) font:APPFONT(15) placeholder:@"" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
        _unitTxt.layer.cornerRadius = 5;
        _unitTxt.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
        _unitTxt.layer.borderWidth = 1;
        [_sideView addSubview:_unitTxt];
        
        UIButton *cancleBtn = [BaseViewFactory buttonWithFrame:CGRectMake(0, 115, 152.5, 40) font:APPFONT(15) title:@"取消" titleColor:UIColorFromRGB(WhiteColorValue) backColor:UIColorFromRGB(LineColorValue)];
        [cancleBtn addTarget:self action:@selector(cancleBtnclick) forControlEvents:UIControlEventTouchUpInside];
        [_sideView addSubview:cancleBtn];
        SubBtn *doneBtn = [SubBtn buttonWithtitle:@"确定" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(doneBtnclick) andframe:CGRectMake(152.5, 115, 152.5, 40)];
        [_sideView addSubview:doneBtn];
        
    }
    return _sideView;
}
#pragma mark ========= UI

- (void)setUp{
    
    [self addSubview:self.backButton];
    [self addSubview:self.sideView];
    
    
}
#pragma - mark setter
//- (void)setBaseVC:(UIViewController *)baseVC
//{
//    _baseVC = baseVC;
//}


-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    
    return YES;
}

#pragma - mark public method
- (void)showinView:(UIView *)view
{
    if (_isShow) return;
    _unitTxt.text = @"";
    _isShow = YES;
    
    [view addSubview:self];
    
    _sideView.frame = CGRectMake((ScreenWidth - ViewWidth)/2, ScreenHeight, ViewWidth, 155);
    
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame = CGRectMake((ScreenWidth - ViewWidth)/2,200, ViewWidth, 155);
    }];
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
    
    //CGFloat duration = 0.4 * (ScreenWidth - _sideView.frame.origin.x)/_sideView.frame.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame = CGRectMake((ScreenWidth - ViewWidth)/2, ScreenHeight, ViewWidth, 155);
        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _backButton.alpha = 0.3;
    }];
}

/**
 确定
 */
- (void)doneBtnclick{
    
    
        if (_unitTxt.text.length>5) {
            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"最多输入5个字";
            hud.margin = 10.0f;
            hud.removeFromSuperViewOnHide = YES;
            // [hud hide:YES afterDelay:1.5];
            [hud hideAnimated:YES afterDelay:1.5];
                return ;
        }
    if (_unitTxt.text.length<=0) {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.label.text = @"新增属性不能为空";
        hud.margin = 10.0f;
        hud.removeFromSuperViewOnHide = YES;
        // [hud hide:YES afterDelay:1.5];
        [hud hideAnimated:YES afterDelay:1.5];
        return ;
    }
    if (self.type == 0) {
        //kind
        if ([self.delegate respondsToSelector:@selector(didSelectedaddkindBtnwithtext:)]) {
            [self.delegate didSelectedaddkindBtnwithtext:_unitTxt.text];
        }
    }else{
        //unit
        if ([self.delegate respondsToSelector:@selector(didSelectedaddunitBtnwithtext:)]) {
            [self.delegate didSelectedaddunitBtnwithtext:_unitTxt.text];
        }
    
    }
    

    [self dismiss];

    

}

/**
 取消
 */
- (void)cancleBtnclick{
    [self dismiss];

    
}
@end
