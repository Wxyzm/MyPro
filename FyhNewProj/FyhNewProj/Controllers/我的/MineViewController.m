//
//  MineViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//  人生最好的三种状态：不期而遇、不言而喻、不药而愈

#import "MineViewController.h"
#import "MemberLoginController.h"
#import "CertificationViewController.h"
#import "BussCertificaViewController.h"
#import "SetupViewController.h"
#import "MineTopView.h"
#import "OrderBtn.h"
#import "MyOrderController.h"
#import "MyGoBuyViewController.h"
#import "MyCollectionController.h"
#import "MyEvaController.h"
#import "DOTabBarController.h"
#import "AppDelegate.h"
#import "MainInfoViewController.h"

#import "UserInfoChangePL.h"
#import "UserInfoModel.h"
#import "OrderPL.h"
#import "ChatListViewController.h"
#import "MyAssetsViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "BankCardPL.h"

@interface MineViewController ()<UITableViewDelegate,UITableViewDataSource,UINavigationControllerDelegate,UITabBarControllerDelegate>
@property (nonatomic , strong) UITableView *BuyersTbv;
@end

@implementation MineViewController{
    MineTopView      *_topView;
    UserInfoChangePL *_infoPL;
    UserInfoModel    *_infomodel;
    UILabel          *_blanceLab;

}


-(UITableView *)BuyersTbv{
    if (!_BuyersTbv) {
        if (iPad) {
            _BuyersTbv = [[UITableView alloc]initWithFrame:CGRectMake(0, 250, ScreenWidth, ScreenHeight-TABBAR_HEIGHT-250) style:UITableViewStylePlain];
        }else{
            _BuyersTbv = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenWidth*2/5+50, ScreenWidth, ScreenHeight-50-TABBAR_HEIGHT-ScreenWidth*2/5) style:UITableViewStylePlain];
        }
        _BuyersTbv.delegate = self;
        _BuyersTbv.dataSource = self;
        _BuyersTbv.separatorStyle = UITableViewCellSeparatorStyleNone;
        _BuyersTbv.backgroundColor = UIColorFromRGB(BGColorValue);

    }
    return _BuyersTbv;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    _infoPL = [[UserInfoChangePL alloc]init];
    self.navigationController.delegate = self;
    
    //用户信息变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadUserInfo)
                                                 name:@"userDataIsChange"  object:nil];
    //用户退出登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Userlogout)
                                                 name:@"Userlogout"  object:nil];
    
    //用户是否登录
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserIslogin)
                                                 name:@"UserIslogin"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MineShouldRefresh)
                                                 name:@"MineShouldRefresh"  object:nil];
    
    
    [self setView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    [self loadUserInfo];
  
}

    
-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];

}

