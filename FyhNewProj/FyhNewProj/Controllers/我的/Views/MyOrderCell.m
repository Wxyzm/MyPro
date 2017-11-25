//
//  MyOrderCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyOrderCell.h"

@implementation MyOrderCell{

 


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

    
    _picture = [[UIImageView alloc]init];
    [self.contentView addSubview:_picture];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"清仓大甩卖清仓大甩卖清仓大甩卖贱卖隔壁妖艳贱货陈瑶，走过路过不要错过了"];
    _nameLab.numberOfLines = 2;
    _colorLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"颜色：薄荷绿；状态：现货；"];
    _kindLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"类型：大货"];
    _nowPriceLab  = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"￥69.00"];
    _oldPriceLab  = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"￥99.00"];
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:_nowPriceLab.text];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger:1] range:strRange];
    [_nowPriceLab setAttributedText:str];
    _numberLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"X2"];
    [self.contentView addSubview:_nameLab];
    [self.contentView addSubview:_colorLab];
    [self.contentView addSubview:_kindLab];
    [self.contentView addSubview:_oldPriceLab];
    [self.contentView addSubview:_nowPriceLab];
    [self.contentView addSubview:_numberLab];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 1)];
    [self.contentView addSubview:line];
    line.backgroundColor = UIColorFromRGB(PlaColorValue);
    
}

-(void)layoutSubviews{

    
    _picture.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _nowPriceLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,9).widthIs(70).heightIs(16);
    _oldPriceLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(_nowPriceLab,10).widthIs(70).heightIs(14);

    _nameLab.sd_layout.leftSpaceToView(_picture,20).topEqualToView(_picture).rightSpaceToView(_nowPriceLab,5).heightIs(36);
    
    _kindLab.sd_layout.leftEqualToView(_nameLab).bottomEqualToView(_picture).rightEqualToView(_nameLab).heightIs(14);
    _colorLab.sd_layout.leftEqualToView(_nameLab).bottomSpaceToView(_kindLab,5).rightEqualToView(self.contentView).heightIs(14);

    _numberLab.sd_layout.rightEqualToView(_oldPriceLab).bottomEqualToView(_kindLab).widthIs(100).heightIs(16);

}





@end
