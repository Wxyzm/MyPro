//
//  MyEvaluateCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyEvaluateCell.h"
#import "EvaModel.h"

@implementation MyEvaluateCell{

    UIView *_bommview;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(PlaColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUp];
    }
    return self;
}


- (void)setUp{
    
    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 100) color:UIColorFromRGB(WhiteColorValue)];
    [self.contentView addSubview:topView];
    
    _bommview = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    _bommview.layer.cornerRadius = 5;
    _bommview.clipsToBounds = YES;
    [self.contentView addSubview:_bommview];
    
    _picture = [[UIImageView alloc]init];
    _picture.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_picture];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"清仓大甩卖贱卖隔壁妖艳贱货陈瑶，走过路过不要错过了"];
    _nameLab.numberOfLines = 2;
    [self.contentView addSubview:_nameLab];
    
    _priceLab  = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"￥69.00"];
    [self.contentView addSubview:_priceLab];

    _evaluBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_evaluBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
    [_evaluBtn setTitle:@"好评" forState:UIControlStateNormal];
    _evaluBtn.titleLabel.font = APPFONT(15);
    [_evaluBtn setImage:[UIImage imageNamed:@"3-red"] forState:UIControlStateNormal];
    [_evaluBtn setImageRect:CGRectMake(0, 0, 16, 16)];
    [_evaluBtn setTitleRect:CGRectMake(21, 0, 40, 16)];
    [self.contentView addSubview:_evaluBtn];

    _dateLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(11) textAligment:NSTextAlignmentLeft andtext:@"2019-03-03  17:23:02"];
    [self.contentView addSubview:_dateLab];

    _evaluLab= [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊啊"];
    [self.contentView addSubview:_evaluLab];
    
    
    _picture.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _nameLab.sd_layout.leftSpaceToView(_picture,20).topEqualToView(_picture).rightSpaceToView(self.contentView,20).heightIs(36);
    _priceLab.sd_layout.leftSpaceToView(_picture,20).topSpaceToView(_nameLab,5).rightSpaceToView(self.contentView,20).heightIs(16);
    _evaluBtn.sd_layout.leftSpaceToView(_picture,20).bottomEqualToView(_picture).widthIs(70).heightIs(16);
    
    _dateLab.sd_layout.leftEqualToView(_picture).topSpaceToView(_picture,20).widthIs(200).heightIs(12);

    _dateLab.sd_layout.leftEqualToView(_picture).topSpaceToView(_picture,20).widthIs(200).heightIs(12);

    _evaluLab.sd_layout.leftSpaceToView(self.contentView,30).topSpaceToView(_dateLab,23).rightSpaceToView(self.contentView,30).heightIs(20);
    
    
    
}


-(void)setModel:(EvaModel *)model{

    _model = model;
    _evaluLab.text = model.evaStr;
    _evaluLab.numberOfLines = 0;
    _evaluLab.sd_layout.autoHeightRatio(0);
    _evaluLab.backgroundColor = UIColorFromRGB(WhiteColorValue);
    CGFloat height2 = [self getSpaceLabelHeight:_evaluLab.text withFont:APPFONT(13) withWidth:ScreenWidth-70];
//    UIView *bommview = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
//    [self.contentView addSubview:bommview];
//    bommview.sd_layout.leftSpaceToView(_evaluLab,0).topSpaceToView(_evaluLab,0).rightSpaceToView(_evaluLab,0).heightIs(1);
    _bommview.sd_layout.leftEqualToView(_picture).rightSpaceToView(self.contentView,20).topSpaceToView(_dateLab,13).heightIs(height2+20);

    // view1使用高度根据子view内容自适应，所以不需要设置高度，而是设置实现高度根据内容自适应
    [self setupAutoHeightWithBottomView:_evaluLab bottomMargin:23];
}


-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width
{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    // paraStyle.lineSpacing = 8; 行距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 0) options:\
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.height;
}
@end