-(void)setView{
       
    
    if (iPad) {
        _topView = [[MineTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,  250)];
    }else{
        _topView = [[MineTopView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,  ScreenWidth*2/5+50)];

        
    }
    [self.view addSubview:_topView];
    YLButton *changeBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(20, 50, 116, 20);
    [_topView  addSubview:changeBtn];
    [changeBtn setTitle:@"切换为卖家" forState:UIControlStateNormal];
    [changeBtn setImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    [changeBtn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    [changeBtn setImageRect:CGRectMake(0, 2, 16, 16)];
    [changeBtn setTitleRect:CGRectMake(21, 0, 95, 20)];
    changeBtn.titleLabel.font = APPFONT(13);
    [changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *messageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [messageBtn setImage:[UIImage imageNamed:@"information"] forState:UIControlStateNormal];
    [self.view addSubview:messageBtn];
    messageBtn.frame = CGRectMake(ScreenWidth - 40, 50, 20, 20);
    [messageBtn addTarget:self action:@selector(messageBtnClick) forControlEvents:UIControlEventTouchUpInside];
   
    UIButton *sheZhiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sheZhiBtn setImage:[UIImage imageNamed:@"set"] forState:UIControlStateNormal];
    [self.view addSubview:sheZhiBtn];
    sheZhiBtn.frame = CGRectMake(ScreenWidth - 80, 50, 20, 20);
    [sheZhiBtn addTarget:self action:@selector(sheZhiBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *userBtn = [BaseViewFactory  buttonWithFrame:CGRectZero font:APPFONT(15) title:@"" titleColor:UIColorFromRGB(LineColorValue) backColor:[UIColor clearColor]];
    [_topView addSubview:userBtn];
    userBtn.sd_layout.leftSpaceToView(_topView,20).bottomSpaceToView(_topView,20).widthIs(200).heightIs(80);
    [userBtn addTarget:self action:@selector(changeUserIno) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.view addSubview:self.BuyersTbv];
    [self.BuyersTbv reloadData];
    [self loadUserInfo];
    
    
    
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2) {
        return 3;
    }
    else
    {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2)
    {
        if (indexPath.row == 2)
        {
            
            return 50+12;
        }
        else
        {
            return 50;
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            return 39;
        }
        else
        {
            return 60+12;
        }
    }
    else
    {
        if (indexPath.row == 0)
        {
            return 39;
        }
        else
        {
            return 100+12;
        }
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static
    NSString *cellId = @"Cell111";
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil)
    {
        cell  = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellAccessoryNone;
        
        if (indexPath.section == 0)
        {
            if (indexPath.row ==0)
            {
                UIImageView *dingdanimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9.5, 20, 20)];
                dingdanimage.image = [UIImage imageNamed:@"order"];
                [cell.contentView addSubview:dingdanimage];
                
                UILabel *dingdanlab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dingdanimage.frame)+5, 12, 80, 15)];
                dingdanlab.text = @"我的订单";
                dingdanlab.textColor = UIColorFromRGB(0x434a54);
                dingdanlab.textAlignment = NSTextAlignmentLeft;
                dingdanlab.font =APPFONT(15);
                [cell.contentView addSubview:dingdanlab];
                
                YLButton *chakanlab = [[YLButton alloc]initWithFrame:CGRectMake(ScreenWidth-20-100, 0, 100, 39)];
                [chakanlab setTitle:@"查看全部订单" forState:UIControlStateNormal];
                [chakanlab setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
                [chakanlab setTitleRect:CGRectMake(0, 0, 80, 39)];
                [chakanlab setImageRect:CGRectMake(90, 11.5, 10, 16)];
                chakanlab.titleLabel.textAlignment = NSTextAlignmentRight;
                [chakanlab setTitleColor:UIColorFromRGB(PlaColorValue) forState:UIControlStateNormal];
                chakanlab.titleLabel.font = APPFONT(13);
                [cell.contentView addSubview:chakanlab];
                [chakanlab addTarget:self action:@selector(lookAllOrderBtnclick) forControlEvents:UIControlEventTouchUpInside];
                [self createLineWithColor:UIColorFromRGB(BGColorValue) frame:CGRectMake(0, 38, ScreenWidth, 1) Super:cell];
                
            }
            else
            {
                NSArray * jiqiaotitlarr = @[@"待付款",@"待发货",@"待收货",@"待评价",@"退款/售后"];
                NSArray * jiqiaoiamgearr = @[@"pay-red",@"send-red",@"receive-red",@"evaluate-red",@"refund-red"];
                for (int i = 0; i<5; i++)
                {
                    NSInteger index = i % 5;   //列
                    NSInteger page = i / 5;    //行
                    OrderBtn *btn = [[OrderBtn alloc]initWithFrame:CGRectMake(index *ScreenWidth/5,10+ page *(15+39+9+13+17), ScreenWidth/5, (15+39+9+13+17))];
                    [btn setImage:[UIImage imageNamed:jiqiaoiamgearr[i]] forState:UIControlStateNormal];
                    [btn setTitle:jiqiaotitlarr[i] forState:UIControlStateNormal];
                    [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:0];
                    [cell.contentView  addSubview:btn];
                    btn.tag = 3100+i;
                    [btn addTarget:self action:@selector(jiqiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
                    
                }
                [self createLineWithColor:UIColorFromRGB(BGColorValue) frame:CGRectMake(0, 100, ScreenWidth, 12) Super:cell];
                
            }
        }
        else if (indexPath.section == 1)
        {
            if (indexPath.row == 0)
            {
                UIImageView *dingdanimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 9.5, 20, 20)];
                dingdanimage.image = [UIImage imageNamed:@"property"];
                [cell.contentView addSubview:dingdanimage];
                
                UILabel *dingdanlab = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(dingdanimage.frame)+5, 12, 80, 15)];
                dingdanlab.text = @"我的资产";
                dingdanlab.textColor = UIColorFromRGB(BlackColorValue);
                dingdanlab.textAlignment = NSTextAlignmentLeft;
                dingdanlab.font =APPFONT(15);
                [cell.contentView addSubview:dingdanlab];
                
                UIImageView *right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
                [cell.contentView addSubview:right];
                right.frame = CGRectMake(ScreenWidth-20-10, 11.5, 10, 16);
                
                [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 38, ScreenWidth, 1) Super:cell];
                UIButton *moneyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//                moneyBtn.backgroundColor = [UIColor orangeColor];
                [cell.contentView addSubview:moneyBtn];
                moneyBtn.frame = CGRectMake(0, 0, ScreenWidth, 39);
                [moneyBtn addTarget:self action:@selector(moneyBtnClick) forControlEvents:UIControlEventTouchUpInside];
                
            }
            else
            {
                
                _blanceLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 11, ScreenWidth/2, 15) textColor:UIColorFromRGB(RedColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"￥0.00"];
                [cell addSubview:_blanceLab];
