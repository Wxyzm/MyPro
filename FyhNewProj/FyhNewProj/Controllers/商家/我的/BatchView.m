//
//  BatchView.m
//  FyhNewProj
//
//  Created by yh f on 2017/8/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BatchView.h"

@interface BatchView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton      *backButton;

@property (nonatomic , strong) UIView       *sideView;

@end

@implementation BatchView{

    BOOL        _isShow;
    UIButton   *_cancleBtn;
    CGFloat     _hetght;
    UILabel    *_showLab;
    UIView     *_line1;
    UIView     *_line2;
    BOOL        isHaveDian;

}

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
#pragma mark ========= init
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
    
}
- (void)setUp{
    [self addSubview:self.backButton];
    
    _sideView = [BaseViewFactory viewWithFrame:CGRectMake(20, ScreenHeight, ScreenWidth-40, 325) color:UIColorFromRGB(WhiteColorValue)];
    _sideView.clipsToBounds = YES;
    _sideView.layer.cornerRadius = 4;
    [self addSubview:_sideView];
    
    
    
    UILabel *toplab = [BaseViewFactory labelWithFrame:CGRectMake(0, 30, _sideView.width, 18) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(16) textAligment:NSTextAlignmentCenter andtext:@"批量设置"];
    [_sideView addSubview:toplab];
    
    UIButton *closeBtn = [BaseViewFactory  buttonWithWidth:16 imagePath:@"close"];
    [_sideView addSubview:closeBtn];
    closeBtn.frame = CGRectMake(ScreenWidth-36, 17, 36, 36);
    [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    _pricetxt = [BaseViewFactory textFieldWithFrame:CGRectMake(36, 78, _sideView.width - 72, 32) font:APPFONT(13) placeholder:@"统一输入价格" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    [_sideView addSubview:_pricetxt];
    _pricetxt.layer.borderWidth = 1;
    _pricetxt.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _pricetxt.layer.cornerRadius = 4;
    _pricetxt.keyboardType = UIKeyboardTypeDecimalPad;
    [_pricetxt setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];

    _stocktxt = [BaseViewFactory textFieldWithFrame:CGRectMake(36, _pricetxt.bottom +16, _sideView.width - 72, 32) font:APPFONT(13) placeholder:@"统一输入库存" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    [_sideView addSubview:_stocktxt];
    _stocktxt.layer.borderWidth = 1;
    _stocktxt.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _stocktxt.layer.cornerRadius = 4;
    _stocktxt.keyboardType = UIKeyboardTypeNumberPad;
    [_stocktxt setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    

    
    
    _mintxt = [BaseViewFactory textFieldWithFrame:CGRectMake(36, _stocktxt.bottom +16, _sideView.width - 72, 32) font:APPFONT(13) placeholder:@"统一输入起订量" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    [_sideView addSubview:_mintxt];
    _mintxt.layer.borderWidth = 1;
    _mintxt.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _mintxt.layer.cornerRadius = 4;
    _mintxt.keyboardType = UIKeyboardTypeNumberPad;
    [_mintxt setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];

    
    _maxtxt = [BaseViewFactory textFieldWithFrame:CGRectMake(36, _mintxt.bottom +16, _sideView.width - 72, 32) font:APPFONT(13) placeholder:@"统一输入限购" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    _maxtxt.layer.borderWidth = 1;
    _maxtxt.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _maxtxt.layer.cornerRadius = 4;
    [_maxtxt setValue:[NSNumber numberWithInt:5] forKey:@"paddingLeft"];
    _maxtxt.keyboardType = UIKeyboardTypeNumberPad;

    [_sideView addSubview:_maxtxt];
    
    _showLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentCenter andtext:@"您可以只设定价格、库存、限购或起订量"];
    
    [_sideView addSubview:_showLab];

    _sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sureBtn setTitle:@"确定" forState:UIControlStateNormal];
    [_sureBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_sideView addSubview:_sureBtn];
    
    _cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [_cancleBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_cancleBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    [_sideView addSubview:_cancleBtn];
    
    _line1 = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xe6e9ed)];
    [_sideView addSubview:_line1];
    _line2 = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xe6e9ed)];
    [_sideView addSubview:_line2];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
    _stocktxt.leftView = paddingView;
    _stocktxt.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
    _pricetxt.leftView = paddingView1;
    _pricetxt.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
    _mintxt.leftView = paddingView2;
    _mintxt.leftViewMode = UITextFieldViewModeAlways;
    
    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 32)];
    _maxtxt.leftView = paddingView3;
    _maxtxt.leftViewMode = UITextFieldViewModeAlways;

}


