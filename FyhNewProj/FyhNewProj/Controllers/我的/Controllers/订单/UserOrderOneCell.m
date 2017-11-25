//
//  UserOrderOneCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserOrderOneCell.h"
#import "OrderItems.h"
#import "OrderOtherItemModel.h"
@interface UserOrderOneCell()

@property (nonatomic , strong) UIView  *boomView;

@property (nonatomic , strong) UILabel *traLab;

@property (nonatomic , strong) UILabel *thepriceLab;

@property (nonatomic , strong) UILabel *numbrLab;

@property (nonatomic , strong) UILabel *staterLab;


@end

@implementation UserOrderOneCell{
    CGRect leftButtonFrame;
    CGRect rightButtonFrame;
}

-(UIView *)boomView{
    
    if (!_boomView) {
        _boomView = [BaseViewFactory viewWithFrame:CGRectMake(0, 100, ScreenWidth, 80) color:UIColorFromRGB(WhiteColorValue)];
        UIView *topLine = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [_boomView addSubview:topLine];
        
        UIView *topLine1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 39, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [_boomView addSubview:topLine1];
        
        rightButtonFrame = CGRectMake(ScreenWidth - 90, 45, 70, 30);
        _payBtn = [SubBtn buttonWithtitle:@"付款" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(payBtnClick) andframe:rightButtonFrame];
        _payBtn.titleLabel.font = APPFONT(12);
        [_boomView addSubview:_payBtn];
        
        leftButtonFrame = CGRectMake(ScreenWidth-180, 45, 70, 30);
        _cancleBtn = [SubBtn buttonWithtitle:@"取消订单" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(cancleBtnClick)];
        _cancleBtn.frame = leftButtonFrame;
        _cancleBtn.titleLabel.font = APPFONT(12);
        [_boomView addSubview:_cancleBtn];
        
        _traLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(LineColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
        [_boomView addSubview:_traLab];
        
        _thepriceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
        [_boomView addSubview:_thepriceLab];
        
        _numbrLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
        [_boomView addSubview:_numbrLab];
        
        
        _staterLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
        _staterLab.frame = CGRectMake(20, 0, 180, 40);
        [_boomView addSubview:_staterLab];

        _traLab.sd_layout.rightSpaceToView(_boomView,20).topSpaceToView(_boomView,0).heightIs(40);
        [_traLab setSingleLineAutoResizeWithMaxWidth:200];
        
        _thepriceLab.sd_layout.rightSpaceToView(_traLab,0).topSpaceToView(_boomView,0).heightIs(40);
        [_thepriceLab setSingleLineAutoResizeWithMaxWidth:200];
        
        _numbrLab.sd_layout.rightSpaceToView(_thepriceLab,0).topSpaceToView(_boomView,0).heightIs(40);
        [_numbrLab setSingleLineAutoResizeWithMaxWidth:200];
        
    }
    
    
    return _boomView;
}




-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = UIColorFromRGB(WhiteColorValue);
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.clipsToBounds = YES;
        [self setUp];
    }
    return self;
}

- (void)setUp{
    UIView *lineview =[BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)   ];
    [self.contentView addSubview:lineview];
    
    _picture = [[UIImageView alloc]init];
    _picture.contentMode = UIViewContentModeScaleToFill;
    _picture.clipsToBounds = YES;
    _picture.layer.cornerRadius = 5;
    [self.contentView addSubview:_picture];
    
    _backImageView = [UIImageView new];
    _backImageView.contentMode = UIViewContentModeScaleToFill;
    _backImageView.clipsToBounds = YES;
    _backImageView.image = [UIImage imageNamed:@"result_background"];
    [self.contentView  addSubview:_backImageView];

    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _nameLab.numberOfLines = 0;
    [self.contentView addSubview:_nameLab];
    
    _unitLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    _unitLab.numberOfLines = 0;
    [self.contentView addSubview:_unitLab];
    
    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_priceLab];
    
    _numberLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentRight andtext:@""];
    [self.contentView addSubview:_numberLab];
    [self.contentView addSubview:self.boomView];
    
    _onBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _onBtn.frame = CGRectMake(0, 0, ScreenWidth, 100);
    [self.contentView addSubview:_onBtn];
    [_onBtn addTarget:self action:@selector(onBtnClick) forControlEvents:UIControlEventTouchUpInside];
}



