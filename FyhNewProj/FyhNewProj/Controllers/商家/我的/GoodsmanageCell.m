//
//  GoodsmanageCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GoodsmanageCell.h"
#import "GItemModel.h"

@implementation GoodsmanageCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUP];
    }
    return self;
}

- (void)setUP{

    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topView];
    
    _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 22, 80, 80)];
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.clipsToBounds = YES;
    [self.contentView addSubview:_faceImageView];
    _faceImageView.image  = [UIImage imageNamed:@"loding"];
    
    _backImageView = [UIImageView new];
    _backImageView.frame =CGRectMake(20, 22, 80, 80);
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.clipsToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"result_background"];
    [self.contentView  addSubview:_backImageView];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _nameLab.numberOfLines = 2;
    [self.contentView addSubview:_nameLab];

    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_priceLab];

    _unitLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_unitLab];

    _stockLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_stockLab];

    CGFloat Width = ScreenWidth/3;
    _editBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setImage:[UIImage imageNamed:@"ware_edit"] forState:UIControlStateNormal];
    [_editBtn setTitleRect:CGRectMake((Width - 35 -20)/2+20, 0, 35, 40)];
    [_editBtn setImageRect:CGRectMake((Width - 35 -20)/2, 10, 19, 20)];
    [_editBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _editBtn.titleLabel.font = APPFONT(15);
    _editBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _editBtn.frame = CGRectMake(0, 112, Width, 40);
    [self.contentView addSubview:_editBtn];
    [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _downBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_downBtn setTitle:@"下架" forState:UIControlStateNormal];
    [_downBtn setImage:[UIImage imageNamed:@"ware_down"] forState:UIControlStateNormal];
    [_downBtn setTitleRect:CGRectMake((Width - 35 -20)/2+20, 0, 35, 40)];
    [_downBtn setImageRect:CGRectMake((Width - 35 -20)/2, 10, 19, 20)];
    [_downBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _downBtn.titleLabel.font = APPFONT(15);
    _downBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _downBtn.frame = CGRectMake(Width, 112, Width, 40);
    [self.contentView addSubview:_downBtn];
    [_downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    _deleteBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setImage:[UIImage imageNamed:@"ware_delete"] forState:UIControlStateNormal];
    [_deleteBtn setTitleRect:CGRectMake((Width - 35 -20)/2+20, 0, 35, 40)];
    [_deleteBtn setImageRect:CGRectMake((Width - 35 -20)/2, 10, 19, 20)];
    [_deleteBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = APPFONT(15);
    _deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _deleteBtn.frame = CGRectMake(Width*2, 112, Width, 40);
    [self.contentView addSubview:_deleteBtn];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 111, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineView];
    
}


-(void)setModel:(GItemModel *)model{
    _model = model;
    if (model.imageUrlList.count>0) {
        [_faceImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrlList[0]] placeholderImage:[UIImage imageNamed:@"loding"]];

    }
    _nameLab.text = model.title;
    _priceLab.text = model.price;
    _stockLab.text = [NSString stringWithFormat:@"库存:%@",model.stock];
    NSMutableString *str = [[NSMutableString  alloc]initWithString:@""];
    if (model.specificationValues.count >0) {
        for (int i = 0; i<model.specificationValues.count; i++) {
            NSDictionary *dic = model.specificationValues[i];
            NSString *theStr = dic[@"name"];
            if (theStr.length>0) {
                [str appendString:[NSString stringWithFormat:@"%@  ",theStr]];

            }
        }
    }
    _unitLab.text = str;
    
    _nameLab.sd_layout.leftSpaceToView(_faceImageView,12).topSpaceToView(self.contentView,27).rightSpaceToView(self.contentView,130).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
    _stockLab.sd_layout.rightSpaceToView(self.contentView,20).bottomEqualToView(_faceImageView).heightIs(14).leftSpaceToView(_faceImageView,0);
    
    _priceLab.sd_layout.leftSpaceToView(_nameLab,5).topSpaceToView(self.contentView,27).rightSpaceToView(self.contentView,15).heightIs(16);
    _unitLab.sd_layout.leftSpaceToView(_faceImageView,12).topSpaceToView(_nameLab,10).rightSpaceToView(self.contentView,15).autoHeightRatio(0);
    [_unitLab setMaxNumberOfLinesToShow:2];
    if (self.type == 2) {
        [_downBtn setTitle:@"上架" forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@"ware_up"] forState:UIControlStateNormal];
    }else{
        [_downBtn setTitle:@"下架" forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@"ware_down"] forState:UIControlStateNormal];

    }
    
}

- (void)editBtnClick{
    if ([self.delegate respondsToSelector:@selector(didselectedEditBtnWithCell:)]) {
        [self.delegate didselectedEditBtnWithCell:self];
    }

}

- (void)downBtnClick{
    if ([self.delegate respondsToSelector:@selector(didselectedDownBtnWithCell:)]) {
        [self.delegate didselectedDownBtnWithCell:self];
    }}

- (void)deleteBtnClick{
    if ([self.delegate respondsToSelector:@selector(didselectedDeleteBtnWithCell:)]) {
        [self.delegate didselectedDeleteBtnWithCell:self];
    }
}
@end
