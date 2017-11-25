//
//  SellerViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SellerViewController.h"
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
#import "SellerTopview.h"
#import "sellerBtn.h"
#import "DOTabBarController.h"
#import "AppDelegate.h"

#import "MainInfoViewController.h"

#import "ShopReleaseGoodsController.h"
#import "HTMLViewController.h"
#import "MyShopViewController.h"
#import "GoodsManageViewController.h"
#import "SellerOrderViewController.h"
#import "OrderPL.h"
#import "UserInfoChangePL.h"
#import "UserInfoModel.h"
#import "MyPriceViewController.h"

#import "TureNamePL.h"
//#import "TureNameViewController.h"
#import "TureNameView.h"
#import "TureNameResultController.h"
#import "ChatListViewController.h"
#import "BusIntroController.h"
#import "NewProCreateController.h"
#import "Personal authenticationViewController.h"
#import "EnterprisecertificationViewController.h"
#import "BussQRCodeController.h"

@interface SellerViewController ()<UIScrollViewDelegate,UITabBarControllerDelegate>

@property (nonatomic , strong) UIScrollView *myscrollview;

@property (nonatomic , strong) TureNameView *tureView;

@end

@implementation SellerViewController{
    SellerTopview  *_topView;
    UIButton *_bageBtn1;
    UIButton *_bageBtn2;
    UserInfoChangePL *_infoPL;
    UserInfoModel *_infomodel;

}


