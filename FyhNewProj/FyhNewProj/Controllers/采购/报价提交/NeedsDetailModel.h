//
//  NeedsDetailModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NeedsDetailModel : NSObject

@property (nonatomic , copy) NSString *acceptQuotationId;

@property (nonatomic , copy) NSString *auditRefuseReason;

@property (nonatomic , copy) NSString *categoryId;

@property (nonatomic , copy) NSString *categoryName;

@property (nonatomic , copy) NSString *cdnUrl;

@property (nonatomic , copy) NSString *contact;

@property (nonatomic , copy) NSString *createTime;

@property (nonatomic , copy) NSString *NeedsDescription;      //description替换

@property (nonatomic , copy) NSString *expectUnitPrice;

@property (nonatomic , copy) NSString *expireTime;

@property (nonatomic , copy) NSString *hasSample;

@property (nonatomic , copy) NSString *needid;                //id替换

@property (nonatomic , copy) NSString *imageUrl;

@property (nonatomic , copy) NSArray *imageUrlList;            //图片数组

@property (nonatomic , copy) NSString *isCustom;

@property (nonatomic , copy) NSString *isSame;

@property (nonatomic , copy) NSString *quantity;

@property (nonatomic , copy) NSString *quotationOfCurrentUser;

@property (nonatomic , copy) NSArray *quotations;

@property (nonatomic , copy) NSString *status;

@property (nonatomic , copy) NSString *title;

@property (nonatomic , copy) NSString *unit;

@property (nonatomic , copy) NSString *updateTime;

@property (nonatomic , copy) NSString *viewedCount;
@property (nonatomic , copy) NSString *accountId;

@property (nonatomic , assign)BOOL isUserCollectedPurchasingNeed;
@end
