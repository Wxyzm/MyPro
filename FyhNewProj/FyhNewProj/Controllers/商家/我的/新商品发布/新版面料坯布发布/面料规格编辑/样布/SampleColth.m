//
//  SampleColth.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SampleColth.h"
#import "SampleColthModel.h"

@interface SampleColth ()<UITextFieldDelegate>



@end

@implementation SampleColth

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        [self setUp];
    }
    
    return self;
}

- (void)setUp
{
    UIView *topView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 0, ScreenWidth, 9) color:UIColorFromRGB(0xf5f7fa)];
    [self addSubview:topView];
    
    UIView *line1 = [BaseViewFactory  viewWithFrame:CGRectMake(0, 0, ScreenWidth, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [topView addSubview:line1];
    
    UIView *line2 = [BaseViewFactory  viewWithFrame:CGRectMake(0, 8.5, ScreenWidth, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [topView addSubview:line2];
    
    UIView *line3 = [BaseViewFactory  viewWithFrame:CGRectMake(62,9, 0.5, 96) color:UIColorFromRGB(0xe6e9ed)];
    [self addSubview:line3];
    
    UIView *line4= [BaseViewFactory  viewWithFrame:CGRectMake(62, 57, ScreenWidth, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [self addSubview:line4];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 9, 62, 96) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"样布"];
    [self addSubview:_nameLab];
    
    
    
    UILabel *titleLab1 = [BaseViewFactory labelWithFrame:CGRectMake(77, 9, 35, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"单价"];
    [self addSubview:titleLab1];
    
   
    
    UILabel *titleLab3 = [BaseViewFactory labelWithFrame:CGRectMake(77, 57, 35, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"库存"];
    [self addSubview:titleLab3];
    
    CGFloat TxtWIdth =ScreenWidth - 120-16;
    
    _priceTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(120, 9, TxtWIdth, 48) font:APPFONT(15) placeholder:@"请输入单价" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    _priceTxt.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTxt.textAlignment = NSTextAlignmentRight;

    [self addSubview:_priceTxt];
    
  
    
    
    _stockTxt  = [BaseViewFactory textFieldWithFrame:CGRectMake(120, 57, TxtWIdth, 48) font:APPFONT(15) placeholder:@"请输入数量" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    _stockTxt.keyboardType = UIKeyboardTypeNumberPad;
    _stockTxt.textAlignment = NSTextAlignmentRight;

    [self addSubview:_stockTxt];

}

-(void)setClothModel:(SampleColthModel *)clothModel{
    _clothModel = clothModel;
    _priceTxt.text = clothModel.price;
    _stockTxt.text = clothModel.stock;
}


-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField == _priceTxt) {
        if (![_clothModel.price isEqualToString:_priceTxt.text]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];

        }
        _clothModel.price = _priceTxt.text;
    }else if (_stockTxt){
        if (![_clothModel.stock isEqualToString:_stockTxt.text]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];
            
        }
        _clothModel.stock = _stockTxt.text;
    }
}


@end
