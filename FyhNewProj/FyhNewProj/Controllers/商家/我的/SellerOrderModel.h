//
//  SellerOrderModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SellerOrderModel : NSObject

@property (nonatomic , copy) NSString *buyerInfo;

@property (nonatomic , copy) NSString *userOrderId;

@property (nonatomic , copy) NSString *logisticsAmount;

@property (nonatomic , strong) NSMutableArray *itemOrdersData;

@property (nonatomic , copy) NSString *payAmount;


@property (nonatomic , assign) BOOL on;

@end
