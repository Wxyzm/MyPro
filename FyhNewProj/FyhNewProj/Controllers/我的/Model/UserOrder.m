//
//  UserOrder.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserOrder.h"

@implementation UserOrder
+ (NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"orderId": @"id"};
}

+(NSDictionary *)mj_objectClassInArray
{
    return @{
             @"itemOrders":@"OrderItems",
             @"sellerItemOrders":@"OrderSellerItems",
             
             };
}


-(id)mutableCopyWithZone:(NSZone *)zone{

    UserOrder   *order = [[self class] allocWithZone:zone];
    order.orderId = [_orderId mutableCopy];
    order.payAmount = [_payAmount mutableCopy];
    order.itemIdList = [_itemIdList mutableCopy];
    order.title = [_title mutableCopy];
    order.status = [_status mutableCopy];
    order.createTime = [_createTime mutableCopy];
    order.updateTime = [_updateTime mutableCopy];
    order.currencyCode = [_currencyCode mutableCopy];
    order.addressId = [_addressId mutableCopy];
    order.paidType = [_paidType mutableCopy];
    order.memo = [_memo mutableCopy];
    order.itemOrders = [_itemOrders mutableCopy];
    order.sellerItemOrders = [_sellerItemOrders mutableCopy];
    order.address = [_address mutableCopy];
    return order;

}


@end