-(TureNameView *)tureView{

    if (!_tureView) {
        _tureView = [[TureNameView alloc]init];
        [_tureView.personBtn addTarget:self action:@selector(personClick) forControlEvents:UIControlEventTouchUpInside];
        [_tureView.BussBtn addTarget:self action:@selector(BussBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _tureView;


}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"";
    _infoPL = [[UserInfoChangePL alloc]init];
    [self setView];
    [self loadUserInfo];
//    [self loadbuyerordercount];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MineShouldRefresh)
                                                 name:@"MineShouldRefresh"  object:nil];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [self loadUserInfo];

    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [self.tureView dismiss];

}

-(void)setView{
    
    
    _topView = [[SellerTopview alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,  ScreenWidth*2/5+50)];
    if (iPad) {
        _topView = [[SellerTopview alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,  250)];
    }else{
        _topView = [[SellerTopview alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth,  ScreenWidth*2/5+50)];
    }
    [self.view addSubview:_topView];
    YLButton *changeBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    changeBtn.frame = CGRectMake(20, 50, 116, 20);
    [_topView  addSubview:changeBtn];
    [changeBtn setTitle:@"切换为买家" forState:UIControlStateNormal];
    [changeBtn setImage:[UIImage imageNamed:@"change"] forState:UIControlStateNormal];
    [changeBtn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    [changeBtn setImageRect:CGRectMake(0, 2, 16, 16)];
    [changeBtn setTitleRect:CGRectMake(21, 0, 95, 20)];
    changeBtn.titleLabel.font = APPFONT(13);
    [changeBtn addTarget:self action:@selector(changeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    UIButton *qrBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [qrBtn setImage:[UIImage imageNamed:@"QRcode"] forState:UIControlStateNormal];
    [self.view addSubview:qrBtn];
    qrBtn.frame = CGRectMake(ScreenWidth - 40, 50, 20, 20);
    [qrBtn addTarget:self action:@selector(qrBtnClick) forControlEvents:UIControlEventTouchUpInside];
    if (iPad) {
        qrBtn.frame = CGRectMake(ScreenWidth - 40, 210 , 20, 20);
    }else{
        qrBtn.frame = CGRectMake(ScreenWidth - 40, ScreenWidth*2/5+10, 20, 20);
    }
    
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
    
//    [self.view addSubview:self.BuyersTbv];
//    [self.BuyersTbv reloadData];
    
    if (iPad) {
        _myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 250, ScreenWidth, ScreenHeight-TABBAR_HEIGHT-250)];
    }else{
        _myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, ScreenWidth*2/5+50, ScreenWidth, ScreenHeight-50-TABBAR_HEIGHT-ScreenWidth*2/5)];
    }
    _myscrollview.delegate = self;
    _myscrollview.contentSize = CGSizeMake(ScreenWidth, 667-64-ScreenWidth*2/5+50);
    _myscrollview.backgroundColor = UIColorFromRGB(LineColorValue);
    [self.view addSubview:_myscrollview];
    
    NSArray * jiqiaotitlarr = @[@"待付款",@"待发货",@"退款中",@"已评价"];
    NSArray * jiqiaoiamgearr = @[@"pay-grey",@"send-grey",@"refund-grey",@"evaluate-grey"];
    CGFloat Width = ScreenWidth/4;
    CGFloat Height = ScreenWidth/4;

    for (int i = 0; i<4; i++)
    {
        NSInteger index = i % 4;   //列
      //  NSInteger page = i / 4;    //行
        YLButton *btn = [[YLButton alloc]initWithFrame:CGRectMake(index *ScreenWidth/4,0, Width,Height)];
        btn.backgroundColor = UIColorFromRGB(WhiteColorValue);
        [btn setImage:[UIImage imageNamed:jiqiaoiamgearr[i]] forState:UIControlStateNormal];
        [btn setTitle:jiqiaotitlarr[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:0];
        btn.titleLabel.font = APPFONT(14);
        btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        btn.titleRect = CGRectMake(0, (Height -54)/2+5+15+25, Width, 14);
        btn.imageRect = CGRectMake(Width/2-12.5, (Height -54)/2+5, 25, 25);
        [_myscrollview  addSubview:btn];
        btn.tag = 3200+i;
        [btn addTarget:self action:@selector(jiqiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
        
        if (i == 0) {
            _bageBtn1 = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/4/2+2.5, (Height -54)/2-5, 20, 20)];
            _bageBtn1.backgroundColor = [UIColor whiteColor];
            [_bageBtn1 setTitle:@"0" forState:UIControlStateNormal];
            _bageBtn1.titleLabel.font = APPFONT(11);
            [_bageBtn1 setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
            _bageBtn1.layer.cornerRadius = 10;
            _bageBtn1.layer.borderWidth = 1;
            _bageBtn1.layer.borderColor = UIColorFromRGB(RedColorValue).CGColor;
            _bageBtn1.layer.masksToBounds = YES;
            //_badge.hidden = YES;
            [btn addSubview:_bageBtn1];

        }else if (i == 1){
            _bageBtn2 = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth/4/2+2.5, (Height -54)/2-5, 20, 20)];
            _bageBtn2.backgroundColor = [UIColor whiteColor];
            [_bageBtn2 setTitle:@"0" forState:UIControlStateNormal];
            _bageBtn2.titleLabel.font = APPFONT(11);
            [_bageBtn2 setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
            _bageBtn2.layer.cornerRadius = 10;
            _bageBtn2.layer.borderWidth = 1;
            _bageBtn2.layer.borderColor = UIColorFromRGB(RedColorValue).CGColor;
            _bageBtn2.layer.masksToBounds = YES;
            //_badge.hidden = YES;
            [btn addSubview:_bageBtn2];
        }
        
        
    }
    
    NSArray * jiqiaotitlarr1 = @[@"订单管理",@"发布商品",@"店铺设置",@"商品管理",@"商家认证",@"我的报价",@"运营报表",@"申请代运营"];
    NSArray * jiqiaoiamgearr1 = @[@"order-man",@"pub-good",@"shop-set",@"bus-man",@"bus-idn-red",@"my-price",@"bus-report",@"apl-man"];
    for (int i = 0; i<8; i++)
    {
        NSInteger index = i % 4;   //列
        NSInteger page = i / 4;    //行
        
        sellerBtn *btn = [[sellerBtn alloc]initWithFrame:CGRectMake(index *ScreenWidth/4,ScreenWidth/4+12 +page *113, ScreenWidth/4, 113)];
        btn.backgroundColor = UIColorFromRGB(WhiteColorValue);
        [btn setImage:[UIImage imageNamed:jiqiaoiamgearr1[i]] forState:UIControlStateNormal];
        [btn setTitle:jiqiaotitlarr1[i] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:0];
        [_myscrollview  addSubview:btn];
        btn.layer.borderWidth = 0.5;
        btn.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
        btn.tag = 3300+i;
        [btn addTarget:self action:@selector(jiqiaoBtn:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    UIButton *userBtn = [BaseViewFactory  buttonWithFrame:CGRectZero font:APPFONT(15) title:@"" titleColor:UIColorFromRGB(LineColorValue) backColor:[UIColor clearColor]];
    [_topView addSubview:userBtn];
    userBtn.sd_layout.leftSpaceToView(_topView,20).bottomSpaceToView(_topView,20).widthIs(200).heightIs(80);
    [userBtn addTarget:self action:@selector(changeUserIno) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *telBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenWidth/4+12+226+40, ScreenWidth, 15)];
    telBtn.backgroundColor = [UIColor clearColor];
    [telBtn setTitle:@"联系客服400-878-0966" forState:0];
    [telBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:0];
    telBtn.titleLabel.font = APPFONT(15);
    [telBtn addTarget:self action:@selector(kefudianhua) forControlEvents:UIControlEventTouchUpInside];
    [_myscrollview addSubview:telBtn];
    

    
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
    
//    DOTabBarController *tarbar = [[DOTabBarController alloc]init];
//    tarbar.delegate = self;
//    [tarbar settheType:1];
//    tarbar.selectedIndex = 4;
    
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    [app.mainController settheType:1];
    app.mainController.selectedIndex = 4;
    app.mainController.delegate = self;

    self.view.window.rootViewController = app.mainController;

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
                
            }
            
            return YES;
        }
    }
    
    return YES;
}

