//
//  UserWantPL.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserWantPL.h"

@implementation UserWantPL

+ (void)getUserCategorylistwithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{

    HTTPClient *client = [HTTPClient sharedHttpClient];
    //  NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];
    
    
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client getpurchasingneedcategorylistwithReturnBlock:^(id returnValue) {
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

+ (void)addGoodsWithDic:(NSDictionary *)goodsDic withReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    HTTPClient *client = [HTTPClient sharedHttpClient];
    
    
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client userUpGoodwithDic:goodsDic ReturnBlock:^(id returnValue) {
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



#pragma mark - 用户查看他创建的采购
+(void)userLookPurchasingneedWithDic:(NSDictionary *)needsDic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{

    HTTPClient *client = [HTTPClient sharedHttpClient];
    
    
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client userLookHisNeedwithDic:needsDic WithReturnBlock:^(id returnValue) {
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
            }];;
            
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


#pragma mark - 用户获取被编辑采购需求的数据
+ (void)userGetNeedWithNeedId:(NSString *)needId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    
    
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client userGetPurchasingNeedWithNeedId:needId WithReturnBlock:^(id returnValue) {
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
#pragma mark - 用户删除他的采购需求
+ (void)userDeleteNeedWithNeedId:(NSString *)needId andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    HTTPClient *client = [HTTPClient sharedHttpClient];
    
    
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client userDeletePurchasingNeedWithNeedId:needId WithReturnBlock:^(id returnValue) {
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
#pragma mark - 用户编辑采购需求
+ (void)userEditNeedWithNeedId:(NSString *)needId andDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    
    
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client userEditPurchasingNeedWithNeedId:needId andDic:dic WithReturnBlock:^(id returnValue) {
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
#pragma mark -收藏某个采购需求
+ (void)userCollectNeedWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client userCollectNeedWithDic:dic WithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                NSLog(@"用户收藏采购：%@",dic);
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
#pragma mark - 取消收藏某个采购需求
+ (void)userCancleCollectNeedWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client userCancleCollectNeedWithDic:dic WithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                NSLog(@"用户取消收藏采购：%@",dic);
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
#pragma mark - 获取用户收藏的采购需求
+ (void)getUserCollectNeedWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            
            [client getUserCollectNeedsWithDic:dic WithReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                NSLog(@"用户收藏采购列表：%@",dic);
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
@end
