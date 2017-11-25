//
//  ConnectBuyerCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ConnectBuyerCell.h"
#import "SellerOrderModel.h"
@implementation ConnectBuyerCell{

    UIButton  *_connectBtn;

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
    
    UIView *topView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topView];
    _faceView = [[UIImageView alloc]init];
    [self.contentView addSubview:_faceView];
    _faceView.image = [UIImage imageNamed:@"goto_message"];
    
    _connectLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"联系卖家"];
    [self.contentView addSubview:_connectLab];
    
    _freightLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"运费："];
    [self.contentView addSubview:_freightLab];

    _payLab  = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"实付款："];
    [self.contentView addSubview:_payLab];
    
    _connectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_connectBtn];
    [_connectBtn addTarget:self action:@selector(connectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)setModel:(SellerOrderModel *)model{

    _model = model;
    _freightLab.text = [NSString stringWithFormat:@"运费：%@",model.logisticsAmount];
    _payLab.text = [NSString stringWithFormat:@"实付款：%.2f",[model.payAmount floatValue]+[model.logisticsAmount floatValue]];
    
    _connectLab.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,42).heightIs(14);
    [_connectLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _connectBtn.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView, 0).rightEqualToView(_connectLab);
    
    _faceView.sd_layout.centerXEqualToView(_connectLab).topSpaceToView(self.contentView,15).widthIs(20).heightIs(20);

    _freightLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(200).heightIs(15);
    _payLab.sd_layout.rightSpaceToView(self.contentView,20).bottomSpaceToView(self.contentView,10).widthIs(200).heightIs(15);

}


- (void)setTheLogPay:(CGFloat )logPay andAmountPay:(CGFloat )amountPay{

    _freightLab.text = [NSString stringWithFormat:@"运费：%.2f",logPay];
    _payLab.text = [NSString stringWithFormat:@"实付款：%.2f",amountPay];
    
    _faceView.sd_layout.leftSpaceToView(self.contentView,20).centerYEqualToView(self.contentView).widthIs(20).heightIs(20);

    _connectLab.sd_layout.leftSpaceToView(_faceView,10).centerYEqualToView(self.contentView).heightIs(14);
    [_connectLab setSingleLineAutoResizeWithMaxWidth:200];
    _connectBtn.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView, 0).rightEqualToView(_connectLab);

    
    _freightLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(200).heightIs(15);
    _payLab.sd_layout.rightSpaceToView(self.contentView,20).bottomSpaceToView(self.contentView,10).widthIs(200).heightIs(15);
}



- (void)connectBtnClick{

    if ( [self.delegate respondsToSelector:@selector(didselectedconnectbtnWithId: andsellinfo:)]) {
        if (_accountId) {
            [self.delegate didselectedconnectbtnWithId:_accountId andsellinfo:_sellerinfo];

        }
    }


}


@end