-(void)setType:(NSInteger)type{

    _type = type;
    
    switch (type) {
        case 0:{
            _mintxt.hidden = YES;
            _maxtxt.hidden = YES;

            _hetght = 268;
           
            break;
        }
        case 1:{
            _hetght = 320;
            _maxtxt.hidden = YES;


            break;
        }
        case 2:{
            _hetght = 320;
            _mintxt.hidden = YES;
            _maxtxt.frame = CGRectMake(36, _stocktxt.bottom +16, _sideView.width - 72, 32);


            break;
        }
        case 3:{
            _mintxt.hidden = NO;
            _maxtxt.hidden = NO;
            _hetght = 372;
            _maxtxt.frame = CGRectMake(36, _mintxt.bottom +16, _sideView.width - 72, 32);

            
            
            break;
        }
        default:
            break;
    }
    
    _line1.sd_layout.leftSpaceToView(_sideView,0).bottomSpaceToView(_sideView,45).heightIs(1).widthIs(_sideView.width);
    _line2.sd_layout.leftSpaceToView(_sideView,_sideView.width/2-0.5).bottomSpaceToView(_sideView,0).widthIs(1).heightIs(44);
    _sureBtn.sd_layout.leftSpaceToView(_sideView,0).bottomSpaceToView(_sideView,0).heightIs(44).widthIs(_sideView.width/2);
    _cancleBtn.sd_layout.rightSpaceToView(_sideView,0).bottomSpaceToView(_sideView,0).heightIs(44).widthIs(_sideView.width/2);
    _showLab.sd_layout.rightSpaceToView(_sideView,0).bottomSpaceToView(_cancleBtn,26).heightIs(15).widthIs(_sideView.width);

   
}

#pragma - mark public method
- (void)showinView:(UIView *)view
{
    if (_isShow) return;
    
    _isShow = YES;
    
    [view addSubview:self];
    _sideView.frame = CGRectMake(20, ScreenHeight, ScreenWidth-40, _hetght);
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame = CGRectMake(20, (self.height -_hetght)/2-50, ScreenWidth-40, _hetght);
        
    }];
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
    
    //CGFloat duration = 0.4 * (ScreenWidth - _sideView.frame.origin.x)/_sideView.frame.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        _sideView.frame = CGRectMake(20, ScreenHeight, ScreenWidth-40, _hetght);
        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _backButton.alpha = 0.3;
    }];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == _pricetxt) {
        if ([textField.text rangeOfString:@"."].location == NSNotFound)
        {
            isHaveDian = NO;
        }else{
            isHaveDian = YES;
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
                            
                            //    [self showMyMessage:@"亲，您最多输入两位小数!"];
                            
                            return NO;
                            
                        }
                        
                    }else{
                        
                        return YES;
                        
                    }
                    
                }
                
            }else{//输入的数据格式不正确
                
                //   [self showMyMessage:@"亲，您输入的格式不正确!"];
                
                [textField.text stringByReplacingCharactersInRange:range withString:@""];
                
                return NO;
                
            }
            
        }
        
        else
            
        {
            
            return YES;
            
        }
    }
    
    return YES;
    
}

@end
