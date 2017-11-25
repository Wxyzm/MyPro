//
//  NewFaViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
@class FabricUnitModel;

@interface NewFaViewController : FyhBaseViewController


@property (nonatomic,strong)FabricUnitModel *dataModel;     //用于保存或者传入编辑数据model


@property (nonatomic,strong)NSString *ProIdStr;


@end
