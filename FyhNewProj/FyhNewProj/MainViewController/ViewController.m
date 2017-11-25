//
//  ViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ViewController.h"
#import "WebViewJavascriptBridge.h"
#import "AFNetworking.h"
#import "MemberLoginController.h"
#import "User.h"
#import "UserPL.h"
//二维码扫描
#import "SubLBXScanViewController.h"
#import "LBXScanView.h"
#import <objc/message.h>
#import "ScanResultViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
//打印二维码
#import "PrintQrcodeViewController.h"
#import "UpEncodedImageStrPL.h"
#import "MBProgressHUD.h"
//商户注册
#import "BusinessRegistController.h"
//搜索照片
#import "PhotoSearchResultViewController.h"
//实名认证首页
#import "TureNameViewController.h"
#import "TureNameResultController.h"


@interface ViewController ()<UIWebViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>
//声明`WebViewJavascriptBridge`对象为属性
@property (nonatomic,strong) WebViewJavascriptBridge* bridge;

@end

@implementation ViewController{

    UIWebView               *_webView;
    UIImagePickerController *_imagePicker;
    BOOL                     _isChoiceCamera;
    UIActivityIndicatorView *loadingIndicator;
    UpEncodedImageStrPL     *_EncodedImageStrPL;
    UIView                  *_bgView;
    NSInteger               _photoChoseType;      //1.搜索图片  2.发布商品
    NSString                *_returnJsStr;
    UIImage                 *_upImage;
    WVJBResponseCallback   _block;                //上传商品图片回调
    UIView *_showView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xffffff);
    _EncodedImageStrPL = [[UpEncodedImageStrPL alloc]init];
     [self.view setTranslatesAutoresizingMaskIntoConstraints:NO];
    //通知：登录、扫码等
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshwebview:)
                                                 name:@"userLoginIn" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showQrcodeImfo:)
                                                 name:@"ScanStrQrcodeSuccess" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refresFailhwebview:)
                                                 name:@"userLoginFail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refrehwebviewforBussRegist:)
                                                 name:@"BussRegistSuccess" object:nil];
    
    [self setWebView];
    [self.view addSubview:_bgView];