- (void)setItemsModel:(OrderItems *)ItemsModel{

    _ItemsModel = ItemsModel;
    _otherModel = nil;
    if (ItemsModel.imageUrlList.count >0) {
        [_picture sd_setImageWithURL:[NSURL URLWithString:ItemsModel.imageUrlList[0]] placeholderImage:[UIImage imageNamed:@"loding"]];
    }
    _nameLab.text = ItemsModel.title;
    if (ItemsModel.itemSpecificationDescription) {
        _unitLab.text = ItemsModel.itemSpecificationDescription;

    }
    _priceLab.text = [NSString stringWithFormat:@"%.2f",[ItemsModel.payAmount floatValue]/[ItemsModel.quantity floatValue]];
    
    _numberLab.text = [NSString stringWithFormat:@"X%@",ItemsModel.quantity];
    
    
    _picture.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
   _backImageView.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    
    _nameLab.sd_layout.leftSpaceToView(_picture,10).topEqualToView(_picture).rightSpaceToView(self.contentView,20).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
    if (iPhone5) {
        _unitLab.sd_layout.leftEqualToView(_nameLab).topSpaceToView(_nameLab,3).rightEqualToView(_nameLab).autoHeightRatio(0);
        [_unitLab setMaxNumberOfLinesToShow:2];
    }else{
        _unitLab.sd_layout.leftEqualToView(_nameLab).topSpaceToView(_nameLab,10).rightEqualToView(_nameLab).autoHeightRatio(0);
        [_unitLab setMaxNumberOfLinesToShow:2];
    }
   

    _priceLab.sd_layout.leftEqualToView(_nameLab).bottomEqualToView(_picture).heightIs(16);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:100];
    
    
    _numberLab.sd_layout.leftSpaceToView(_priceLab,10).bottomEqualToView(_picture).heightIs(14).rightSpaceToView(self.contentView,20);

    if (ItemsModel.logistics ) {
        _traLab.text = [NSString stringWithFormat:@"(含运费%.2f)",[ItemsModel.logisticsAmount floatValue]];

    }else{
          _traLab.text =@"(含运费0.00)";

    }
    
    _thepriceLab.text = [NSString stringWithFormat:@"￥%.2f",[ItemsModel.payAmount floatValue]];
    _numbrLab.text = [NSString stringWithFormat:@"共%@件商品，小计：",ItemsModel.quantity];

    switch ([ItemsModel.status intValue]) {
        case 0:{
            //未付款
            _staterLab.text = @"等待付款";
            [self showButton:self.cancleBtn withTitle:@"取消订单" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"付款" frame:rightButtonFrame];

            break;
        }
        case 1:{
            //已支付，待发货
            _staterLab.text = @"买家已付款";
            self.cancleBtn.hidden = YES;
            self.payBtn.hidden = YES;
            break;
        }
        case 2:{
            //卖家已发货
            _staterLab.text = @"卖家已发货";
            [self showButton:self.cancleBtn withTitle:@"查看物流" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"确认收货" frame:rightButtonFrame];
            break;
        }
        case 3:{
            //交易成功   ，确认收货后
            _staterLab.text = @"交易成功";
            [self showButton:self.cancleBtn withTitle:@"查看物流" frame:leftButtonFrame];
            [self showButton:self.payBtn withTitle:@"评价" frame:rightButtonFrame];

            break;
        }
            
            
        case 4:{
            //交易关闭
            _staterLab.text = @"交易关闭";
            [self showButton:self.cancleBtn withTitle:@"删除订单" frame:rightButtonFrame];
            self.payBtn.hidden = YES;
            break;
        }
        default:
            break;
    }

    _traLab.sd_layout.rightSpaceToView(_boomView,20).topSpaceToView(_boomView,0).heightIs(40);
    [_traLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _thepriceLab.sd_layout.rightSpaceToView(_traLab,0).topSpaceToView(_boomView,0).heightIs(40);
    [_thepriceLab setSingleLineAutoResizeWithMaxWidth:200];
    
    _numbrLab.sd_layout.rightSpaceToView(_thepriceLab,0).topSpaceToView(_boomView,0).heightIs(40);
    [_numbrLab setSingleLineAutoResizeWithMaxWidth:200];

    

}

