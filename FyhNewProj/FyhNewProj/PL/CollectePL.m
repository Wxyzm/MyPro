//
//  CollectePL.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/5.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CollectePL.h"

@implementation CollectePL

/**
 收藏某个店铺
 
 @param dic 店铺的卖家sellerIdDic
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)userCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userCollectShopWithShopDic:dic ReturnBlock:^(id returnValue) {
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
 取消收藏某个店铺
 
 @param dic 店铺的卖家sellerIdDic
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)userCancleCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userCancelCollectShopWithShopDic:dic ReturnBlock:^(id returnValue) {
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
 收藏某个商品
 
 @param goodId 商品id
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)userCollectGoodsWithGoodsId:(NSString *)goodId ndReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userColectGoodsWithId:goodId ReturnBlock:^(id returnValue) {
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
 删除某个收藏商品
 
 @param goodId 商品id
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)userCancleCollectGoodsWithGoodsId:(NSString *)goodId ndReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client useracancleColectGoodsWithId:goodId ReturnBlock:^(id returnValue) {
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
获取用户的商品收藏



@param dic 店铺的卖家sellerIdDic
@param returnBlock 成功
@param errorBlick 失败
*/
+ (void)GetUserGoodsCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client getUserGoodsCollecteShopWithDic:dic andReturnBlock:^(id returnValue) {
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
 获取用户收藏的店铺
 
 
 @param dic 店铺的卖家sellerIdDic
 @param returnBlock 成功
 @param errorBlick 失败
 */
+ (void)GetUserShopsCollecteShopWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client getUserShopsCollecteShopWithDic:dic andReturnBlock:^(id returnValue) {
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
        
    }];}



@end
