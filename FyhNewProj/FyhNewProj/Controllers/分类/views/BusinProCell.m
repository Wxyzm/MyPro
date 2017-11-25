//
//  BusinProCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BusinProCell.h"
#import "ItemsModel.h"

@implementation BusinProCell
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
    _productFace.contentMode = UIViewContentModeScaleToFill;
    _productFace.clipsToBounds = YES;

    _backImageView = [UIImageView new];
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.clipsToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"result_background"];
    
    
    _productNameL = [UILabel new];
    _productNameL.font = APPFONT(14);
    _productNameL.numberOfLines = 2;
    _productNameL.textColor = UIColorFromRGB(0x000000);

    _priceL = [UILabel new];
    _priceL.font = APPFONT(15);
    _priceL.numberOfLines = 1;
    _priceL.textColor = UIColorFromRGB(RedColorValue);

    _buyNumberL = [UILabel new];
    _buyNumberL.font = APPFONT(12);
    _buyNumberL.numberOfLines = 1;
    _buyNumberL.textColor = UIColorFromRGB(BlackColorValue);
    _buyNumberL.textAlignment = NSTextAlignmentRight;

    _imageview  = [BaseViewFactory icomWithWidth:16 imagePath:@"buy"];
    NSArray *views = @[_productFace,_productNameL,_priceL,_buyNumberL,_imageview,_backImageView];
    [views enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [self.contentView addSubview:obj];
    }];
    UIView *contentView = self.contentView;
    if (iPad) {
        _productFace.sd_layout.rightSpaceToView(contentView,0).leftSpaceToView(contentView,0).topSpaceToView(contentView,0).heightIs(180*TimeScaleY);
        _backImageView.sd_layout.rightSpaceToView(contentView,0).leftSpaceToView(contentView,0).topSpaceToView(contentView,0).heightIs(180*TimeScaleY);


    }else{
        _productFace.sd_layout.rightSpaceToView(contentView,0).leftSpaceToView(contentView,0).topSpaceToView(contentView,0).heightIs(180);
        _backImageView.sd_layout.rightSpaceToView(contentView,0).leftSpaceToView(contentView,0).topSpaceToView(contentView,0).heightIs(180);

    }
    _productNameL.sd_layout.rightSpaceToView(contentView,10).leftSpaceToView(contentView,10).topSpaceToView(_productFace,10).heightIs(15);
    _priceL.sd_layout.leftSpaceToView(contentView,10).topSpaceToView(_productNameL,10).heightIs(15);
    [_priceL setSingleLineAutoResizeWithMaxWidth:(ScreenWidth-36)/4];
    _buyNumberL.sd_layout.leftSpaceToView(_priceL,8).topEqualToView(_priceL).heightIs(15);
    [_buyNumberL setSingleLineAutoResizeWithMaxWidth:(ScreenWidth-36)/4];
    _imageview.sd_layout.rightSpaceToView(contentView,10).bottomSpaceToView(contentView,8).widthIs(25).heightIs(25);

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
    
    _priceL.text  =[NSString stringWithFormat:@"￥%@", model.price];
    if ([model.sales intValue]>0) {
        _buyNumberL.text = [NSString stringWithFormat:@"已购%@人",model.sales];
        
    }else{
        _buyNumberL.text = @"已购0人";
        
    }
    
       
}

@end
