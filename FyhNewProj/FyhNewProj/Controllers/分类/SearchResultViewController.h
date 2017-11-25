//
//  SearchResultViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class GoodItemsNetModel;
@interface SearchResultViewController : FyhBaseViewController


@property (nonatomic , copy) NSString *searchStr;
@property (nonatomic , strong)   GoodItemsNetModel *netModel;

@end
