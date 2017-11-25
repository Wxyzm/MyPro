//
//  ShopSettingPL.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/6.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShopSettingPL : NSObject

//获取当前店铺的id
+ (void)getTheShopIdWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;


//获取当前店铺的设置信息
+ (void)getTheShopSettingInfoWithReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

//批量设置店铺信息
+ (void)SettingTheShopInfoWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

//设置自定义数据
+ (void)SettingCustomShopInfoWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;

//获取自定义数据
+ (void)GetCustomShopInfoWithDic:(NSDictionary *)dic andReturnBlock:(PLReturnValueBlock)returnBlock andErrorBlock:(PLErrorCodeBlock)errorBlick;
@end
