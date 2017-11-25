//
//  RCTokenPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/8/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RCTokenPL : NSObject


+ (void)getRcTokenWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;


+ (void)getRcsellersinfoWithdic:(NSDictionary *)dic ReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlcok;

@end
