//
//  OrderOtherModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderOtherModel : NSObject

@property (nonatomic , strong) NSString *userOrderIdAndSellerId;

@property (nonatomic , strong) NSMutableArray *itemOrders;

@property (nonatomic , strong) NSString *logisticsAmount;

@property (nonatomic , strong) NSString *sellerInfo;



@end
