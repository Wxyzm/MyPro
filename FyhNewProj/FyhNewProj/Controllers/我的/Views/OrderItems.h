//
//  OrderItems.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderItems : NSObject

@property (nonatomic , copy) NSString *theId;           //id

@property (nonatomic , copy) NSString *userOrderId;     //OrderId

@property (nonatomic , copy) NSString *payAmount;       //总价

@property (nonatomic , copy) NSString *itemId;          //子订单id

@property (nonatomic , copy) NSString *title;           //商品名称

@property (nonatomic , copy) NSString *status;          //订单状态

@property (nonatomic , copy) NSString *quantity;        //数量

@property (nonatomic , copy) NSString *createTime;      //创建时间

@property (nonatomic , copy) NSString *updateTime;      //更新时间

@property (nonatomic , copy) NSString *accountId;       //账号id

@property (nonatomic , copy) NSString *sellerId;        //卖家id

@property (nonatomic , copy) NSString *memo;            //备注

@property (nonatomic , copy) NSString *currencyCode;    //中国

@property (nonatomic , strong) NSDictionary *logistics;       //
@property (nonatomic , copy) NSString *logisticsAmount;       //物流价格


@property (nonatomic , copy) NSString *sellerInfo;      //店家名称

@property (nonatomic , copy) NSString *imageUrl;        //图片

@property (nonatomic , copy) NSString *itemUrl;         //

@property (nonatomic , copy) NSString *itemSpecificationDescription;  //规格

@property (nonatomic , strong) NSArray *imageUrlList;     //图片



@end
