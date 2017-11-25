//
//
//
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "SubLBXScanViewController.h"
//#import "MyQRViewController.h"
#import "ScanResultViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "LBXScanVideoZoomView.h"
#import "MBProgressHUD.h"
#import "GoodsDetailViewController.h"
#import "ItemsModel.h"
#import "BusinessesShopViewController.h"

@interface SubLBXScanViewController ()
@property (nonatomic, strong) LBXScanVideoZoomView *zoomView;
@end

@implementation SubLBXScanViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"二维码扫描";
    //设置扫码后需要扫码图像
    self.isNeedScanImage = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)respondToLeftButtonClickEvent{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (_isQQSimulator) {
        
         [self drawBottomItems];
        [self drawTitle];
         [self.view bringSubviewToFront:_topTitle];
    }
    else
        _topTitle.hidden = YES;
}

//绘制扫描区域
- (void)drawTitle
{
    if (!_topTitle)
    {
        self.topTitle = [[UILabel alloc]init];
        _topTitle.bounds = CGRectMake(0, 0, 145, 60);
        _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 50);
        
        //3.5inch iphone
        if ([UIScreen mainScreen].bounds.size.height <= 568 )
        {
            _topTitle.center = CGPointMake(CGRectGetWidth(self.view.frame)/2, 38);
            _topTitle.font = [UIFont systemFontOfSize:14];
        }
        
        
        _topTitle.textAlignment = NSTextAlignmentCenter;
        _topTitle.numberOfLines = 0;
        _topTitle.text = @"将取景框对准二维码即可自动扫描";
        _topTitle.textColor = [UIColor whiteColor];
        [self.view addSubview:_topTitle];
    }    
}

- (void)cameraInitOver
{
    if (self.isVideoZoom) {
        //设置拉近拉远
        // [self zoomView];
    }
}

- (LBXScanVideoZoomView*)zoomView
{
    if (!_zoomView)
    {
      
        CGRect frame = self.view.frame;
        
        int XRetangleLeft = self.style.xScanRetangleOffset;
        
        CGSize sizeRetangle = CGSizeMake(frame.size.width - XRetangleLeft*2, frame.size.width - XRetangleLeft*2);
        
        if (self.style.whRatio != 1)
        {
            CGFloat w = sizeRetangle.width;
            CGFloat h = w / self.style.whRatio;
            
            NSInteger hInt = (NSInteger)h;
            h  = hInt;
            
            sizeRetangle = CGSizeMake(w, h);
        }
        
        CGFloat videoMaxScale = [self.scanObj getVideoMaxScale];
        
        //扫码区域Y轴最小坐标
        CGFloat YMinRetangle = frame.size.height / 2.0 - sizeRetangle.height/2.0 - self.style.centerUpOffset;
        CGFloat YMaxRetangle = YMinRetangle + sizeRetangle.height;
        
        CGFloat zoomw = sizeRetangle.width + 40;
        _zoomView = [[LBXScanVideoZoomView alloc]initWithFrame:CGRectMake((CGRectGetWidth(self.view.frame)-zoomw)/2, YMaxRetangle + 40, zoomw, 18)];
        
        [_zoomView setMaximunValue:videoMaxScale/4];
        
        
        __weak __typeof(self) weakSelf = self;
        _zoomView.block= ^(float value)
        {            
            [weakSelf.scanObj setVideoScale:value];
        };
        [self.view addSubview:_zoomView];
                
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tap)];
        [self.view addGestureRecognizer:tap];
    }
    
    return _zoomView;
   
}

- (void)tap
{
    _zoomView.hidden = !_zoomView.hidden;
}

- (void)drawBottomItems
{
    if (_bottomItemsView) {
        
        return;
    }
    
    self.bottomItemsView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame)-164,
                                                                      CGRectGetWidth(self.view.frame), 100)];
    _bottomItemsView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    
    [self.view addSubview:_bottomItemsView];
    
    CGSize size = CGSizeMake(65, 87);
    self.btnFlash = [[UIButton alloc]init];
    _btnFlash.bounds = CGRectMake(0, 0, size.width, size.height);
    _btnFlash.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2+65, CGRectGetHeight(_bottomItemsView.frame)/2);
     [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor@2x"] forState:UIControlStateNormal];
    [_btnFlash addTarget:self action:@selector(openOrCloseFlash) forControlEvents:UIControlEventTouchUpInside];
    
    self.btnPhoto = [[UIButton alloc]init];
    _btnPhoto.bounds = _btnFlash.bounds;
    _btnPhoto.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame)/2-65, CGRectGetHeight(_bottomItemsView.frame)/2);
    [_btnPhoto setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_nor"] forState:UIControlStateNormal];
    [_btnPhoto setImage:[UIImage imageNamed:@"qrcode_scan_btn_photo_down"] forState:UIControlStateHighlighted];
    [_btnPhoto addTarget:self action:@selector(openPhoto) forControlEvents:UIControlEventTouchUpInside];
    
//    self.btnMyQR = [[UIButton alloc]init];
//    _btnMyQR.bounds = _btnFlash.bounds;
//    _btnMyQR.center = CGPointMake(CGRectGetWidth(_bottomItemsView.frame) * 3/4, CGRectGetHeight(_bottomItemsView.frame)/2);
//    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_nor"] forState:UIControlStateNormal];
//    [_btnMyQR setImage:[UIImage imageNamed:@"CodeScan.bundle/qrcode_scan_btn_myqrcode_down"] forState:UIControlStateHighlighted];
//    [_btnMyQR addTarget:self action:@selector(myQRCode) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomItemsView addSubview:_btnFlash];
    [_bottomItemsView addSubview:_btnPhoto];
   // [_bottomItemsView addSubview:_btnMyQR];
    
}







