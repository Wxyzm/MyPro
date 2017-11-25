//
//  SecurityCenterViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SecurityCenterViewController.h"
#import "changpwdViewController.h"
#import "ChangePhoneViewController.h"
#import "MemberFgPwdViewController.h"

#import "AppDelegate.h"
#import "MenueView.h"
#import "ChatListViewController.h"
#import "DOTabBarController.h"

@interface SecurityCenterViewController ()<MenueViewDelegate>

@property (nonatomic , strong) MenueView *menuView;

@end

@implementation SecurityCenterViewController
-(MenueView *)menuView{
    if (!_menuView) {
        _menuView = [[MenueView alloc]init];
        _menuView.delegate = self;
    }
    
    return _menuView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(0xe6e9ed);
    self.title = @"安全中心";
    [self creatrRightBtnItem];
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view1];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view1 Frame:CGRectMake(20, 17.5, 150, 15) Alignment:NSTextAlignmentLeft Text:@"修改登录密码"];
    
    UIImageView *youimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17, 10, 16)];
    youimage1.image = [UIImage imageNamed:@"right"];
    [view1 addSubview:youimage1];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    btn1.backgroundColor = [UIColor clearColor];
    [btn1 addTarget:self action:@selector(changpwd:) forControlEvents:UIControlEventTouchUpInside];
    btn1.tag = 10000;
    [view1 addSubview:btn1];
    
//    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 50)];
//    view2.backgroundColor = [UIColor whiteColor];
//    [self.view addSubview:view2];
//    
//    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view2 Frame:CGRectMake(20, 17.5, 150, 15) Alignment:NSTextAlignmentLeft Text:@"预存款支付密码"];
//    
//    UIImageView *youimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17, 10, 16)];
//    youimage2.image = [UIImage imageNamed:@"right"];
//    [view2 addSubview:youimage2];
//    
//    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
//    btn2.backgroundColor = [UIColor clearColor];
//    [btn2 addTarget:self action:@selector(changpwd:) forControlEvents:UIControlEventTouchUpInside];
//    btn2.tag = 10001;
//    [view2 addSubview:btn2];
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 50)];
    view3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view3];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view3 Frame:CGRectMake(20, 17.5, 150, 15) Alignment:NSTextAlignmentLeft Text:@"修改手机号"];
    
    UIImageView *youimage3 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17, 10, 16)];
    youimage3.image = [UIImage imageNamed:@"right"];
    [view3 addSubview:youimage3];
    
    
    UIButton *btn3 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    btn3.backgroundColor = [UIColor clearColor];
    [btn3 addTarget:self action:@selector(changbinding) forControlEvents:UIControlEventTouchUpInside];
    [view3 addSubview:btn3];
    
    
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view1];
    
   // [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view2];
    
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view3];
    
    

}


#pragma  mark ======= initUI
- (void)creatrRightBtnItem{
    UIImage *image = [UIImage imageNamed:@"more-white"];
    if (!image) return ;
    CGFloat imgHeight = 24;
    YLButton *button = [[YLButton alloc] initWithFrame:CGRectMake(0, 0, 40, imgHeight)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightbuttonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [button setImageRect:CGRectMake(35, 4, 4, 16)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;
    
    
}


#pragma  mark ======= 按钮点击方法
- (void)rightbuttonClickEvent{
    self.menuView.OriginY = 60;
    [self.menuView show];
}

-(void)changpwd:(UIButton *)btn
{
    
    if (btn.tag == 10000) {
        MemberFgPwdViewController *fogvc = [[MemberFgPwdViewController alloc]init];
        fogvc.Type = 1;
        [self.navigationController pushViewController:fogvc animated:YES];

    }else if (btn.tag == 10001)
    {
        changpwdViewController *vc = [[changpwdViewController alloc]init];
        vc.str = @"2";
        [self.navigationController pushViewController:vc animated:YES];
    }
   
}

-(void)changbinding
{
    ChangePhoneViewController *phVc = [[ChangePhoneViewController alloc]init];
    [self.navigationController pushViewController:phVc animated:YES];
    
    
}


#pragma mark -------- menudelegate

-(void)didselectedBtnWithButton:(UIButton *)btn{
    
    if (btn.tag ==1001) {
        if (![[UserPL shareManager] userIsLogin]) {
            [self gotoLoginViewController];
            return;
        }
        ChatListViewController *chVc = [[ChatListViewController alloc] init];
        [self.navigationController pushViewController:chVc animated:YES];
        return;
    }
    
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    switch (btn.tag) {
        case 1000:
            [self.navigationController popToRootViewControllerAnimated:NO];
            app.mainController.selectedIndex = 0;
            break;
        case 1002:
            if (![[UserPL shareManager] userIsLogin]) {
                [self gotoLoginViewController];
            }else{
                [self.navigationController popToRootViewControllerAnimated:NO];
                app.mainController.selectedIndex = 4;

            }
            break;
        case 1003:
            if (![[UserPL shareManager] userIsLogin]) {
                [self gotoLoginViewController];
            }else{
                [self.navigationController popToRootViewControllerAnimated:NO];
                app.mainController.selectedIndex = 3;

            }
            break;
        case 1004:
            [self.navigationController popToRootViewControllerAnimated:NO];
            app.mainController.selectedIndex = 1;
            break;
            
        default:
            break;
    }
    
}

@end