- (void)payBtnClick{
    if ([self.delegate respondsToSelector:@selector(didselectedUserOrderOneCellPayBtnWithType:andModel:)]) {
        [self.delegate didselectedUserOrderOneCellPayBtnWithType:[_ItemsModel.status intValue] andModel:_ItemsModel];
    }
}

- (void)cancleBtnClick{
    if ([self.delegate respondsToSelector:@selector(didselectedUserOrderOneCellCancleBtnWithType:andModel:)]) {
        [self.delegate didselectedUserOrderOneCellCancleBtnWithType:[_ItemsModel.status intValue] andModel:_ItemsModel];
    }
}

- (void)onBtnClick{

    NSString *itemId;
    if (_otherModel) {
        itemId = _otherModel.itemId;
    }else{
        itemId = _ItemsModel.itemId;
    
    }
    if ([self.delegate respondsToSelector:@selector(didselectedUserOrderOneCellOnBtnWithItemId:)]) {
        [self.delegate didselectedUserOrderOneCellOnBtnWithItemId:itemId];
    }


}

- (void)showboomView{
    self.boomView.hidden = NO;
    
}
- (void)hiddenboomView{
    self.boomView.hidden = YES;
    
}

- (void)showButton:(UIButton*)button withTitle:(NSString*)title frame:(CGRect)frame
{
    button.hidden = NO;
    button.frame = frame;
    [button setTitle:title forState:UIControlStateNormal];
}

-(void)setOtherModel:(OrderOtherItemModel *)otherModel{

    _otherModel = otherModel;
    _ItemsModel = nil;
    if (otherModel.imageUrlList.count >0) {
        [_picture sd_setImageWithURL:[NSURL URLWithString:otherModel.imageUrlList[0]] placeholderImage:[UIImage imageNamed:@"loding"]];
    }
    _nameLab.text = otherModel.title;
    NSDictionary *dic = otherModel.item;
    if (dic[@"specificationDescription"]) {
        _unitLab.text = dic[@"specificationDescription"];
        
    }
    _priceLab.text = [NSString stringWithFormat:@"%@",dic[@"price"]];
    
    _numberLab.text = [NSString stringWithFormat:@"X%@",otherModel.quantity];
    
    
    _picture.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _backImageView.sd_layout.leftSpaceToView(self.contentView,20).topSpaceToView(self.contentView,10).widthIs(80).heightIs(80);
    _nameLab.sd_layout.leftSpaceToView(_picture,10).topEqualToView(_picture).rightSpaceToView(self.contentView,20).autoHeightRatio(0);
    [_nameLab setMaxNumberOfLinesToShow:2];
    
    if (iPhone5) {
        _unitLab.sd_layout.leftEqualToView(_nameLab).topSpaceToView(_nameLab,3).rightEqualToView(_nameLab).autoHeightRatio(0);
        [_unitLab setMaxNumberOfLinesToShow:2];
    }else{
        _unitLab.sd_layout.leftEqualToView(_nameLab).topSpaceToView(_nameLab,10).rightEqualToView(_nameLab).autoHeightRatio(0);
        [_unitLab setMaxNumberOfLinesToShow:2];
    }

    _priceLab.sd_layout.leftEqualToView(_nameLab).bottomEqualToView(_picture).heightIs(16);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:100];
    

}

@end
