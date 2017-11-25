//
//  ScanResultViewController.m
//  LBXScanDemo
//
//  Created by lbxia on 15/11/17.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "ScanResultViewController.h"

@interface ScanResultViewController ()<WKNavigationDelegate>

@end

@implementation ScanResultViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"二维码详情";

    [self setBarBackBtnWithImage:nil];
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    NSLog(@"imgScanimage===%@ \nstrScan====%@  \nstrCodeType====%@",self.imgScan,self.strScan,self.strCodeType);
    
    WKWebView  *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    
  
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.strScan]];
    [webView loadRequest:request];
    [self.view addSubview:webView];

}


- (void)respondToLeftButtonClickEvent{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;

}

- (void)loadqrcodetext{
    [[HTTPClient sharedHttpClient] POST:@"/process-qrcode-text" dict:@{@"text":self.strScan} success:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]!=-1) {
            [self showTextHud:@"无效二维码"];
            [self.navigationController  popToRootViewControllerAnimated:YES];
            return;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTextHud:@"网络错误"];
        [self.navigationController  popToRootViewControllerAnimated:YES];
    }];



}



@end
