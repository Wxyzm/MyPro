//
//  changpwdViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "changpwdViewController.h"

@interface changpwdViewController ()

@property (nonatomic , strong) UITextField *oldpsd;

@property (nonatomic , strong) UITextField *newpsd;

@property (nonatomic , strong) UITextField *qrpsd;

@end

@implementation changpwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    if ([self.str isEqualToString:@"1"]) {
        self.title = @"修改登录密码";
    }
    else if ([self.str isEqualToString:@"2"])
    {
        self.title = @"修改支付密码";
    }
    
    self.view.backgroundColor = UIColorFromRGB(LineColorValue);
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view1 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"原密码"];
    
    
    _oldpsd = [BaseViewFactory textFieldWithFrame:CGRectMake(115, 0, ScreenWidth-135, 50) font:APPFONT(15) placeholder:@"请输入原密码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:nil];
    [view1 addSubview:_oldpsd];
    
    
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50+12, ScreenWidth, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view2];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view2 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"新密码"];
    
    _newpsd = [BaseViewFactory textFieldWithFrame:CGRectMake(115, 0, ScreenWidth-135, 50) font:APPFONT(15) placeholder:@"请输入新密码"textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:nil];
    [view2 addSubview:_newpsd];

    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view2];
    
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 50+12+50, ScreenWidth, 50)];
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view3 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"确认密码"];
    
    _qrpsd = [BaseViewFactory textFieldWithFrame:CGRectMake(115, 0, ScreenWidth-135, 50) font:APPFONT(15) placeholder:@"请再次输入新密码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:nil];
    [view3 addSubview:_qrpsd];
   
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(15) WithSuper:self.view Frame:CGRectMake(20, 174, ScreenWidth, 14) Alignment:NSTextAlignmentLeft Text:@"密码需要6-20位字母数字组合"];
    

    SubBtn *setBtn = [SubBtn buttonWithtitle:@"确认修改" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(setBtnclick) andframe:CGRectMake(20, 262, ScreenWidth - 40, 50)];
    [self.view addSubview:setBtn];
    
}

- (void)setBtnclick{





}

@end
