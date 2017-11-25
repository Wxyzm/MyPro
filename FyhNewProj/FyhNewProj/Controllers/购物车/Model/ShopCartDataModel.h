//
//  ShopCartDataModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/27.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopCartDataModel : NSObject

@property (nonatomic , copy) NSString *sellerId;           //店铺名
@property (nonatomic , copy) NSString *sellerInfo;           //店铺名
@property (nonatomic , strong) NSMutableArray *cartItems;             //
@property (nonatomic , assign) BOOL edit;
@property (nonatomic , assign) BOOL selected;

@property (nonatomic , copy) NSString *money;              //价格
@property (nonatomic , copy) NSString *memo;                //备注


@end
