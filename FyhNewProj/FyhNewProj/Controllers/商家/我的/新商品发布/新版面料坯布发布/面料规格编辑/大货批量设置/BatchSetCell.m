//
//  BatchSetCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BatchSetCell.h"
#import "BatchModel.h"
#import "UpImagePL.h"
@interface BatchSetCell ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>


@end


@implementation BatchSetCell{
    UIImagePickerController *_imagePicker;
    UpImagePL               *_upImagePL;                     //上传图片
    UILabel *unitLab;
    UILabel *stockLab;
    UILabel *priceLab;
    UILabel *mineLab;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.contentView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        
        [self setUP];
    }
    return self;
}

- (void)setUP{
    
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(100, 29.5, ScreenWidth-100, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [self.contentView addSubview:lineView];
    
    _pictureIV = [[UIImageView alloc]init];
    _pictureIV.backgroundColor = UIColorFromRGB(0xccd1d9);
    [self.contentView addSubview:_pictureIV];
    
    _upImageBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_upImageBtn];
    [_upImageBtn setImageRect:CGRectMake(36, 30, 28, 23)];
    [_upImageBtn setTitleRect:CGRectMake(0, 59, 100, 13)];
    _upImageBtn.titleLabel.font = APPFONT(12);
    _upImageBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [_upImageBtn setTitle:@"添加商品图片" forState:UIControlStateNormal];
    [_upImageBtn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    [_upImageBtn addTarget:self action:@selector(upImageBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_upImageBtn setImage:[UIImage imageNamed:@"Upload"] forState:UIControlStateNormal];
    _upImageBtn.hidden = YES;
    
    unitLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"规格:"];
    [self.contentView addSubview:unitLab];

    stockLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"库存:"];
    [self.contentView addSubview:stockLab];
    
    priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"价格:"];
    [self.contentView addSubview:priceLab];
    
    mineLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"起订:"];
    [self.contentView addSubview:mineLab];
    
    _unitLab =  [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xff5d38) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_unitLab];
    
    
    _stockTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(13) placeholder:@"" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(0x434a54) delegate:self];
    //    _stockTxt.userInteractionEnabled = NO;
    _stockTxt.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_stockTxt];
    _stockTxt.keyboardType = UIKeyboardTypeNumberPad;
    _stockTxt.layer.cornerRadius = 4;
    _stockTxt.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _stockTxt.layer.borderWidth = 1;
    
    _priceTxt  = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(13) placeholder:@"" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(0x434a54) delegate:self];
    //    _stockTxt.userInteractionEnabled = NO;
    _priceTxt.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_priceTxt];
    _priceTxt.keyboardType = UIKeyboardTypeDecimalPad;
    _priceTxt.layer.cornerRadius = 4;
    _priceTxt.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _priceTxt.layer.borderWidth = 1;
    
    _MineeTxt  = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(13) placeholder:@"" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(0x434a54) delegate:self];
    //    _stockTxt.userInteractionEnabled = NO;
    _MineeTxt.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_MineeTxt];
    _MineeTxt.keyboardType = UIKeyboardTypeNumberPad;
    _MineeTxt.layer.cornerRadius = 4;
    _MineeTxt.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
    _MineeTxt.layer.borderWidth = 1;
    
    
    UIView *boomView = [BaseViewFactory viewWithFrame:CGRectMake(0, 100, ScreenWidth, 12) color:UIColorFromRGB(0xf5f7fa)];
    [self.contentView addSubview:boomView];
    
    CGFloat TXTWIDTH = (ScreenWidth -112)/2-24-2-39;
    
    _pictureIV.sd_layout.
    leftSpaceToView(self.contentView, 0).
    topSpaceToView(self.contentView, 0).
    widthIs(100).
    heightIs(100);
    _upImageBtn.sd_layout.
    leftSpaceToView(self.contentView, 0).
    topSpaceToView(self.contentView, 0).
    widthIs(100).
    heightIs(100);
    
    
    unitLab.sd_layout.
    leftSpaceToView(_pictureIV, 12).
    topSpaceToView(self.contentView, 0).
    widthIs(39).
    heightIs(30);
    
    _unitLab.sd_layout.
    leftSpaceToView(unitLab, 2).
    topEqualToView(unitLab).
    widthIs(ScreenWidth-165).
    heightIs(30);
    
    stockLab.sd_layout.
    leftSpaceToView(_pictureIV, 12).
    topSpaceToView(self.contentView, 36.5).
    widthIs(39).
    heightIs(25);
    
    _stockTxt.sd_layout.
    leftSpaceToView(stockLab, 2).
    topEqualToView(stockLab).
    widthIs(TXTWIDTH).
    heightIs(25);
    
    priceLab.sd_layout.
    leftSpaceToView(_stockTxt, 24).
    topSpaceToView(self.contentView, 36.5).
    widthIs(39).
    heightIs(25);
    
    _priceTxt.sd_layout.
    leftSpaceToView(priceLab, 2).
    topEqualToView(priceLab).
    widthIs(TXTWIDTH).
    heightIs(25);
    
    mineLab.sd_layout.
    leftSpaceToView(_pictureIV, 12).
    topSpaceToView(stockLab, 7).
    widthIs(39).
    heightIs(25);
    
    _MineeTxt.sd_layout.
    leftSpaceToView(mineLab, 2).
    topEqualToView(mineLab).
    widthIs(TXTWIDTH).
    heightIs(25);
    
}



-(void)setModel:(BatchModel *)model{
    
    _model = model;
    
    
    _priceTxt.text = model.price;
    _stockTxt.text = model.stock;
    _MineeTxt.text = model.mineBuy;
    
    if (model.type == 0||model.type == 3) {
        //面料、坯布
        mineLab.hidden = NO;
        _MineeTxt.hidden = NO;
        NSArray *arr = [model.kind componentsSeparatedByString:@","];
        if (arr.count==3) {
            _unitLab.text = [NSString stringWithFormat:@"%@,%@,%@",arr[0],arr[1],arr[2]];
        }
        if (model.minePicture) {
            _pictureIV.image = model.minePicture;
        }else{
            if (model.pictureArr.count >0) {
                _pictureIV.image = model.pictureArr[0];
                
            }
        }
    }else if (model.type == 1||model.type == 2){
        //服装设计
        mineLab.hidden = YES;
        _MineeTxt.hidden = YES;
        NSArray *arr = [model.kind componentsSeparatedByString:@","];
        if (arr.count==2) {
            _unitLab.text = [NSString stringWithFormat:@"%@,%@",arr[0],arr[1]];
        }
        if (model.minePicture) {
            _pictureIV.image = model.minePicture;
        }else{
            if (model.pictureArr.count >0) {
                _pictureIV.image = model.pictureArr[0];
                
            }
        }
    }
    
    
    
    
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == _stockTxt) {
        if (![_model.stock isEqualToString:_stockTxt.text]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];
            
        }
        _model.stock  = _stockTxt.text;
    }else if (textField == _priceTxt){
        if (![_model.price isEqualToString:_priceTxt.text]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];
            
        }
        _model.price  = _priceTxt.text;
    }else if (textField == _MineeTxt){
        if (![_model.mineBuy isEqualToString:_MineeTxt.text]) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"UserHaveChangeData" object:nil];
            
        }
        _model.mineBuy = _MineeTxt.text;
    }
    
}

/**
 上传图片按钮点击
 */
- (void)upImageBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(didSelectedUpImagedBtnWithCell:)]) {
        [self.delegate didSelectedUpImagedBtnWithCell:self];
    }
   
}

@end
