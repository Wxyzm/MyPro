//
//  UserOrderBoomCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserOrderBoomCell.h"
#import "UserOrder.h"
#import "OrderItems.h"
#import "OrderSellerItems.h"
#import "OrderOtherModel.h"
#import "OrderOtherItemModel.h"

@implementation UserOrderBoomCell{
    CGRect leftButtonFrame;
    CGRect rightButtonFrame;
    NSInteger   _selfType;

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
    rightButtonFrame = CGRectMake(ScreenWidth - 90, 45, 70, 30);
    _payBtn = [SubBtn buttonWithtitle:@"付款" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(payBtnClick) andframe:rightButtonFrame];
    _payBtn.titleLabel.font = APPFONT(12);
    [self.contentView  addSubview:_payBtn];
    
    leftButtonFrame = CGRectMake(ScreenWidth-180, 45, 70, 30);
    _cancleBtn = [SubBtn buttonWithtitle:@"取消订单" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(cancleBtnClick)];
    _cancleBtn.frame = leftButtonFrame;
    _cancleBtn.titleLabel.font = APPFONT(12);
    [self.contentView addSubview:_cancleBtn];

    UIView *topLine = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topLine];

    UIView *topLine1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 39, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topLine1];
    
    
    _traLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LineColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_traLab];

    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_priceLab];
    
    _numbrLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_numbrLab];



}
-(void)setModel:(UserOrder *)model{
    _model = model;
    _selfType = 0;

    CGFloat TraAmout = 0.00f;
    NSInteger  goodsNumber = 0;
    for (int i = 0 ; i<model.sellerItemOrders.count; i++) {
        OrderSellerItems *itemsModel = model.sellerItemOrders[i];
        for (OrderItems *item in itemsModel.itemOrders) {
            if ([item.itemId integerValue] == -1) {
                TraAmout+= [item.payAmount floatValue];
            }else{
                goodsNumber += [item.quantity integerValue];
            }
        }
    }
    _traLab.text = [NSString stringWithFormat:@"(含运费%.2f)",TraAmout];
    _priceLab.text = [NSString stringWithFormat:@"￥%@",model.payAmount];
    _numbrLab.text = [NSString stringWithFormat:@"共%ld件商品，小计：",(long)goodsNumber];
    
    _traLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,0).heightIs(40);
    [_traLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _priceLab.sd_layout.rightSpaceToView(_traLab,0).topSpaceToView(self.contentView,0).heightIs(40);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _numbrLab.sd_layout.rightSpaceToView(_priceLab,0).topSpaceToView(self.contentView,0).heightIs(40);
    [_numbrLab setSingleLineAutoResizeWithMaxWidth:200];

    OrderSellerItems *itemsModel = model.sellerItemOrders[0];
    OrderItems *item = itemsModel.itemOrders[0];
    switch ([item.status intValue]) {
        case 0:{
            //未付款
            [self showButton:self.cancleBtn withTitle:@"取消订单" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"付款" frame:rightButtonFrame];

            break;
        }
        case 1:{
            //已支付，待发货
            self.cancleBtn.hidden = YES;
            self.payBtn.hidden = YES;
            break;
        }
        case 2:{
             //卖家已发货
            [self showButton:self.cancleBtn withTitle:@"查看物流" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"确认收货" frame:rightButtonFrame];

            break;
        }
        case 3:{
            //交易成功   ，确认收货后
            [self showButton:self.cancleBtn withTitle:@"查看物流" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"评价" frame:rightButtonFrame];
            break;
        }
        case 4:{
            //交易关闭
            [self showButton:self.cancleBtn withTitle:@"删除订单" frame:rightButtonFrame];
            self.payBtn.hidden = YES;

            break;
        }
        default:
            break;
    }
    

}



- (void)payBtnClick{
    
    if (_selfType == 0) {
        OrderSellerItems *itemsModel = _model.sellerItemOrders[0];
        OrderItems *item = itemsModel.itemOrders[0];
        if ([self.delegate respondsToSelector:@selector(didselectedBoomCellPayBtnWithType:andModel:)]) {
            [self.delegate didselectedBoomCellPayBtnWithType:[item.status intValue] andModel:_model];
        }
    }else if (_selfType == 1){
        if ([self.delegate respondsToSelector:@selector(waitAcceptdidselectedUserOrderOneCellPayBtnWithModel:)]) {
            [self.delegate waitAcceptdidselectedUserOrderOneCellPayBtnWithModel:_otherModel];
        }
    }
    
}

- (void)cancleBtnClick{
    if (_selfType == 0) {
        OrderSellerItems *itemsModel = _model.sellerItemOrders[0];
        OrderItems *item = itemsModel.itemOrders[0];
        if ([self.delegate respondsToSelector:@selector(didselectedBoomCellCancleBtnWithType:andModel:)]) {
            [self.delegate didselectedBoomCellCancleBtnWithType:[item.status intValue] andModel:_model];
        }
    }else if (_selfType == 1){
        if ([self.delegate respondsToSelector:@selector(waitAcceptdidselectedUserOrderOneCellCancleBtnWithModel:)]) {
            [self.delegate waitAcceptdidselectedUserOrderOneCellCancleBtnWithModel:_otherModel];
        }
    }
    



}

- (void)showButton:(UIButton*)button withTitle:(NSString*)title frame:(CGRect)frame
{
    button.hidden = NO;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
}


-(void)setOtherModel:(OrderOtherModel *)otherModel{

    _otherModel = otherModel;
    _selfType = 1;

    CGFloat payAmount = 0.00f;
    NSInteger  goodsNumber = 0;
    
    for (int i = 0 ; i<otherModel.itemOrders.count; i++) {
        OrderOtherItemModel *itemsModel = otherModel.itemOrders[i];
        payAmount += [itemsModel.payAmount floatValue];
        goodsNumber += [itemsModel.quantity integerValue];
    }
    _traLab.text =@"(含运费0.00)" ;
    _priceLab.text = [NSString stringWithFormat:@"￥%.2f",payAmount];
    _numbrLab.text = [NSString stringWithFormat:@"共%ld件商品，小计：",(long)goodsNumber];
    
    _traLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,0).heightIs(40);
    [_traLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _priceLab.sd_layout.rightSpaceToView(_traLab,0).topSpaceToView(self.contentView,0).heightIs(40);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _numbrLab.sd_layout.rightSpaceToView(_priceLab,0).topSpaceToView(self.contentView,0).heightIs(40);
    [_numbrLab setSingleLineAutoResizeWithMaxWidth:200];

    [self showButton:self.cancleBtn withTitle:@"查看物流" frame:leftButtonFrame];
    [self showButton:self.payBtn withTitle:@"确认收货" frame:rightButtonFrame];


}


@end
