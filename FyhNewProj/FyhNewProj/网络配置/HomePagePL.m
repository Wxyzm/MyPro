//
//  HomePagePL.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/23.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "HomePagePL.h"

@implementation HomePagePL

/**
 获取首页数据
 
 @param returnBlock 成功
 @param errorBlock 失败
 */
+ (void)getHomeDatasWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client getHomePageDataswithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
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



@end
