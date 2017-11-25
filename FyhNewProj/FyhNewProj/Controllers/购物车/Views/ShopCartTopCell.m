//
//  ShopCartTopCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShopCartTopCell.h"
#import "ShopCartDataModel.h"

@implementation ShopCartTopCell{

    UILabel         *_nameLab;
    UIImageView     *_rightImageView;
    UIImageView     *_facImage;
    UIView *_lineview1;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        [self setUp];
    }
    return self;
}


- (void)setUp{
    
//    UIView *lineview =[BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 12) color:UIColorFromRGB(PlaColorValue)   ];
//    [self.contentView addSubview:lineview];
    
    _lineview1=[BaseViewFactory viewWithFrame:CGRectMake(ScreenWidth-55, 10, 1, 20) color:UIColorFromRGB(LineColorValue)   ];
    [self.contentView addSubview:_lineview1];

    _selectBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_selectBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
    [_selectBtn setImageRect:CGRectMake(10, 10, 20, 20)];
    [self.contentView addSubview:_selectBtn];
    if (iPhone5) {
        _selectBtn.frame = CGRectMake(0, 0, 40, 40);

    }else{
        _selectBtn.frame = CGRectMake(10, 0, 40, 40);

    }
    [_selectBtn addTarget:self action:@selector(selectBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _facImage= [BaseViewFactory icomWithWidth:20 imagePath:@"icon-shop"];
    _facImage.frame = CGRectMake(50, 10, 20, 20);
    [self.contentView addSubview:_facImage];

    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext: @""];
    [self.contentView addSubview:_nameLab];
    _nameLab.sd_layout.leftSpaceToView(_facImage,5).topEqualToView(_selectBtn).heightIs(40);
    [_nameLab setSingleLineAutoResizeWithMaxWidth:0];
    
    _rightImageView = [BaseViewFactory icomWithWidth:10 imagePath:@"right"];
    [self.contentView addSubview:_rightImageView];
    _rightImageView.sd_layout.leftSpaceToView(_nameLab,10).centerYEqualToView(_selectBtn).heightIs(16).widthIs(10);

    
   

    _receiveBtn =  [YLButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_receiveBtn];
    [_receiveBtn setTitle:@"领券" forState:UIControlStateNormal];
    [_receiveBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _receiveBtn.frame = CGRectMake(ScreenWidth-90, 0, 35, 40);
    _receiveBtn.titleLabel.font =APPFONT(11);
    [_receiveBtn addTarget:self action:@selector(receiveBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    _editBtn =  [YLButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_editBtn];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _editBtn.titleLabel.font =APPFONT(11);
    _editBtn.frame = CGRectMake(ScreenWidth-55, 0, 35, 40);
    [_editBtn addTarget:self action:@selector(editBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _shopBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_shopBtn];
    _shopBtn.frame = CGRectZero;
    [_shopBtn addTarget:self action:@selector(theshopBtnClick) forControlEvents:UIControlEventTouchUpInside];
}


- (void)sdlayoutBuyTopView{
    
    _lineview1.hidden = YES;
    _receiveBtn.hidden = YES;
    _editBtn.hidden = YES;
    _facImage.frame = CGRectMake(20, 10, 20, 20);
    _nameLab.sd_layout.leftSpaceToView(_facImage,5).centerYEqualToView(self.contentView).heightIs(40);
    _rightImageView.sd_layout.rightSpaceToView(self.contentView,15).centerYEqualToView(_selectBtn).heightIs(16).widthIs(10);

    
    _shopBtn.frame = CGRectMake(20, 12, ScreenWidth-40, 40);

}

- (void)theshopBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(shopGoTopShopBtnClick:)]) {
        [self.delegate shopGoTopShopBtnClick:self];
    }
    
}
- (void)receiveBtnClick{
    if ([self.delegate respondsToSelector:@selector(shopTopReceiveBtnClick:)]) {
        [self.delegate shopTopReceiveBtnClick:self];
    }
    
}
- (void)editBtnBtnClick{
    _model.edit = !_model.edit;
    if (_model.edit) {
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];

    }else{
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];

    }
    
    if ([self.delegate respondsToSelector:@selector(shopTopEditBtnClick:)]) {
        [self.delegate shopTopEditBtnClick:self];
    }
    
}
- (void)selectBtnClick{
    if ([self.delegate respondsToSelector:@selector(shopTopLeftBtnClick:)]) {
        [self.delegate shopTopLeftBtnClick:self];
    }
    
}

-(void)setModel:(ShopCartDataModel *)model{

    _model = model;
    if (_model.edit) {
        [_editBtn setTitle:@"完成" forState:UIControlStateNormal];
        
    }else{
        [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
        
    }
    if (_model.selected) {
        [_selectBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
        
    }else{
        
        [_selectBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
        
    }

    _nameLab.text = model.sellerInfo;
    _nameLab.sd_layout.leftSpaceToView(_facImage,5).topEqualToView(_selectBtn).heightIs(40);
    [_nameLab setSingleLineAutoResizeWithMaxWidth:0];
    _rightImageView.sd_layout.leftSpaceToView(_nameLab,10).centerYEqualToView(_selectBtn).heightIs(16).widthIs(10);

    _shopBtn.sd_layout.leftEqualToView(_facImage).centerYEqualToView(_selectBtn).heightIs(40).rightEqualToView(_rightImageView);

}


@end
