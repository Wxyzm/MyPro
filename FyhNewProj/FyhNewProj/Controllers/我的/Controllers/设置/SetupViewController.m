//
//  SetupViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SetupViewController.h"
#import "CleanCacheController.h"
#import "SecurityCenterViewController.h"
#import "AdministrationaddViewController.h"
#import "aboutFYHViewController.h"

#import "UserPL.h"

#import "AppDelegate.h"
#import "MenueView.h"
#import "ChatListViewController.h"
#import "DOTabBarController.h"

//#import "AppDelegate.h"
//#import "DOTabBarController.h"

@interface SetupViewController ()<MenueViewDelegate,UIScrollViewDelegate>

@property (nonatomic,strong) UISwitch *switchview;

@property (nonatomic , strong) MenueView *menuView;


@end

@implementation SetupViewController


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

    self.title = @"设置";
    [self creatrRightBtnItem];
    [self setUI];
   
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
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


-(void)setUI
{
    UIScrollView *myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    myscrollview.delegate = self;
    myscrollview.contentSize = CGSizeMake(ScreenWidth, 667-64);
    myscrollview.backgroundColor = UIColorFromRGB(0xe6e9ed);
    [self.view addSubview:myscrollview];
    
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 50)];
    view1.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view1];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view1 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"清除缓存"];
    
    UIImageView *youimage1 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17, 10, 16)];
    youimage1.image = [UIImage imageNamed:@"right"];
    [view1 addSubview:youimage1];
    
    
    
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view2];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view2 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"安全中心"];
    
    UIImageView *youimage2 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17, 10, 16)];
    youimage2.image = [UIImage imageNamed:@"right"];
    [view2 addSubview:youimage2];
    
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, 50)];
    view3.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view3];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view3 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"收货地址"];
    
    UIImageView *youimage3 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17, 10, 16)];
    youimage3.image = [UIImage imageNamed:@"right"];
    [view3 addSubview:youimage3];
    
    UIView *view4 = [[UIView alloc]initWithFrame:CGRectMake(0, 150, ScreenWidth, 50)];
    view4.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view4];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view4 Frame:CGRectMake(20, 17.5, 100, 15) Alignment:NSTextAlignmentLeft Text:@"关于丰云汇"];
    UIImageView *youimage4 = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17, 10, 16)];
    youimage4.image = [UIImage imageNamed:@"right"];
    [view4 addSubview:youimage4];
    
    
    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(0, 200, ScreenWidth, 50)];
    view6.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:view6];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view6 Frame:CGRectMake(20, 17.5, 100, 15) Alignment:NSTextAlignmentLeft Text:@"消息提示音"];
    
    
    self.switchview = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth-70, 10, 60, 40)];
    [_switchview addTarget:self action:@selector(myswitch:) forControlEvents:UIControlEventValueChanged];
    _switchview.on = YES;
    [view6 addSubview:_switchview];
    
    
    
    
    
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view1];

    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view2];
    
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view3];
    
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view4];
    
    
    SubBtn *tuichuBtn = [SubBtn buttonWithtitle:@"退出登录" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(tuichu) andframe:CGRectMake(25, CGRectGetMaxY(view6.frame)+100, ScreenWidth-50, 50)];
    tuichuBtn.titleLabel.font = APPFONT(18);
    [myscrollview addSubview:tuichuBtn];

    for (int i = 0; i <4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [myscrollview  addSubview:btn];
        btn.frame = CGRectMake(0, 50*i, ScreenWidth, 50);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnclick:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    

}
#pragma  mark ======= 按钮点击方法
- (void)rightbuttonClickEvent{
    self.menuView.OriginY = 60;
    [self.menuView show];
}
-(void)tuichu
{
    
    [[UserPL shareManager] logout];
    NSNotification *notification =[NSNotification notificationWithName:@"Userlogout" object:nil userInfo:nil];
    //通过通知中心发送通知
    [[NSNotificationCenter defaultCenter] postNotification:notification];
   // DOTabBarController *tarbar = [[DOTabBarController alloc]init];
    //    [tarbar settheType:2];
    //    tarbar.selectedIndex = 4;
    //    self.view.window.rootViewController = tarbar;
    //
    [self.navigationController popToRootViewControllerAnimated:YES];

        }

-(void)myswitch:(UISwitch *)sender
{
    
}

- (void)btnclick:(UIButton *)btn{

    switch (btn.tag) {
        case 1000:
        {
            //清除缓存
            CleanCacheController *cleanvc = [[CleanCacheController alloc]init];
            [self.navigationController pushViewController:cleanvc animated:YES];
            break;
        }
        case 1001:
        {
            //安全中心
            SecurityCenterViewController *safeVc = [[SecurityCenterViewController alloc]init];
            [self.navigationController pushViewController:safeVc animated:YES];
            break;
        }
        case 1002:
        {
            //收货地址
            AdministrationaddViewController *adressVc = [[AdministrationaddViewController  alloc]init];
            adressVc.title = @"管理收货地址";
            [self.navigationController pushViewController:adressVc animated:YES];                                                                                                                                                                                                                                                                             
            break;
        }
        case 1003:
        {
            //关于丰云汇
            aboutFYHViewController *abVc = [[aboutFYHViewController alloc]init];
            [self.navigationController pushViewController:abVc animated:YES];
            break;
        }
        
        default:
            break;
    }



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
    
    [self.navigationController popToRootViewControllerAnimated:NO];
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
