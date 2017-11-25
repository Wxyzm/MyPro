//
//  PayPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "PayPL.h"

@implementation PayPL

/**
 对某个商品结算创建订单-立即购买
 
 @param dic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)payAtOnceWithId:(NSString *)proId andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userPayAtOnceWithId:proId andDic:dic andReturnBlock:^(id returnValue) {
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
 从购物车开始结算创建订单
 
 @param dic 参数
 @param returnBlock success
 @param errorBlick error
 */
+ (void)payForShopCartWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock )errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client settlementMoneyWithdic:dic andReturnBlock:^(id returnValue) {
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
 支付宝支付
 
 @param orderId orderid
 @param returnBlock success
 @param errorBlick error
 */
+ (void)ailPayWithOrderId:(NSString *)orderId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client getAilPayOrderStrWithOrderId:orderId andReturnBlock:^(id returnValue) {
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
微信支付

@param orderId orderid
@param returnBlock success
@param errorBlick error
*/
+ (void)weixinPayWithOrderId:(NSString *)orderId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client getWeixinPayOrderStrWithOrderId:orderId andReturnBlock:^(id returnValue) {
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
        
    }];}
@end
