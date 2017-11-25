//
//  AppDelegate.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"
#import "DOTabBarController.h"
#import "DOHNavigationController.h"
#import "UserPL.h"
#import "IQKeyboardManager.h"
#import "UMMobClick/MobClick.h"
// 引入JPush功能所需头文件
#import "JPUSHService.h"
// iOS10注册APNs所需头文件
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif
// 如果需要使用idfa功能所需要引入的头文件（可选）
#import <AdSupport/AdSupport.h>

#import "RongIMKit/RongIMKit.h"
//支付宝
#import <AlipaySDK/AlipaySDK.h>

#import "WXApi.h"
#import "WXApiManager.h"

#import "MemberLoginController.h"
#import "DOHNavigationController.h"
#import "UserPL.h"

//友盟分享
#import <UMSocialCore/UMSocialCore.h>
#import "RCTokenPL.h"
#import "DIYGoodsMessage.h"
#import "UserInfoModel.h"
#import "xxxxViewController.h"

@interface AppDelegate ()<JPUSHRegisterDelegate,UITabBarControllerDelegate,WXApiDelegate,RCIMUserInfoDataSource>


@end

@implementation AppDelegate{
    
    UIWebView * tempWebView;
}


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

    //微信支付
    [WXApi registerApp:@"wx90ca16b8c6c73e4c"];
    
    //键盘监控
    [self initKeyBoardManage];
    //修改webView的UserAgent
    tempWebView = [[UIWebView alloc] initWithFrame:CGRectZero];
    NSString * oldAgent = [tempWebView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
    NSString * newAgent = oldAgent;
    if (![oldAgent hasSuffix:@"FYHIOS"])
    {
        newAgent = [oldAgent stringByAppendingString:@"/FYHIOS"];
    }
    NSLog(@"new agent :%@", newAgent);
    NSDictionary * dictionnary = [[NSDictionary alloc] initWithObjectsAndKeys:newAgent, @"UserAgent", nil];
    [[NSUserDefaults standardUserDefaults] registerDefaults:dictionnary];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    _mainController=[[DOTabBarController alloc] init];
    [_mainController settheType:1];
    _mainController.delegate = self;
    self.window.rootViewController = _mainController;
    
    
   
        self.mConnBLE = [[ConnectViewController alloc] initWithNibName:nil bundle:nil];

/////////////////////////////////友盟统计////////////////////////////////////
    UMConfigInstance.appKey = @"58d8ae8da40fa36ba6001551";
    UMConfigInstance.channelId = @"App Store";
    [MobClick startWithConfigure:UMConfigInstance];
    
////////////////////////////////极光推送////////////////////////////////////

    //Required
    //notice: 3.0.0及以后版本注册可以这样写，也可以继续用之前的注册方式
    JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
    entity.types = JPAuthorizationOptionAlert|JPAuthorizationOptionBadge|JPAuthorizationOptionSound;
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 可以添加自定义categories
        // NSSet<UNNotificationCategory *> *categories for iOS10 or later
        // NSSet<UIUserNotificationCategory *> *categories for iOS8 and iOS9
    }
    [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    // Required
    // init Push
    // notice: 2.1.5版本的SDK新增的注册方法，改成可上报IDFA，如果没有使用IDFA直接传nil
    // 如需继续使用pushConfig.plist文件声明appKey等配置内容，请依旧使用[JPUSHService setupWithOption:launchOptions]方式初始化。
    [JPUSHService setupWithOption:launchOptions appKey:@"01432afe4c7664ab2dcb2619"
                          channel:@"App Store"
                 apsForProduction:1
            advertisingIdentifier:@""];
    
////////////////////////////////融云////////////////////////////////////
  
    [self initRongCloudSDK];
   
    self.LYConnBLE = [[LYConnectViewController alloc]init];

    
    //判断是否登录
    if ([[UserPL shareManager]userIsLogin]) {
        [[UserPL shareManager] setUserData:[[UserPL shareManager] getLoginUser]];
        [[UserPL shareManager] userLoginWithReturnBlock:^(id returnValue) {
            [RCTokenPL getRcTokenWithReturnBlock:^(id returnValue) {
                
                [[NSUserDefaults standardUserDefaults]setObject:returnValue[@"rongcloudResponse"][@"token"]
                                                         forKey:FYH_RC_Token];
                [GlobalMethod connectRongCloud];

            } andErrorBlock:^(NSString *msg) {
                
            }];
            NSLog(@"用户登陆成功");
        } withErrorBlock:^(NSString *msg) {
            [[UserPL shareManager] logout];
             NSLog(@"用户登陆失败：%@",msg);
        }];
    }
//友盟分享
  
    /* 打开调试日志 */
    [[UMSocialManager defaultManager] openLog:YES];
    
    /* 设置友盟appkey */
    [[UMSocialManager defaultManager] setUmSocialAppkey:@"58d8ae8da40fa36ba6001551"];
    
    [self configUSharePlatforms];
    
    [self confitUShareSettings];
    
    return YES;
}


