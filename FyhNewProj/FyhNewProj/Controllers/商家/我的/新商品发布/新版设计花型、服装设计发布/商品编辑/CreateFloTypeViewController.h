//
//  CreateFloTypeViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/9.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class CreateFlowerModel;
@interface CreateFloTypeViewController : FyhBaseViewController

@property (nonatomic,strong)CreateFlowerModel *dataModel;

@property (nonatomic,assign)NSInteger TYPE;


@property (nonatomic,strong)NSString *ProIdStr;


@end