//    UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 200, 50)];
//    [self.view addSubview:myView];
//    //  创建 CAGradientLayer 对象
//    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//    
//    //  设置 gradientLayer 的 Frame
//    gradientLayer.frame = myView.bounds;
//    gradientLayer.cornerRadius = 10;
//    //  创建渐变色数组，需要转换为CGColor颜色
//    gradientLayer.colors = @[(id)UIColorFromRGB(0xff2d66).CGColor,
////                             (id)[UIColor yellowColor].CGColor,
//                             (id)UIColorFromRGB(0xff5d3b).CGColor];
//    
//    //  设置三种颜色变化点，取值范围 0.0~1.0
//    gradientLayer.locations = @[@(0.1f) ,@(0.4f)];
//    
//    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
//    gradientLayer.startPoint = CGPointMake(0, 0);
//    gradientLayer.endPoint = CGPointMake(1, 0);
//    
//    //  添加渐变色到创建的 UIView 上去
//    [myView.layer addSublayer:gradientLayer];
//    PrintQrcodeViewController *printQrcVc = [[PrintQrcodeViewController alloc]init];
//    NSDictionary *aaadic = @{@"title":@"aaaaa",
//                             @"customBn":@"",
//                             @"bn":@"",
//                             @"url":@"www.baidu.com"
//                             };
//    printQrcVc.infoDic = aaadic;
//    [self.navigationController pushViewController:printQrcVc animated:YES];
    
    
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    if (iPhone5) {
        NSLog(@"iphone5");
    }else if (iPhone6){
        NSLog(@"iphone6");
    }else if (iPhone6p){
    NSLog(@"iphone6p");
    }

}
-(void)setWebView{
    
    _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight-20)];
    _webView.delegate = self;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://fyh88.com/wap"]];
    [_webView loadRequest:request];
    [self.view addSubview:_webView];
    
    _showView = [[UIView alloc]init];
    [self.view addSubview:_showView];
    _showView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    _showView.hidden = YES;
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
        _block = responseCallback;
        NSLog(@"js call getUserIdFromObjC, data from js is %@", data);
         NSDictionary *dic = data;
        //登录
        if ([dic[@"action"] isEqualToString:@"login"]) {
            MemberLoginController *loginVc = [[MemberLoginController alloc]init];
            [self.navigationController pushViewController:loginVc animated:YES];
        }
        //商家注册
        if ([dic[@"action"] isEqualToString:@"switchToShop"]) {
            [self makesureBussIsOpen];
        }
        //个人、公司实名认证
        if ([dic[@"action"] isEqualToString:@"merchantCertification"]) {

            
            [self makeSureBussIsTureName];
            
        }
        //联系客服
        if ([dic[@"action"] isEqualToString:@"callService"]) {
            NSMutableString *str = [[NSMutableString alloc]initWithFormat:@"telprompt://400-878-0966"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
            
        }
        //选搜索照片
        if ([dic[@"action"] isEqualToString:@"useGatewayApiByJpegBase64"]) {
            [self chosePhoto];
            _photoChoseType = 1;
        }
        //发布商品
        if ([dic[@"action"] isEqualToString:@"uploadItemPic"]) {
            [self chosePhoto];
            _photoChoseType = 2;
        }
        //扫描二维码
        if ([dic[@"action"] isEqualToString:@"scanQrcode"]) {
            if (![self cameraPemission])
            {
                [self showTextHud:@"没有摄像机权限"];
                return;
            }
            [self qqStyle];
        }
        //退出登录
        if ([dic[@"action"] isEqualToString:@"logout"]) {
            [self Userlogout];
            NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/wap",kbaseUrl]]];
            [_webView loadRequest:request];
        }
        //打印二维码
        if ([data[@"action"] isEqualToString:@"printQRCode"]) {
            PrintQrcodeViewController *printQrcVc = [[PrintQrcodeViewController alloc]init];
            printQrcVc.infoDic = data[@"param"];
            [self.navigationController pushViewController:printQrcVc animated:YES];
        }
    }];

}



#pragma mark ======== 通知:登陆成功、失败后加载网页  扫码显示


/**
 登录成功设置webview cookies
 @param notificaition notificaition description
 */
- (void)refreshwebview:(NSNotification*)notificaition{
    
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/wap",kbaseUrl]]];
    
    NSString *expiresStr = [userDefaults objectForKey:FYHSessionOption];
    NSArray *expiresArr = [expiresStr componentsSeparatedByString:@";"];
    NSArray *dataArr = [expiresArr[0] componentsSeparatedByString:@"="];
    NSArray *dataArr1 = [expiresArr[1] componentsSeparatedByString:@"="];
    
    NSMutableDictionary *properties = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       request.URL.host, NSHTTPCookieDomain,
                                       @"/", NSHTTPCookiePath,
                                       //(NSDate*)dataArr[1],NSHTTPCookieExpires,   //失效时间
                                       [userDefaults objectForKey:FYHSessionName], NSHTTPCookieName,
                                       [userDefaults objectForKey:FYHSessionId], NSHTTPCookieValue,
                                       nil];
    [properties setObject:[NSDate dateWithTimeIntervalSinceNow:60*60*24] forKey:NSHTTPCookieExpires];
    [properties setObject:dataArr1[1] forKey:NSHTTPCookieMaximumAge];
    
    NSHTTPCookie *cookie1 = [NSHTTPCookie cookieWithProperties:properties];
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookie:cookie1];
    
    
    
    NSArray *nCookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookies];
    
    [_webView loadRequest:request];
}


/**
 退出登录并且清除webview缓存
 */
