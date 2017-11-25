//
//  ShopBuyCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShopBuyCell.h"
#import "ShopCartModel.h"
@implementation ShopBuyCell

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
    UIView *lineview =[BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(PlaColorValue)   ];
    [self.contentView addSubview:lineview];
    
    _picture = [[UIImageView alloc]init];
    _picture.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_picture];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _nameLab.numberOfLines = 0;
    [self.contentView addSubview:_nameLab];
    
    _colorLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_colorLab];
    
    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_priceLab];
    
    _oldPriceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_oldPriceLab];
    
    
        
    }

-(void)setModel:(ShopCartModel *)model{
    _model = model;
    _nameLab.text = model.itemTitle;
    NSMutableString *mutStr = [[NSMutableString alloc]init];
    ShopCartitemsModel *itemModel = model.item;
    for (int i = 0; i<itemModel.specificationValues.count; i++) {
        NSDictionary *dic = itemModel.specificationValues[i];
        [mutStr appendString:[NSString stringWithFormat:@"%@  ",dic[@"name"]]];
    }
    [_picture sd_setImageWithURL:[NSURL URLWithString:itemModel.imageUrlList[0]] placeholderImage:[UIImage imageNamed:@"loding"]];
    _colorLab.text = mutStr;
    _priceLab.text = model.priceDisplay;
    _oldPriceLab.text = [NSString stringWithFormat:@"X  %@",model.quantity];
    
    _picture.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _nameLab.sd_layout.leftSpaceToView(_picture,10).topEqualToView(_picture).rightSpaceToView(self.contentView,20).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
    _colorLab.sd_layout.leftEqualToView(_nameLab).topSpaceToView(self.contentView,50).rightEqualToView(_nameLab).heightIs(14);
    
    _priceLab.sd_layout.leftEqualToView(_nameLab).bottomEqualToView(_picture).heightIs(16);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:100];
    
    
    _oldPriceLab.sd_layout.leftSpaceToView(_priceLab,10).bottomEqualToView(_picture).heightIs(14).rightSpaceToView(self.contentView,20);
    
    
    
    
}



@end
