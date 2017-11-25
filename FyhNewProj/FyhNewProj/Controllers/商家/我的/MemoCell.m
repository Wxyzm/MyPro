//
//  MemoCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/19.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MemoCell.h"
#import "SellerOrderModel.h"
#import "itemOrdersDataModel.h"

@implementation MemoCell{

    UILabel *_lab;
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
    
    
    _lab = [BaseViewFactory labelWithFrame:CGRectMake(50, 10, 100, 14) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"买家留言"];
    [self.contentView addSubview:_lab];
    
    _memoLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_memoLab];
    
    _selectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.frame = CGRectZero;
    [_selectBtn setImage:[UIImage imageNamed:@"order_open"] forState:UIControlStateNormal];
    [self.contentView addSubview:_selectBtn];

}

-(void)setModel:(SellerOrderModel *)model{

    _model = model;
    itemOrdersDataModel *itemModel = model.itemOrdersData[0];
    if (itemModel.userOrderMemo.length>0) {
        _memoLab.text  = itemModel.userOrderMemo;

    }else{
     _memoLab.text  =@"买家未填写备注";
    }

    
    _faceView.sd_layout.leftSpaceToView(self.contentView,20).centerYEqualToView(self.contentView).widthIs(20).heightIs(20);

    if (model.on) {
        _memoLab.sd_layout.leftSpaceToView(_faceView,10).topSpaceToView(_lab,8).widthIs(ScreenWidth - 70).autoHeightRatio(0);
        [_memoLab setMaxNumberOfLinesToShow:0];

    }else{
        _memoLab.sd_layout.leftSpaceToView(_faceView,10).topSpaceToView(_lab,8).widthIs(ScreenWidth - 70).heightIs(14);
        [_memoLab setMaxNumberOfLinesToShow:1];
    }
    _selectBtn.sd_layout.leftSpaceToView(self.contentView,0).rightSpaceToView(self.contentView,0).bottomSpaceToView(self.contentView,0).heightIs(20);

}




@end
