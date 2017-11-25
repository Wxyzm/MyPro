//
//  SampleCardView.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SampleCardView.h"
#import "SampleCardModel.h"
@interface SampleCardView ()<UITextFieldDelegate>



@end

@implementation SampleCardView

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
    
    UIView *line3 = [BaseViewFactory  viewWithFrame:CGRectMake(62, 9, 0.5, 144) color:UIColorFromRGB(0xe6e9ed)];
    [self addSubview:line3];
    
    UIView *line4 = [BaseViewFactory  viewWithFrame:CGRectMake(62, 57, ScreenWidth, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [self addSubview:line4];
    
    UIView *line5 = [BaseViewFactory  viewWithFrame:CGRectMake(62, 105, ScreenWidth, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [self addSubview:line5];
    
    UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 9, 62, 144) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"样卡"];
    [self addSubview:nameLab];
    
    
    
    UILabel *titleLab1 = [BaseViewFactory labelWithFrame:CGRectMake(77, 9, 35, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"单价"];
    [self addSubview:titleLab1];
    
    UILabel *titleLab2 = [BaseViewFactory labelWithFrame:CGRectMake(77, 57, 35, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"限购"];
    [self addSubview:titleLab2];
    
    UILabel *titleLab3 = [BaseViewFactory labelWithFrame:CGRectMake(77, 105, 35, 48) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"库存"];
    [self addSubview:titleLab3];
    
    CGFloat TxtWIdth =ScreenWidth - 120-16;
    
    _priceTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(120, 9, TxtWIdth, 48) font:APPFONT(15) placeholder:@"请输入单价" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    _priceTxt.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTxt.textAlignment = NSTextAlignmentRight;
    [self addSubview:_priceTxt];
    
    _limTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(120, 57, TxtWIdth, 48) font:APPFONT(15) placeholder:@"请输入数量" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    _limTxt.keyboardType = UIKeyboardTypeNumberPad;
    _limTxt.textAlignment = NSTextAlignmentRight;
    [self addSubview:_limTxt];
    
    
    _stockTxt  = [BaseViewFactory textFieldWithFrame:CGRectMake(120, 105, TxtWIdth, 48) font:APPFONT(15) placeholder:@"请输入数量" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    _stockTxt.keyboardType = UIKeyboardTypeNumberPad;
    _stockTxt.textAlignment = NSTextAlignmentRight;

    [self addSubview:_stockTxt];
    
}


-(void)setCardModel:(SampleCardModel *)cardModel{
    
    _cardModel = cardModel;
    _priceTxt.text = cardModel.price;
    _limTxt.text = cardModel.limitBuy;
    _stockTxt.text = cardModel.stock;
    
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _priceTxt) {
        if (![_cardModel.price isEqualToString:_priceTxt.text]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];
            
        }
        _cardModel.price = _priceTxt.text;
    }else if (textField == _limTxt){
        if (![_cardModel.limitBuy isEqualToString:_limTxt.text]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];
            
        }
        _cardModel.limitBuy = _limTxt.text;
    }else if (textField == _stockTxt){
        if (![_cardModel.stock isEqualToString:_stockTxt.text]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];
            
        }
        _cardModel.stock = _stockTxt.text;
    }

}



@end
