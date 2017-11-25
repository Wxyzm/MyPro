//
//  SellerTopCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SellerTopCell.h"
#import "SellerOrderModel.h"
#import "itemOrdersDataModel.h"

@implementation SellerTopCell

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
    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topView];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _nameLab.numberOfLines = 0;
    [self.contentView addSubview:_nameLab];
    
    _numberLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_numberLab];
    
    _stateLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_stateLab];
}


-(void)setModel:(SellerOrderModel *)model{

    _model = model;
    _nameLab.text = [NSString stringWithFormat:@"会员名：%@",model.buyerInfo];
    _numberLab.text = [NSString stringWithFormat:@"订单号：%@",model.userOrderId];
    
    itemOrdersDataModel *themodel;
    for (itemOrdersDataModel *itemmodel in model.itemOrdersData) {
        if ([itemmodel.itemId integerValue]!= -1) {
            themodel    = itemmodel;
            break;
        }
        
    }
    if ([themodel.status integerValue] == 1) {
        _stateLab.text = @"买家已付款";
    }else if ([themodel.status integerValue] == 0){
        _stateLab.text = @"等待买家付款";
    }else if ([themodel.status integerValue] == 4){
        _stateLab.text = @"交易关闭";
    }else if ([themodel.status integerValue] == 2){
        _stateLab.text = @"等待买家收货";
    }else if ([themodel.status integerValue] == 3){
        _stateLab.text = @"买家已收货";
    }
    
    _nameLab.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,22).rightSpaceToView(self.contentView,20).heightIs(15);
    _numberLab.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(_nameLab,0).rightSpaceToView(self.contentView,100).heightIs(15);
    _stateLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(_nameLab,0).leftSpaceToView(self.contentView,100).heightIs(15);
    
}



@end
