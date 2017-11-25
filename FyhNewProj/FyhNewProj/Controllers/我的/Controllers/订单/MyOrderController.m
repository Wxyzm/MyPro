//
//  MyOrderController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyOrderController.h"
#import "OrderFootView.h"
#import "MyOrderCell.h"
#import "MJRefresh.h"
#import "OrderPL.h"

#import "UserOrder.h"
#import "OrderItems.h"
#import "OrderSellerItems.h"
#import "OrderOtherModel.h"
#import "OrderOtherItemModel.h"

#import "UserOrderTopCell.h"
#import "UserOrderOneCell.h"
#import "UserOrdermanyCell.h"
#import "UserOrderBoomCell.h"
#import "PayWayView.h"
#import "PayPL.h"

#import "MyOrderDetailViewController.h"

#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"
#import "MBProgressHUD+Add.h"


#import "AppDelegate.h"
#import "MenueView.h"
#import "ChatListViewController.h"
#import "DOTabBarController.h"
#import "BusinessesShopViewController.h"
#import "ViewLogisticsControllerViewController.h"
#import "GoodsDetailViewController.h"
////加载的方式
//typedef NS_ENUM(NSInteger, BtnOnTypes) {
//    BTN_ALL              = 1,   //全部
//    BTN_UNPAID           = 2,   //未付款
//    BTN_UNSENT           = 3,   //待发货
//    BTN_UNACCEPT         = 4,   //待收货
//    BTN_UNEVA            = 5    //待评价
//};
//加载的方式
typedef NS_ENUM(NSInteger, LoadWayTypes) {
    START_LOAD_FIRST1         = 1,
    RELOAD_DADTAS1            = 2,
    LOAD_MORE_DATAS1          = 3,
    START_LOAD_FIRST2         = 4,
    RELOAD_DADTAS2            = 5,
    LOAD_MORE_DATAS2          = 6,
    START_LOAD_FIRST3         = 7,
    RELOAD_DADTAS3            = 8,
    LOAD_MORE_DATAS3          = 9,
    START_LOAD_FIRST4         = 10,
    RELOAD_DADTAS4            = 11,
    LOAD_MORE_DATAS4          = 12,
    START_LOAD_FIRST5         = 13,
    RELOAD_DADTAS5            = 14,
    LOAD_MORE_DATAS5          = 15
};

@interface MyOrderController ()<MenueViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,PayWayViewDelegate,UserOrderBoomCellDelegate,UserOrderOneCellDelegate,UserOrdermanyCelllDelegate,UserOrderTopCellDelegate>

@property (nonatomic , strong) PayWayView *payWayView;


@property (nonatomic , strong) UIScrollView *bgScrollView;

@property (nonatomic,strong)UITableView *AllOrderTabView;           //全部

@property (nonatomic,strong)UITableView *WaitPayOrderTabView;       //待付款

@property (nonatomic,strong)UITableView *WaitDeliverTabView;        //待发货

@property (nonatomic,strong)UITableView *WaitReciptTabView;         //待收货

@property (nonatomic,strong)UITableView *WaitEvaluateTabView;       //待评价


@property (nonatomic, assign) LoadWayTypes      loadWay;    //加载的方式

@property (nonatomic, strong) NSMutableArray    *loadArray;

@property (nonatomic , strong) MenueView *menuView;

@property (nonatomic , strong) UIView *shopView;

@end

@implementation MyOrderController{

    NSMutableArray *_btnArr;
    NSInteger   _pageNum1;
    NSInteger   _pageNum2;
    NSInteger   _pageNum3;
    NSInteger   _pageNum4;
    NSInteger   _pageNum5;
    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;
    NSMutableArray *_dataArr3;
    NSMutableArray *_dataArr4;
    NSMutableArray *_dataArr5;
    NSString *_userOrderID;
    
}

#pragma  mark =======  view

- (UIView *)shopView{
    if (!_shopView) {
        _shopView = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth/2-75, 185, 150, 160)];
        [_bgScrollView addSubview:_shopView];
      
        UIImageView *nullView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"order_null"]];
        [_shopView addSubview:nullView];
        nullView.sd_layout.centerXEqualToView(_shopView).topSpaceToView(_shopView, 2).widthIs(62).heightIs(67);
        UILabel *lab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"你还没有相关订单"];
        [_shopView addSubview:lab];
        lab.sd_layout.centerXEqualToView(_shopView).topSpaceToView(nullView,16).widthIs(150 ).heightIs(15);
        
        SubBtn *goBtn = [SubBtn buttonWithtitle:@"去逛逛" titlecolor:[UIColor clearColor] cornerRadius:5 andtarget:self action:@selector(goBtnClick) andframe:CGRectZero];
        [_shopView addSubview:goBtn];
        goBtn.sd_layout.centerXEqualToView(_shopView).topSpaceToView(lab,20).widthIs(150 ).heightIs(39);
        goBtn.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
        goBtn.layer.borderWidth = 1;
        goBtn.titleLabel.font = APPFONT(15);
        [goBtn setTitleColor:UIColorFromRGB(0xaab2bd) forState:UIControlStateNormal];
        _shopView.hidden = YES;
        
        
        
    }
    
    return _shopView;
}

-(PayWayView *)payWayView{
    if (!_payWayView) {
        _payWayView = [[PayWayView alloc]init];
        _payWayView.delegate  = self;
    }
    return _payWayView;
}

