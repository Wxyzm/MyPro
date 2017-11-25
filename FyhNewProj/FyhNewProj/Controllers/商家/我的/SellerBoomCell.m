//
//  SellerBoomCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SellerBoomCell.h"
#import "SellerOrderModel.h"
#import "itemOrdersDataModel.h"

@implementation SellerBoomCell{
    CGRect leftButtonFrame;
    CGRect rightButtonFrame;
}

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
    UIView *topLine = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topLine];
    
    UIView *topLine1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 39, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topLine1];
    
    rightButtonFrame = CGRectMake(ScreenWidth - 90, 45, 70, 30);
    _payBtn = [SubBtn buttonWithtitle:@"确认发货" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(payBtnClick) andframe:rightButtonFrame];
    _payBtn.titleLabel.font = APPFONT(13);
    [self.contentView addSubview:_payBtn];
    
    leftButtonFrame = CGRectMake(ScreenWidth-180, 45, 70, 30);
    _cancleBtn = [SubBtn buttonWithtitle:@"联系买家" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(cancleBtnClick)];
    _cancleBtn.frame = leftButtonFrame;
    _cancleBtn.titleLabel.font = APPFONT(13);
    [self.contentView addSubview:_cancleBtn];
    
    _traLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LineColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_traLab];
    
    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_priceLab];
    
    _numbrLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_numbrLab];
}

-(void)setModel:(SellerOrderModel *)model{
    
    _model = model;
    
    CGFloat TraAmout = 0.00f;
    CGFloat payAmount = 0.00f;
    NSInteger  goodsNumber = 0;
    
    itemOrdersDataModel *theModel;
    for (int i = 0 ; i<model.itemOrdersData.count; i++) {
        itemOrdersDataModel *itemsModel = model.itemOrdersData[i];
        payAmount += [itemsModel.payAmount floatValue];
        if ([itemsModel.itemId intValue]!= -1) {
            goodsNumber++;
            theModel = itemsModel;
        }else{
            TraAmout += [itemsModel.payAmount floatValue];
        }
    }
    _traLab.text = [NSString stringWithFormat:@"(含运费%.2f)",TraAmout];
    _priceLab.text = [NSString stringWithFormat:@"￥%.2f",payAmount];
    _numbrLab.text = [NSString stringWithFormat:@"共%ld件商品，小计：",(long)goodsNumber];
    model.payAmount = [NSString stringWithFormat:@"%.2f",payAmount];
    _traLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,0).heightIs(40);
    [_traLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _priceLab.sd_layout.rightSpaceToView(_traLab,0).topSpaceToView(self.contentView,0).heightIs(40);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _numbrLab.sd_layout.rightSpaceToView(_priceLab,0).topSpaceToView(self.contentView,0).heightIs(40);
    [_numbrLab setSingleLineAutoResizeWithMaxWidth:200];
    
    
    switch ([theModel.status intValue]) {
        case 0:{
            //未付款
            [self showButton:self.cancleBtn withTitle:@"联系买家" frame:rightButtonFrame];
            self.payBtn.hidden = YES;
            self.Type = 0;
            break;
        }
        case 1:{
            //已支付，待发货
            [self showButton:self.cancleBtn withTitle:@"联系买家" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"确认发货" frame:rightButtonFrame];
            self.Type = 1;
            break;
        }
        case 2:{
             [self showButton:self.cancleBtn withTitle:@"联系买家" frame:rightButtonFrame];
            self.payBtn.hidden = YES;
            self.Type = 2;
            break;
        }
        case 3:{
            [self showButton:self.payBtn withTitle:@"查看物流" frame:rightButtonFrame];
            self.cancleBtn.hidden = YES;
            self.Type = 3;
            break;
        }
        case 4:{
            [self showButton:self.cancleBtn withTitle:@"联系买家" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"删除订单" frame:rightButtonFrame];
            self.Type = 4;
            break;
        }
        default:
            break;
    }
    
}




- (void)payBtnClick{
    if ([self.delegate respondsToSelector:@selector(didSelectedPayBtnWithCell:)]) {
        [self.delegate didSelectedPayBtnWithCell:self];
    }
    
}

- (void)cancleBtnClick{
    if ([self.delegate respondsToSelector:@selector(didSelectedCancleBtnWithCell:)]) {
        [self.delegate didSelectedCancleBtnWithCell:self];
    }
}
- (void)showButton:(UIButton*)button withTitle:(NSString*)title frame:(CGRect)frame
{
    button.hidden = NO;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
}

@end