//                [self createLabelWith:UIColorFromRGB(RedColorValue) Font:APPFONT(15) WithSuper:cell Frame:CGRectMake(0, 11, ScreenWidth/2, 15) Alignment:NSTextAlignmentCenter Text:@"￥0.00"];
                
                [self createLabelWith:UIColorFromRGB(RedColorValue) Font:APPFONT(15) WithSuper:cell Frame:CGRectMake(ScreenWidth/2, 11, ScreenWidth/2, 15) Alignment:NSTextAlignmentCenter Text:@"0张"];
                
                
                [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(13) WithSuper:cell Frame:CGRectMake(0, 11+15+10, ScreenWidth/2, 13) Alignment:NSTextAlignmentCenter Text:@"余额"];
                
                [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(13) WithSuper:cell Frame:CGRectMake(ScreenWidth/2, 11+15+10, ScreenWidth/2, 13) Alignment:NSTextAlignmentCenter Text:@"优惠券"];
                
                
                [self createLineWithColor:UIColorFromRGB(BGColorValue) frame:CGRectMake(0, 60, ScreenWidth, 12) Super:cell];
           
                UIButton *blanceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cell addSubview:blanceBtn];
                [blanceBtn addTarget:self action:@selector(blanceBtnClick) forControlEvents:UIControlEventTouchUpInside];
                blanceBtn.frame = CGRectMake(0, 0, ScreenWidth/2, 60);
                UIButton *youhuieBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                [cell addSubview:youhuieBtn];
                [youhuieBtn addTarget:self action:@selector(youhuieBtnClick) forControlEvents:UIControlEventTouchUpInside];
                youhuieBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 60);
            }
        }
        else
        {
            if (indexPath.row == 0)
            {
                UIImageView *shouimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12.5, 25, 25)];
                shouimage.image = [UIImage imageNamed:@"my-collect"];
                [cell.contentView addSubview:shouimage];
                
                [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:cell Frame:CGRectMake(20+25+5, 17.5, 65, 15) Alignment:NSTextAlignmentLeft Text:@"我的收藏"];
                
                UIImageView *youimage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17, 10, 16)];
                youimage.image = [UIImage imageNamed:@"right"];
                [cell.contentView addSubview:youimage];

                [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:cell];
                
               
                
            }
            else if (indexPath.row == 1)
            {
                UIImageView *shouimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12.5, 25, 25)];
                shouimage.image = [UIImage imageNamed:@"my-cart"];
                [cell.contentView addSubview:shouimage];
                
                [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:cell Frame:CGRectMake(20+25+5, 17.5, 65, 15) Alignment:NSTextAlignmentLeft Text:@"我的采购"];
                
                UIImageView *youimage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17, 10, 16)];
                youimage.image = [UIImage imageNamed:@"right"];
                [cell.contentView addSubview:youimage];

                [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:cell];
            }
            else
            {
                UIImageView *shouimage = [[UIImageView alloc]initWithFrame:CGRectMake(20, 12.5, 25, 25)];
                shouimage.image = [UIImage imageNamed:@"iv_cart_chose"];
                [cell.contentView addSubview:shouimage];
                
                [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:cell Frame:CGRectMake(20+25+5, 17.5, 65, 15) Alignment:NSTextAlignmentLeft Text:@"我的评价"];
                
                UIImageView *youimage = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth-20-10, 17,10, 16)];
                youimage.image = [UIImage imageNamed:@"right"];
                [cell.contentView addSubview:youimage];

                [self createLineWithColor:UIColorFromRGB(BGColorValue) frame:CGRectMake(0, 50, ScreenWidth, 12) Super:cell];
            }
        }
        
        
    }
    return cell;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            MyCollectionController *goBuyVc = [[MyCollectionController alloc]init];
            [self.navigationController pushViewController:goBuyVc animated:YES];
        }else if (indexPath.row == 1){
            MyGoBuyViewController *goBuyVc = [[MyGoBuyViewController alloc]init];
            [self.navigationController pushViewController:goBuyVc animated:YES];
        }else{
            [self showTextHud:@"即将上线"];
            return;

        }
     
        
    }
}