//融云SDK初始化   在登陆时候连接
- (void)initRongCloudSDK{
    [[RCIM sharedRCIM]initWithAppKey:@"sfci50a7sq58i"];
    
    //获取应用程序消息通知标记数（即小红圈中的数字）
    long badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if (badge>0) {
        //如果应用程序消息通知标记数（即小红圈中的数字）大于0，清除标记。
        badge = 0;
        //清除标记。清除小红圈中数字，小红圈中数字为0，小红圈才会消除。
        [UIApplication sharedApplication].applicationIconBadgeNumber = badge;
    }
    [[RCIM sharedRCIM]registerMessageType:DIYGoodsMessage.class];
    [[RCIM sharedRCIM] setGlobalConversationAvatarStyle:RC_USER_AVATAR_RECTANGLE];
    [[RCIM sharedRCIM] setGlobalMessageAvatarStyle:RC_USER_AVATAR_RECTANGLE];
    [RCIM sharedRCIM].globalNavigationBarTintColor = [UIColor whiteColor];
    //设置用户信息提供者。
    [[RCIM sharedRCIM] setUserInfoDataSource:self];


}


//获取用户数据,设置头像昵称等
- (void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion
{
    if (![[UserPL shareManager] userIsLogin]) {
        return;
    }
     if ([userId length] == 0) return;
    if ([userId isEqualToString:[GlobalMethod getUserid]]) {
        HTTPClient *client = [HTTPClient sharedHttpClient];
        [client getUserInfowithReturnBlock:^(id returnValue) {
            NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
            NSDictionary *redic = dic[@"data"];
            UserInfoModel *infomodel = [UserInfoModel mj_objectWithKeyValues:redic[@"userProfile"]];
            RCUserInfo *user = [[RCUserInfo alloc]init];
            user.userId = infomodel.accountId;
            user.name = infomodel.nickname;
            user.portraitUri = infomodel.avatarUrl ;
            [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:infomodel.accountId];
             return completion(user);
          //  [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:infomodel.accountId];
        } andErrorBlock:^(NSString *msg) {
             return completion([RCIMClient sharedRCIMClient].currentUserInfo);
        }];

    } else {
        NSDictionary *dic = @{@"sellerIds":userId};
        [RCTokenPL getRcsellersinfoWithdic:dic ReturnBlock:^(id returnValue) {
            NSArray *arr = returnValue[@"shopInfoList"];
            NSDictionary *dic = arr[0];
            RCUserInfo *user = [[RCUserInfo alloc] init];
            user.userId = userId;
            if (NULL_TO_NIL(dic[@"shopName"]) ) {
                user.name = dic[@"shopName"];
            }else{
                user.name = dic[@"sellerInfo"];

            }
            user.portraitUri = NULL_TO_NIL(dic[@"shopLogoImageUrl"]) ;
            return completion(user);
        } andErrorBlock:^(NSString *msg) {
            return completion(nil);

        }];
    }
}




- (void)confitUShareSettings
{
    /*
     * 打开图片水印
     */
    //[UMSocialGlobal shareInstance].isUsingWaterMark = YES;
    
    /*
     * 关闭强制验证https，可允许http图片分享，但需要在info.plist设置安全域名
     <key>NSAppTransportSecurity</key>
     <dict>
     <key>NSAllowsArbitraryLoads</key>
     <true/>
     </dict>
     */
    //[UMSocialGlobal shareInstance].isUsingHttpsWhenShareContent = NO;
    
}

- (void)configUSharePlatforms
{
    /*
     设置微信的appKey和appSecret
     [微信平台从U-Share 4/5升级说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_1
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_WechatSession appKey:@"wx90ca16b8c6c73e4c" appSecret:@"3baf1193c85774b3fd9d18447d76cab0" redirectURL:nil];
    

    
   
    /*
     * 移除相应平台的分享，如微信收藏
     */
    //[[UMSocialManager defaultManager] removePlatformProviderWithPlatformTypes:@[@(UMSocialPlatformType_WechatFavorite)]];
    
    /* 设置分享到QQ互联的appID
     * U-Share SDK为了兼容大部分平台命名，统一用appKey和appSecret进行参数设置，而QQ平台仅需将appID作为U-Share的appKey参数传进即可。
     100424468.no permission of union id
     [QQ/QZone平台集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_3
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_QQ appKey:@"1106008540"/*设置QQ平台的appID*/  appSecret:nil redirectURL:@"http://mobile.umeng.com/social"];
    
    /*
     设置新浪的appKey和appSecret
     [新浪微博集成说明]http://dev.umeng.com/social/ios/%E8%BF%9B%E9%98%B6%E6%96%87%E6%A1%A3#1_2
     */
    [[UMSocialManager defaultManager] setPlaform:UMSocialPlatformType_Sina appKey:@"3921700954"  appSecret:@"04b48b094faeb16683c32669824ebdad" redirectURL:@"https://sns.whalecloud.com/sina2/callback"];
    
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
    return  [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}

- (void)onResp:(BaseResp *)resp
{
    
    
    
    if([resp isKindOfClass:[PayResp class]]){
        //支付返回结果，实际支付结果需要去微信服务器端查询
        NSString *strMsg,*strTitle = [NSString stringWithFormat:@"支付结果"];
        NSString *weixinPayCompleted;
        //发出通知
        
        switch (resp.errCode) {
            case WXSuccess:
                
                strMsg = @"支付结果：成功！";
                NSLog(@"支付成功－PaySuccess，retcode = %d", resp.errCode);
                weixinPayCompleted = @"9000";
                break;
                
            default:
                strMsg = @"支付结果：失败!";
                // strMsg = [NSString stringWithFormat:@"支付结果：失败！retcode = %d, retstr = %@", resp.errCode,resp.errStr];
                NSLog(@"错误，retcode = %d, retstr = %@", resp.errCode,resp.errStr);
                weixinPayCompleted = @"8000";
                break;
        }
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:strTitle message:strMsg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        NSNotification * notification = [NSNotification notificationWithName:@"weixinPayComPleted" object:weixinPayCompleted];
        [[NSNotificationCenter defaultCenter] postNotification:notification];

    }
    
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
        //6.3的新的API调用，是为了兼容国外平台(例如:新版facebookSDK,VK等)的调用[如果用6.2的api调用会没有回调],对国内平台没有影响
    BOOL result = [[UMSocialManager defaultManager] handleOpenURL:url sourceApplication:sourceApplication annotation:annotation];
    if (!result) {
        // 其他如支付等SDK的回调
        if ([url.host isEqualToString:@"safepay"]) {
            // 支付跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ailPayComPleted" object:resultDic[@"resultStatus"]];
                
            }];
            
            // 授权跳转支付宝钱包进行支付，处理支付结果
            [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
                NSLog(@"result = %@",resultDic);
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ailPayComPleted" object:resultDic[@"resultStatus"]];
                // 解析 auth code
                NSString *result = resultDic[@"result"];
                NSString *authCode = nil;
                if (result.length>0) {
                    NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                    for (NSString *subResult in resultArr) {
                        if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                            authCode = [subResult substringFromIndex:10];
                            break;
                        }
                    }
                }
                NSLog(@"授权结果 authCode = %@", authCode?:@"");
            }];
        }

    }
    return result;
}
// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        // 支付跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ailPayComPleted" object:resultDic[@"resultStatus"]];

        }];
        
        // 授权跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processAuth_V2Result:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ailPayComPleted" object:resultDic[@"resultStatus"]];

            // 解析 auth code
            NSString *result = resultDic[@"result"];
            NSString *authCode = nil;
            if (result.length>0) {
                NSArray *resultArr = [result componentsSeparatedByString:@"&"];
                for (NSString *subResult in resultArr) {
                    if (subResult.length > 10 && [subResult hasPrefix:@"auth_code="]) {
                        authCode = [subResult substringFromIndex:10];
                        break;
                    }
                }
            }
            NSLog(@"授权结果 authCode = %@", authCode?:@"");
        }];
    }
    return [WXApi handleOpenURL:url delegate:[WXApiManager sharedManager]];
}


- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(nonnull NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler{


    NSLog(@"收到消息推送啊啊啊啊啊啊啊啊啊");


}
-(void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler{

}
/*
 * @brief handle UserNotifications.framework [willPresentNotification:withCompletionHandler:]
 * @param center [UNUserNotificationCenter currentNotificationCenter] 新特性用户通知中心
 * @param notification 前台得到的的通知对象
 * @param completionHandler 该callback中的options 请使用UNNotificationPresentationOptions
 */
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger options))completionHandler{
 NSLog(@"收到前台消息推送啊啊啊啊啊啊啊啊啊");

}

//初始化键盘控制器
- (void)initKeyBoardManage
{
    IQKeyboardManager *manager = [IQKeyboardManager sharedManager];
    manager.enable = YES;
    manager.shouldResignOnTouchOutside = YES;
    manager.shouldToolbarUsesTextFieldTintColor = YES;
    manager.enableAutoToolbar = NO;  //不显示toolBar
    [manager disableDistanceHandlingInViewControllerClass:[xxxxViewController class]];
    

    [manager setKeyboardDistanceFromTextField:70];
}


#pragma - mark for BaseTabBarDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
   // [BaseTabBarController sharedTabBar].curNav = (JTNavigationController *)viewController;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    
    if (viewController == _mainController.viewControllers[4]||viewController == _mainController.viewControllers[3]) {
        if (![[UserPL shareManager]userIsLogin]){
            MemberLoginController *vc = [[MemberLoginController alloc] init];
            vc.type = 2;
            DOHNavigationController *navigationController = [[DOHNavigationController alloc] initWithRootViewController:vc];
            [viewController presentViewController:navigationController animated:YES completion:^{}];
            return NO;
        }else{
            if (viewController == _mainController.viewControllers[4]) {
                viewController.navigationController.navigationBar.hidden = YES;
                
            }
            
            return YES;
        }
    }
    
    return YES;
}

@end
