//
//  ShopBoomCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShopBoomCell.h"
#import "ShopCartDataModel.h"
#import "ShopCartModel.h"

@interface ShopBoomCell()<UITextFieldDelegate>

@end

@implementation ShopBoomCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}


- (void)setUp{

    NSArray *titeArr = @[@"优惠券",@"买家留言"];
    for (int i = 0; i<3; i++) {
        UIView *lineView =[BaseViewFactory viewWithFrame:CGRectMake(0, 50*i, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [self.contentView addSubview:lineView];
        if (i<2) {
            UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(20, 50*i, 70, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:titeArr[i]];
             [self.contentView addSubview:lab];
        }
    }
    
    UIImageView *rightImageView = [BaseViewFactory icomWithWidth:10 imagePath:@"right"];
    [self.contentView addSubview:rightImageView];
    rightImageView.frame =CGRectMake(ScreenWidth - 30, 17, 10, 16);
    
    _beizhuTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(90, 50, ScreenWidth - 120, 50) font:APPFONT(13) placeholder:@"(选填)对本次交易的说明" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    [self.contentView addSubview:_beizhuTxt];
    

    _moneyLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 100, ScreenWidth-20, 50) textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"共2件商品  小计:￥276.00"];
    [self.contentView addSubview:_moneyLab];
    NSString *str1 = @"共两件商品  小计:";
    NSRange range1 = [_moneyLab.text rangeOfString:str1];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:_moneyLab.text];
    [str addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(PlaColorValue) range:range1];
    _moneyLab.attributedText = str;

    

}

- (void)setModel:(ShopCartDataModel *)model{
    _model = model;
    _beizhuTxt.text = _model.memo;
    _moneyLab.text = [NSString stringWithFormat:@"共%lu件商品  小计:￥%.2f",(unsigned long)_model.cartItems.count,[_model.money floatValue]];

}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    _model.memo = textField.text;
    return YES;
}

@end
