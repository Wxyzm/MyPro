//
//  AdressCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AdressCell.h"
#import "AdressModel.h"

@implementation AdressCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self setUP];
    }

    return self;
}

- (void)setUP{

    _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(20, 15, (ScreenWidth-40)/2, 15) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];

    _phoneLab = [BaseViewFactory labelWithFrame:CGRectMake(20+(ScreenWidth-40)/2, 15, (ScreenWidth-40)/2, 15) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_phoneLab];

    _adressLab = [BaseViewFactory labelWithFrame:CGRectMake(20, 35, ScreenWidth-40, 15) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_adressLab];
    
    UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(0, 59, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineview];
    
    _morenBtn  = [SubBtn buttonWithtitle:@"默认地址" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:29/2 andtarget:self action:nil andframe:CGRectMake(20, 65, 70, 29)];
    [_morenBtn addTarget:self action:@selector(morenBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _morenBtn.titleLabel.font = APPFONT(13);
    [self.contentView addSubview:_morenBtn];
    
    _leftBtn  = [YLButton buttonWithType:UIButtonTypeCustom];
    _leftBtn.frame = CGRectMake(20, 70, 80, 20);
    [self.contentView addSubview:_leftBtn];
    [_leftBtn setTitle:@"设为默认" forState:UIControlStateNormal];
    [_leftBtn setImage:[UIImage imageNamed:@"circle-20"] forState:UIControlStateNormal];
    [_leftBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_leftBtn setImageRect:CGRectMake(0, 0, 20, 20)];
    [_leftBtn setTitleRect:CGRectMake(25, 3.5, 60, 13)];
    _leftBtn.titleLabel.font = APPFONT(13);
    [_leftBtn addTarget:self action:@selector(leftBtnClick) forControlEvents:UIControlEventTouchUpInside];

    _editBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _editBtn.frame = CGRectMake(ScreenWidth-20-26-25-20-30-25, 70, 25+30, 20);
    [self.contentView addSubview:_editBtn];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setImage:[UIImage imageNamed:@"edit"] forState:UIControlStateNormal];
    [_editBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_editBtn setImageRect:CGRectMake(0, 0, 20, 20)];
    [_editBtn setTitleRect:CGRectMake(25, 3.5, 30, 13)];
    _editBtn.titleLabel.font = APPFONT(13);
    [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _deleteBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _deleteBtn.frame = CGRectMake(ScreenWidth-20-30-25, 70, 25+30, 20);
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setImage:[UIImage imageNamed:@"delet"] forState:UIControlStateNormal];
    [_deleteBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_deleteBtn setImageRect:CGRectMake(0, 0, 20, 20)];
    [_deleteBtn setTitleRect:CGRectMake(25, 3.5, 30, 13)];
    _deleteBtn.titleLabel.font = APPFONT(13);
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *downline = [BaseViewFactory viewWithFrame:CGRectMake(0, 100, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:downline];
    
}


-(void)setModel:(AdressModel *)model{

    _model = model;
    _nameLab.text = model.consigneeName;
    _phoneLab.text = model.mobile;
    _adressLab.text = [NSString stringWithFormat:@"%@%@%@%@",model.province,model.city,model.area,model.consigneeAddress];
    if (!model.isDefaultAdress) {
        _morenBtn.hidden = YES;
        _leftBtn.hidden = NO;
    }else{
        _morenBtn.hidden = NO;
        _leftBtn.hidden =YES;

    }
    
    
}




- (void)morenBtnClick{

    if ([self.delegate respondsToSelector:@selector(AdressCellMorenBtnClick:)]) {
        [self.delegate AdressCellMorenBtnClick:self];
    }


}

- (void)leftBtnClick{
    if ([self.delegate respondsToSelector:@selector(AdressCellLeftBtnClick:)]) {
        [self.delegate AdressCellLeftBtnClick:self];
    }
}



- (void)editBtnClick{

    if ([self.delegate respondsToSelector:@selector(AdressCellEditBtnClick:)]) {
        [self.delegate AdressCellEditBtnClick:self];
    }


}


- (void)deleteBtnClick{
    if ([self.delegate respondsToSelector:@selector(AdressCellDeleteBtnClick:)]) {
        [self.delegate AdressCellDeleteBtnClick:self];
    }}

@end
