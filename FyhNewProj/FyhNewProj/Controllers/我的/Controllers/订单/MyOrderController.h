//
//  MyOrderController.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
//加载的方式
typedef NS_ENUM(NSInteger, BtnOnTypes) {
    BTN_ALL              = 1,   //全部
    BTN_UNPAID           = 2,   //未付款
    BTN_UNSENT           = 3,   //待发货
    BTN_UNACCEPT         = 4,   //待收货
    BTN_UNEVA            = 5    //待评价
};
@interface MyOrderController : FyhBaseViewController
@property (nonatomic , assign) BtnOnTypes       btnType;                  //选中按钮种类

@property (nonatomic , assign) NSInteger       backType;                  //backType

@end
