//
//  NewAccessViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/9.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class FabricUnitModel;

@interface NewAccessViewController : FyhBaseViewController

@property (nonatomic,strong)FabricUnitModel *dataModel;     //用于保存或者传入编辑数据model

@property (nonatomic,strong)NSString *ProIdStr;

@end
