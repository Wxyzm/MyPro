//
//  UserOrderTopCell.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserOrderTopCell.h"
#import "UserOrder.h"
#import "OrderItems.h"
#import "OrderSellerItems.h"
#import "OrderOtherModel.h"
#import "OrderOtherItemModel.h"

@implementation UserOrderTopCell{

    YLButton *_btn;
    UIImageView *_rightImageView;
    NSString *_sellerId;
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

    UIView *topLine = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [self.contentView addSubview:topLine];

    _facImageView = [BaseViewFactory icomWithWidth:20 imagePath:@"icon-shop"];
    _facImageView.frame = CGRectMake(20, 22, 20, 20);
    [self.contentView addSubview:_facImageView];

    
//    NSString *title = @"丰云汇";
//    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13],};
//    CGSize textSize = [title boundingRectWithSize:CGSizeMake(200, 40) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
//    _btn = [YLButton buttonWithType:UIButtonTypeCustom];
//    _btn.frame = CGRectMake(50, 12, textSize.width+25, 40);
//    [_btn setTitle:title forState:UIControlStateNormal];
//    [_btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
//    [_btn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
//    _btn.titleLabel.font =APPFONT(13);
//    [_btn setTitleRect:CGRectMake(0, 0, textSize.width+5, 40)];
//    [_btn setImageRect:CGRectMake(textSize.width+15, 10.5, 10, 19)];
//    [self.contentView  addSubview:_btn];

    
    
    
    _RightLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"等待付款"];
    _RightLab.frame = CGRectMake(ScreenWidth - 200, 12, 180, 40);
    [self.contentView addSubview:_RightLab];
    
    
    _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [self.contentView addSubview:_nameLab];

    _rightImageView = [BaseViewFactory icomWithWidth:10 imagePath:@"right"];
    [self.contentView addSubview:_rightImageView];
    
    
    _btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_btn];
    [_btn addTarget:self action:@selector(btnClick) forControlEvents:UIControlEventTouchUpInside];


}


-(void)setModel:(UserOrder *)model{

    _model = model;
    OrderSellerItems *itemsModel;
    if (self.tag ) {
        itemsModel  = model.sellerItemOrders[self.tag - 1201];
    }else{
        itemsModel  = model.sellerItemOrders[0];
        
    }
   
    OrderItems *item= itemsModel.itemOrders[0];;
    
    _sellerId = item.sellerId;
    if (model.sellerItemOrders.count >1) {
        //多商铺
        OrderSellerItems *itemsModel = model.sellerItemOrders[0];
        OrderItems *item = itemsModel.itemOrders[0];
        _sellerId = @"-1";
        
        if ([item.status intValue] == 0) {
             _RightLab.text = @"等待付款";
        }else if ([item.status intValue] == 4){
            _RightLab.text = @"交易关闭";
        }else{
        
            _RightLab.text = @"";

        }
    }else{
        switch ([item.status intValue]) {
            case 0:{
                //未付款
                _RightLab.text = @"等待付款";
                
                break;
            }
            case 1:{
                //已支付，待发货
                _RightLab.text = @"买家已付款";
                
                break;
            }
            case 2:{
                //卖家已发货
                _RightLab.text = @"卖家已发货";
                
                break;
            }
            case 3:{
                //交易成功   ，确认收货后
                _RightLab.text = @"交易成功";
                
                break;
            }

                
            case 4:{
                //交易关闭
                _RightLab.text = @"交易关闭";
                
                break;
            }
            default:
                break;
        }

    }
    
    
    
    
    
    if (model.sellerItemOrders.count >1) {
        
        //_nameLab.text = @"丰云汇";
        
    }else{
        OrderSellerItems *itemModel = model.sellerItemOrders[0];
        if (itemModel.sellerInfo.length <=0) {
            _nameLab.text = @"该店铺尚未命名";
        }else{
            _nameLab.text = itemModel.sellerInfo;
            
        }
//        _nameLab.text = itemModel.sellerInfo;
        
    }
    _nameLab.sd_layout.leftSpaceToView(_facImageView,10).topSpaceToView(self.contentView,12).heightIs(40);
    [_nameLab setSingleLineAutoResizeWithMaxWidth:200];
    _rightImageView.sd_layout.leftSpaceToView(_nameLab,15).topSpaceToView(self.contentView,24.5).heightIs(16).widthIs(10);
    _btn.sd_layout.leftEqualToView(_facImageView).topSpaceToView(self.contentView,12).heightIs(40).rightEqualToView(_rightImageView);

}


-(void)setOterModel:(OrderOtherModel *)oterModel{

    _oterModel = oterModel;
    if (oterModel.sellerInfo.length <=0) {
        _nameLab.text = @"该店铺尚未命名";
    }else{
        _nameLab.text = oterModel.sellerInfo;

    }
   // _RightLab.text = @"买家已付款";
    OrderOtherItemModel *model = oterModel.itemOrders[0];
    _sellerId = model.sellerId;
    switch ([model.status intValue]) {
        case 0:{
            //未付款
            _RightLab.text = @"等待付款";
            
            break;
        }
        case 1:{
            //已支付，待发货
            _RightLab.text = @"买家已付款";
            
            break;
        }
        case 2:{
            //卖家已发货
            _RightLab.text = @"卖家已发货";
            
            break;
        }
        case 3:{
            //交易成功   ，确认收货后
            _RightLab.text = @"交易成功";
            
            break;
        }
            
            
        case 4:{
            //交易关闭
            _RightLab.text = @"交易关闭";
            
            break;
        }
        default:
            break;
    }

    _nameLab.sd_layout.leftSpaceToView(_facImageView,10).topSpaceToView(self.contentView,12).heightIs(40);
    [_nameLab setSingleLineAutoResizeWithMaxWidth:200];
    _rightImageView.sd_layout.leftSpaceToView(_nameLab,15).topSpaceToView(self.contentView,22.5).heightIs(20).widthIs(10);
    _btn.sd_layout.leftEqualToView(_facImageView).topSpaceToView(self.contentView,12).heightIs(40).rightEqualToView(_rightImageView);

}



- (void)btnClick{

    
    
    if ([self.delegate respondsToSelector:@selector(didselectedShopbtnWithId:)]) {
        [self.delegate didselectedShopbtnWithId:_sellerId];
    }



}


@end
