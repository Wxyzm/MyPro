//
//  ViewLogisticsControllerViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/6.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ViewLogisticsControllerViewController.h"

@interface ViewLogisticsControllerViewController ()<UIWebViewDelegate>

@end

@implementation ViewLogisticsControllerViewController{
    
    UIWebView * _webView;
    BOOL _isOpen;
    NSString *_urlStr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"查询物流";
    [self setBarBackBtnWithImage:nil];
    _isOpen = NO;
    //_logistNumber = @"786681079898";
    
    _webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, -54, ScreenWidth, ScreenHeight)];
    _webView.scrollView.bounces = NO;
//    _webView.height = self.view.height-64;
    //    view.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://m.kuaidi100.com/result.jsp?com=&nu=%@",_logistNumber]]]];
    
    [self.view addSubview:_webView];
}
#pragma mark  ================  webview Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSString *urlStr = [NSString stringWithFormat:@"%@",mutableRequest.URL];
    
   
    if ([urlStr rangeOfString:_logistNumber].location != NSNotFound||_isOpen||[urlStr isEqualToString:@"about:blank"]) {
        
        return YES;
        
    }
    NSLog(@"%lu",(unsigned long)[urlStr rangeOfString:_logistNumber].location);
                                 
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"您即将进入外部网页，是否继续？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _isOpen = YES;
         [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"https://m.kuaidi100.com/result.jsp?com=&nu=%@",_urlStr]]]];
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        _isOpen = NO;
    }]];
    [self presentViewController:alert animated:YES completion:nil];

    
    return NO;
}



@end