-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth,ScreenHeight-64-39)];
        _bgScrollView.backgroundColor = UIColorFromRGB(LineColorValue);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
        _bgScrollView.contentSize = CGSizeMake(ScreenWidth *5, 10);
        _bgScrollView.scrollEnabled = NO;
        [self.view addSubview:_bgScrollView];

    }
    return _bgScrollView;
}
-(MenueView *)menuView{
    if (!_menuView) {
        _menuView = [[MenueView alloc]init];
        _menuView.delegate = self;
    }
    
    return _menuView;
    
}
-(UITableView *)AllOrderTabView{

    if (!_AllOrderTabView) {
        _AllOrderTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _AllOrderTabView.delegate = self;
        _AllOrderTabView.dataSource = self;
        _AllOrderTabView.backgroundColor = UIColorFromRGB(LineColorValue);
        _AllOrderTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _AllOrderTabView.delaysContentTouches = NO;
        
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _AllOrderTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _AllOrderTabView.mj_footer = footer;
        _AllOrderTabView.mj_footer.hidden = YES;

    }
    return _AllOrderTabView;

}

-(UITableView *)WaitPayOrderTabView{
    
    if (!_WaitPayOrderTabView) {
        _WaitPayOrderTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _WaitPayOrderTabView.delegate = self;
        _WaitPayOrderTabView.dataSource = self;
        _WaitPayOrderTabView.backgroundColor = UIColorFromRGB(LineColorValue);
        _WaitPayOrderTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _WaitPayOrderTabView.delaysContentTouches = NO;

        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _WaitPayOrderTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _WaitPayOrderTabView.mj_footer = footer;
        _WaitPayOrderTabView.mj_footer.hidden = YES;

    }
    return _WaitPayOrderTabView;
    
}


-(UITableView *)WaitDeliverTabView{
    
    if (!_WaitDeliverTabView) {
        _WaitDeliverTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _WaitDeliverTabView.delegate = self;
        _WaitDeliverTabView.dataSource = self;
        _WaitDeliverTabView.backgroundColor = UIColorFromRGB(LineColorValue);
        _WaitDeliverTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _WaitDeliverTabView.delaysContentTouches = NO;

        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _WaitDeliverTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _WaitDeliverTabView.mj_footer = footer;
        _WaitDeliverTabView.mj_footer.hidden = YES;

    }
    return _WaitDeliverTabView;
    
}
-(UITableView *)WaitReciptTabView{
    
    if (!_WaitReciptTabView) {
        _WaitReciptTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _WaitReciptTabView.delegate = self;
        _WaitReciptTabView.dataSource = self;
        _WaitReciptTabView.backgroundColor = UIColorFromRGB(LineColorValue);
        _WaitReciptTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _WaitReciptTabView.delaysContentTouches = NO;

        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _WaitReciptTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _WaitReciptTabView.mj_footer = footer;
        _WaitReciptTabView.mj_footer.hidden = YES;

    }
    return _WaitReciptTabView;
    
}
-(UITableView *)WaitEvaluateTabView{
    
    if (!_WaitEvaluateTabView) {
        _WaitEvaluateTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*4, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _WaitEvaluateTabView.delegate = self;
        _WaitEvaluateTabView.dataSource = self;
        _WaitEvaluateTabView.backgroundColor = UIColorFromRGB(LineColorValue);
        _WaitEvaluateTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _WaitEvaluateTabView.delaysContentTouches = NO;

        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _WaitEvaluateTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _WaitEvaluateTabView.mj_footer = footer;
        _WaitEvaluateTabView.mj_footer.hidden = YES;

    }
    return _WaitEvaluateTabView;
    
}

#pragma  mark ======= viewdidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.navigationItem.title = @"我的订单";
    [self initData];
    [self creatrRightBtnItem];
    [self initUI];
    
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *(_btnType-1), 0) animated:NO];
    self.shopView.frame = CGRectMake(ScreenWidth/2-75+ScreenWidth*(_btnType-1), 185, 150, 160);
    self.shopView.hidden = YES;
    for (YLButton *btn in _btnArr) {
        btn.on = NO;
        if (btn.tag - 1000 == _btnType-1) {
            btn.on = YES;
        }
        if (btn.on) {
            [btn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        }
        
    }

    [self reLoadData];

    //支付结果通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ailPayComPleted:)
                                                 name:@"ailPayComPleted"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weixinPayComPleted:)
                                                 name:@"weixinPayComPleted"  object:nil];
}



- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self reLoadData];
}

