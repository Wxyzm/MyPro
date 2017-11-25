//
//  OrderFootView.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "OrderFootView.h"

@implementation OrderFootView{

    CGRect leftButtonFrame;
    CGRect rightButtonFrame;
}

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
         leftButtonFrame = CGRectMake(ScreenWidth-190, 44, 80, 29);
         rightButtonFrame = CGRectMake(ScreenWidth-100, 44, 80, 29);

        [self setUP];
    }
    
    return self;
}

- (void)setUP{

    _numLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"共件商品 小计:"];
    _priceLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"￥"];
    _freightLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"(含运费)"];
    
    [self addSubview:_numLab];
    [self addSubview:_priceLab];
    [self addSubview:_freightLab];
    
    _freightLab.sd_layout.rightSpaceToView(self,20).topEqualToView(self).heightIs(39);
    [_freightLab setSingleLineAutoResizeWithMaxWidth:100];
    
    _priceLab.sd_layout.rightSpaceToView(_freightLab,0).topEqualToView(self).heightIs(39);
    [_priceLab setSingleLineAutoResizeWithMaxWidth:100];
   
    _numLab.sd_layout.rightSpaceToView(_priceLab,0).topEqualToView(self).heightIs(39);
    [_numLab setSingleLineAutoResizeWithMaxWidth:200];
    
    
    UIView *lineview = [[UIView alloc]initWithFrame:CGRectMake(0, 38.5, ScreenWidth, 1)];
    lineview.backgroundColor = UIColorFromRGB(PlaColorValue);
    [self addSubview:lineview];
    
    _garyBtn = [SubBtn buttonWithtitle:@"" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:14.5 andtarget:self action:@selector(garyBtnclick)];
    [self addSubview:_garyBtn];
    _colorBtn = [SubBtn buttonWithtitle:@"" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:14.5 andtarget:self action:@selector(colorBtnclick) andframe:CGRectMake(0, 0, 80, 29)];
}

-(void)setTheOrderStatus:(RWMyOrderStatus)orderStatus{
    [self addSubview:_colorBtn];

    _OrderStatus = orderStatus;
    switch (orderStatus) {
        case RWMyOrderStatusSAll:
            [_colorBtn setTitle:@"取消订单" forState:UIControlStateNormal];
            [_garyBtn setTitle:@"付款" forState:UIControlStateNormal];
            _colorBtn.frame = leftButtonFrame;
            _garyBtn.frame = rightButtonFrame;
            break;
        case RWMyOrderStatusWaitPay:
            
            break;
        case RWMyOrderStatusWaitDeliver:
            
            break;
        case RWMyOrderStatusWaitRecipt:
            
            break;
        case RWMyOrderStatusWaitEvaluate:
            
            break;
        default:
            break;
    }
    
}



- (void)garyBtnclick{

}
- (void)colorBtnclick{


}

@end
