//
//  GoodsItemsPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GoodsItemsPL.h"

@implementation GoodsItemsPL

#pragma mark - 公共页面获取已经上架的商品
+ (void)GETGoodsIetmsWithDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client GETGoodsIetmsWithDic:dic ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        } else {
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

#pragma mark - 公共页面获取某个的商品数据
+ (void)GETGoodsDetailWithGoodsId:(NSString *)GoodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client clientgetGoodsdetailwithGoodsId:GoodsId ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }

            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        } else {
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

#pragma mark - 添加一个商品到购物车
+ (void)AddGoodsIntoBuyCartWithGoodsInfo:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
  
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client UserAddGoodsIetmsIntoBuyCaryWithGoodsNumber:infoDic[@"quantity"] andid:infoDic[@"goodId"] ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }

            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        } else {
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

#pragma mark - 获取用户创建的商品
+ (void)UserGetCreatedGppdsWithGoodsInfo:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userGetHisGoodsWithDic:infoDic ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }

            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
 
            }];
        } else {
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

#pragma mark - 删除创建的商品
+ (void)userDeleteGoodsWithGoodsid:(NSString *)goodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userDeleteHisGoodsWithGoodsid:goodsId ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }

            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        } else {
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


#pragma mark - 修改商品上架
+ (void)userUpGoodsWithGoodsid:(NSString *)goodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userUpHisGoodsWithGoodsid:goodsId ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }
                
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        } else {
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


#pragma mark - 修改商品下架
+ (void)userDownGoodsWithGoodsid:(NSString *)goodsId ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userDownHisGoodsWithGoodsid:goodsId ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }
                
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        } else {
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

#pragma mark - 获取要被修改更新的商品数据
+ (void)getEditGoodsInfoWithId:(NSString *)goodsId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userGetEditGoodsInfoWithId:goodsId ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

#pragma mark - 获取用户创建的商品
+ (void)UserGetHisMasterProWithGoodsInfo:(NSDictionary *)infoDic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userGetMasterProductwithInfoDic:infoDic ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

#pragma mark - 获取库存警报的产品
+ (void)UserGetHisInventoryAlertProductwithInfoDic:(NSDictionary *)infodic
                                       ReturnBlock:(PLReturnValueBlock)ReturnBlock
                                     andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorCodeBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userGetInventoryAlertProductwithInfoDic:infodic ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    ReturnBlock(dic);
                }else{
                    errorCodeBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorCodeBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

#pragma mark - 产品上架
+ (void)UserOnSaleProductwithIProId:(NSString *)ProId
                        ReturnBlock:(PLReturnValueBlock)ReturnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorCodeBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userUpProductwithProId:ProId ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    ReturnBlock(dic);
                }else{
                    errorCodeBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorCodeBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

#pragma mark -产品下架
+ (void)UserNotSaleProductwithIProId:(NSString *)ProId
                         ReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorCodeBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userDownProductwithProId:ProId ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    ReturnBlock(dic);
                }else{
                    errorCodeBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorCodeBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}
#pragma mark -产品删除
+ (void)UserDeleteProductwithIProId:(NSString *)ProId
                        ReturnBlock:(PLReturnValueBlock)ReturnBlock
                      andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorCodeBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userDeleteProductwithProId:ProId ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    ReturnBlock(dic);
                }else{
                    errorCodeBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorCodeBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}


#pragma mark - 批量产品加入样品间
+ (void)UserbatchsetissamplewithInfo:(NSDictionary *)infoDic
                         ReturnBlock:(PLReturnValueBlock)ReturnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorCodeBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client probatchsetissamplewithInfoDic:infoDic ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    ReturnBlock(dic);
                }else{
                    errorCodeBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorCodeBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}


#pragma mark - 批量产品移出样品间
+ (void)UserbatchsetnotsamplewithInfo:(NSDictionary *)infoDic
                          ReturnBlock:(PLReturnValueBlock)ReturnBlock
                        andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorCodeBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client probatchsetnotsamplewithInfoDic:infoDic ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    ReturnBlock(dic);
                }else{
                    errorCodeBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorCodeBlock(msg);
                } else {
                    [subscriber sendError:nil];
                }
            }];
        }
        return nil;
    }] retry] subscribeNext:^(id x) {
        
    }];
}

#pragma mark - 获取某个产品信息
+ (void)UserGetHisMasterProDETAILWithProId:(NSString *)proId
                               ReturnBlock:(PLReturnValueBlock)returnBlock
                             andErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userGetMasterProductDetailwithProId:proId ReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic);
                }else{
                    errorBlock(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlock(msg);
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
