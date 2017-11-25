//
//  UserInfoChangePL.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UserInfoChangePL.h"
#import "UserInfoModel.h"

@implementation UserInfoChangePL

- (void)upuserInfoWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{

    
    HTTPClient *client = [HTTPClient sharedHttpClient];
    NSMutableDictionary *bodyDic = [[NSMutableDictionary alloc] init];

    
    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            [bodyDic removeAllObjects];
            
            if ([_infoModel.gender isEqualToString:@"男"]) {
                [bodyDic setValue:@"1" forKey:@"gender"];

            }else if ([_infoModel.gender isEqualToString:@"女"]){
                [bodyDic setValue:@"2" forKey:@"gender"];

            }
//            [bodyDic setValue:_infoModel.gender forKey:@"gender"];
            [bodyDic setValue:_infoModel.birthday forKey:@"birthday"];
            [bodyDic setValue:_infoModel.nickname forKey:@"nickname"];
            
            NSString *urlstr = _infoModel.upUrl;
            [bodyDic setValue:urlstr forKey:@"avatarUrl"];

//            NSArray *arr = [urlstr  componentsSeparatedByString:@"http://114.55.5.207:82/"];
//            if (arr.count>1) {
//                [bodyDic setValue:arr[1] forKey:@"avatarUrl"];
//            }
//            NSArray *arr = imageDic[@"imageUrls"];
//            NSArray *upArr = [arr[0] componentsSeparatedByString:imageDic[@"cdnUrl"]];

            [client refreshUserInfoWithInfoDic:bodyDic withReturnBlock:^(id returnValue) {
                NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
                if ([dic[@"code"] intValue]==-1) {
                    NSNotification *notification =[NSNotification notificationWithName:@"userDataIsChange" object:nil userInfo:nil];
                    //通过通知中心发送通知
                    [[NSNotificationCenter defaultCenter] postNotification:notification];
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


- (void)getUserInfoWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock{

    HTTPClient *client = [HTTPClient sharedHttpClient];

    __block int timeNum = 0;
    [[[RACSignal createSignal:^RACDisposable *(id subscriber){
        timeNum ++;
        if (timeNum > 3) {//调用超过3次就不继续循环调用
            errorBlock(@"网络不给力啊!");
        }
        
        if (timeNum % 2 == 1) {
            [client getUserInfowithReturnBlock:^(id returnValue) {
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



@end
