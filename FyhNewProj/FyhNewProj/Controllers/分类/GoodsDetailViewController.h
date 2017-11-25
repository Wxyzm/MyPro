//
//  GoodsDetailViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class ItemsModel;
@interface GoodsDetailViewController : FyhBaseViewController

@property (nonatomic , strong) ItemsModel *itemModel;

@property (nonatomic , assign) NSInteger shopType;          //1个人  2商家   3返回到首页


@end
