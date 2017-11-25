//
//  TureNamePL.h
//  FyhNewProj
//
//  Created by yh f on 2017/8/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TureNamePL : NSObject
/**
 获取实名认证状态
 @param returnBlock success
 @param errorBlick error
 */
+ (void)UserGetcertifiCationStatusReturnBlock:(PLReturnValueBlock)returnBlock
                       andErrorBlock:(PLErrorCodeBlock)errorBlick;


/**
 shangjia获取实名认证状态
 @param returnBlock success
 @param errorBlick error
 */
+ (void)BussUserGetcertifiCationStatusReturnBlock:(PLReturnValueBlock)returnBlock
                                andErrorBlock:(PLErrorCodeBlock)errorBlick;
@end
