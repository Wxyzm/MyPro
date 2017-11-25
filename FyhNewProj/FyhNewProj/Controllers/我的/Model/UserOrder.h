//
//  UserOrder.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserOrder : NSObject<NSMutableCopying>

@property (nonatomic , copy)  NSString *orderId;

@property (nonatomic , copy)  NSString *payAmount;

@property (nonatomic , copy)  NSString *itemIdList;

@property (nonatomic , copy)  NSString *title;

@property (nonatomic , copy)  NSString *status;

@property (nonatomic , copy)  NSString *createTime;

@property (nonatomic , copy)  NSString *updateTime;

@property (nonatomic , copy)  NSString *currencyCode;

@property (nonatomic , copy)  NSString *addressId;

@property (nonatomic , copy)  NSString *paidType;

@property (nonatomic , copy)  NSString *paidTime;

@property (nonatomic , copy)  NSString *memo;

@property (nonatomic , strong)  NSMutableArray *itemOrders;

@property (nonatomic , strong)  NSMutableArray *sellerItemOrders;

@property (nonatomic , strong)  NSDictionary *address;

@end
