//
//  OrderPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "OrderPL.h"

@implementation OrderPL
/**
 买家获取他的ItemOrder
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersGetItemOrderWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client buyersGetHisItemOrderwithInfoDic:infoDic andReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }

            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }else{
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

/**
 买家获取他的UserOrder
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersGetUserOrderWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client buyersGetHisUserOrderwithInfoDic:infoDic andReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }else{
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}
/**
 买家获取他按照卖家分组后的ItemOrder
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersGetgroupitemordersWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client buyersGetHisgroupItemOrderswithInfoDic:infoDic andReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }

            }];
        }else{
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

/**
 买家取消某个UserOrder
 
 
 
 @param orderId 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersCancleOrderWithorderID:(NSString *)orderId
                         ReturnBlock:(PLReturnValueBlock)returnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client buyersCancleUserOrderwithorderID:orderId andReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }else{
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

/**
 买家批量确认收货
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersmakeSureAcceptedGoodsWithinfoDic:(NSDictionary *)infoDic
                                   ReturnBlock:(PLReturnValueBlock)returnBlock
                                 andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client buyersmakeSureAcceptedGoodsWithinfoDic:infoDic ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }else{
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}
/**
 买家删除某个UserOrder
 
 @param orderId 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersDeleteOrderWithorderID:(NSString *)orderId
                         ReturnBlock:(PLReturnValueBlock)returnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client buyersDeleteHisUserOrderwithOrderId:orderId andReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }else{
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

/**
 卖家获取分组后的商品订单
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)SellerGetGroupItemOrderWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client SellersGetHisGroupItemOrderwithInfoDic:infoDic andReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }else{
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}



/**
 卖家添加物流信息并发货
 
 @param infoDic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)SellerupdatelogisticsItemWithinfoDic:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client SellersupdatelogisticswithInfoDic:infoDic andReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }else{
            [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
            [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
                [subscriber sendError:nil];
            } withErrorBlock:^(NSString *msg) {
                [subscriber sendError:nil];
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

/**
 买家获取相关商品订单数目数据
 
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BuyersGetordercountsWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
  
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client buyersGetordercountsWithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }

            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}


/**
 卖家获取相关商品订单数目数据
 
 @param returnBlock success
 @param errorBlick error
 */
+ (void)SellerGetordercountsWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client sellersGetordercountsWithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlick(dic[@"message"]);
                }

            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlick(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

@end
