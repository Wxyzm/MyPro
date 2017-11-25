//
//  OfferView.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/19.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "OfferView.h"

@interface OfferView()<UITextFieldDelegate,UITextViewDelegate>

@property (nonatomic, strong) UIView        *sideView;      //此view上面根据ui制作

@property (nonatomic, strong) UIButton      *backButton;


@end

@implementation OfferView{
    
    BOOL        _isShow;
    BOOL        isHaveDian;
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
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
- (UIView *)sideView
{
    if (!_sideView) {
        _sideView = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 258)];
        _sideView.backgroundColor = [UIColor whiteColor];
        
        UIButton *backBtn = [BaseViewFactory buttonWithWidth:16 imagePath:@"need_X"];
        [backBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        [_sideView addSubview:backBtn];
        backBtn.frame = CGRectMake(ScreenWidth - 36, 15, 20, 20);
        
        UIView *moneyView = [BaseViewFactory viewWithFrame:CGRectMake(16, 50, ScreenWidth - 32, 39) color:UIColorFromRGB(WhiteColorValue)];
        moneyView.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
        moneyView.layer.borderWidth = 0.5;
        moneyView.layer.cornerRadius = 4;
        [_sideView addSubview:moneyView];
        
        UILabel *leftLab = [BaseViewFactory labelWithFrame:CGRectMake(13, 0, 65, 39) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"报价金额"];
        [moneyView addSubview:leftLab];
        
        _unitLabl = [BaseViewFactory labelWithFrame:CGRectMake(moneyView.width - 73, 0, 60, 39) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"元/米"];
        [moneyView addSubview:_unitLabl];
        
        _moneyTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(leftLab.right +10, 0, moneyView.width - leftLab.right -10 - _unitLabl.width - 15, 39) font:APPFONT(13) placeholder:@"请输入金额" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
        _moneyTxt.keyboardType = UIKeyboardTypeDecimalPad;
        _moneyTxt.clearButtonMode = UITextFieldViewModeNever;
;
        [moneyView addSubview:_moneyTxt];
        
        UIView *remarkView = [BaseViewFactory viewWithFrame:CGRectMake(16, moneyView.bottom +12, ScreenWidth - 32, 80) color:UIColorFromRGB(WhiteColorValue)];
        remarkView.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
        remarkView.layer.borderWidth = 0.5;
        remarkView.layer.cornerRadius = 4;
        [_sideView addSubview:remarkView];

        UILabel *releftLab = [BaseViewFactory labelWithFrame:CGRectMake(13, 0, 65, 42) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"备注说明"];
        [remarkView addSubview:releftLab];
        
        _remarkTxt = [[UITextView alloc]initWithFrame:CGRectMake(87, 0, remarkView.width -103, 80)];
        _remarkTxt.text = @"请输入您的报价说明不超过30字(选填)";
        _remarkTxt.delegate = self;
        _remarkTxt.font = APPFONT(13);
        _remarkTxt.textColor = UIColorFromRGB(PlaColorValue);
        [remarkView addSubview:_remarkTxt];

        
        SubBtn *setBtn = [SubBtn buttonWithtitle:@"提交报价" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(setThePrice) andframe:CGRectMake(10, remarkView.bottom + 12, remarkView.width, 50)];
        [_sideView addSubview:setBtn];
        
    }
    return _sideView;
}

#pragma - mark setter
- (void)setBaseVC:(UIViewController *)baseVC
{
    _baseVC = baseVC;
}
#pragma mark ========= UI

- (void)setUp{
    
    [self addSubview:self.backButton];
    [self addSubview:self.sideView];


}
- (void)setthetxtpLa:(NSString *)str{
    _moneyTxt.placeholder = [NSString stringWithFormat:@"采购商期望价格%@",str];

}


/**
 提交报价
 */
- (void)setThePrice{

   
    if ([self.delegate respondsToSelector:@selector(didSelectedsubmitBtn)]) {
        [self.delegate didSelectedsubmitBtn];
    }

}

#pragma - mark public method
- (void)showinView:(UIView *)view
{
    if (_isShow) return;
    
    _isShow = YES;
    
    [view addSubview:self];
    
    _sideView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 258);
    
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame = CGRectMake(0, ScreenHeight - 258, ScreenWidth, 258);
    }];
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
    
    //CGFloat duration = 0.4 * (ScreenWidth - _sideView.frame.origin.x)/_sideView.frame.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 235);
        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _backButton.alpha = 0.3;
    }];
}

#pragma mark ========= uitextviewdelegate
-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{

    if ([_remarkTxt.text isEqualToString: @"请输入您的报价说明不超过30字(选填)"]) {
        _remarkTxt.text = @"";
        _remarkTxt.textColor = UIColorFromRGB(BlackColorValue);
    }
    
    return YES;
}

-(BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (_remarkTxt.text.length<=0) {
        _remarkTxt.text = @"请输入您的报价说明不超过30字(选填)";
        _remarkTxt.textColor = UIColorFromRGB(PlaColorValue);

    }
    
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        isHaveDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0)
            {
                
                if(single == '.')
                {
                    
                    //  [self showMyMessage:@"亲，第一个数字不能为小数点!"];
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
                //                if (single == '0')
                //                {
                //
                //                 //   [self showMyMessage:@"亲，第一个数字不能为0!"];
                //
                //                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                //
                //                    return NO;
                //
                //                }
                
            }
            
            //输入的字符是否是小数点
            
            if (single == '.')
            {
                
                if(!isHaveDian)//text中还没有小数点
                {
                    
                    isHaveDian = YES;
                    
                    return YES;
                    
                }else{
                    
                    //   [self showMyMessage:@"亲，您已经输入过小数点了!"];
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
            }else{
                
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    
                    NSRange ran = [textField.text rangeOfString:@"."];
                    
                    if (range.location - ran.location <= 2) {
                        
                        return YES;
                        
                    }else{
                        
                        
                        return NO;
                        
                    }
                    
                }else{
                    
                    return YES;
                    
                }
                
            }
            
        }else{//输入的数据格式不正确
            
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            
            return NO;
            
        }
        
    }
    
    else
        
    {
        
        return YES;
        
    }
    
    
    
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@""]) {
        return YES;
    }
    if (textView.text.length >=30) {
        return NO;
    }
    return YES;
}

-(void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length >30) {
        textView.text = [textView.text substringToIndex:30];
    }
    
}

@end
