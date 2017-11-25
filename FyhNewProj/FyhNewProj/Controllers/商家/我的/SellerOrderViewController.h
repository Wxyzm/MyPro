//
//  SellerOrderViewController.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
//加载的方式
typedef NS_ENUM(NSInteger, SLoadTypes) {
    SBTN_ALL               = 1,   //全部
    SBTN_UnPay             = 2,   //未付款
    SBTN_UnSent            = 3,   //待发货
    SBTN_Refund            = 4,   //退款中
    SBTN_Sented            = 5,   //已发货
    SBTN_Completed         = 6,   //已完成
    SBTN_Closed            = 7    //已关闭
    
};
@interface SellerOrderViewController : FyhBaseViewController

@property (nonatomic , assign) SLoadTypes       btnType;                  //选中按钮种类

@end
