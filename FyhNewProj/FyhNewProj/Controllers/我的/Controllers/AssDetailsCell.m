//
//  AssDetailsCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AssDetailsCell.h"
#import "AssetDetailModel.h"

@implementation AssDetailsCell{

    UILabel *_leftLab;
    UILabel *_priceLab;
    UILabel *_timeLab;


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

    _leftLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x444a55) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_leftLab];
    
    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x444a55) font:APPFONT(18) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_priceLab];

    _timeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(12) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_timeLab];
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineView];
    

}


-(void)setModel:(AssetDetailModel *)model{

    _model = model;
    _leftLab.text = model.name;
//    _priceLab.text = model.amount;
    _timeLab.text = [GlobalMethod returnTimeStrWith:model.createTime];
    NSString *str = [model.amount substringToIndex:1];
    if ([str isEqualToString:@"-"]) {
        _priceLab.text = model.amount;
        
    }else{
        _priceLab.text = [NSString stringWithFormat:@"+%@",model.amount];
        
    }

    
    _priceLab.sd_layout.rightSpaceToView(self.contentView, 16).topSpaceToView(self.contentView, 5).heightIs(19);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:0];
    
    _timeLab.sd_layout.rightSpaceToView(self.contentView, 16).topSpaceToView(_priceLab, 9).heightIs(13);
    [_timeLab setSingleLineAutoResizeWithMaxWidth:0];
    
    _leftLab.sd_layout.leftSpaceToView(self.contentView, 16).centerYEqualToView(self.contentView).heightIs(50).rightSpaceToView(_priceLab, 10);

}


@end
