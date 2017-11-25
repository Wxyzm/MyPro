//
//  demandViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/4/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class MyNeedsModel;
@interface demandViewController : FyhBaseViewController

@property (nonatomic , strong) MyNeedsModel *model;

@property (nonatomic , assign) NSInteger type;

@end
