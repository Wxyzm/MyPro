//
//  ProjectMacro.h
//  FyhNewProj
//
//  Created by yh f on 2017/3/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#ifndef ProjectMacro_h
#define ProjectMacro_h


//系统版本
//判断是在iOS11之前
#ifndef kiOS11Before
#define kiOS11Before ([[UIDevice currentDevice] systemVersion].floatValue < 11)
#endif


/**
 *  判断是否是空字符串 空字符串 = yes
 *
 *  @param string
 *
 *  @return
 */
#define  IsEmptyStr(string) string == nil || string == NULL ||[string isKindOfClass:[NSNull class]]|| [string isEqualToString:@""] ||[[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0 ? YES : NO
#define NULL_TO_NIL(obj) ({ __typeof__ (obj) __obj = (obj); __obj == [NSNull null] ? nil : obj; })
//--------------      常用颜色     -------------------------

//白色
#define WhiteColorValue          0xffffff
//红色
#define RedColorValue            0xff5d3b
//分割线颜色
#define LineColorValue           0xe6e9ed
//正文
#define BlackColorValue          0x434a54
//#define BlackColorValue          0x4f4f4f

//浅灰
#define LightLineColorValue      0x434a54
//提示颜色
#define PlaColorValue            0xccd1d9
//#define PlaColorValue            0x959595

//浅灰
#define BGColorValue        0xf5f7fa

#define PLAHColorValue        0xaab2bd


//灰色按钮
#define GaryBtnColorValue        0xccd1d9

#define WeakSelf(type)  __weak typeof(type) weak##type = type;
#define StrongSelf(type)  __strong typeof(type) type = weak##type;
//--------------------------------------------------------------------------------------------
//--------------                         微信支付宝appk等     -------------------------
//--------------------------------------------------------------------------------------------

#define WX_APPID @"wx90ca16b8c6c73e4c"
#define WX_APPSecret @""
// 微信支付商户号
#define MCH_ID  @"1"
// 安全校验码（MD5）密钥，商户平台登录账户和密码登录http://pay.weixin.qq.com 平台设置的“API密钥”，为了安全，请设置为以数字和字母组成的32字符串。
#define WX_PartnerKey @""

//比例系数
#define TimeScaleX  MainViewWidth/375
#define TimeScaleY  MainViewHeight/667
#define MainViewWidth   [[UIScreen mainScreen] bounds].size.width
#define MainViewHeight  [[UIScreen mainScreen] bounds].size.height


//iphone各机型判断
#define iPad               CGSizeEqualToSize(CGSizeMake(768, 1024), [[UIScreen mainScreen] bounds].size)
#define iPhone5               CGSizeEqualToSize(CGSizeMake(320, 568), [[UIScreen mainScreen] bounds].size)
#define iPhone6               CGSizeEqualToSize(CGSizeMake(375, 667), [[UIScreen mainScreen] bounds].size)
#define iPhone6p               CGSizeEqualToSize(CGSizeMake(414, 736), [[UIScreen mainScreen] bounds].size)
#define iPhoneX               CGSizeEqualToSize(CGSizeMake(375, 812), [[UIScreen mainScreen] bounds].size)


// 设置颜色.
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

// 获取屏幕高度.
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height
// 获取屏幕宽度
#define ScreenWidth [[UIScreen mainScreen] bounds].size.width

//底部控制栏高度
//#define TABBAR_HEIGHT           60

//导航栏高度
//#define NaviHeight  44
//#define NaviHeight64 64
#define TOPSTATUSBAR_ADD           (iPhoneX?20:0)  //tabbar的默认高度
#define iPhoneX_DOWNHEIGHT       (iPhoneX?34:0)  //tabbar的默认高度
#define TABBAR_HEIGHT           (iPhoneX?83:60)  //tabbar的默认高度
#define STATUSBAR_HEIGHT        (iPhoneX?44:20)  //状态栏高度
#define NaviHeight   (NaviHeight+44)
#define NaviHeight64   (STATUSBAR_HEIGHT+44)//navigation+statue默认高度
#define NAVIGATION_BAR_HEIGHT   (STATUSBAR_HEIGHT+44)  //navigation+statue默认高度

//字体大小
#define FSYSTEMFONT(x) [UIFont systemFontOfSize:(x)]
//加粗
#define FSYSTEMBLODFONTT(x) [UIFont boldSystemFontOfSize:(x)]
//字体大小
#define APPFONT(x) [UIFont systemFontOfSize:(x)]
//加粗
#define APPBLODFONTT(x) [UIFont boldSystemFontOfSize:(x)]
// 账号、密码、网络请求SessionId
//--------------------------------------------------------------------------------------------
#define FYH_USER_ACCOUNT        @"FYHUserPhone"         //账号
#define FYH_USER_ID             @"FYHUserId"            //用户id
#define FYH_USER_PASSWORD            @"FYHPassword"     //用户密码
#define FYH_USER_NAME           @"FYHUsername"          //用户名称
#define FYH_SING_IN             @"FYHUserSingIn"        //登录状态 成功:@“1” 失败:@"0"
#define FYH_RC_Token             @"FYHRCToken"          //融云Token
#define AppVerison          @"appverison"          //app当前版本号

#define IS_FIRST_LOAD          @"IS_FIRST_LOAD"          //是否第一次加载

#define User_bankCard             @"User_bankCard"          //用户默认银行卡



//用户cookies设置信息
#define FYHSessionName          @"sessionCookieName"
#define FYHSessionOption        @"sessionCookieOption"
#define FYHSessionId            @"FYH-Session-Id"
#define FYHSubSession            @"FYH-SubSession"


//获取本地图片的路径
#define GetImage(name)  [UIImage imagePathed:name]
#define GetImagePath(name)  [UIImage imagePathed:name]


//一些方便使用的宏定义****************UtilsMacro***************************//
//Alert展示ARC
#define showAlertARC(x) {UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:x delegate:nil cancelButtonTitle:@"确认" otherButtonTitles:nil , nil];[alert show];}

//ios系统版本
#define ios8x [[[UIDevice currentDevice] systemVersion] floatValue] >=8.0f
#define ios7x ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f) && ([[[UIDevice currentDevice] systemVersion] floatValue] < 8.0f)
#define ios6x [[[UIDevice currentDevice] systemVersion] floatValue] < 7.0f
#define iosNot6x [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f

#if TARGET_IPHONE_SIMULATOR
#define SIMULATOR 1
#elif TARGET_OS_IPHONE
#define SIMULATOR 0
#endif


////zx nslog只在调试版出现
//#ifndef __OPTIMIZE__
//#define NSLog(...) NSLog(__VA_ARGS__)
//#else
//#define NSLog(...) {}
//#endif

#endif
