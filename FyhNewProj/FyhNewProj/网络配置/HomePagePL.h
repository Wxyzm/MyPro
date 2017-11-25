//
//  HomePagePL.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/23.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HomePagePL : NSObject


/**
 获取首页数据

 @param returnBlock 成功
 @param errorBlock 失败
 */
+ (void)getHomeDatasWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlock;



@end
