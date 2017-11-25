//
//  CreaTeViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/26.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CreaTeViewController.h"
#import "GoodsDetailViewController.h"
#import "BusinessesShopViewController.h"
#import "ItemsModel.h"
@interface CreaTeViewController ()<UIWebViewDelegate>


@end

@implementation CreaTeViewController{
    
    UIWebView * _webView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _titlesStr;
    
    [self setBarBackBtnWithImage:nil];
    
    _webView = [[UIWebView alloc]initWithFrame:self.view.frame];
    _webView.backgroundColor = UIColorFromRGB(LineColorValue);

    _webView.height = self.view.height-64;
    //    view.scalesPageToFit = YES;//自动对页面进行缩放以适应屏幕
    _webView.delegate = self;
    [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_anniuStr]]];
    
    [self.view addSubview:_webView];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    NSUserDefaults *userDefaults =  [NSUserDefaults standardUserDefaults];
    NSDictionary *headerDic = request.allHTTPHeaderFields;
    
    NSString *sessionid = [userDefaults objectForKey:FYHSessionId];
    if (!headerDic[@"FYH-Session-Id"]&&sessionid.length > 0) {
        [mutableRequest setValue: [userDefaults objectForKey:FYHSessionId] forHTTPHeaderField:@"FYH-Session-Id"];
        [mutableRequest setValue:@"iOS_51" forHTTPHeaderField:@"FYH-App-Key"];
        // [_webView loadRequest:mutableRequest];
    }
    NSString *urlStr = [NSString stringWithFormat:@"%@",mutableRequest.URL];
    if ([urlStr containsString:@"fyhapp:"]) {
        if ([urlStr containsString:@"item/"]) {
            NSArray *idArr = [urlStr componentsSeparatedByString:@"item/"];
            NSString *idStr = [idArr lastObject];
            NSLog(@"===========%@",idStr);
            ItemsModel *model = [[ItemsModel alloc]init];
            model.itemId = idStr;
            GoodsDetailViewController *goods = [[GoodsDetailViewController alloc]init];
            goods.itemModel = model;
            //        goods.shopType = 3;
            [self.navigationController pushViewController:goods animated:YES];
            
            return NO;
        }else if ([urlStr containsString:@"shop/"]){
            NSArray *idArr = [urlStr componentsSeparatedByString:@"shop/"];
            NSString *idStr = [idArr lastObject];
            BusinessesShopViewController *shopVc = [[BusinessesShopViewController alloc]init];
            shopVc.shopId = idStr;
            shopVc.goType = 1;
            [self.navigationController pushViewController:shopVc animated:YES];
            
            return NO;
        }
        
    }
    
    
    NSLog(@"===========%@",request.allHTTPHeaderFields);
    
    return YES;
}



@end