- (void)Userlogout{
    [[UserPL shareManager] logout];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    //清除UIWebView的缓存
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSURLCache * cache = [NSURLCache sharedURLCache];
    [cache removeAllCachedResponses];
    [cache setDiskCapacity:0];
    [cache setMemoryCapacity:0];

}


//登录失败
- (void)refresFailhwebview:(NSNotification *)note{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/wap",kbaseUrl]]];
    //本地测试
    // NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://192.168.137.123/wap/member.html"]];
    [_webView loadRequest:request];
    
    
}

/**
 扫码str成功回调

 @param notificaition 返回的信息str
 */
- (void)showQrcodeImfo:(NSNotification*)notificaition{
    NSDictionary *dic = notificaition.userInfo;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫码信息" message:dic[@"message"] preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}


/**
 注册成功回调

 @param notificaition notificaition description
 */
- (void)refrehwebviewforBussRegist:(NSNotification*)notificaition{

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@/wap/member.html",kbaseUrl]]];
    [_webView loadRequest:request];


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

#pragma mark  ================  webview Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSString *urlstr = [NSString stringWithFormat:@"%@",url];
    NSLog(@"URL===========%@",urlstr);
    return YES;
}


#pragma mark  ================  选取照片

- (void)chosePhoto{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    if (!loadingIndicator) {
        loadingIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingIndicator.color = [UIColor grayColor];
        [loadingIndicator setHidesWhenStopped:YES];
        [self.view addSubview:loadingIndicator];
        loadingIndicator.center = CGPointMake(ScreenWidth/2, ScreenHeight/2);
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];

}
#pragma mark--------------------------------UIActionDelegate--------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0:
            // Take a photo directly!
            [self pickImageFromCamera];
            break;
        case 1:
            // Pick one from library.
            [self pickImageFromAlbum];
            break;
        default:
            break;
    }
}

#pragma mark 从摄像头获取活动图片
- (void)pickImageFromCamera
{
    _isChoiceCamera = YES;
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:_imagePicker animated:YES completion:^(void){
    }];
}
#pragma mark 从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    _isChoiceCamera= NO;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    [self presentViewController:_imagePicker animated:YES completion:^(void){
    }];
}

#pragma imagePicekr
//点击相册中的图片or照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (_photoChoseType == 1) {
        if (image) {
            PhotoSearchResultViewController *photoVc = [[PhotoSearchResultViewController alloc]init];
            photoVc.searchImage = image;
            [self.navigationController pushViewController:photoVc animated:YES];
        }

    }else if (_photoChoseType == 2){
        if (!image) {
            return;
        }
        NSData * imageData = [self scaleImage:image toKb:1024];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        NSDictionary *dataDict = @{@"image":imageData};
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
        [self showLoadHUDMsg:@"正在上传图片"];

        NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
        NSTimeInterval a=[dat timeIntervalSince1970];
        NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
        [manager.requestSerializer setValue:@"FYHIOS" forHTTPHeaderField:@"FYH-App-Key"];
        [manager.requestSerializer setValue:timeString forHTTPHeaderField:@"FYH-App-Timestamp"];
        [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
        //用的是测试的
        [manager.requestSerializer setValue:@"oIkBLWG4OUHTgYmN" forHTTPHeaderField:@"FYH-App-Signature"];
        //需要在登录后获取 存于本地  注意在用户登出时清掉
        if ([HTTPClient getUserSessiond]) {
            [manager.requestSerializer setValue:[HTTPClient getUserSessiond] forHTTPHeaderField:@"FYH-Session-Id"];
        }
        
        
        
        [manager POST:[NSString stringWithFormat:@"%@/gateway?api=uploadShopItemImages",kbaseUrl] parameters:dataDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
           
            [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
            [loadingIndicator stopAnimating];
           // _webView.userInteractionEnabled = YES;
            
            NSDictionary  *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
            NSArray *returnArr = jsonDic[@"data"];
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:returnArr options:NSJSONWritingPrettyPrinted error:&parseError];
            NSString *jsonStr = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
            [self hideLoadHUD];
            _block(jsonStr);
        } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
           [self hideLoadHUD];
            _webView.userInteractionEnabled = YES;
        }];

    
    }
    
  
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark ===== 查询商家是否已经注册