- (void)jiqiaoBtn:(sellerBtn *)btn{
    
    
    switch (btn.tag) {
    
        case 3200:{
            SellerOrderViewController  *shopVc = [[SellerOrderViewController   alloc]init];
            shopVc.btnType = SBTN_UnPay;
            [self.navigationController pushViewController:shopVc animated:YES];
            
            break;
        }
        case 3201:{
            SellerOrderViewController  *shopVc = [[SellerOrderViewController   alloc]init];
            shopVc.btnType = SBTN_UnSent;
            [self.navigationController pushViewController:shopVc animated:YES];
            
            break;
        }
        case 3202:{
            [self showTextHud:@"敬请期待"];
            
            break;
        }
        case 3203:{
            [self showTextHud:@"敬请期待"];
            
            break;
        }

        case 3300:{
            SellerOrderViewController  *shopVc = [[SellerOrderViewController   alloc]init];
            shopVc.btnType = SBTN_ALL;
            [self.navigationController pushViewController:shopVc animated:YES];

            break;
        }
        case 3301:{
            //发布商品判断是否实名认证
          
            
            [TureNamePL BussUserGetcertifiCationStatusReturnBlock:^(id returnValue) {
                NSLog(@"%@",returnValue);
                if (!NULL_TO_NIL(returnValue[@"certification"]) ) {
                    [self.tureView showinView:self.view];

                }else{
                    NSDictionary *dic = returnValue[@"certification"];
                    if ([dic[@"status"] intValue]==1) {
                        //审核中
                        TureNameResultController *tureVc = [[TureNameResultController alloc]init];
                        tureVc.type = 1;
                        [self.navigationController pushViewController:tureVc animated:YES];

                    }else if ([dic[@"status"] intValue]==3){
                        //失败
                        TureNameResultController *tureVc = [[TureNameResultController alloc]init];

                        tureVc.type = 3;

                        [self.navigationController pushViewController:tureVc animated:YES];
                    }else if ([dic[@"status"] intValue]==2){

                        NewProCreateController *newVc = [[NewProCreateController alloc]init];
                        [self.navigationController pushViewController:newVc animated:YES];
                        //通过
                    }

                }



            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];
            }];

            
          
            
            break;
        }
        case 3302:{
            MyShopViewController  *shopVc = [[MyShopViewController   alloc]init];
            [self.navigationController pushViewController:shopVc animated:YES];
            break;
        }
        case 3303:{
            GoodsManageViewController *goodVc = [[GoodsManageViewController   alloc]init];
            [self.navigationController pushViewController:goodVc animated:YES];
            break;
        }
        case 3304:{
            [self makeSureIsTrueName];
            break;
        }
        case 3305:{
            
            MyPriceViewController *priceVc = [[MyPriceViewController alloc]init];
            [self.navigationController pushViewController:priceVc animated:YES];
            break;
        }
        case 3306:{
            
            [self showTextHud:@"敬请期待"];
            break;
        }
        case 3307:{
            [self showTextHud:@"敬请期待"];

            break;
        }
        
            
            
            
            
        default:
            break;
    }

}


