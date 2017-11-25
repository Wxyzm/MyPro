//
//  ShopCartCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShopCartCell.h"
#import "ShopCartModel.h"
#import "ShopCartitemsModel.h"

@interface ShopCartCell()<UITextFieldDelegate>

@end

@implementation ShopCartCell{

    UIView  *_numberView;
    UILabel *_downUnitLab;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.clipsToBounds = YES;
        self.clipsToBounds = YES;
        [self setUp];
    }
    return self;
}


- (void)setUp{

    
    UIView *lineview =[BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)   ];
    [self.contentView addSubview:lineview];
    
    _leftBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_leftBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
    [_leftBtn setImageRect:CGRectMake(10, 10, 20, 20)];
    [self.contentView addSubview:_leftBtn];
    [_leftBtn addTarget:self action:@selector(shopCartGoodBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _picture = [[UIImageView alloc]init];
    _picture.backgroundColor = [UIColor orangeColor];
    [self.contentView addSubview:_picture];
    _backImageView = [UIImageView new];
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.clipsToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"result_background"];
    [self.contentView addSubview:_backImageView];

    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _nameLab.numberOfLines = 0;
    [self.contentView addSubview:_nameLab];
    
    _colorLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_colorLab];

    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_priceLab];
    
    _oldPriceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_oldPriceLab];
    
    
    _deleteBtn = [SubBtn buttonWithtitle:@"删除" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(deleteBtnClick)];
    _deleteBtn.frame = CGRectMake(ScreenWidth - 62.5, 0, 62.5,99);
    [self.contentView   addSubview:_deleteBtn];
    
    _numberView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    [self.contentView addSubview:_numberView];
    _numberView.layer.cornerRadius = 5;
    _numberView.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    _numberView.layer.borderWidth = 1;
    CGFloat width;
    if (iPhone5) {
        width = ScreenWidth - 135 -67.5;

    }else{
        width = ScreenWidth - 150 -82.5;

    }
    
    UIView *jianView = [BaseViewFactory viewWithFrame:CGRectMake(15, 14.5, 15, 1) color:UIColorFromRGB(BlackColorValue)];
    [_numberView addSubview:jianView];
    
    UIView *jiaView1 = [BaseViewFactory viewWithFrame:CGRectMake(width - 30, 14.5, 15, 1) color:UIColorFromRGB(BlackColorValue)];
    [_numberView addSubview:jiaView1];
    UIView *jiaView2 = [BaseViewFactory viewWithFrame:CGRectMake(width - 23, 8.5, 1, 13) color:UIColorFromRGB(BlackColorValue)];
    [_numberView addSubview:jiaView2];
    
    UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(45, 5, 1, 20) color:UIColorFromRGB(LineColorValue)];
    [_numberView addSubview:line1];

    UIView *line2 = [BaseViewFactory viewWithFrame:CGRectMake(width - 45, 5, 1, 20) color:UIColorFromRGB(LineColorValue)];
    [_numberView addSubview:line2];
    
    _numTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(45, 0, width - 90, 30) font:APPFONT(13) placeholder:@"" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _numTxt.textAlignment = NSTextAlignmentCenter;
    _numTxt.keyboardType = UIKeyboardTypeNumberPad;
    [_numberView addSubview:_numTxt];
    

    UIButton *reducebtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_numberView addSubview:reducebtn];
    reducebtn.frame = CGRectMake(0, 0, 45, 30);
    [reducebtn addTarget:self action:@selector(reducebtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *addbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_numberView addSubview:addbtn];
    addbtn.frame = CGRectMake(width - 45, 0, 45, 30);
    [addbtn addTarget:self action:@selector(addbtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _downUnitLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_downUnitLab];
    
        UIView *lineview1 =[BaseViewFactory viewWithFrame:CGRectMake(0, 100, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
        [self.contentView addSubview:lineview1];

}


- (void)deleteBtnClick{
    if ([self.delegate respondsToSelector:@selector(shopDeleteBtnClickWithCell:)]) {
        [self.delegate shopDeleteBtnClickWithCell:self];
    }
    
    
}




- (void)reducebtnClick{
    int a = [_numTxt.text intValue];
    if (a<=1) {
        return;
    }
    a--;
    ShopCartitemsModel   *itemModel = _model.item;
    if (itemModel.minBuyQuantity) {
        if (a <[itemModel.minBuyQuantity intValue]) {
            [self showTextHud:@"数量小于起购量"];
            return;
        }
    }
    
    
    _numTxt.text = [NSString stringWithFormat:@"%d",a];


}




- (void)addbtnClick{
    int a = [_numTxt.text intValue];
    a++;
    ShopCartitemsModel   *itemModel = _model.item;
        if (itemModel.limitUserTotalBuyQuantity) {
        if (a >[itemModel.limitUserTotalBuyQuantity intValue]) {
            [self showTextHud:@"数量超出限购量"];
            return;
        }
    }
    if (itemModel.buyerHasBoughtQuantityInLimitTotalBuy) {
        if (a >[itemModel.limitUserTotalBuyQuantity intValue]-[itemModel.buyerHasBoughtQuantityInLimitTotalBuy intValue]){
        
            [self showTextHud:[NSString stringWithFormat:@"该商品限购数量为%@您已经购买了%@件，还能购买%d件",itemModel.limitUserTotalBuyQuantity,itemModel.buyerHasBoughtQuantityInLimitTotalBuy,[itemModel.limitUserTotalBuyQuantity intValue]-[itemModel.buyerHasBoughtQuantityInLimitTotalBuy intValue]]];
            return;
        }
    }

    _numTxt.text = [NSString stringWithFormat:@"%d",a];



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
    if ([itemModel.status intValue]==2) {
        _priceLab.text = @"该商品已失效";

    }
    
    _oldPriceLab.text = [NSString stringWithFormat:@"X  %@",model.quantity];
    if (iPhone5) {
        _leftBtn.sd_layout.topSpaceToView(self.contentView,30).leftSpaceToView(self.contentView,0).widthIs(40).heightIs(40);
        _picture.sd_layout.leftSpaceToView(_leftBtn,10).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);

        _numberView.sd_layout.leftSpaceToView(_picture,5).rightSpaceToView(_deleteBtn,5).heightIs(30).topSpaceToView(self.contentView,10);

    }else{
        _leftBtn.sd_layout.topSpaceToView(self.contentView,30).leftSpaceToView(self.contentView,10).widthIs(40).heightIs(40);
        _picture.sd_layout.leftSpaceToView(_leftBtn,10).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);

        _numberView.sd_layout.leftSpaceToView(self.contentView,150).rightSpaceToView(_deleteBtn,20).heightIs(30).topSpaceToView(self.contentView,10);

    }
   
    _backImageView.sd_layout.leftSpaceToView(_leftBtn,10).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _nameLab.sd_layout.leftSpaceToView(_picture,10).topEqualToView(_picture).rightSpaceToView(self.contentView,20).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];

    _colorLab.sd_layout.leftEqualToView(_nameLab).topSpaceToView(_nameLab,10).rightEqualToView(_nameLab).heightIs(14);

    _priceLab.sd_layout.leftEqualToView(_nameLab).bottomEqualToView(_picture).heightIs(16);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:100];
    

    _oldPriceLab.sd_layout.leftSpaceToView(_priceLab,10).bottomEqualToView(_picture).heightIs(14).rightSpaceToView(self.contentView,20);
    
    
    _downUnitLab.sd_layout.topSpaceToView(_numberView,0).bottomEqualToView(_picture).leftEqualToView(_numberView).rightEqualToView(_numberView);
    if (model.edit) {
        _numTxt.text = model.quantity;
        _downUnitLab.text = mutStr;
        _numberView.hidden = NO;
        _downUnitLab.hidden = NO;
        _deleteBtn.hidden = NO;
        _nameLab.hidden = YES;
        _colorLab.hidden = YES;
        _priceLab.hidden = YES;
        _oldPriceLab.hidden = YES;

        
    }else{
        _numberView.hidden = YES;
        _downUnitLab.hidden = YES;
        _deleteBtn.hidden = YES;
        _nameLab.hidden = NO;
        _colorLab.hidden = NO;
        _priceLab.hidden = NO;
        _oldPriceLab.hidden = NO;

    }
    if (model.selected) {
        [_leftBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];

    }else{
    
        [_leftBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];

    }
    
    
    
}

- (void)shopCartGoodBtnClick{
    
    _model.selected = !_model.selected;
    if (_model.selected) {
        [_leftBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
        
    }else{
        
        [_leftBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
        
    }
    if ([self.delegate respondsToSelector:@selector(shopBtnTabVClick:)]) {
        [self.delegate shopBtnTabVClick:self];
    }

}

- (void)showTextHud:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = msg;
    hud.detailsLabel.font = APPFONT(15);
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    // [hud hide:YES afterDelay:1.5];
    [hud hideAnimated:YES afterDelay:1.5];
}
@end
