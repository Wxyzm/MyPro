//
//  OrderNumberCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/19.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "OrderNumberCell.h"
#import "SellerOrderModel.h"
#import "itemOrdersDataModel.h"
@implementation OrderNumberCell

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
    _numLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"订单编号："];
    [self.contentView addSubview:_numLab];
    
    _setTimeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"创建时间："];
    [self.contentView addSubview:_setTimeLab];
    
//    _payTimeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"付款时间："];
//    [self.contentView addSubview:_payTimeLab];
    
//    _sentTimeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"发货时间："];
//    [self.contentView addSubview:_sentTimeLab];

}


-(void)setModel:(SellerOrderModel *)model{
    _model = model;
    itemOrdersDataModel *item = model.itemOrdersData[0];
    _numLab.text = [NSString stringWithFormat:@"订单编号：%@",model.userOrderId];
    _setTimeLab.text = [NSString stringWithFormat:@"创建时间：%@",[self timeWithTimeIntervalString:item.createTime]];
 //   _payTimeLab.text = [NSString stringWithFormat:@"创建时间：%@",[self timeWithTimeIntervalString:item.paidTime]];

    _numLab.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).heightIs(14).widthIs(ScreenWidth-40);
    
    _setTimeLab.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(_numLab,5).heightIs(14).widthIs(ScreenWidth-40);

 //   _payTimeLab.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(_setTimeLab,5).heightIs(14).widthIs(ScreenWidth-40);

}

- (void)setOrderNumber:(NSString *)orderNumber andcreateTime:(NSString *)createTime{

    _numLab.text = [NSString stringWithFormat:@"订单编号：%@",orderNumber];
    _setTimeLab.text = [NSString stringWithFormat:@"创建时间：%@",[self timeWithTimeIntervalString:createTime]];
    //   _payTimeLab.text = [NSString stringWithFormat:@"创建时间：%@",[self timeWithTimeIntervalString:item.paidTime]];
    
    _numLab.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).heightIs(14).widthIs(ScreenWidth-40);
    
    _setTimeLab.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(_numLab,5).heightIs(14).widthIs(ScreenWidth-40);
}


- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
//    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
//    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
//    [formatter setDateStyle:NSDateFormatterMediumStyle];
//    [formatter setTimeStyle:NSDateFormatterShortStyle];
//    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    
//    // 毫秒值转化为秒
//    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
//    NSString* dateString = [formatter stringFromDate:date];
//    return dateString;
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[timeString integerValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
    
    
}
@end
