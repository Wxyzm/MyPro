//
//  MyOrderDetailViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/27.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class UserOrder;
@class OrderOtherModel;

@interface MyOrderDetailViewController : FyhBaseViewController

@property (nonatomic , assign) NSInteger type;   //0全部、未支付     1其他

@property (nonatomic , strong) UserOrder *order;

@property (nonatomic , strong) OrderOtherModel *otherModel;


@end
