//
//  OrderSellerItems.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderSellerItems : NSObject

@property (nonatomic , copy) NSString *sellerInfo;

@property (nonatomic , strong) NSMutableArray *itemOrders;


@property (nonatomic , copy) NSString *logisticsAmount;
@end
