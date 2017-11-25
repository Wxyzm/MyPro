//
//  MyCollectionCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyCollectionCell.h"

@implementation MyCollectionCell{
    YLButton *_delectBtn;
    YLButton *_shopBtn;
    UILabel *_desLab;
    NSInteger _type;

}

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

    _picture = [[UIImageView alloc]init];
    _priceLab.clipsToBounds = YES;
    _priceLab.contentMode = UIViewContentModeScaleAspectFill;
    [self.contentView addSubview:_picture];
    
    _backImageView = [UIImageView new];
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.clipsToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"result_background"];
    [self.contentView  addSubview:_backImageView];
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _nameLab.numberOfLines = 2;
    [self.contentView addSubview:_nameLab];

    _priceLab  = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"￥"];
    [self.contentView addSubview:_priceLab];
    
    
    _desLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_desLab];

    _delectBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_delectBtn setImage:[UIImage imageNamed:@"delet"] forState:UIControlStateNormal];
    [_delectBtn addTarget:self action:@selector(deleteBtnclick) forControlEvents:UIControlEventTouchUpInside];

    [_delectBtn setImageRect:CGRectMake(5, 5, 20, 20)];
    [self.contentView addSubview:_delectBtn];

    _shopBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_shopBtn setTitle:@"进入店铺" forState:UIControlStateNormal];
    [_shopBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
    [_shopBtn addTarget:self action:@selector(gotoShopBtnclick) forControlEvents:UIControlEventTouchUpInside];
    _shopBtn .titleLabel.font = APPFONT(13);
    [self.contentView addSubview:_shopBtn];

    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 99, ScreenWidth, 1)];
    [self.contentView addSubview:line];
    line.backgroundColor = UIColorFromRGB(PlaColorValue);
}

- (void)gotoShopBtnclick{
    if (_type == 0) {
        if ([self.delegate respondsToSelector:@selector(didselectedGoingBtnWithShopId:)]) {
            [self.delegate didselectedGoingBtnWithShopId:_dataDic[@"item"][@"accountId"]];
        }
    }else if (_type == 2){
        
        
    }
    else{
        if ([self.delegate respondsToSelector:@selector(didselectedGoingBtnWithShopId:)]) {
            [self.delegate didselectedGoingBtnWithShopId:_shopDic[@"id"]];
        }
    }
}


- (void)deleteBtnclick{

    if (_type == 0) {
        if ([self.delegate respondsToSelector:@selector(didselectedDelegateBtnWithDic:andType:)]) {
            [self.delegate didselectedDelegateBtnWithDic:_dataDic andType:0];
        }
    }else if (_type == 2){
        if ([self.delegate respondsToSelector:@selector(didselectedDelegateBtnWithDic:andType:)]) {
            [self.delegate didselectedDelegateBtnWithDic:_needDic andType:2];
        }
    }
    else{
        if ([self.delegate respondsToSelector:@selector(didselectedDelegateBtnWithDic:andType:)]) {
            [self.delegate didselectedDelegateBtnWithDic:_shopDic andType:1];
        }
    
    }
   


}

-(void)setDataDic:(NSDictionary *)dataDic{
    if (!dataDic) {
        return;
    }
    _dataDic = dataDic;
    _type = 0;
    NSDictionary *item = dataDic[@"item"];
    NSArray *arr = item[@"imageUrlList"];
    if (arr.count >0) {
        [_picture sd_setImageWithURL:[NSURL URLWithString:item[@"imageUrlList"][0]] placeholderImage:[UIImage imageNamed:@"loding"]];

    }
    _nameLab.text = dataDic[@"itemTitle"];
    _priceLab.text =[NSString stringWithFormat:@"￥%@", item[@"price"]];
    _picture.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
   _backImageView.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _nameLab.sd_layout.leftSpaceToView(_picture,20).topEqualToView(_picture).rightSpaceToView(self.contentView,70).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    _priceLab.sd_layout.leftSpaceToView(_picture,20).bottomEqualToView(_picture).widthIs(200).heightIs(36);
    
    _delectBtn.sd_layout.rightSpaceToView(self.contentView,20).centerYEqualToView(_picture).widthIs(30).heightIs(30);
    
    _shopBtn.sd_layout.rightSpaceToView(_delectBtn,0).bottomEqualToView(_picture).widthIs(60).heightIs(15);
    _priceLab.hidden = NO;
    _desLab.hidden = YES;
}

