//
//  HomeViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "HomeViewController.h"
#import "MemberLoginController.h"
#import "TZImagePickerController.h"
#import "xxxxViewController.h"
#import "User.h"
#import "UserPL.h"
//二维码扫描
#import "SubLBXScanViewController.h"
//#import "MyQRViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>
#import "ScanResultViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "UMMobClick/MobClick.h"
#import "DOHNavigationController.h"
@interface HomeViewController ()<UIWebViewDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
//声明`WebViewJavascriptBridge`对象为属性
@property (nonatomic,strong) WebViewJavascriptBridge* bridge;

/**
 图片选择器
 */
@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@end

@implementation HomeViewController{

    NSMutableArray *_selectedPhotos;
    UIWebView  *_webView;
}

/**
 图片选择器
 */
- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;
        // set appearance / 改变相册选择页的导航栏外观
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        _imagePickerVc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
        _imagePickerVc.navigationBar.tintColor = self.navigationController.navigationBar.tintColor;
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _selectedPhotos = [NSMutableArray array];
    [self hideBarbackBtn];
//    [[RCIM sharedRCIM] connectWithToken:@"1gh7Vemk7DLllZPb3jPBEw4Wsy/eGkPk0DhgGQGMMHu5DtiBKibQYzbWMeEQOspCMuqKnMao80mQ+KTuFKQDwA=="     success:^(NSString *userId) {
//        NSLog(@"登陆成功。当前登录的用户ID：%@", userId);
//        dispatch_async(dispatch_get_main_queue(), ^
//                       {
//                           //新建一个聊天会话View Controller对象,建议这样初始化
//                           xxxxViewController *chat =[[xxxxViewController alloc] initWithConversationType:ConversationType_PRIVATE
//                                                                                                                     targetId:@"3"];
//                           
//                           //        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
//                                   chat.conversationType = ConversationType_PRIVATE;
//                           //        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
//                           //        chat.targetId = @"4";
//                           //        
//                           //        //设置聊天会话界面要显示的标题
//                                   chat.title = @"想显示的会话标题";
//                           //        //显示聊天会话界面
//                           DOHNavigationController *nav = [[DOHNavigationController alloc] initWithRootViewController:chat];
//                           
//                           [self presentViewController:nav animated:YES completion:nil];
//                          // [self.navigationController pushViewController:nav animated:YES];
//                           
//                       });
//        
//        
//    } error:^(RCConnectErrorCode status) {
//        NSLog(@"登陆的错误码为:%ld", (long)status);
//    } tokenIncorrect:^{
//        //token过期或者不正确。
//        //如果设置了token有效期并且token过期，请重新请求您的服务器获取新的token
//        //如果没有设置token有效期却提示token错误，请检查您客户端和服务器的appkey是否匹配，还有检查您获取token的流程。
//        NSLog(@"token错误");
//    }];


}

- (void)respondToLeftButtonClickEvent{

    //新建一个聊天会话View Controller对象,建议这样初始化
    xxxxViewController *chat =[[xxxxViewController alloc] initWithConversationType:ConversationType_PRIVATE
                                                                          targetId:@"3"];
    
    //        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
    //        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    //        chat.targetId = @"4";
    //
    //        //设置聊天会话界面要显示的标题
    chat.title = @"想显示的会话标题";
    //        //显示聊天会话界面
    DOHNavigationController *nav = [[DOHNavigationController alloc] initWithRootViewController:chat];
    
    [self presentViewController:nav animated:YES completion:nil];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}
-(void)setWebView{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight-69)];
    _webView.delegate = self;
    _webView.tag = 1000;
   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/wap",kbaseUrl]]];
    
    //本地测试
 //   NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.137.123/wap"]];
    
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    //通知：登录、扫码等
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshwebview:)
                                                 name:@"userLoginIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showQrcodeImfo:)
                                                 name:@"ScanStrQrcodeSuccess" object:nil];
    // 开启日志
    [WebViewJavascriptBridge enableLogging];
    
    // 给哪个webview建立JS与OjbC的沟通桥梁
    self.bridge = [WebViewJavascriptBridge bridgeForWebView:_webView];
    [self.bridge setWebViewDelegate:self];
    
    // JS主动调用OjbC的方法
    // 这是JS会调用getUserIdFromObjC方法，这是OC注册给JS调用的
    // JS需要回调，当然JS也可以传参数过来。data就是JS所传的参数，不一定需要传
    // OC端通过responseCallback回调JS端，JS就可以得到所需要的数据
    [self.bridge registerHandler:@"FYHAppHandler" handler:^(id data, WVJBResponseCallback responseCallback) {
        NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
        NSDictionary *dic = data;
        //登录
        if ([dic[@"action"] isEqualToString:@"login"]) {
            MemberLoginController *loginVc = [[MemberLoginController alloc]init];
            [self.navigationController pushViewController:loginVc animated:YES];
        }
        //选择照片
        if ([dic[@"action"] isEqualToString:@"useGatewayApiByJpegBase64"]) {
            MemberLoginController *loginVc = [[MemberLoginController alloc]init];
            [self.navigationController pushViewController:loginVc animated:YES];
        }
        //扫描二维码
        if ([dic[@"action"] isEqualToString:@"scanQrcode"]) {
            if (![self cameraPemission])
            {
                [self showTextHud:@"没有摄像机权限"];
                return;////'/////////////
            }
            [self qqStyle];
        }
        if ([dic[@"action"] isEqualToString:@"scanQrcode"]) {
            if (![self cameraPemission])
            {
                [self showTextHud:@"没有摄像机权限"];
                return;////'/////////////
            }
            [self qqStyle];
        }

    }];
    
}


#pragma mark ======== 通知    登陆成功后加载网页  扫码显示

- (void)refreshwebview:(NSNotification*)notificaition{



    
}

- (void)showQrcodeImfo:(NSNotification*)notificaition{
    NSDictionary *dic = notificaition.userInfo;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫码信息" message:dic[@"message"] preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}

#pragma mark - 扫码模仿qq界面
- (void)qqStyle
{
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    
    vc.isQQSimulator = YES;
    vc.isVideoZoom = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

/**
 判断照相机权限

 @return 是否
 */
- (BOOL)cameraPemission
{
    
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    
    return isHavePemission;
}


-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSString *urlstr = [NSString stringWithFormat:@"%@",url];
    NSLog(@"URL===========%@",urlstr                                );
    return YES;
}




@end
