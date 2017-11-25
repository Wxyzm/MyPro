//
//  SearchProductCollectionCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SearchProductCollectionCell.h"
#import "UIImageView+WebCache.h"
#import "UIView+SDAutoLayout.h"
#import "ItemsModel.h"

@implementation SearchProductCollectionCell
-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        self.layer.cornerRadius = 5;
        self.clipsToBounds = YES;

        [self setup];
    }
    return self;
}

-(void)setup
{
    _productFace = [UIImageView new];
    _productFace.contentMode = UIViewContentModeScaleAspectFill;
    _productFace.clipsToBounds = YES;
    
    _backImageView = [UIImageView new];
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.clipsToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"result_background"];
    
    
    _productNameL = [UILabel new];
    _productNameL.font = FSYSTEMFONT(13);
    _productNameL.numberOfLines = 2;
    _productNameL.textColor = UIColorFromRGB(0x000000);
    _productNameL.text = @"";
    _priceL = [UILabel new];
    _priceL.font = FSYSTEMFONT(13);
    _priceL.numberOfLines = 1;
    _priceL.textColor = UIColorFromRGB(RedColorValue);
    _priceL.text = @"";

    _buyNumberL = [UILabel new];
    _buyNumberL.font = FSYSTEMFONT(13);
    _buyNumberL.numberOfLines = 1;
    _buyNumberL.textColor = UIColorFromRGB(BlackColorValue);
//    _buyNumberL.text = @"已有10人购买";
    _buyNumberL.textAlignment = NSTextAlignmentRight;
    
    _comL = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(11) textAligment:NSTextAlignmentLeft andtext:@""];
    _imageview  = [BaseViewFactory icomWithWidth:16 imagePath:@"per-idn"];
    
    UIView *line = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(LineColorValue)];
    
    NSArray *views = @[_productFace,_productNameL,_priceL,_buyNumberL,_comL,_imageview,line,_backImageView];
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    UIView *contentView = self.contentView;
    if (iPad) {
        _productFace.sd_layout.rightSpaceToView(contentView,0).leftSpaceToView(contentView,0).topSpaceToView(contentView,0).heightIs(180*TimeScaleY);
        _productNameL.sd_layout.rightSpaceToView(contentView,10).leftSpaceToView(contentView,10).topSpaceToView(_productFace,13).autoHeightRatio(0);
        _priceL.sd_layout.widthIs((ScreenWidth-36)/4).leftSpaceToView(contentView,10).topSpaceToView(_productFace,63).heightIs(14);
        _buyNumberL.sd_layout.widthIs((ScreenWidth-36)/4).rightSpaceToView(contentView,10).topSpaceToView(_productNameL,13).heightIs(14);
        line.sd_layout.leftEqualToView(_priceL).topSpaceToView(_priceL,10).rightSpaceToView(contentView,10).heightIs(1);
        _imageview.sd_layout.leftEqualToView(_priceL).topSpaceToView(line,10).widthIs(16).heightIs(16);
        _comL.sd_layout.leftSpaceToView(_imageview,5).topSpaceToView(line,10).rightSpaceToView(contentView,10).heightIs(16);
        _backImageView.sd_layout.rightSpaceToView(contentView,0).leftSpaceToView(contentView,0).topSpaceToView(contentView,0).heightIs(180*TimeScaleY);
    }else{
        _productFace.sd_layout.rightSpaceToView(contentView,0).leftSpaceToView(contentView,0).topSpaceToView(contentView,0).heightIs(180);
        _productNameL.sd_layout.rightSpaceToView(contentView,10).leftSpaceToView(contentView,10).topSpaceToView(_productFace,13).autoHeightRatio(0);
        _priceL.sd_layout.widthIs((ScreenWidth-36)/4).leftSpaceToView(contentView,10).topSpaceToView(_productFace,63).heightIs(14);
        _buyNumberL.sd_layout.widthIs((ScreenWidth-36)/4).rightSpaceToView(contentView,10).topSpaceToView(_productNameL,13).heightIs(14);
        line.sd_layout.leftEqualToView(_priceL).topSpaceToView(_priceL,10).rightSpaceToView(contentView,10).heightIs(1);
        _imageview.sd_layout.leftEqualToView(_priceL).topSpaceToView(line,10).widthIs(16).heightIs(16);
        _comL.sd_layout.leftSpaceToView(_imageview,5).topSpaceToView(line,10).rightSpaceToView(contentView,10).heightIs(16);
        _backImageView.sd_layout.rightSpaceToView(contentView,0).leftSpaceToView(contentView,0).topSpaceToView(contentView,0).heightIs(180);
    }
    
}

-(void)setDataDic:(NSDictionary *)dataDic{

    if (dataDic[@"image_url"]) {
        NSString *url = dataDic[@"image_url"];
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_productFace sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_picture"]];

    }
    if (dataDic[@"title"]) {
        _productNameL.text = dataDic[@"title"];
    }
    if (dataDic[@"price"]) {
        _priceL.text = [NSString stringWithFormat:@"￥%.2f",[dataDic[@"title"] floatValue]];
    }
    _buyNumberL.hidden = YES;

}

-(void)setModel:(ItemsModel *)model{

    _model = model;
    
    if (model.imageUrl.length>0&&[model.imageUrl containsString:@"https"]) {
        NSString *url = model.imageUrl;
        url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_productFace sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_picture"]];

    }else{
        if (model.imageUrlList.count > 0) {
            NSString *url = model.imageUrlList[0];
            url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            [_productFace sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"default_picture"]];
            
        }
    }
     _productNameL.text = model.title;
     _productNameL.sd_layout.rightSpaceToView(self.contentView,10).leftSpaceToView(self.contentView,10).topSpaceToView(_productFace,13).autoHeightRatio(0);
    [_productNameL setMaxNumberOfLinesToShow:2];

    _priceL.text  =[NSString stringWithFormat:@"￥%@", model.price];
    if ([model.sales intValue]>0) {
        _buyNumberL.text = [NSString stringWithFormat:@"已购%@人",model.sales];

    }else{
        _buyNumberL.text = @"已购0人";

    }
    _comL.text = _model.shopName;
    
    if ([_model.shopCertificationType isEqualToString:@"1"]||!_model.shopCertificationType||[_model.shopCertificationType isEqualToString:@""]) {
        _imageview.image = [UIImage imageNamed:@"per-idn"];
    }else{
        _imageview.image = [UIImage imageNamed:@"business-icon"];

    }

}


@end
