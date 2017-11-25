//
//  GoodsPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GoodsPL.h"

@implementation GoodsPL


+ (void)getGoodsCategorywithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{

    HTTPClient *client = [HTTPClient sharedHttpClient];
    //  NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client getGoodsCategorywithReturnBlock:^(id returnValue) {
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
//发布商品分类类目
+ (void)getFabuGoodsCategorywithReturnBlock:(PLReturnValueBlock)ReturnBlock
                              andErrorBlock:(PLErrorCodeBlock)errorCodeBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    //  NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorCodeBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client getFabuGoodsCategorywithReturnBlock:^(id returnValue) {
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
