//
//  ItemsModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemsModel : NSObject

@property (nonatomic , copy) NSString *categoryId;      //所属类目id

@property (nonatomic , copy) NSString *createTime;      //创建时间

@property (nonatomic , copy) NSString *currencyCode;    //所属地区代码

@property (nonatomic , copy) NSString *itemId;          //id

@property (nonatomic , copy) NSString *imageUrl;        //图片展示链接

@property (nonatomic , copy) NSArray *imageUrlList;     //图片数组

@property (nonatomic , copy) NSString *limitUserTotalBuyQuantity;   //限购量

@property (nonatomic , copy) NSString *minBuyQuantity;  //起购量

@property (nonatomic , copy) NSString *price;           //价格

@property (nonatomic , copy) NSString *productId;       //productId

@property (nonatomic , copy) NSString *sales;           //已售数量

@property (nonatomic , copy) NSString *shopCertificationStatus; //shopCertificationStatus

@property (nonatomic , copy) NSString *shopCertificationType;   //shopCertificationType

@property (nonatomic , copy) NSString *shopName;        //店铺名称

@property (nonatomic , copy) NSString *skuCode;         //skuCode

@property (nonatomic , copy) NSString *specificationValueIds;   //specificationValueIds

@property (nonatomic , copy) NSString *status;          //status

@property (nonatomic , copy) NSString *stock;           //库存

@property (nonatomic , copy) NSString *title;           //名称

@property (nonatomic , copy) NSString *unit;            //单位

@property (nonatomic , copy) NSString *updateTime;      //刷新时间



@end