-(void)respondToLeftButtonClickEvent{

   
    if (_backType) {
        for (UIViewController *controller in self.navigationController.viewControllers) {
            if ([controller isKindOfClass:[GoodsDetailViewController class]]) {
                [self.navigationController popToViewController:controller animated:YES];
            }
        }
    }else{
        [self.navigationController  popToRootViewControllerAnimated:YES];
        
    }
   
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


- (void)initUI{
    NSArray *arr = @[@"全部",@"待付款",@"待发货",@"待收货",@"待评价"];
    for (int i = 0; i<5; i++) {
        YLButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = APPFONT(15);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(orderBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(ScreenWidth/5*i, 0, ScreenWidth/5, 39);
        btn.backgroundColor = UIColorFromRGB(WhiteColorValue);
        if (i == 0) {
            btn.on = YES;
             [btn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
        }else{
            btn.on = NO;
            [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        }
        [_btnArr addObject:btn];
    }
//    self.btnType = BTN_ALL;
    [self.bgScrollView addSubview:self.AllOrderTabView];
    [self.bgScrollView addSubview:self.WaitPayOrderTabView];
    [self.bgScrollView addSubview:self.WaitDeliverTabView];
    [self.bgScrollView addSubview:self.WaitReciptTabView];
//    [self.bgScrollView addSubview:self.WaitEvaluateTabView];

    
}


- (void)rightbuttonClickEvent{
    self.menuView.OriginY = 60;
    [self.menuView show];
}

/**
 去逛逛
 */
- (void)goBtnClick{
    
    [self.navigationController popToRootViewControllerAnimated:NO];
    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.mainController.selectedIndex = 0;
    
    
}


- (void)initData{
    _btnArr = [[NSMutableArray alloc]initWithCapacity:0];
    self.loadArray = [[NSMutableArray alloc]initWithCapacity:0];
    _pageNum1 = 1;
    _pageNum2 = 1;
    _pageNum3 = 1;
    _pageNum4 = 1;
    _pageNum5 = 1;
    _dataArr5 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr1 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr2 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr3 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr4 = [[NSMutableArray alloc]initWithCapacity:0];


}

 
/**
 订单类型

 @param button 订单类型btn
 */
- (void)orderBtnclick:(YLButton*)button
{
    for (YLButton *btn in _btnArr) {
        btn.on = NO;
    }
    button.on = YES;
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            [btn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        }
    }
    self.shopView.frame = CGRectMake(ScreenWidth/2-75+ScreenWidth*(button.tag-1000), 185, 150, 160);
    self.shopView.hidden = YES;
    
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *(button.tag - 1000), 0) animated:NO];
    switch (button.tag) {
        case 1000:{
            self.btnType = BTN_ALL;
            
                self.loadWay = START_LOAD_FIRST1;
            
                [self reLoadData];
                
            

            break;
        }
        case 1001:{
            self.btnType = BTN_UNPAID;
            
                self.loadWay = START_LOAD_FIRST2;
                [self reLoadData];
                
            
            break;
        }
        case 1002:{
            self.btnType = BTN_UNSENT;
            
                self.loadWay = START_LOAD_FIRST3;
                [self reLoadData];
                
            
            break;
        }
        case 1003:{
            self.btnType = BTN_UNACCEPT;
            
                self.loadWay = START_LOAD_FIRST4;
                [self reLoadData];
                
            
            break;
        }
        case 1004:{
            self.btnType = BTN_UNEVA;
            
                self.loadWay = START_LOAD_FIRST5;
                [self reLoadData];
                
            
            break;
        }
        default:
            break;
    }
    

}
#pragma  mark ======= 获取数据

- (void)loadOrderList{

    NSDictionary *infoDic;
    if (self.btnType == BTN_ALL) {
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum1],
                    @"title":@"",
                    @"status":@""};
        
    }else if (self.btnType == BTN_UNPAID){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum2],
                    @"title":@"",
                    @"status":@"0"};

        
    }else if (self.btnType == BTN_UNSENT){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum3],
                    @"title":@"",
                    @"status":@"1"};

        
    }else if (self.btnType == BTN_UNACCEPT){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum4],
                    @"title":@"",
                    @"status":@"2"};

        
    }else if (self.btnType == BTN_UNEVA){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum5],
                    @"title":@"",
                    @"status":@""};
        //暂时未开通
        [self showTextHud:@"暂未开放"];

    }
    [self loadOrderListWithDic:infoDic];
}

- (void)loadOrderListWithDic:(NSDictionary *)dic{

//    [MBProgressHUD showMessag:nil toView:[UIApplication sharedApplication].keyWindow];
    
    if (self.btnType == BTN_ALL||self.btnType == BTN_UNPAID){
    [OrderPL BuyersGetUserOrderWithinfoDic:dic ReturnBlock:^(id returnValue) {
        self.loadArray = [UserOrder mj_objectArrayWithKeyValuesArray:returnValue[@"userOrdersData"]];
        NSLog(@"%@",_loadArray);
        [self loadSuccess];
        [self endLoading];
    } andErrorBlock:^(NSString *msg) {
//        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];

        [self showTextHud:msg];
        [self endLoading];
    }];
    
    }else{
        
[OrderPL BuyersGetgroupitemordersWithinfoDic:dic ReturnBlock:^(id returnValue) {
    self.loadArray = [OrderOtherModel mj_objectArrayWithKeyValuesArray:returnValue[@"buyerGroupItemOrdersData"]];
    NSLog(@"%@",_loadArray);
    [self loadSuccess];
    [self endLoading];
} andErrorBlock:^(NSString *msg) {
//    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];

    [self showTextHud:msg];
    [self endLoading];

}];
    }



}
#pragma mark ======= 下拉刷新，上啦加载设置

