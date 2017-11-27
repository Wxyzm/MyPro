//
//  MemberLoginController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MemberLoginController.h"
#import "MemberFgPwdViewController.h"
#import "MassageloginViewController.h"
#import "MemberRegistController.h"
#import "AppDelegate.h"
#import "RCTokenPL.h"
#import "UserPL.h"
#import "User.h"
@interface MemberLoginController ()<UITextFieldDelegate>

@property (nonatomic,strong)UITextField *userNameTxt;  //账号

@property (nonatomic,strong)UITextField *passWordTxt;  //密码

@end

@implementation MemberLoginController{
    UIButton *_mimaBtn;    //密码显隐按钮
    SubBtn *_loginBtn;     //登录按钮
    SubBtn *_registBtn;   //注册按钮
    CGFloat _OriginY;
    UserPL *_userPL;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.navigationItem.title = @"会员登录";
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"close"]];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _OriginY = 0;
    [self setupUI];
    UILabel *titlelab;
           titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext:@"登录"];
    self.navigationItem.titleView = titlelab;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
   // self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;

    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    myView.backgroundColor = [UIColor whiteColor];
    myView.layer.sublayers[0].hidden = YES;
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = YES;
    }
    NSLog(@"%@",myView.layer.sublayers);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;

}



-(void)dealloc{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}
/**
 创建页面
 */
-(void)setupUI
{

    UIImageView *headimageview = [[UIImageView alloc]initWithFrame:CGRectMake((ScreenWidth-95)/2, 30, 95, 95)];
    headimageview.layer.cornerRadius = 95/2;
    headimageview.clipsToBounds = YES;
    headimageview.image = [UIImage imageNamed:@"pic-head"];
    [self.view addSubview:headimageview];
    
    UIView *loginwindview = [[UIView alloc]initWithFrame:CGRectMake(35, CGRectGetMaxY(headimageview.frame)+30, ScreenWidth-70, 130)];
    loginwindview.layer.borderWidth = 1;
    loginwindview.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    [self.view addSubview:loginwindview];
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 64.5, ScreenWidth-70, 1)];
    line.backgroundColor = UIColorFromRGB(LineColorValue);
    [loginwindview addSubview:line];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:loginwindview Frame:CGRectMake(20, 0, 40, 65) Alignment:NSTextAlignmentLeft Text:@"账号"];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:loginwindview Frame:CGRectMake(20, 65, 40, 65) Alignment:NSTextAlignmentLeft Text:@"密码"];
    
    _userNameTxt = [[UITextField alloc]initWithFrame:CGRectMake(60, 0, ScreenWidth-70-20-40, 65)];
    _userNameTxt.placeholder = @"请输入您的账号";
    _userNameTxt.keyboardType = UIKeyboardTypeASCIICapable;
    _userNameTxt.font = APPFONT(13);
    _userNameTxt.textColor = UIColorFromRGB(BlackColorValue);
    [loginwindview addSubview:_userNameTxt];
    
    _passWordTxt = [[UITextField alloc]initWithFrame:CGRectMake(20+35+5, 65, ScreenWidth-70-20-40, 65)];
    _passWordTxt.placeholder = @"请输入您的密码";
    _passWordTxt.keyboardType = UIKeyboardTypeASCIICapable;
    _passWordTxt.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passWordTxt.font = APPFONT(13);
    _passWordTxt.delegate = self;
    _passWordTxt.textColor = UIColorFromRGB(BlackColorValue);
    [loginwindview addSubview:_passWordTxt];

    _passWordTxt.secureTextEntry = YES;
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"visible_password"] forState:UIControlStateNormal];
    [loginwindview addSubview:btn];
    btn.frame = CGRectMake(ScreenWidth-30-80, 65, 30, 65);
    [btn addTarget:self action:@selector(bbtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    SubBtn *loginBtn = [SubBtn buttonWithtitle:@"登录" titlecolor:UIColorFromRGB(0xffffff) cornerRadius:2 andtarget:self action:@selector(login) andframe:CGRectMake(35, CGRectGetMaxY(loginwindview.frame)+30, ScreenWidth-70, 50)];
    loginBtn.titleLabel.font = APPFONT(18);
    loginBtn.layer.cornerRadius = 5;
    [self.view addSubview:loginBtn];
    
    SubBtn *forgetBtn = [SubBtn buttonWithtitle:@"忘记密码？" backgroundColor:[UIColor clearColor] titlecolor:UIColorFromRGB(BlackColorValue) cornerRadius:0 andtarget:self action:@selector(forget)];
    forgetBtn.titleLabel.font = APPFONT(13);
    forgetBtn.frame = CGRectMake(35, CGRectGetMaxY(loginBtn.frame)+15, 70, 30);
    [self.view addSubview:forgetBtn];
    
    SubBtn *codeLoginBtn = [SubBtn buttonWithtitle:@"短信登录" backgroundColor:[UIColor clearColor] titlecolor:UIColorFromRGB(BlackColorValue) cornerRadius:0 andtarget:self action:@selector(codeLogin)];
    codeLoginBtn.titleLabel.font = APPFONT(13);
    codeLoginBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    codeLoginBtn.frame = CGRectMake(ScreenWidth-45-50, CGRectGetMaxY(loginBtn.frame)+15, 55, 30);
    [self.view addSubview:codeLoginBtn];
    
    SubBtn *registBtn = [SubBtn buttonWithtitle:@"注册新用户" backgroundColor:[UIColor clearColor] titlecolor:UIColorFromRGB(BlackColorValue) cornerRadius:0 andtarget:self action:@selector(regist)];
    registBtn.titleLabel.font = APPFONT(15);
    registBtn.frame = CGRectMake(ScreenWidth/2-100, ScreenHeight-160, 200, 30);
    [self.view addSubview:registBtn];
    


}

- (void)codeLogin{
    
    MassageloginViewController  *enterVc = [[MassageloginViewController alloc]init];
    [self.navigationController pushViewController:enterVc animated:YES];
    
    
}

- (void)bbtnClick:(UIButton *)btn{
    btn.selected  = !btn.selected;
    if ( btn.selected) {
        _passWordTxt.secureTextEntry = NO;
        _passWordTxt.keyboardType = UIKeyboardTypeASCIICapable;

        [btn setImage:[UIImage imageNamed:@"eye"] forState:UIControlStateNormal];

    }else{
        _passWordTxt.secureTextEntry = YES;
        _passWordTxt.keyboardType = UIKeyboardTypeASCIICapable;

        [btn setImage:[UIImage imageNamed:@"visible_password"] forState:UIControlStateNormal];

    }


}
#pragma mark ============= 登录注册忘记密码
- (void)login{
    if (_userNameTxt.text.length <= 0) {
        [self showTextHud:@"请输入您的账户"];
        return;
    }
    if (_passWordTxt.text.length <= 0) {
        [self showTextHud:@"请输入您的密码"];
        return;
    }
    _userPL =  [UserPL shareManager];

    User *user = [[User alloc] init];
    user.username   = _userNameTxt.text;
    user.password = _passWordTxt.text;
    [_userPL setUserData:user];
    [_userPL userLoginWithReturnBlock:^(id returnValue) {
        [self showTextHud:@"登录成功"];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"userHaveLoginIn" object:nil userInfo:nil];
        
        [RCTokenPL getRcTokenWithReturnBlock:^(id returnValue) {
            
            [[NSUserDefaults standardUserDefaults]setObject:returnValue[@"rongcloudResponse"][@"token"]
                                                     forKey:FYH_RC_Token];
            [GlobalMethod connectRongCloud];

        } andErrorBlock:^(NSString *msg) {
            
        }];
        
        [self performSelector:@selector(Goback) withObject:nil afterDelay:0.5];

    } withErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];

    }];
    
    
