//
//  NewGoBuyCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "NewGoBuyCell.h"
#import "MyNeedsModel.h"
@implementation NewGoBuyCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(LineColorValue);
     //   self.selectionStyle = UITableViewCellSelectionStyleDefault;
        [self setUp];
    }
    return self;
}


- (void)setUp{

    _backView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    [self.contentView    addSubview:_backView];
    _backView.layer.shadowColor = [UIColor blackColor].CGColor;
    _backView.layer.shadowOffset = CGSizeMake(0, 0.5);
    //shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    _backView.layer.shadowOpacity = 1;
    _backView.layer.shadowRadius = 1.5;
    _backView.layer.shadowColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.24].CGColor;
    _backView.layer.cornerRadius = 2;
    
    
    _typeeImageView = [[UIImageView alloc]init];
    _typeeImageView.clipsToBounds = YES;
    [_backView addSubview:_typeeImageView];
    
    
    
    _typeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x656d78) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:@""];
    [_backView addSubview:_typeLab];

    _pictureImageView = [[UIImageView alloc]init];
    _pictureImageView.clipsToBounds = YES;
    _pictureImageView.contentMode = UIViewContentModeScaleAspectFill;
    [_backView addSubview:_pictureImageView];
    
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"result_background"]];
    [_pictureImageView addSubview:imageView];
    imageView.frame = CGRectMake(0, 0, 75, 75);
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [_backView addSubview:_nameLab];

    _statuesLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x656d78) font:APPFONT(10) textAligment:NSTextAlignmentRight andtext:@""];
    [_backView addSubview:_statuesLab];

    _numberLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x656d78) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:@""];
    [_backView addSubview:_numberLab];
    
    _dateLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(12) textAligment:NSTextAlignmentRight andtext:@""];
    [_backView addSubview:_dateLab];
    
    _collectBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setTitle:@"收藏" forState:UIControlStateNormal];
    [_collectBtn setTitleColor:UIColorFromRGB(0x656d78) forState:UIControlStateNormal];
    _collectBtn.titleLabel.font = APPFONT(12);
    [_collectBtn setImage:[UIImage imageNamed:@"collect-gray"] forState:UIControlStateNormal];
    _collectBtn.imageRect = CGRectMake(10, 10, 13, 11);
    _collectBtn.titleRect = CGRectMake(29, 9, 25, 13);
    [_backView addSubview:_collectBtn];
    [_collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(12, 28, ScreenWidth - 48, 0.5) color:UIColorFromRGB(0xe6e9ed)];
    [_backView addSubview:lineView];
    
    _backView.frame = CGRectMake(12, 0, ScreenWidth - 24, 132);
}

-(void)setModel:(MyNeedsModel *)model{
    
    _model = model;
    NSArray *imageArr = model.imageUrlList;
    if (imageArr.count>0) {
        [_pictureImageView sd_setImageWithURL:[NSURL URLWithString:imageArr[0]] placeholderImage:[UIImage imageNamed:@"loding"]];

    }
    _nameLab.text = model.title;
    _typeLab.text = model.categoryName;
    
    UIImage *typeImage;
    if ([model.categoryName isEqualToString:@"家纺"]) {
        typeImage = [UIImage imageNamed:@"chuanglian"];
        
    }else if ([model.categoryName isEqualToString:@"服装"]){
        typeImage = [UIImage imageNamed:@"fuzhuang"];

    }else if ([model.categoryName isEqualToString:@"辅料"]){
        typeImage = [UIImage imageNamed:@"fuliao"];

    }else if ([model.categoryName isEqualToString:@"花型"]){
        typeImage = [UIImage imageNamed:@"huaxin"];

    }else if ([model.categoryName isEqualToString:@"面料"]){
        typeImage = [UIImage imageNamed:@"mianliao"];

    }else{
        //坯布
        typeImage = [UIImage imageNamed:@"peibu"];

    }

    _typeeImageView.image =typeImage;
    
    
    if ([model.status intValue] == 1) {
        _statuesLab.text = @"状态:审核中";
        
    }else if ([model.status intValue] == 3){
        _statuesLab.text = @"状态:未通过";
        
    }else if ([model.status intValue] == 4){
        _statuesLab.text = @"状态:进行中";
        _statuesLab.textColor = UIColorFromRGB(0xe65332);

    }else if ([model.status intValue] == 6){
        _statuesLab.text = @"状态:报价中";
        _statuesLab.textColor = UIColorFromRGB(0x35b304);

    }else if ([model.status intValue] == 9){
        _statuesLab.text = @"状态:已完成";
        _statuesLab.textColor = UIColorFromRGB(LineColorValue);
    }
    
    if (model.isUserCollectedPurchasingNeed) {
        [_collectBtn setImage:[UIImage imageNamed:@"collect-red"] forState:UIControlStateNormal];
    }else{
        [_collectBtn setImage:[UIImage imageNamed:@"collect-gray"] forState:UIControlStateNormal];
    }
    
    _dateLab.text = [GlobalMethod returnTimeStrWith:model.updateTime];
    _numberLab.text = [NSString stringWithFormat:@"数量：%ld",(long)_model.quantity];
    
    _typeeImageView.sd_layout.
    leftSpaceToView(_backView, 12).
    topSpaceToView(_backView, 6.5).
    widthIs(15).
    heightIs(15);
    
    _typeLab.sd_layout.
    leftSpaceToView(_typeeImageView, 6).
    topSpaceToView(_backView, 6.5).
    widthIs(200).
    heightIs(15);
    
    _pictureImageView.sd_layout.
    leftSpaceToView(_backView, 14).
    topSpaceToView(_backView, 43).
    widthIs(75).
    heightIs(75);
    
    _collectBtn.sd_layout.
    rightSpaceToView(_backView, 12).
    topSpaceToView(_backView, 39).
    widthIs(54).
    heightIs(31);
    
    _nameLab.sd_layout.
    rightSpaceToView(_backView, 87).
    topSpaceToView(_backView, 43).
    leftSpaceToView(_backView, 99).
    autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
    _dateLab.sd_layout.
    rightSpaceToView(_backView, 12).
    bottomSpaceToView(_backView, 21).
    heightIs(10);
    [_dateLab setSingleLineAutoResizeWithMaxWidth:200];
 
    _numberLab.sd_layout.
    leftSpaceToView(_pictureImageView, 12).
    rightSpaceToView(_dateLab, 12).
    bottomSpaceToView(_backView, 19).
    heightIs(12);
    
    _statuesLab.sd_layout.
    rightSpaceToView(_backView, 12).
    bottomSpaceToView(_dateLab, 9).
    widthIs(100).
    heightIs(12);
    
}

- (void)collectBtnClick{
    
    if ([self.delegate respondsToSelector:@selector(didSelectedCollectBtnWithcell:)]) {
        [self.delegate didSelectedCollectBtnWithcell:self];
    }
    
}

@end
