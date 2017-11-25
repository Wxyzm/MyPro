//
//  aboutFYHViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/11.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "aboutFYHViewController.h"
#import "YLButton.h"

@interface aboutFYHViewController ()

@end

@implementation aboutFYHViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于丰云汇";
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(LineColorValue);
    
    UIImageView *logoimage = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-90)*0.5, 50, 90, 90)];
    logoimage.image = [UIImage imageNamed:@"logo-fyh"];
    [self.view addSubview:logoimage];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];

    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(13) WithSuper:self.view Frame:CGRectMake(0, CGRectGetMaxY(logoimage.frame)+10, ScreenWidth, 13) Alignment:NSTextAlignmentCenter Text:[NSString stringWithFormat:@"当前版本%@",app_Version]];
    
    YLButton *dianzanBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    dianzanBtn.frame = CGRectMake(0, CGRectGetMaxY(logoimage.frame)+10+13+35, ScreenWidth*0.5 - 0.5, 120);
    [self.view addSubview:dianzanBtn];
    dianzanBtn.backgroundColor = UIColorFromRGB(WhiteColorValue);
    dianzanBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    [dianzanBtn setTitle:@"我要点赞" forState:UIControlStateNormal];
    [dianzanBtn setImage:[UIImage imageNamed:@"good"] forState:UIControlStateNormal];
    [dianzanBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [dianzanBtn setImageRect:CGRectMake((ScreenWidth/2-42)*0.5, 19, 42, 42)];
    [dianzanBtn setTitleRect:CGRectMake(0, 19+42+25, ScreenWidth*0.5, 15)];
    dianzanBtn.titleLabel.font = APPFONT(15);
    [dianzanBtn addTarget:self action:@selector(dianzan) forControlEvents:UIControlEventTouchUpInside];
    
    YLButton *tucaoBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    tucaoBtn.frame = CGRectMake(ScreenWidth*0.5+0.5, CGRectGetMaxY(logoimage.frame)+10+13+35, ScreenWidth*0.5, 120);
    [self.view addSubview:tucaoBtn];
    tucaoBtn.backgroundColor = UIColorFromRGB(WhiteColorValue);
    tucaoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;

    [tucaoBtn setTitle:@"我要吐槽" forState:UIControlStateNormal];
    [tucaoBtn setImage:[UIImage imageNamed:@"bad"] forState:UIControlStateNormal];
    [tucaoBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [tucaoBtn setImageRect:CGRectMake((ScreenWidth/2-42)*0.5, 19, 42, 42)];
    [tucaoBtn setTitleRect:CGRectMake(0, 19+42+25, ScreenWidth*0.5, 15)];
    tucaoBtn.titleLabel.font = APPFONT(15);
    [tucaoBtn addTarget:self action:@selector(tucao) forControlEvents:UIControlEventTouchUpInside];


}

-(void)dianzan
{
    [self jumpToAppStore];
}

-(void)tucao
{
    [self jumpToAppStore];

}

- (void)jumpToAppStore{
    
    NSString *urlStr = @"itms-apps://itunes.apple.com/app/id1156310259";
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    
   
    
    
}
@end
