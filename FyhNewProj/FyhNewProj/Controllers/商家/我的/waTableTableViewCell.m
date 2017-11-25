//
//  waTableTableViewCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "waTableTableViewCell.h"
#import "MasterProModel.h"

@implementation waTableTableViewCell{
    
    UIView *_downView;
    
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setUP];
    }
    return self;
}


- (void)setUP
{
    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topView];
    
    _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10+12, 80, 80)];
    _faceImageView.contentMode = UIViewContentModeScaleAspectFill;
    _faceImageView.clipsToBounds = YES;
    [self.contentView addSubview:_faceImageView];
    _faceImageView.image  = [UIImage imageNamed:@"loding"];
    
    _backImageView = [UIImageView new];
    _backImageView.frame =CGRectMake(0, 0, 80, 80);
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.clipsToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"result_background"];
    [_faceImageView  addSubview:_backImageView];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _nameLab.numberOfLines = 2;
    [self.contentView addSubview:_nameLab];
    
    _downView = [BaseViewFactory viewWithFrame:CGRectMake(0, 112, ScreenWidth, 40) color:UIColorFromRGB(WhiteColorValue)];
    [self.contentView addSubview:_downView];
    
    CGFloat Width = ScreenWidth/4;
    _editBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_editBtn setTitle:@"编辑" forState:UIControlStateNormal];
    [_editBtn setImage:[UIImage imageNamed:@"manager_edit"] forState:UIControlStateNormal];
    [_editBtn setTitleRect:CGRectMake((Width - 35 -20)/2+20, 0, 35, 40)];
    [_editBtn setImageRect:CGRectMake((Width - 35 -20)/2, 10, 19, 20)];
    [_editBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _editBtn.titleLabel.font = APPFONT(15);
    _editBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _editBtn.frame = CGRectMake(0, 0, Width, 40);
    [_downView addSubview:_editBtn];
    [_editBtn addTarget:self action:@selector(editBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _downBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_downBtn setTitle:@"下架" forState:UIControlStateNormal];
    [_downBtn setImage:[UIImage imageNamed:@"ware_up"] forState:UIControlStateNormal];
    [_downBtn setTitleRect:CGRectMake((Width - 35 -20)/2+20, 0, 35, 40)];
    [_downBtn setImageRect:CGRectMake((Width - 35 -20)/2, 10, 19, 20)];
    [_downBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _downBtn.titleLabel.font = APPFONT(15);
    _downBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _downBtn.frame = CGRectMake(Width, 0, Width, 40);
    [_downView addSubview:_downBtn];
    [_downBtn addTarget:self action:@selector(downBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _deleteBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setTitle:@"删除" forState:UIControlStateNormal];
    [_deleteBtn setImage:[UIImage imageNamed:@"manager_delete"] forState:UIControlStateNormal];
    [_deleteBtn setTitleRect:CGRectMake((Width - 35 -20)/2+20, 0, 35, 40)];
    [_deleteBtn setImageRect:CGRectMake((Width - 35 -20)/2, 10, 19, 20)];
    [_deleteBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _deleteBtn.titleLabel.font = APPFONT(15);
    _deleteBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _deleteBtn.frame = CGRectMake(Width*2, 0, Width, 40);
    [_downView addSubview:_deleteBtn];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _PrintBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_PrintBtn setTitle:@"打印" forState:UIControlStateNormal];
    [_PrintBtn setImage:[UIImage imageNamed:@"manager_qrcode"] forState:UIControlStateNormal];
    [_PrintBtn setTitleRect:CGRectMake((Width - 35 -20)/2+20, 0, 35, 40)];
    [_PrintBtn setImageRect:CGRectMake((Width - 35 -20)/2, 10, 19, 20)];
    [_PrintBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _PrintBtn.titleLabel.font = APPFONT(15);
    _PrintBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    _PrintBtn.frame = CGRectMake(Width*3, 0, Width, 40);
    [_downView addSubview:_PrintBtn];
    [_PrintBtn addTarget:self action:@selector(PrintBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _selectedBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_selectedBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
    [_selectedBtn setImageRect:CGRectMake(12, 42, 16, 16)];
    [self.contentView addSubview:_selectedBtn];
    [_selectedBtn addTarget:self action:@selector(selectedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 111, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:lineView];
}

-(void)setModel:(MasterProModel *)model{
    _model = model;
    if (model.imageUrlList.count>0) {
        [_faceImageView sd_setImageWithURL:[NSURL URLWithString:_model.imageUrlList[0]] placeholderImage:[UIImage imageNamed:@"loding"]];
        
    }
    _nameLab.text = model.name;
    
    if (_model.isSelected) {
        [_selectedBtn setImage:[UIImage imageNamed:@"manager_red"] forState:UIControlStateNormal];
    }else{
        [_selectedBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
    }
    
        if (model.status == 0) {
        [_downBtn setTitle:@"上架" forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@"ware_up"] forState:UIControlStateNormal];
    }else{
        [_downBtn setTitle:@"下架" forState:UIControlStateNormal];
        [_downBtn setImage:[UIImage imageNamed:@"ware_down"] forState:UIControlStateNormal];
    }
    if (_type == 3) {
        _selectedBtn.hidden = YES;
        _faceImageView.sd_layout.leftSpaceToView(self.contentView,16).topSpaceToView(self.contentView,22).widthIs(80).heightIs(80);
    }else{
     
        _selectedBtn.hidden = NO;
        _selectedBtn.sd_layout.leftSpaceToView(self.contentView,0).topSpaceToView(self.contentView,12).widthIs(40).heightIs(100);
        _faceImageView.sd_layout.leftSpaceToView(_selectedBtn,0).topSpaceToView(self.contentView,22).widthIs(80).heightIs(80);
        
        if (_type == 4) {
            _downView.hidden = YES;
        }
        
    }

    _nameLab.sd_layout.leftSpaceToView(_faceImageView,16).topSpaceToView(self.contentView,47).rightSpaceToView(self.contentView,130).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
}


- (void)selectedBtnClick{
    
    _model.isSelected = !_model.isSelected;
    if (_model.isSelected) {
        [_selectedBtn setImage:[UIImage imageNamed:@"manager_red"] forState:UIControlStateNormal];
    }else{
        [_selectedBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];

        
    }
    if ([self.delegate respondsToSelector:@selector(didselectedSelectedBtnWithCell:)]) {
        [self.delegate didselectedSelectedBtnWithCell:self];
    }
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
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
- (void)PrintBtnClick
{
    if ([self.delegate respondsToSelector:@selector(didselectedPrintBtnClickWithCell:)]) {
        [self.delegate didselectedPrintBtnClickWithCell:self];
    }
}
@end