- (void)loadSuccess{
//    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
    if (self.btnType == BTN_ALL) {
        //全部
        
        if (self.loadArray.count > 0 )
        {
            if (self.loadWay != LOAD_MORE_DATAS1)
            {
                _pageNum1 = 1;
            }
            _pageNum1 ++;
        }

        if (self.loadWay == START_LOAD_FIRST1 || self.loadWay == RELOAD_DADTAS1) {
            [_dataArr1  removeAllObjects];
        }
        
        [_dataArr1 addObjectsFromArray:self.loadArray];
        if (_dataArr1.count <=0) {
            self.shopView.hidden = NO;
        }else{
            self.shopView.hidden = YES;

        }
        [_AllOrderTabView reloadData];
        if (self.loadArray.count < 30) {
            _AllOrderTabView.mj_footer.hidden = YES;
          //  [self showTextHud:@"已经加载全部数据"];

        } else {
            _AllOrderTabView.mj_footer.hidden = NO;
        }

    }else if (self.btnType == BTN_UNPAID){
        //待付款
        if (self.loadArray.count > 0 )
        {
            if (self.loadWay != LOAD_MORE_DATAS2)
            {
                _pageNum2 = 1;
            }
            _pageNum2 ++;
        }

        
        if (self.loadWay == START_LOAD_FIRST2 || self.loadWay == RELOAD_DADTAS2) {
            [_dataArr2  removeAllObjects];
        }
        
        [_dataArr2 addObjectsFromArray:self.loadArray];
        [_WaitPayOrderTabView reloadData];
        if (_dataArr2.count <=0) {
            self.shopView.hidden = NO;
        }else{
            self.shopView.hidden = YES;
            
        }
        if (self.loadArray.count < 30) {
            _WaitPayOrderTabView.mj_footer.hidden = YES;
         //   [self showTextHud:@"已经加载全部数据"];

        } else {
            _WaitPayOrderTabView.mj_footer.hidden = NO;
        }

        
    }else if (self.btnType == BTN_UNSENT){
        //待发货
        if (self.loadArray.count > 0 )
        {
            if (self.loadWay != LOAD_MORE_DATAS3)
            {
                _pageNum3 = 1;
            }
            _pageNum3 ++;
        }

        
        if (self.loadWay == START_LOAD_FIRST3 || self.loadWay == RELOAD_DADTAS3) {
            [_dataArr3  removeAllObjects];
        }
        
        [_dataArr3 addObjectsFromArray:self.loadArray];
        
        if (_dataArr3.count <=0) {
            self.shopView.hidden = NO;
        }else{
            self.shopView.hidden = YES;
            
        }
        [_WaitDeliverTabView reloadData];
        if (self.loadArray.count < 30) {
            _WaitDeliverTabView.mj_footer.hidden = YES;
       //     [self showTextHud:@"已经加载全部数据"];

        } else {
            _WaitDeliverTabView.mj_footer.hidden = NO;
        }
        

        
    }else if (self.btnType == BTN_UNACCEPT){
        //待收货
        
        if (self.loadArray.count > 0 )
        {
            if (self.loadWay != LOAD_MORE_DATAS4)
            {
                _pageNum4 = 1;
            }
            _pageNum4 ++;
        }

        if (self.loadWay == START_LOAD_FIRST4 || self.loadWay == RELOAD_DADTAS4) {
            [_dataArr4  removeAllObjects];
        }
        
        [_dataArr4 addObjectsFromArray:self.loadArray];
        [_WaitReciptTabView reloadData];
        if (_dataArr4.count <=0) {
            self.shopView.hidden = NO;
        }else{
            self.shopView.hidden = YES;
            
        }
        if (self.loadArray.count < 30) {
            _WaitReciptTabView.mj_footer.hidden = YES;
        } else {
            _WaitReciptTabView.mj_footer.hidden = NO;
        }

        
    }else if (self.btnType == BTN_UNEVA){
        if (_dataArr5.count <=0) {
            self.shopView.hidden = NO;
        }else{
            self.shopView.hidden = YES;
            
        }
        //暂时未开通
        [self showTextHud:@"暂未开放"];
    }
}

- (void)reLoadData
{
    if (self.btnType == BTN_ALL) {
        //全部
        _pageNum1 = 1;
        self.loadWay = RELOAD_DADTAS1;
        [self loadOrderList];
    }else if (self.btnType == BTN_UNPAID){
         //待付款
        _pageNum2 = 1;
        self.loadWay = RELOAD_DADTAS2;
        [self loadOrderList];
    }else if (self.btnType == BTN_UNSENT){
        //待发货
        _pageNum3 = 1;
        self.loadWay = RELOAD_DADTAS3;
        [self loadOrderList];
    }else if (self.btnType == BTN_UNACCEPT){
       //待收货
        _pageNum4 = 1;
        self.loadWay = RELOAD_DADTAS4;
        [self loadOrderList];
    }else if (self.btnType == BTN_UNEVA){
        //暂时未开通
        if (_dataArr5.count <=0) {
            self.shopView.hidden = NO;
        }else{
            self.shopView.hidden = YES;
            
        }
        //暂时未开通
        [self showTextHud:@"暂未开放"];
    }
    
}

- (void)loadMoreData
{
    if (self.btnType == BTN_ALL) {
        //全部
        self.loadWay = LOAD_MORE_DATAS1;
        [self loadOrderList];
    }else if (self.btnType == BTN_UNPAID){
        //待付款
        self.loadWay = LOAD_MORE_DATAS2;
        [self loadOrderList];
    }else if (self.btnType == BTN_UNSENT){
        //待发货
        self.loadWay = LOAD_MORE_DATAS3;
        [self loadOrderList];
    }else if (self.btnType == BTN_UNACCEPT){
        //待收货
        self.loadWay = LOAD_MORE_DATAS4;
        [self loadOrderList];
    }else if (self.btnType == BTN_UNEVA){
        //暂时未开通
        
    }
    
    
}


- (void)endLoading{
    [_AllOrderTabView.mj_footer endRefreshing];
    [_AllOrderTabView.mj_header endRefreshing];
    
    [_WaitPayOrderTabView.mj_footer endRefreshing];
    [_WaitPayOrderTabView.mj_header endRefreshing];
    
    [_WaitDeliverTabView.mj_footer endRefreshing];
    [_WaitDeliverTabView.mj_header endRefreshing];
    
    [_WaitReciptTabView.mj_footer endRefreshing];
    [_WaitReciptTabView.mj_header endRefreshing];
    
    [_WaitEvaluateTabView.mj_footer endRefreshing];
    [_WaitEvaluateTabView.mj_header endRefreshing];
}



