//
//  ProDetailController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ProDetailController.h"

@interface ProDetailController ()<WKNavigationDelegate>

@end

@implementation ProDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商品详情";
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self setUpUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setUpUI{
   
    
    WKWebView  *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    webView.navigationDelegate = self;
    webView.backgroundColor = [UIColor whiteColor];
    
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:self.urlStr]];
    [webView loadRequest:request];
    [self.view addSubview:webView];
    

    
}

-(void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation
{
    [MBProgressHUD showMessag:@"正在加载数据" toView:self.view];
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(null_unspecified WKNavigation *)navigation {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(null_unspecified WKNavigation *)navigation withError:(NSError *)error {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
@end
