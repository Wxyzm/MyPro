//
//  ShopReleaseGoodsController.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"


typedef enum _ReleaseType{
    ReleaseType_CreativeDesign  = 0,    //创意设计
    ReleaseType_Accessories,            //辅料
    ReleaseType_Fabric                  //面料
} ReleaseType;



@interface ShopReleaseGoodsController : FyhBaseViewController

@property (nonatomic , assign) ReleaseType releaseType;

@end