- (void)makesureBussIsOpen{
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client POST:@"/gateway?api=isUserShopOpened" dict:nil success:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"]intValue]==0) {
            NSDictionary *dic = resultDic[@"data"];
            if (![dic[@"isShopOpened"] boolValue]) {
                BusinessRegistController *registVc = [[BusinessRegistController alloc]init];
                [self.navigationController pushViewController:registVc animated:YES];
            }
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
#pragma mark ===== 查询商家是否已实名认证

- (void)makeSureBussIsTureName{

    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client POST:@"/gateway?api=getShopCertification" dict:@{} success:^(NSDictionary *resultDic) {
          NSDictionary *dataDic = resultDic[@"data"];
        if (![dataDic[@"isCertificated"] boolValue]&&[dataDic[@"statusCode"]intValue] == 1) {
            //未认证
            TureNameViewController *tureVc = [[TureNameViewController alloc]init];
            [self.navigationController pushViewController:tureVc animated:YES];
        }else{
            if ([dataDic[@"statusCode"]intValue] == 5) {
                //等待审核个人认证
                TureNameResultController *resultVc = [[TureNameResultController alloc]init];
                resultVc.type = 1;
                resultVc.nametype = 1;
                [self.navigationController pushViewController:resultVc animated:YES];
                
            }else if ([dataDic[@"statusCode"]intValue] == 6){
                //等待审核企业认证
                TureNameResultController *resultVc = [[TureNameResultController alloc]init];
                resultVc.type = 1;
                resultVc.nametype = 2;
                [self.navigationController pushViewController:resultVc animated:YES];
            }else if ([dataDic[@"statusCode"]intValue] == 7){
                //个人审核被拒绝
                TureNameResultController *resultVc = [[TureNameResultController alloc]init];
                resultVc.type = 2;
                resultVc.nametype = 1;
                [self.navigationController pushViewController:resultVc animated:YES];
            }else if ([dataDic[@"statusCode"]intValue] == 8){
                //企业审核被拒绝
                TureNameResultController *resultVc = [[TureNameResultController alloc]init];
                resultVc.type = 2;
                resultVc.nametype = 2;
                [self.navigationController pushViewController:resultVc animated:YES];
            }else if ([dataDic[@"statusCode"]intValue] == 9){
                //个人审核通过
                TureNameResultController *resultVc = [[TureNameResultController alloc]init];
                resultVc.type =3;
                resultVc.nametype = 21;
                [self.navigationController pushViewController:resultVc animated:YES];
            }else if ([dataDic[@"statusCode"]intValue] == 10){
                //企业审核通过
                TureNameResultController *resultVc = [[TureNameResultController alloc]init];
                resultVc.type = 3;
                resultVc.nametype = 2;
                [self.navigationController pushViewController:resultVc animated:YES];
            }
            
        
        }
         NSLog(@"商家实名认证===%@",resultDic);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"商家实名认证===%@",error);
        [self showTextHud:@"网络错误，稍后再试"];
    }];


}


#pragma mark ===== 图片压缩至1m


/**
 压缩图片返回data
 @param image 传入图片
 @param kb 压缩至1M（1024kb）
 @return 压缩后的图片转化的base64编码
 */
- (NSData *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    kb*=1024;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"原始大小:%fkb",(float)[imageData length]/1024.0f);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return imageData;
}

#pragma mark ========= webview使用MBProgressHUD

//正在加载提示
- (void)showLoadHUDMsg:(NSString *)msg{
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.label.text = msg;
    
    //progressHUD.mode = MBProgressHUDModeText;
    //progressHUD.dimBackground = YES;
}

//隐藏加载提示
- (void)hideLoadHUD{
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
}


@end
