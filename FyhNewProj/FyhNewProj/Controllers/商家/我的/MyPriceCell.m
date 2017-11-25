//
//  MyPriceCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/26.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyPriceCell.h"
#import "MyPriceModel.h"

@implementation MyPriceCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
        [self.contentView addSubview:topView];
        
    }

    return self;
}


- (void)setUP{

    _faceImage  = [[UIImageView alloc]init];
    _faceImage.frame = CGRectMake(20, 22, 20, 20);
    [self.contentView addSubview:_faceImage];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _nameLab.numberOfLines = 0;
    [self.contentView addSubview:_nameLab];
    
    _stateLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_stateLab];


    _kindLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_kindLab];

    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_priceLab];

    _timeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_timeLab];

}

-(void)setModel:(MyPriceModel *)model{

    _model = model;
    NSDictionary *infoDic = model.purchasingNeed;
    NSArray *imageArr = infoDic[@"imageUrlList"];
    if (imageArr.count >0) {
        [_faceImage sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"loding"]];

    }
    NSString *stateStr;
    _nameLab.text = infoDic[@"title"];
    
    if ([model.status intValue] == 1) {
        stateStr   = @"状态：报价中";
    }else{
        stateStr   = @"状态：已接受";

    }
    NSMutableAttributedString *AttriStr = [[NSMutableAttributedString alloc]initWithString:stateStr];
    [AttriStr addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(BlackColorValue) range:NSMakeRange(0, 3)];
    _stateLab.attributedText = AttriStr;
    
    _kindLab.text = [NSString stringWithFormat:@"分类：%@",infoDic[@"categoryName"]];
    
    _priceLab.text = [NSString stringWithFormat:@"%@/%@",model.price,infoDic[@"unit"]];
    
   
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    [formatter setDateFormat:@"YYYY-MM-dd"]; // （@"YYYY-MM-dd hh:mm:ss"）----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"Asia/Beijing"];
    
    [formatter setTimeZone:timeZone];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[model.createTime integerValue]];
    
    NSString *confromTimespStr = [formatter stringFromDate:confromTimesp];
    _timeLab.text = confromTimespStr;
    
    _faceImage.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,22).widthIs(80).heightIs(80);
    _priceLab.sd_layout.rightSpaceToView(self.contentView,20).topSpaceToView(self.contentView,22).widthIs(80).heightIs(14);

    _nameLab.sd_layout.leftSpaceToView(_faceImage,10).topEqualToView(_faceImage).rightSpaceToView(_priceLab,5).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
    _kindLab.sd_layout.leftEqualToView(_nameLab).bottomEqualToView(_faceImage).rightEqualToView(_nameLab).heightIs(14);
    _stateLab.sd_layout.leftEqualToView(_nameLab).bottomSpaceToView(_kindLab,10).rightEqualToView(_nameLab).heightIs(14);
    
    _timeLab.sd_layout.rightEqualToView(_priceLab).bottomEqualToView(_kindLab).widthIs(100).heightIs(14);
    
}



@end