- (void)makeSureIsTrueName{

[TureNamePL BussUserGetcertifiCationStatusReturnBlock:^(id returnValue) {
    NSLog(@"%@",returnValue);
    if (!NULL_TO_NIL(returnValue[@"certification"]) ) {
        [self.tureView showinView:self.view];

    }else{
        TureNameResultController *tureVc = [[TureNameResultController alloc]init];
        NSDictionary *dic = returnValue[@"certification"];
        if ([dic[@"status"] intValue]==1) {
            tureVc.type = 1;
        }else if ([dic[@"status"] intValue]==2){
        tureVc.type = 2;
        
        }else if ([dic[@"status"] intValue]==3){
        tureVc.type = 3;
        
        }
        if ([dic[@"type"] intValue]==1) {
            tureVc.nametype     = 1;
        }else if ([dic[@"type"] intValue]==2){
            tureVc.nametype = 2;
            
        }
        [self.navigationController pushViewController:tureVc animated:YES];
    }
    
    
    
} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];
}];


}

/**
 客服电话按钮
 */
- (void)kefudianhua{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",@"400-878-0966"];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];


}

/**
 右上角信息按钮
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
 设置按钮
 */
- (void)sheZhiBtnBtnClick{

    SetupViewController *setVc = [[SetupViewController alloc]init];
    [self.navigationController pushViewController:setVc animated:YES];

}
#pragma mark ========= 网络请求获取个人信息
- (void)loadbuyerordercount{
    
    [OrderPL SellerGetordercountsWithReturnBlock:^(id returnValue) {
        
                NSLog(@"%@",returnValue);
        [_bageBtn1 setTitle:[NSString stringWithFormat:@"%@",returnValue[@"newItemOrderCount"]] forState:UIControlStateNormal];
        [_bageBtn2 setTitle:[NSString stringWithFormat:@"%@",returnValue[@"paidItemOrderCount"]] forState:UIControlStateNormal];

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
   // [RCIMClient sharedRCIMClient].currentUserInfo.portraitUri = infoModel.avatarUrl;
    
    
}

#pragma mark  ------ 实名认证跳转
- (void)personClick{
    Personal_authenticationViewController *PersoncerVc = [[Personal_authenticationViewController alloc]init];
    [self.navigationController pushViewController:PersoncerVc animated:YES];

}

- (void)BussBtnClick{
    EnterprisecertificationViewController *bussVC = [[EnterprisecertificationViewController alloc]init];
    [self.navigationController pushViewController:bussVC animated:YES];

}
- (void)MineShouldRefresh{
    
    
    if ([[UserPL shareManager]userIsLogin]) {
        [self loadUserInfo];
        
    }
    
}

- (void)qrBtnClick{
    if (!_infomodel.accountId) {
        return;
    }
//    BusIntroController *busVC = [[BusIntroController alloc]init];
//    busVC.shopId = _infomodel.accountId;
//    [self.navigationController pushViewController:busVC animated:YES];
    BussQRCodeController *qrVc = [[BussQRCodeController alloc]init];
    qrVc.shopId =  _infomodel.accountId;
    [self.navigationController pushViewController:qrVc animated:YES];
}
@end
