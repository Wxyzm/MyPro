//
//  GlobalMethod.h
//  FyhNewProj
//
//  Created by yh f on 2017/8/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalMethod : NSObject
/********************************************************************************************/
#pragma 启动相关
//是否第一次安装
+ (BOOL)isFirstiInstall;
/********************************************************************************************/

//得到用户id
+ (NSString *)getUserid;

//连接融云
+ (void)connectRongCloud;

// 获取字符串高度
+ (float) heightForString:(NSString *)value andWidth:(float)width andFont:(UIFont *)font;


//时间戳转时间str
+ (NSString *)returnTimeStrWith:(NSString *)time;


// 根据银行卡号判断银行名称
+ (NSString *)getBankName:(NSString*) cardId;

//检查银行卡是否合法
//Luhn算法
+ (BOOL)isValidCardNumber:(NSString *)cardNumber;


/**
 计算字符串长度

 @param text 字符串
 @return 长度
 */
+  (int)textLength:(NSString *)text;

/**
 根据字节数截取字符串

 @param str 字符串
 @param len 指定字节数/2
 @return 截取后的str
 */
+(NSString*)subTextString:(NSString*)str len:(NSInteger)len;


/**
 获取当前屏幕显示的viewcontroller

 @return viewcontroller
 */
+ (UIViewController *)getCurrentVC;

/**
 词典转换为字符串

 @param dic 词典
 @return 字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;


@end
