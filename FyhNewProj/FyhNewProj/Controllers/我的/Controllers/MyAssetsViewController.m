//
//  MyAssetsViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyAssetsViewController.h"
#import "BankCardMViewController.h"
#import "AssetDetailsViewController.h"
#import "WithdrawalsViewController.h"
#import "BankCardPL.h"

@interface MyAssetsViewController ()

@property (nonatomic , strong) UILabel  *balanceLab;        //余额

@end

@implementation MyAssetsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的资产";
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    [self setBarBackBtnWithImage:nil];
    [self createNavagationItem];
    [self initUI];
    [self loadbalance];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.hidden = NO;

}

#pragma mark === initUI
- (void)initUI{

    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 102) color:UIColorFromRGB(WhiteColorValue)];
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = topView.bounds;
    //  gradientLayer.cornerRadius = 10;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)UIColorFromRGB(0xff2d66).CGColor,
                             (id)UIColorFromRGB(0xff4452).CGColor,
                             (id)UIColorFromRGB(0xff5d3b).CGColor];
    //  设置三种颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@(0.1f) ,@(0.5f),@(1.0f)];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  添加渐变色到创建的 UIView 上去
    [topView.layer addSublayer:gradientLayer];
    [self.view addSubview:topView];
    
    UILabel *baLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 20, 150, 16) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"账户金额（元）"];
    [topView addSubview:baLab];
    
    _balanceLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 50, ScreenWidth - 110, 36) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(36) textAligment:NSTextAlignmentLeft andtext:@"0.00"];
    [topView addSubview:_balanceLab];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightBtn setTitle:@"余额规则说明" forState:UIControlStateNormal];
    [rightBtn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    [topView addSubview:rightBtn];
    rightBtn.titleLabel.font = APPFONT(13);
    rightBtn.sd_layout.rightSpaceToView(topView, 16).bottomEqualToView(_balanceLab).heightIs(14).widthIs(80);
    [rightBtn addTarget:self action:@selector(rightBtnClick) forControlEvents:UIControlEventTouchUpInside];
    rightBtn.alpha = 0.7;
    
    UIView *middleView = [BaseViewFactory viewWithFrame:CGRectMake(0, 102, ScreenWidth, 100) color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:middleView];
    NSArray *imagenameArr = @[@"Ass-recharge",@"Ass-withdraw"];
    NSArray *titleArr = @[@"充值",@"提现"];

    for (int i = 0; i<2; i++) {
        UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imagenameArr[i]]];
        imageView.frame = CGRectMake(16, 12.5 +50*i, 25, 25);
        [middleView addSubview:imageView];
        [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:middleView Frame:CGRectMake(51, 50*i, 100, 50) Alignment:NSTextAlignmentLeft Text:titleArr[i]];
        [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49+50*i, ScreenWidth, 1) Super:middleView];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 50*i, ScreenWidth, 50);
        [middleView addSubview:btn];
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }

    
    UIView *downView = [BaseViewFactory viewWithFrame:CGRectMake(0, 222, ScreenWidth, 50) color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:downView];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:downView];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 0, ScreenWidth, 1) Super:downView];
    UIImageView *imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"Ass-bankcm"]];
    imageView.frame = CGRectMake(16, 16, 24, 18);
    [downView addSubview:imageView];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:downView Frame:CGRectMake(51, 0, 100, 50) Alignment:NSTextAlignmentLeft Text:@"银行卡管理"];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, ScreenWidth, 50);
    [downView addSubview:btn];
    btn.tag = 1002;
    [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];

    
}



#pragma mark === createNavagationItem
- (void)createNavagationItem
{
    UIButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"明细" forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoDetailViewController) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = choiceCityBtn;
}



#pragma mark === 按钮点击方法
/**
 查看明细
 */
- (void)gotoDetailViewController{

    AssetDetailsViewController *assDeVc = [[AssetDetailsViewController alloc]init];
    [self.navigationController pushViewController:assDeVc animated:YES];

}

/**
 余额规则说明
 */
- (void)rightBtnClick{

    [self showTextHud:@"即将上线"];


}

- (void)btnClick:(UIButton *)btn{

    switch (btn.tag - 1000) {
        case 0:
            [self showTextHud:@"即将上线"];

            break;
        case 1:{
            if ([_balanceLab.text floatValue]<=0.00) {
                [self showTextHud:@"您的账户没有余额"];
                return;
            }
            WithdrawalsViewController *wVc = [[WithdrawalsViewController alloc]init];
            wVc.money =  _balanceLab.text;
            [self.navigationController pushViewController:wVc animated:YES];
            break;
        }
        case 2:{
            BankCardMViewController *bcmVc = [[BankCardMViewController alloc]init];
            [self.navigationController pushViewController:bcmVc animated:YES];
            break;
        }
        default:
            break;
    }
}

#pragma mark === 加载余额
- (void)loadbalance{

[BankCardPL userGetbalanceWithReturnBlock:^(id returnValue) {
    _balanceLab.text = [NSString stringWithFormat:@"%@",returnValue[@"balance"]];
} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];
}];


}





@end