#pragma  mark ======= tableViewdelegate and datasource

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    if (tableView == _AllOrderTabView) {
        return _dataArr1.count;
        
    }else if (tableView == _WaitPayOrderTabView){
        return _dataArr2.count;

    }else if (tableView == _WaitDeliverTabView){
        return _dataArr3.count;

    }else if (tableView == _WaitReciptTabView){
        return _dataArr4.count;

    }else{
        return _dataArr5.count;

    }


}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0.000001;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    
    if (tableView == _AllOrderTabView) {
        
        UserOrder *order = _dataArr1[section];

        if (order.sellerItemOrders.count>1) {
            //多店铺
            
            OrderSellerItems * Items = order.sellerItemOrders[0];
            OrderItems  *itemModel = Items.itemOrders[0];
            if ([itemModel.status intValue]==0||[itemModel.status intValue]==4) {
                //0未支付 3交易关闭  只显示一排商品
                return 3;
                
            }else{
                //每个店铺显示一排商品
                return order.sellerItemOrders.count+1;
                
                
            }
        }else{
            //单店铺 只显示一排商品

            return 3;
        }

    }else if (tableView == _WaitPayOrderTabView){
        UserOrder *order = _dataArr2[section];
        
        if (order.sellerItemOrders.count>1) {
            //多店铺
            
            OrderSellerItems * Items = order.sellerItemOrders[0];
            OrderItems  *itemModel = Items.itemOrders[0];
            if ([itemModel.status intValue]==0||[itemModel.status intValue]==4) {
                //0未支付 3交易关闭  只显示一排商品
                return 3;
                
            }else{
                //每个店铺显示一排商品
                return order.sellerItemOrders.count+1;
                
                
            }
        }else{
            //单店铺 只显示一排商品
            
            return 3;
        }
        
    }else if (tableView == _WaitDeliverTabView){
        OrderOtherModel *model = _dataArr3[section];
        
        return model.itemOrders.count +2;
        
    }else if (tableView == _WaitReciptTabView){
        OrderOtherModel *model = _dataArr4[section];
        
        return model.itemOrders.count +2;
    }else{
        return 0;
        
    }

    return 2+2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == _AllOrderTabView||tableView == _WaitPayOrderTabView) {//11
        UserOrder *order;
        if (tableView == _AllOrderTabView) {
            order = _dataArr1[indexPath.section];

        }else{
            order = _dataArr2[indexPath.section];

        }

        if (indexPath.row ==0) {
            return 52;
            
        }else{//22
            if (order.sellerItemOrders.count>1) {
                
            //多店铺
                
                OrderSellerItems * Items = order.sellerItemOrders[0];
                OrderItems  *itemModel = Items.itemOrders[0];
                if ([itemModel.status intValue]==0||[itemModel.status intValue]==4){
                     //0未支付 3交易关闭  只显示一排商品
                    if (indexPath.row == 2){
                    
                        return 80;
                    }else{
                    
                        return 100;
                    }
                
                
                }else{
                    //每个店铺显示一排商品
                    
                    if (indexPath.row == order.sellerItemOrders.count+1) {
                        //底部
                        return 80;
                    }else{
                        return 180;
                        }
                    }
                    
                    
            }else{
                if (indexPath.row == 2) {
                    return 80;
                }else{
                    return 100;
                }
            
            }
            
            }//22
        
    }//11
    else if (tableView == _WaitDeliverTabView||tableView == _WaitReciptTabView){
        OrderOtherModel *model;
        if (tableView == _WaitDeliverTabView) {
            model  = _dataArr3[indexPath.section];
        }else{
            model  = _dataArr4[indexPath.section];

        }

        if (indexPath.row == 0) {
            return 52;
        }else if (indexPath.row == model.itemOrders.count+1){
            return 80;
        }else{
        
            return 100;
        }
    
    
    
    }
    
    return 100;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    if (tableView == _AllOrderTabView||tableView == _WaitPayOrderTabView) {
        UserOrder *order ;
        if (tableView == _AllOrderTabView) {
            order = _dataArr1[indexPath.section];
            
        }else{
            order = _dataArr2[indexPath.section];
            
        }

        if (indexPath.row == 0) {
            static NSString *cellid = @"topcellid";
            UserOrderTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UserOrderTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.model = order;
            if (order.sellerItemOrders.count >1) {
                cell.nameLab.text = @"丰云汇";
            }
            cell.delegate = self;
            return cell;
            
        }else{//2_1
                if (order.sellerItemOrders.count>1) {
                        //多店铺
                        OrderSellerItems * Items = order.sellerItemOrders[0];
                        OrderItems  *itemModel = Items.itemOrders[0];
                        if ([itemModel.status intValue]==0||[itemModel.status intValue]==4) {
                            //0未支付 3交易关闭  只显示一排商品
                            if (indexPath.row == 2) {
                                //底部
                                static NSString *cellid = @"Booyfmclliiiii";
                                UserOrderBoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                                if (!cell) {
                                    cell = [[UserOrderBoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                                }
                                cell.model = order;
                                cell.delegate = self;
                                return cell;
                            }
                            
                            static NSString *cellid = @"ordermorecell";
                            UserOrdermanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                            if (!cell) {
                                cell = [[UserOrdermanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                            }
                            cell.dataArr = order.sellerItemOrders;
                            cell.model = order;

                            cell.delegate = self;
                            [cell hiddenboomView];
                            
                            return cell;
                        }else{
                            
                            
                                OrderSellerItems * theItems = order.sellerItemOrders[indexPath.row -1];

                                if (theItems.itemOrders.count >1) {
                                    //多个商品   //显示图片cell
                                    static NSString *cellid = @"ordermorecellaa";
                                    UserOrdermanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                                    if (!cell) {
                                        cell = [[UserOrdermanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                                    }
                                    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
                                    [arr addObject:theItems];
                                    cell.dataArr = arr;
                                    [cell showboomView];
                                    cell.model = order;

                                    cell.delegate = self;

                                    return cell;
                                    
                                }else{
                                    //只有一个商品   显示图文cell
                                    static NSString *cellid = @"orderoncecellbb";
                                    UserOrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                                    if (!cell) {
                                        cell = [[UserOrderOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                                    }
                                    [cell showboomView];
                                    cell.onBtn.hidden = YES;
                                    cell.delegate = self;
                                    OrderItems *othModel = theItems.itemOrders[0];
                                    othModel.logisticsAmount = theItems.logisticsAmount;
                                    cell.ItemsModel = othModel;
                                    return cell;
                                    
                                }
                            //}
                            
                            
                        }
                    }else{//2_2
                        //单店铺
                        
                        if (indexPath.row == 2){
                            static NSString *cellid = @"Boomcllcc";
                            UserOrderBoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                            if (!cell) {
                                cell = [[UserOrderBoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                            }
                            cell.model = order;
                            cell.delegate = self;

                            return cell;

                        }
                        OrderSellerItems *model = order.sellerItemOrders[0];
                        if (model.itemOrders.count>1) {
                            static NSString *cellid = @"ordermorecelldd";
                            UserOrdermanyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                            if (!cell) {
                                cell = [[UserOrdermanyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                            }
                            cell.dataArr = order.sellerItemOrders;
                            cell.model = order;
                            [cell hiddenboomView];
                            cell.delegate = self;
                            return cell;
            
                        }else{
                            static NSString *cellid = @"orderoncecellee";
                            UserOrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
                            if (!cell) {
                                cell = [[UserOrderOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
                            }
                            OrderItems *othModel = model.itemOrders[0];
                            othModel.logisticsAmount = model.logisticsAmount;
                            cell.ItemsModel = othModel;
                            
//                            cell.ItemsModel = model.itemOrders[0];
                            [cell hiddenboomView];
                            cell.onBtn.hidden = YES;

                            cell.delegate = self;
                            return cell;
                        }
                    }//2_2
                
                }//2_1

    }else if (tableView == _WaitDeliverTabView){
    
        OrderOtherModel *model = _dataArr3[indexPath.section];
        
        if (indexPath.row == 0) {
            static NSString *cellid = @"topcellidff";
            UserOrderTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UserOrderTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.oterModel = model;
            cell.RightLab.text = @"买家已付款";
            cell.delegate = self;
            return cell;
 
        }else if (indexPath.row == model.itemOrders.count+1){
            static NSString *cellid = @"Boomcllgg";
            UserOrderBoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UserOrderBoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.otherModel = model;
            cell.delegate = self;
            cell.payBtn.hidden = YES;
            cell.cancleBtn.hidden = YES;

            return cell;
        }else{
            static NSString *cellid = @"orderoncecellhh";
            UserOrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UserOrderOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
//            cell.ItemsModel = model.itemOrders[0];
            cell.otherModel = model.itemOrders[indexPath.row - 1];
            cell.onBtn.hidden = YES;

            [cell hiddenboomView];
            cell.delegate = self;
            return cell;
            
        }
    }else if (tableView == _WaitReciptTabView){
        
        OrderOtherModel *model = _dataArr4[indexPath.section];
        
        if (indexPath.row == 0) {
            static NSString *cellid = @"topcellidjj";
            UserOrderTopCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UserOrderTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.oterModel = model;
            cell.RightLab.text = @"买家已发货";
            cell.delegate = self;
            return cell;
            
        }else if (indexPath.row == model.itemOrders.count+1){
            static NSString *cellid = @"Boomcllkk";
            UserOrderBoomCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UserOrderBoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.otherModel = model;
            cell.delegate = self;
            cell.payBtn.hidden = NO;
            cell.cancleBtn.hidden = NO;
            
            return cell;
            
        }else{
            static NSString *cellid = @"orderoncecellll";
            UserOrderOneCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
            if (!cell) {
                cell = [[UserOrderOneCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            }
            cell.onBtn.hidden = YES;
            cell.otherModel = model.itemOrders[indexPath.row - 1];
            [cell hiddenboomView];
            cell.delegate = self;
            return cell;
            
        }
    }

    
    
    
    static NSString *cellid = @"ssssss";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.backgroundColor = [UIColor clearColor];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _AllOrderTabView||tableView == _WaitPayOrderTabView) {
        UserOrder *order ;
        if (tableView == _AllOrderTabView) {
            order = _dataArr1[indexPath.section];
        }else{
            order = _dataArr2[indexPath.section];
        }
        UserOrder  *nextOrder = [order mutableCopy];
        
        if (indexPath.row == 0) {
       //顶部无点击处理
        }else{//2_1
            
            if (order.sellerItemOrders.count>1) {
                //多店铺
                OrderSellerItems * Items = order.sellerItemOrders[0];
                OrderItems  *itemModel = Items.itemOrders[0];
                if ([itemModel.status intValue]==0||[itemModel.status intValue]==4) {
                    //0未支付 3交易关闭  只显示一排商品
                    if (indexPath.row == 2) {
                        //底部
                    }
                 //   NSMutableArray *arr =  order.sellerItemOrders;  //需要传整个order
                    NSLog(@"%@",nextOrder);
                    
                }else{
                    //多店铺 多行显示
                    OrderSellerItems * theItems = order.sellerItemOrders[indexPath.row -1];
                    [nextOrder.sellerItemOrders removeAllObjects];
                    [nextOrder.sellerItemOrders addObject:theItems];
                    NSLog(@"%@",nextOrder);

                }
            }else{//2_2
                //单店铺
                
                NSLog(@"%@",nextOrder);
            }//2_2
            
        }//2_1
        
        MyOrderDetailViewController *deVc = [[MyOrderDetailViewController  alloc]init];
        deVc.type = 0;
        deVc.order = nextOrder;
        [self.navigationController pushViewController:deVc animated:YES];
        
        
    }else{
        
        OrderOtherModel *model;
        if (tableView == _WaitDeliverTabView){
           model  = _dataArr3[indexPath.section];

        
        
        }else if (tableView == _WaitReciptTabView){
            model = _dataArr4[indexPath.section];

        }else if (tableView == _WaitEvaluateTabView){
            [self showTextHud:@"暂未开放"];
            return;
        }
        NSLog(@"%@",model);
        MyOrderDetailViewController *deVc = [[MyOrderDetailViewController  alloc]init];
        deVc.type = 1;
        deVc.otherModel = model;
        [self.navigationController pushViewController:deVc animated:YES];
        }
        
}

#pragma mark ======== cellDelegate

-(void)didselectedBoomCellPayBtnWithType:(NSInteger)type andModel:(UserOrder *)model{
    
    _userOrderID = model.orderId;
    switch (type) {
        case 0:{
            //未付款    付款
            [self.payWayView showinView:self.view];

            break;
        }
        case 1:{
            //已支付，待发货
           
            break;
        }
        case 2:{
            //卖家已发货     确认收货
            [self makeSureAcceptGoodsWithOrder:model.sellerItemOrders[0]];
            
            break;
        }
        case 3:{
            //交易成功，确认收货后            评价
            [self showTextHud:@"暂未开放"];
            break;
        }
        case 4:{
            //交易关闭              删除订单
            break;
        }
        default:
            break;
    }


}
-(void)didselectedBoomCellCancleBtnWithType:(NSInteger)type andModel:(UserOrder *)model{
    _userOrderID = model.orderId;

    switch (type) {
        case 0:{
            //未付款    取消订单
            [self cancleOrderWithId:model.orderId];
            break;
        }
        case 1:{
            //已支付，待发货
            
            break;
        }
        case 2:{
            //卖家已发货      查看物流
            OrderSellerItems *itemModel = model.sellerItemOrders[0];
            if (itemModel.itemOrders.count<=0) {
                return;
            }
            OrderItems *items = itemModel.itemOrders[0];
            if (!items.logistics) {
                return;
            }
            [self gotoLogistVcWithLogistNumber:items.logistics[@"logisticsNumber"]];

            break;
        }
        case 3:{
            //交易成功   ，确认收货后
            OrderSellerItems *itemModel = model.sellerItemOrders[0];
            if (itemModel.itemOrders.count<=0) {
                return;
            }
            OrderItems *items = itemModel.itemOrders[0];
            if (!items.logistics) {
                return;
            }
            [self gotoLogistVcWithLogistNumber:items.logistics[@"logisticsNumber"]];

            break;
        }
        case 4:{
            //交易关闭
              [self deleteOrderWithId:_userOrderID];
            break;
        }
        default:
            break;
    }
}



-(void)didselectedUserOrderOneCellPayBtnWithType:(NSInteger)type andModel:(OrderItems *)model{
    _userOrderID = model.userOrderId;

    switch (type) {
        case 0:{
            //未付款    付款  被BoomCell代替
          //  [self.payWayView showinView:self.view];
            
            break;
        }
        case 1:{
            //已支付，待发货
            
            break;
        }
        case 2:{
            //卖家已发货     确认收货
            OrderSellerItems *items = [[OrderSellerItems alloc]init];
            items.itemOrders = [NSMutableArray arrayWithCapacity:0];
            [items.itemOrders addObject:model];
            [self makeSureAcceptGoodsWithOrder:items];
            
            break;
        }
        case 3:{
            //交易成功，确认收货后            评价
            break;
        }
        case 4:{
            //交易关闭              删除订单
            [self deleteOrderWithId:_userOrderID];
            break;
        }
        default:
            break;
    }


}
-(void)didselectedUserOrderOneCellCancleBtnWithType:(NSInteger)type andModel:(OrderItems *)model{
    
    _userOrderID = model.userOrderId;

    switch (type) {
        case 0:{
            //未付款    取消订单
            [self cancleOrderWithId:model.userOrderId];
            break;
        }
        case 1:{
            //已支付，待发货
            
            break;
        }
        case 2:{
            //卖家已发货      查看物流
            [self gotoLogistVcWithLogistNumber:model.logistics[@"logisticsNumber"]];

            break;
        }
        case 3:{
            //交易成功   ，确认收货后          查看物流
            [self gotoLogistVcWithLogistNumber:model.logistics[@"logisticsNumber"]];

            break;
        }
        case 4:{
            //交易关闭
            [self deleteOrderWithId:_userOrderID];

            break;
        }
        default:
            break;
    }

}


-(void)didselectedUserOrdermanyCellPayBtnWithType:(NSInteger)type andArr:(NSMutableArray *)arr{

    switch (type) {
        case 0:{
            //未付款       被BoomCell代替
            
            break;
        }
        case 1:{
            //已支付，待发货
                        break;
        }
        case 2:{
            //卖家已发货     //确认收货
            OrderSellerItems *items = [[OrderSellerItems alloc]init];
            items.itemOrders = [NSMutableArray arrayWithCapacity:0];
            for (int i = 0; i<arr.count; i++) {
              
                [items.itemOrders addObject:arr[i]];

            }
                        [self makeSureAcceptGoodsWithOrder:items];

//            OrderSellerItems *item = arr[0];
//            [self makeSureAcceptGoodsWithOrder:item];
            break;
        }
        case 3:{
            //交易成功   ，确认收货后
                break;
        }
            
            
        case 4:{
            //交易关闭
          //  [self deleteOrderWithId:_userOrderID];

            break;
        }
        default:
            break;
    }

}

-(void)didselectedUserOrdermanyCellCancleBtnWithType:(NSInteger)type andArr:(NSMutableArray *)arr{
    if (arr.count <=0) {
        return;
    }
    switch (type) {
        case 0:{
            //未付款  取消订单
            OrderItems *ItemsModel = arr[0];
            [self cancleOrderWithId:ItemsModel.userOrderId];
            break;
        }
        case 1:{
            //已支付，待发货
            break;
        }
        case 2:{
            //卖家已发货     //查看物流
            OrderItems *ItemsModel = arr[0];
            [self gotoLogistVcWithLogistNumber:ItemsModel.logistics[@"logisticsNumber"]];
            
            break;
        }
        case 3:{
            //交易成功   ，确认收货后
            break;
        }
            
            
        case 4:{
            //交易关闭
            [self deleteOrderWithId:_userOrderID];

            break;
        }
        default:
            break;
    }


}


-(void)didselectedCollecTionViewWithArr:(NSMutableArray *)dataArr andModel:(UserOrder *)model{
    

    MyOrderDetailViewController *deVc = [[MyOrderDetailViewController  alloc]init];
    deVc.type = 0;
    deVc.order = model;
    [self.navigationController pushViewController:deVc animated:YES];


}

-(void)waitAcceptdidselectedUserOrderOneCellPayBtnWithModel:(OrderOtherModel *)model{

    NSMutableArray *itemIdArr = [NSMutableArray arrayWithCapacity:0];
    for (OrderOtherItemModel *item in model.itemOrders) {
        [itemIdArr addObject:item.theId];
    }
    NSDictionary *dic = @{@"itemOrderIds":[itemIdArr componentsJoinedByString:@","]};
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定已收到商品？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OrderPL BuyersmakeSureAcceptedGoodsWithinfoDic:dic ReturnBlock:^(id returnValue) {
            [self showTextHud:@"商品已确认收货"];
            [self performSelector:@selector(reLoadData) withObject:nil afterDelay:0.5];
            
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];

}

-(void)waitAcceptdidselectedUserOrderOneCellCancleBtnWithModel:(OrderOtherModel *)model{

    OrderOtherItemModel *themodel = model.itemOrders[0];
    if (!themodel.logistics) {
        return;
    }
    [self gotoLogistVcWithLogistNumber:themodel.logistics[@"logisticsNumber"]];
}


-(void)didselectedShopbtnWithId:(NSString *)shopId{

    if ([shopId intValue] == -1) {
        [self showTextHud:@"多店铺不能查看店铺首页"];
        return;
    }
    
    BusinessesShopViewController *buVc = [[BusinessesShopViewController alloc]init];
    buVc.shopId = shopId;
    [self.navigationController pushViewController:buVc animated:YES];


}

- (void)gotoLogistVcWithLogistNumber:(NSString *)number{
    ViewLogisticsControllerViewController *vc = [[ViewLogisticsControllerViewController alloc]init];
    vc.logistNumber = number;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark ======== payWayViewDelegate  微信、支付宝支付
/**
 获取订单号
 */
-(void)didSelectedSetUpBtn{
    
    if (self.payWayView.isAilPayWay) {
        //支付宝
        [self ailPayAtOncewithId:_userOrderID];
        
    }else{
        //微信
        [self weixinPayAtOncewithId:_userOrderID];
    }

    
}
/**
 支付宝支付
 */
- (void)ailPayAtOncewithId:(NSString *)orderid{
    [PayPL ailPayWithOrderId:orderid andReturnBlock:^(id returnValue) {
        NSString *orderStr = returnValue[@"orderStr"];
        [[AlipaySDK defaultService] payOrder:orderStr fromScheme:@"fyhapp" callback:^(NSDictionary *resultDic) {
            NSLog(@"%@",resultDic);
            NSLog(@"%@",resultDic);
            // [self.delegate finishedAlipayPaymentWithResult:resultDic];
        }];
        
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    
    
}
/**
 微信支付
 */
- (void)weixinPayAtOncewithId:(NSString *)orderid{
    [PayPL weixinPayWithOrderId:orderid andReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        PayReq *req =  [[PayReq alloc] init];
        req.partnerId = [returnValue objectForKey:@"partnerid"];
        req.prepayId = [returnValue objectForKey:@"prepayid"];
        req.nonceStr = [returnValue objectForKey:@"noncestr"];
        NSMutableString *stamp  = [returnValue objectForKey:@"timestamp"];
        req.timeStamp = stamp.intValue;
        req.package = [returnValue objectForKey:@"package"];
        req.sign = [returnValue objectForKey:@"sign"];
        [WXApi sendReq:req];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        
    }];
    
    
}
#pragma mark ======== 取消订单收货等

- (void)cancleOrderWithId:(NSString *)orderId{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否取消该订单？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OrderPL BuyersCancleOrderWithorderID:orderId ReturnBlock:^(id returnValue) {
            [self showTextHud:@"取消成功"];
            [self performSelector:@selector(reLoadData) withObject:nil afterDelay:0.5];
            
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];


}

-(void)makeSureAcceptGoodsWithOrder:(OrderSellerItems*)sellerItems{
    NSMutableArray *itemIdArr = [NSMutableArray arrayWithCapacity:0];
    for (OrderItems *item in sellerItems.itemOrders) {
        [itemIdArr addObject:item.theId];
    }
    NSDictionary *dic = @{@"itemOrderIds":[itemIdArr componentsJoinedByString:@","]};
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定已收到商品？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OrderPL BuyersmakeSureAcceptedGoodsWithinfoDic:dic ReturnBlock:^(id returnValue) {
            [self showTextHud:@"商品已确认收货"];
            [self performSelector:@selector(reLoadData) withObject:nil afterDelay:0.5];

        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];

    
    
    

}


#pragma mark ====== 支付完成
- (void)ailPayComPleted:(NSNotification *)noti{
    
    NSString *idStr = noti.object;
    NSLog(@"%@",idStr);
    if ([idStr intValue]==9000) {
        [self showTextHud:@"支付成功"];
        [self performSelector:@selector(reLoadData) withObject:nil afterDelay:1.5];
    }else{
        [self showTextHud:@"支付失败"];

    }
}

- (void)weixinPayComPleted:(NSNotification *)noti{
    
    NSString *idStr = noti.object;
    NSLog(@"%@",idStr);
    if ([idStr intValue]==9000) {
     //   [self showTextHud:@"支付成功"];
        [self performSelector:@selector(reLoadData) withObject:nil afterDelay:1.5];
    }else{
      //  [self showTextHud:@"支付失败"];
        
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

- (void)deleteOrderWithId:(NSString *)orderId{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除订单？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [OrderPL BuyersDeleteOrderWithorderID:orderId ReturnBlock:^(id returnValue) {
            [self showTextHud:@"删除成功"];
            [self reLoadData];
            
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}


@end
