//
//  BankCardPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BankCardPL.h"

@implementation BankCardPL

/**
 获取用户银行卡
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userGetBankCardWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlcok(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client usergethisBankCardWithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlcok(dic[@"message"]);
                }

            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlcok(msg);
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
 添加银行卡
 
 @param dic 参数
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userAddBankCardWithinfoDic:(NSDictionary *)dic WithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{


    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlcok(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userAddbankcardwithInfoDic:dic WithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlcok(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlcok(msg);
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
 删除用户银行卡
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userDeleteHisBankCardWithId:(NSString *)cardId WithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlcok(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userDeletehisBankCardWithCardId:cardId WithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlcok(dic[@"message"]);
                }

            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlcok(msg);
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
 获取账单
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userGetbillrecordWithinfoDic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlcok(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client usergetbillrecordwithInfoDic:dic WithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlcok(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlcok(msg);
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
 获取余额
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userGetbalanceWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlcok(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client usergetbalanceWithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlcok(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlcok(msg);
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
 用户发起提现请求
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userDrawalRequestWithDic:(NSDictionary *)dic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlcok(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client userdrawalrequestWithDic:dic withReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlcok(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlcok(msg);
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
 用户查看提现请求记录
 
 @param returnBlock returnBlock description
 @param errorBlcok errorBlcok description
 */
+ (void)userCheckDrawalRequestListWithDic:(NSDictionary *)dic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlcok(@"网络不给力啊!");
        }
        if (timeNum % 2 == 1) {
            [client usercheckdrawalrequestListWithDic:dic withReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    returnBlock(dic[@"data"]);
                }else{
                    errorBlcok(dic[@"message"]);
                }
            } andErrorBlock:^(NSString *msg) {
                if (timeNum > 1) {
                    errorBlcok(msg);
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
