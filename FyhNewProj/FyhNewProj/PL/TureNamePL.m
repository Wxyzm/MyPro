//
//  TureNamePL.m
//  FyhNewProj
//
//  Created by yh f on 2017/8/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "TureNamePL.h"

@implementation TureNamePL

/**
 获取实名认证状态
 @param returnBlock success
 @param errorBlick error
 */
+ (void)UserGetcertifiCationStatusReturnBlock:(PLReturnValueBlock)returnBlock
                                andErrorBlock:(PLErrorCodeBlock)errorBlick{

    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userGetcertifiCationStatusReturnBlock:^(id returnValue) {
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
 shangjia获取实名认证状态
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BussUserGetcertifiCationStatusReturnBlock:(PLReturnValueBlock)returnBlock
                                    andErrorBlock:(PLErrorCodeBlock)errorBlick{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlick(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client bussuserGetcertifiCationStatusReturnBlock:^(id returnValue) {
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
@end