//    HTTPClient *client = [HTTPClient sharedHttpClient];
//    [client userLoginName:_userNameTxt.text Password:_passWordTxt.text withReturnBlock:^(id returnValue) {
//        NSLog(@"%@",returnValue);
//        NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
//        if ([dic[@"code"] intValue]==-1) {
//            [self showTextHud:@"登录成功"];
//            NSDictionary *dataDic = dic[@"data"];
//            
//            //保存账户密码
//            [[NSUserDefaults standardUserDefaults]setObject:_userNameTxt.text forKey:FYH_USER_ACCOUNT];
//            [[NSUserDefaults standardUserDefaults]setObject:_passWordTxt.text forKey:FYH_USER_PASSWORD];
//            [[NSUserDefaults standardUserDefaults]setObject:dataDic[@"sessionId"] forKey:FYHSessionId];
//
////            [[NSUserDefaults standardUserDefaults] objectForKey:FYHSessionId];
//
//            [self performSelector:@selector(Goback) withObject:nil afterDelay:0.5];
//        }else {
//            [self showTextHud:dic[@"message"]];
//        }
//    } andErrorBlock:^(NSString *msg) {
//        [self showTextHud:@"出错啦，请稍后再试"];
//    }];
}

/**
 注册
 */
- (void)regist{
    MemberRegistController *RegistVc = [[MemberRegistController alloc]init];
    [self.navigationController pushViewController:RegistVc animated:YES];
}
- (void)forget{
    MemberFgPwdViewController *fogetVc = [[MemberFgPwdViewController alloc]init];
    [self.navigationController pushViewController:fogetVc animated:YES];
}

- (void)Goback{
    if (self.type == 2) {
        [self.navigationController dismissViewControllerAnimated:YES completion:nil];

    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)respondToLeftButtonClickEvent{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}




@end
