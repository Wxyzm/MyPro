//
//  GItemModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/23.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GItemModel : NSObject

@property (nonatomic , copy) NSString *itemID;

@property (nonatomic , copy) NSString *accountId;

@property (nonatomic , copy) NSString *createTime;

@property (nonatomic , copy) NSString *updateTime;

@property (nonatomic , copy) NSString *title;

@property (nonatomic , copy) NSString *imageUrl;

@property (nonatomic , copy) NSString *detail;

@property (nonatomic , copy) NSString *categoryId;

@property (nonatomic , copy) NSString *productId;

@property (nonatomic , copy) NSString *specificationValueIds;

@property (nonatomic , copy) NSString *price;

@property (nonatomic , copy) NSString *currencyCode;

@property (nonatomic , copy) NSString *status;

@property (nonatomic , copy) NSString *skuCode;

@property (nonatomic , copy) NSString *unit;

@property (nonatomic , copy) NSString *stock;

@property (nonatomic , copy) NSString *minBuyQuantity;

@property (nonatomic , copy) NSString *limitUserTotalBuyQuantity;

@property (nonatomic , copy) NSString *sales;

@property (nonatomic , copy) NSString *buyerHasBoughtQuantityInLimitTotalBuy;

@property (nonatomic , copy) NSString *categoryDescription;

@property (nonatomic , copy) NSArray *imageUrlList;                         //array

@property (nonatomic , copy) NSString *cdnUrl;

@property (nonatomic , copy) NSArray *specificationValues;                  //array

@property (nonatomic , strong) NSArray *attributes;

@property (nonatomic , strong) NSDictionary *shop;

@property (nonatomic , strong) NSDictionary *product;

@property (nonatomic , strong) NSArray *specificationList;




@end
