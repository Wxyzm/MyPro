//
//  AcceptAdressCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AcceptAdressCell.h"
#import "SellerOrderModel.h"
#import "itemOrdersDataModel.h"
@implementation AcceptAdressCell

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
    _faceView = [[UIImageView alloc]init];
    [self.contentView addSubview:_faceView];
    _faceView.image = [UIImage imageNamed:@"position"];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"收货人："];
    [self.contentView addSubview:_nameLab];
    
    _phoneLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_phoneLab];
    
    _adressLab  = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"收货地址："];
    [self.contentView addSubview:_adressLab];
    
}


-(void)setAdressDic:(NSDictionary *)adressDic{

    _adressDic = adressDic;
    _nameLab.text =[NSString stringWithFormat:@"收货人：%@", NULL_TO_NIL(adressDic[@"consigneeName"])] ;
    _phoneLab.text = NULL_TO_NIL(adressDic[@"mobile"]) ;
    _adressLab.text = [NSString stringWithFormat:@"%@-%@-%@  %@",NULL_TO_NIL(adressDic[@"provinceName"]),NULL_TO_NIL(adressDic[@"cityName"]),NULL_TO_NIL(adressDic[@"areaName"]),NULL_TO_NIL(adressDic[@"consigneeAddress"])];
    
    _faceView.sd_layout.leftSpaceToView(self.contentView,20).centerYEqualToView(self.contentView).widthIs(20).heightIs(20);
    _nameLab.sd_layout.leftSpaceToView(_faceView,10).topSpaceToView(self.contentView,10).widthIs(200).heightIs(14);
    _phoneLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(200).heightIs(14);
    _adressLab.sd_layout.leftSpaceToView(_faceView,10).topSpaceToView(_nameLab,8).widthIs(ScreenWidth - 70).autoHeightRatio(0);
    [_adressLab setMaxNumberOfLinesToShow:2];

}

-(void)setModel:(SellerOrderModel *)model{
    _model = model;
    itemOrdersDataModel *itemModel;
    for (itemOrdersDataModel *item in model.itemOrdersData) {
        if ([item.itemId intValue]!= -1) {
            itemModel = item;
        }
    }
    NSDictionary *adressDic= itemModel.userOrderAddress;
    _nameLab.text =[NSString stringWithFormat:@"收货人：%@", NULL_TO_NIL(adressDic[@"consigneeName"])] ;
    _phoneLab.text = NULL_TO_NIL(adressDic[@"mobile"]) ;
    _adressLab.text = [NSString stringWithFormat:@"%@-%@-%@  %@",NULL_TO_NIL(adressDic[@"provinceName"]),NULL_TO_NIL(adressDic[@"cityName"]),NULL_TO_NIL(adressDic[@"areaName"]),NULL_TO_NIL(adressDic[@"consigneeAddress"])];

    _faceView.sd_layout.leftSpaceToView(self.contentView,20).centerYEqualToView(self.contentView).widthIs(20).heightIs(20);
    _nameLab.sd_layout.leftSpaceToView(_faceView,10).topSpaceToView(self.contentView,10).widthIs(200).heightIs(14);
    _phoneLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(200).heightIs(14);
    _adressLab.sd_layout.leftSpaceToView(_faceView,10).topSpaceToView(_nameLab,8).widthIs(ScreenWidth - 70).autoHeightRatio(0);
    [_adressLab setMaxNumberOfLinesToShow:2];
}


@end
