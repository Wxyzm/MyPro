//
//  BussShopSearchViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/10/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class GoodItemsNetModel;

@interface BussShopSearchViewController : FyhBaseViewController

@property (nonatomic,copy)NSString  *searchStr;

@property (nonatomic,copy)NSString  *shopId;


@property (nonatomic , strong)   GoodItemsNetModel *netModel;

@end