#pragma mark ========== 按钮点击方法


- (void)youhuieBtnClick{
    
    [self showTextHud:@"即将上线"];
}
/**
 改变用户信息
 */
- (void)changeUserIno{

    MainInfoViewController *infovc = [[MainInfoViewController alloc]init];
    [self.navigationController pushViewController:infovc animated:YES];

}

/**
 切换商家
 */
- (void)changeBtnClick{


    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    [app.mainController settheType:2];
    app.mainController.selectedIndex = 4;
    app.mainController.delegate = self;
    self.view.window.rootViewController = app.mainController;

    

}

/**
 我的资产
 */
- (void)moneyBtnClick{

    MyAssetsViewController *myAssVC = [[MyAssetsViewController alloc]init];
    [self.navigationController pushViewController:myAssVC animated:YES];


}

- (void)blanceBtnClick{
    
    MyAssetsViewController *myAssVC = [[MyAssetsViewController alloc]init];
    [self.navigationController pushViewController:myAssVC animated:YES];
}
#pragma - mark for BaseTabBarDelegate
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    // [BaseTabBarController sharedTabBar].curNav = (JTNavigationController *)viewController;
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];

    if (viewController == app.mainController.viewControllers[4]||viewController == app.mainController.viewControllers[3]) {
        if (![[UserPL shareManager]userIsLogin]){
            MemberLoginController *vc = [[MemberLoginController alloc] init];
            vc.type = 2;
            DOHNavigationController *navigationController = [[DOHNavigationController alloc] initWithRootViewController:vc];
            [viewController presentViewController:navigationController animated:YES completion:^{}];
            return NO;
        }else{
            if (viewController == app.mainController.viewControllers[4]) {
                viewController.navigationController.navigationBar.hidden = YES;
                [self loadbuyerordercount];

            }
            
            return YES;
        }
    }
    
    return YES;
}


/**
 联系客服
 */
- (void)messageBtnClick{
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    ChatListViewController *chatVc = [[ChatListViewController alloc]init];
    [self.navigationController pushViewController:chatVc animated:YES];
    
}

/**
 设置
 */
- (void)sheZhiBtnBtnClick{

    SetupViewController *setVc = [[SetupViewController alloc]init];
    [self.navigationController pushViewController:setVc animated:YES];
}

/**
 查看全部订单
 */
- (void)lookAllOrderBtnclick{
    //全部
    MyOrderController  *orderVC = [[MyOrderController    alloc]init];
    orderVC.btnType = BTN_ALL;

    [self.navigationController  pushViewController:orderVC animated:YES];


}


/**
 我的订单按钮

 @param button 按钮
 */
- (void)jiqiaoBtn:(UIButton *)button{

    switch (button.tag) {
        case 3100:{
           //待付款
            MyOrderController  *orderVC = [[MyOrderController    alloc]init];
            orderVC.btnType = BTN_UNPAID;
            [self.navigationController  pushViewController:orderVC animated:YES];
            break;
        }
        case 3101:{
            //待发货
            MyOrderController  *orderVC = [[MyOrderController    alloc]init];
            orderVC.btnType = BTN_UNSENT;
            [self.navigationController  pushViewController:orderVC animated:YES];
            break;
            break;
        }
        case 3102:{
            //待收货
            MyOrderController  *orderVC = [[MyOrderController    alloc]init];
            orderVC.btnType = BTN_UNACCEPT;
            [self.navigationController  pushViewController:orderVC animated:YES];

            break;
        }
        case 3103:{
            //待评价
            [self showTextHud:@"即将上线"];
            break;
        }
        case 3104:{
            //退款、售后
             [self showTextHud:@"即将上线"];
            break;
        }
        default:
            break;
    }


}