-(void)setShopDic:(NSDictionary *)shopDic{
    if (!shopDic) {
        return;
    }
    _shopDic = shopDic;
    _type = 1;
//    id a = NULL_TO_NIL(shopDic[@"shopLogoImageUrl"]);
    if (NULL_TO_NIL(shopDic[@"shopLogoImageUrl"])) {
         [_picture sd_setImageWithURL:[NSURL URLWithString:NULL_TO_NIL(shopDic[@"shopLogoImageUrl"])] placeholderImage:[UIImage imageNamed:@"loding"]];
    }else{
        _picture.image =[UIImage imageNamed:@"loding"];
    }
//    [_picture sd_setImageWithURL:[NSURL URLWithString:shopDic[@"shopLogoImageUrl"]] placeholderImage:[UIImage imageNamed:@"loding"]];
    
    
    _nameLab.text = NULL_TO_NIL(shopDic[@"shopName"]);
    if ( _nameLab.text.length <=0) {
         _nameLab.text = @"该店铺尚未命名";
    }
    
    _desLab.hidden = NO;
    _priceLab.hidden = YES;
    _desLab.text = NULL_TO_NIL(shopDic[@"shopDescription"]) ;
    if ( _desLab.text.length <=0) {
        _desLab.text = @"该店铺暂无描述";
    }
    _picture.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _backImageView.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _nameLab.sd_layout.leftSpaceToView(_picture,20).topEqualToView(_picture).rightSpaceToView(self.contentView,70).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    _desLab.sd_layout.leftSpaceToView(_picture,20).topSpaceToView(_nameLab,10).rightSpaceToView(self.contentView,70).autoHeightRatio(0);
    [_desLab setMaxNumberOfLinesToShow:2];
    
    _delectBtn.sd_layout.rightSpaceToView(self.contentView,20).centerYEqualToView(_picture).widthIs(30).heightIs(30);
    
    _shopBtn.sd_layout.rightSpaceToView(_delectBtn,0).bottomEqualToView(_picture).widthIs(60).heightIs(15);


}


-(void)setNeedDic:(NSDictionary *)needDic{
    
    if (!needDic) {
        return;
    }
    _type = 2;

    _needDic = needDic;
    _nameLab.text = NULL_TO_NIL(needDic[@"purchasingNeed"][@"title"]);

    if (NULL_TO_NIL(needDic[@"purchasingNeed"][@"imageUrlList"])) {
        NSArray *arr = needDic[@"purchasingNeed"][@"imageUrlList"];
        [_picture sd_setImageWithURL:[NSURL URLWithString:NULL_TO_NIL(arr[0])] placeholderImage:[UIImage imageNamed:@"loding"]];
    }else{
        _picture.image =[UIImage imageNamed:@"loding"];
    }
    _priceLab.text =[NSString stringWithFormat:@"数量：%@%@", needDic[@"purchasingNeed"][@"quantity"],needDic[@"purchasingNeed"][@"unit"]];
    if ([needDic[@"purchasingNeed"][@"status"] intValue] == 1) {
      //  _statuesLab.text = @"状态:审核中";
        
    }else if ([needDic[@"purchasingNeed"][@"status"] intValue] == 3){
       // _statuesLab.text = @"状态:未通过";
        
    }else if ([needDic[@"purchasingNeed"][@"status"] intValue] == 4){
        [_shopBtn setTitle:@"进行中" forState:UIControlStateNormal];
        [_shopBtn setTitleColor:UIColorFromRGB(0xe65332) forState:UIControlStateNormal];
        
    }else if ([needDic[@"purchasingNeed"][@"status"] intValue] == 6){
        
        [_shopBtn setTitle:@"报价中" forState:UIControlStateNormal];
        [_shopBtn setTitleColor:UIColorFromRGB(0x35b304) forState:UIControlStateNormal];
      
        
    }else if ([needDic[@"purchasingNeed"][@"status"] intValue] == 9){
        
        [_shopBtn setTitle:@"状已完成" forState:UIControlStateNormal];
        [_shopBtn setTitleColor:UIColorFromRGB(LineColorValue) forState:UIControlStateNormal];
       
    }
    
    
    
    _picture.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _backImageView.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _nameLab.sd_layout.leftSpaceToView(_picture,20).topEqualToView(_picture).rightSpaceToView(self.contentView,70).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    _priceLab.sd_layout.leftSpaceToView(_picture,20).bottomEqualToView(_picture).widthIs(200).heightIs(36);
    
    _delectBtn.sd_layout.rightSpaceToView(self.contentView,20).centerYEqualToView(_picture).widthIs(30).heightIs(30);
    
    _shopBtn.sd_layout.rightSpaceToView(_delectBtn,0).bottomEqualToView(_picture).widthIs(60).heightIs(15);
    _priceLab.hidden = NO;
    _desLab.hidden = YES;
}

@end
