//
//  OrderFootView.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, RWMyOrderStatus)
{
    RWMyOrderStatusSAll = 0,            //全部
    RWMyOrderStatusWaitPay = 1,         //待付款
    RWMyOrderStatusWaitDeliver = 2,     //待发货
    RWMyOrderStatusWaitRecipt = 3,      //待收货
    RWMyOrderStatusWaitEvaluate = 4     //待评价
    
    
};



@interface OrderFootView : UIView


@property (nonatomic,assign)RWMyOrderStatus  OrderStatus;

@property (nonatomic , strong) UILabel  *numLab;

@property (nonatomic , strong) UILabel  *priceLab;

@property (nonatomic , strong) UILabel  *freightLab;

@property (nonatomic , strong) SubBtn   *garyBtn;

@property (nonatomic , strong) SubBtn   *colorBtn;

-(void)setTheOrderStatus:(RWMyOrderStatus )orderStatus;

@end
