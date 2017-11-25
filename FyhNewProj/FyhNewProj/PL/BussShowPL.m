//
//  BussShowPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BussShowPL.h"

@implementation BussShowPL

/**
 买家查看店铺信息
 @param shopId 参数id
 @param returnBlock success
 @param errorBlick error
 */
+ (void)GetShopInfoWithShopID:(NSString *)shopId andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client getShopInfoWiId:shopId andDic:dic andReturnBlock:^(id returnValue) {
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
                }            }];
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

@end