- (void)showError:(NSString*)str
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = str;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    // [hud hide:YES afterDelay:1.5];
    [hud hideAnimated:YES afterDelay:1.5];}



- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    
    if (array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
     
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
    for (LBXScanResult *result in array) {
        
        NSLog(@"scanResult:%@",result.strScanned);
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
   // [LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    [self showNextVCWithScanResult:scanResult];
   
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = strResult;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    // [hud hide:YES afterDelay:1.5];
    [hud hideAnimated:YES afterDelay:1.5];
}


/**
 扫码成功，展示内容
 
 @param strResult 二维码内容
 */
- (void)showNextVCWithScanResult:(LBXScanResult*)strResult
{

    [[HTTPClient sharedHttpClient] POST:@"/process-qrcode-text" dict:@{@"text":strResult.strScanned} success:^(NSDictionary *resultDic) {
        NSLog(@"%@",resultDic);
        if ([resultDic[@"code"] integerValue]==-1) {
            if ([resultDic[@"data"][@"type"] intValue]==1) {
                ItemsModel *model = [[ItemsModel alloc]init];
                model.itemId = resultDic[@"data"][@"value"];
                if (model.itemId.length<=0) {
                    [self showTextHud:@"该商品已被下架"];
                    [self.navigationController popViewControllerAnimated:YES];
                    return ;
                }
                GoodsDetailViewController *goods = [[GoodsDetailViewController alloc]init];
                goods.itemModel = model;
                goods.shopType = 3;
                [self.navigationController pushViewController:goods animated:YES];
                
            }else if ([resultDic[@"data"][@"type"] intValue]==3){
                
                if (!resultDic[@"data"][@"value"]) {
                    return;
                }
                BusinessesShopViewController *buVc = [[BusinessesShopViewController alloc]init];
                buVc.goType = 1;
                buVc.shopId = [NSString stringWithFormat:@"%@",resultDic[@"data"][@"value"]];
                [self.navigationController  pushViewController:buVc animated:YES];
                
            } else{
                
                
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"该二维码为外部链接，是否确认打开？" preferredStyle:UIAlertControllerStyleAlert];
                [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    ScanResultViewController *vc = [ScanResultViewController new];
                    vc.imgScan = strResult.imgScanned;
                    
                    vc.strScan = strResult.strScanned;
                    
                    vc.strCodeType = strResult.strBarCodeType;
                    
                    [self.navigationController pushViewController:vc animated:YES];
                }]];
                [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    
                    [self.navigationController popViewControllerAnimated:YES];

                    
                }]];
                [self presentViewController:alert animated:YES completion:nil];

                
                
                
            }
            
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            NSDictionary *messageDic = [NSDictionary dictionaryWithObject:strResult.strScanned forKey:@"message"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanStrQrcodeSuccess" object:nil userInfo:messageDic];
            
        }
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTextHud:@"网络错误"];
    }];

    //    if ([self isUrlString:strResult.strScanned]) {
//        ScanResultViewController *vc = [ScanResultViewController new];
//        vc.imgScan = strResult.imgScanned;
//        
//        vc.strScan = strResult.strScanned;
//        
//        vc.strCodeType = strResult.strBarCodeType;
//        
//        [self.navigationController pushViewController:vc animated:YES];
//    }else{
//        //发送注册成功通知
//         [self.navigationController popViewControllerAnimated:YES];
//        NSDictionary *messageDic = [NSDictionary dictionaryWithObject:strResult.strScanned forKey:@"message"];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"ScanStrQrcodeSuccess" object:nil userInfo:messageDic];
//
//       
//    
//    }
    
}





/**
 判断为网址的Url

 @return yes or no
 */
- (BOOL)isUrlString:(NSString *)str {
    
    NSString *emailRegex = @"[a-zA-z]+://.*";
    
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    
    return [emailTest evaluateWithObject:str];
    
}
#pragma mark -底部功能项
//打开相册
- (void)openPhoto
{
    if ([LBXScanWrapper isGetPhotoPermission])
        [self openLocalPhoto];
    else
    {
        [self showError:@"      请到设置->隐私中开启本程序相册权限     "];
    }
}

//开关闪光灯
- (void)openOrCloseFlash
{
    
    [super openOrCloseFlash];
   
    
    if (self.isOpenFlash)
    {
        [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_down"] forState:UIControlStateNormal];
    }
    else
        [_btnFlash setImage:[UIImage imageNamed:@"qrcode_scan_btn_flash_nor"] forState:UIControlStateNormal];
}


#pragma mark -底部功能项


- (void)myQRCode
{
//    MyQRViewController *vc = [MyQRViewController new];
//    [self.navigationController pushViewController:vc animated:YES];
}



@end