#pragma mark ========= 网络请求获取个人信息
- (void)loadbuyerordercount{

[OrderPL BuyersGetordercountsWithReturnBlock:^(id returnValue) {
    NSLog(@"%@",returnValue);
    NSIndexPath *index = [NSIndexPath indexPathForRow:1 inSection:0];
    UITableViewCell *cell = [_BuyersTbv cellForRowAtIndexPath:index];
    
    OrderBtn *btn1 = (OrderBtn*)[cell.contentView viewWithTag:3100];
   // [btn1.badge setTitle:[NSString stringWithFormat:@"%@",returnValue[@"newUserOrderCount"]] forState:UIControlStateNormal];
    [btn1 setThebadgeNumber:[NSString stringWithFormat:@"%@",returnValue[@"newUserOrderCount"]]];
  //  [btn1 setThebadgeNumber:@"10000"];

    OrderBtn *btn2 = (OrderBtn*)[cell.contentView viewWithTag:3101];
//    [btn2.badge setTitle:[NSString stringWithFormat:@"%@",returnValue[@"paidItemOrderCount"]] forState:UIControlStateNormal];
    [btn2 setThebadgeNumber:[NSString stringWithFormat:@"%@",returnValue[@"paidItemOrderCount"]]];

    OrderBtn *btn3 = (OrderBtn*)[cell.contentView viewWithTag:3102];
//    [btn3.badge setTitle:[NSString stringWithFormat:@"%@",returnValue[@"sentItemOrderCount"]] forState:UIControlStateNormal];
    [btn3 setThebadgeNumber:[NSString stringWithFormat:@"%@",returnValue[@"sentItemOrderCount"]]];

    OrderBtn *btn4 = (OrderBtn*)[cell.contentView viewWithTag:3103];
    [btn4.badge setHidden:YES];
    
    OrderBtn *btn5 = (OrderBtn*)[cell.contentView viewWithTag:3104];
    [btn5.badge setHidden:YES];

    

} andErrorBlock:^(NSString *msg) {
   [self showTextHud:msg];
}];

}
#pragma mark ========= 网络请求获取余额
- (void)loadBlance{
    [BankCardPL userGetbalanceWithReturnBlock:^(id returnValue) {
        _blanceLab.text = [NSString stringWithFormat:@"￥%@",returnValue[@"balance"]];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];

}




- (void)loadUserInfo{

    __weak __typeof(self)weakSelf = self;

    [_infoPL getUserInfoWithReturnBlock:^(id returnValue) {
        NSDictionary *redic = returnValue[@"data"];
        _infomodel = [UserInfoModel mj_objectWithKeyValues:redic[@"userProfile"]];
        [weakSelf refreshTopViewWithModel:_infomodel];
        [self loadbuyerordercount];
        [self loadBlance];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
}


- (void)refreshTopViewWithModel:(UserInfoModel *)infoModel{

    if (infoModel.nickname) {
        _topView.nameLab.text = infoModel.nickname;
    }else{
        _topView.nameLab.text = [[NSUserDefaults standardUserDefaults] objectForKey:FYH_USER_ACCOUNT];
        
    }

    if (infoModel.avatarUrl) {
        [_topView.faceImageView sd_setImageWithURL:[NSURL URLWithString:infoModel.avatarUrl] placeholderImage:[UIImage imageNamed:@"member-big"]];
    }else{
        
        _topView.faceImageView.image = [UIImage imageNamed:@"member-big"];
        
    }


}

#pragma mark======== 通知
- (void)Userlogout{

    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.mainController.selectedIndex = 0;


}

- (void)UserIslogin{

    

}

- (void)MineShouldRefresh{

    
    if ([[UserPL shareManager]userIsLogin]) {
        [self loadUserInfo];

    }

}

@end
