//
//  XieYiController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "XieYiController.h"

@interface XieYiController ()

@end

@implementation XieYiController{
    UILabel *_myLab;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
   self.navigationItem.title = @"用户注册协议";
    if (_Type == 1) {
        [self loadXieYi];
    }else{
        [self loadRuzhuXieYi];
    }
    
}

///gateway?api=openShopLicense
- (void)loadXieYi{

    UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    NSString *path = [NSString stringWithFormat:@"%@/register-agreement",kbaseUrl];
    NSURL *url = [NSURL URLWithString:path];
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    //        [webView loadHTMLString:str baseURL:nil];
    [self.view addSubview:webView];
}

- (void)loadRuzhuXieYi{
    
    HTTPClient *client = [HTTPClient  sharedHttpClient];
    [client POST:@"/gateway?api=openShopLicense" dict:@{} success:^(NSDictionary *resultDic) {
        NSDictionary *strDic = resultDic[@"data"];
        NSString *str = strDic[@"license"];
        str = [self htmlEntityDecode:str];
        NSAttributedString *attributedStr = [self attributedStringWithHTMLString:str];
        _myLab.attributedText = attributedStr;
        UIWebView * webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        [webView loadHTMLString:str baseURL:nil];
        [self.view addSubview:webView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTextHud:@"协议获取失败"];
    }];
    
}

-(NSString *)filterHTML:(NSString *)html
{
    NSScanner * scanner = [NSScanner scannerWithString:html];
    NSString * text = nil;
    while([scanner isAtEnd]==NO)
    {
        //找到标签的起始位置
        [scanner scanUpToString:@"&" intoString:nil];
        //找到标签的结束位置
        [scanner scanUpToString:@";" intoString:&text];
        //替换字符
        html = [html stringByReplacingOccurrencesOfString:[NSString stringWithFormat:@"%@>",text] withString:@""];
    }
    //    NSString * regEx = @"<([^>]*)>";
    //    html = [html stringByReplacingOccurrencesOfString:regEx withString:@""];
    return html;
}
//将HTML字符串转化为NSAttributedString富文本字符串
- (NSAttributedString *)attributedStringWithHTMLString:(NSString *)htmlString
{
    NSDictionary *options = @{ NSDocumentTypeDocumentAttribute : NSHTMLTextDocumentType,
                               NSCharacterEncodingDocumentAttribute :@(NSUTF8StringEncoding) };
    
    NSData *data = [htmlString dataUsingEncoding:NSUTF8StringEncoding];
    
    return [[NSAttributedString alloc] initWithData:data options:options documentAttributes:nil error:nil];
}
//将 &lt 等类似的字符转化为HTML中的“<”等
- (NSString *)htmlEntityDecode:(NSString *)string
{
    string = [string stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    string = [string stringByReplacingOccurrencesOfString:@"&apos;" withString:@"'"];
    string = [string stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    string = [string stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    string = [string stringByReplacingOccurrencesOfString:@"&amp;" withString:@"&"]; // Do this last so that, e.g. @"&amp;lt;" goes to @"&lt;" not @"<"
    
    return string;
}



@end
