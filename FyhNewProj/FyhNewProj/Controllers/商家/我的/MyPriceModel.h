//
//  MyPriceModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/26.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyPriceModel : NSObject

@property (nonatomic , copy) NSString *acceptTime;

@property (nonatomic , copy) NSString *accountId;

@property (nonatomic , copy) NSString *createTime;

@property (nonatomic , copy) NSString *currencyCode;

@property (nonatomic , copy) NSString *priceId;

@property (nonatomic , copy) NSString *isDisplayForSupplier;

@property (nonatomic , copy) NSString *memo;

@property (nonatomic , copy) NSString *price;

@property (nonatomic , strong) NSDictionary *purchasingNeed;

@property (nonatomic , copy) NSString *purchasingNeedId;

@property (nonatomic , copy) NSString *status;



@end
