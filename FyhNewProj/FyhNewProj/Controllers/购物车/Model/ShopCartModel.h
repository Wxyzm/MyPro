//
//  ShopCartModel.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShopCartitemsModel.h"

@interface ShopCartModel : NSObject



@property (nonatomic , copy) NSString *proId;           //id

@property (nonatomic , copy) NSString *itemId;

@property (nonatomic , copy) NSString *itemTitle;

@property (nonatomic , copy) NSString *quantity;        //数量

@property (nonatomic , copy) NSString *isChecked;

@property (nonatomic , copy) NSString *price;

@property (nonatomic , copy) NSString *priceDisplay;

@property (nonatomic , copy) NSString *currencyCode;

@property (nonatomic , strong) ShopCartitemsModel *item;

@property (nonatomic , assign) BOOL edit;

@property (nonatomic , assign) BOOL selected;

@end
