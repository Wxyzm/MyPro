//
//  itemOrdersDataModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface itemOrdersDataModel : NSObject

@property (nonatomic , copy) NSString *theId;

@property (nonatomic , copy) NSString *userOrderId;

@property (nonatomic , copy) NSString *payAmount;

@property (nonatomic , copy) NSString *itemId;

@property (nonatomic , copy) NSString *title;

@property (nonatomic , copy) NSString *status;

@property (nonatomic , copy) NSString *quantity;

@property (nonatomic , copy) NSString *createTime;

@property (nonatomic , copy) NSString *updateTime;

@property (nonatomic , copy) NSString *accountId;

@property (nonatomic , copy) NSString *sellerId;

  @property (nonatomic , copy) NSString *memo;

@property (nonatomic , copy) NSString *currencyCode;

@property (nonatomic , strong) NSDictionary *item;

@property (nonatomic , copy) NSString *itemUrl;

@property (nonatomic , copy) NSString *itemImageUrl;

@property (nonatomic , strong) NSMutableArray *imageUrlList;

@property (nonatomic , copy) NSString *paidTime;

@property (nonatomic , copy) NSString *userOrderMemo;

@property (nonatomic , strong) NSDictionary *userOrderAddress;

@property (nonatomic , copy) NSString *logistics;

@end
