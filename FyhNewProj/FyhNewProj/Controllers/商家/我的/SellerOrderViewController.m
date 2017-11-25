//
//  SellerOrderViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/15.
//  Copyright © 2017年 fyh. All rights reserved.
//  我就不明白了 春风十里怎么就他妈不如你了 春风十里 五十里 一百里 体测八百米 海底两万里 德芙巧克力 香草味八喜 可可布朗尼 榴莲菠萝蜜 芝士玉米粒 鸡汁土豆泥 黑椒牛里脊 黄焖辣子鸡 红烧排骨酱醋鱼 不如你 全他妈都不如你

#import "SellerOrderViewController.h"
#import "MoreSelectedView.h"
#import "MJRefresh.h"
#import "OrderPL.h"
#import "SellerOrderModel.h"
#import "itemOrdersDataModel.h"
#import "SellerTopCell.h"
#import "SellerOrderCell.h"
#import "SellerBoomCell.h"
#import "MakeSureSentView.h"
#import "OrderPL.h"
#import "OrderDetailController.h"
#import "xxxxViewController.h"
#import "RCTokenPL.h"

#import "AppDelegate.h"
#import "MenueView.h"
#import "ChatListViewController.h"
#import "DOTabBarController.h"

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
    LOAD_MORE_DATAS5          = 15,
    START_LOAD_FIRST6         = 16,
    RELOAD_DADTAS6            = 17,
    LOAD_MORE_DATAS6          = 18,
    START_LOAD_FIRST7         = 19,
    RELOAD_DADTAS7            = 20,
    LOAD_MORE_DATAS7          = 21
};

@interface SellerOrderViewController ()<MenueViewDelegate,UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate,SellerBoomCellDelegate,MakeSureSentViewDelegate>

@property (nonatomic , strong) UIScrollView *bgScrollView;

@property (nonatomic,strong)UITableView *AllTabView;             //全部

@property (nonatomic,strong)UITableView *UnPayOrderTabView;      //待付款

@property (nonatomic,strong)UITableView *UnSentTabView;          //待发货

@property (nonatomic,strong)UITableView *UnRefundTabView;        //退款中

@property (nonatomic,strong)UITableView *SentedTabView;          //已发货

@property (nonatomic,strong)UITableView *CompletedTabView;       //已完成

@property (nonatomic,strong)UITableView *ClosedTabView;          //已关闭

@property (nonatomic , strong) MoreSelectedView *selectedView;

@property (nonatomic,strong)MakeSureSentView *SentView;          //已关闭


@property (nonatomic, assign) LoadWayTypes      loadWay;    //加载的方式

@property (nonatomic, strong) NSMutableArray    *loadArray;

@property (nonatomic , strong) MenueView *menuView;


@end

@implementation SellerOrderViewController{

    NSMutableArray *_btnArr;
    NSInteger   _pageNum1;
    NSInteger   _pageNum2;
    NSInteger   _pageNum3;
    NSInteger   _pageNum4;
    NSInteger   _pageNum5;
    NSInteger   _pageNum6;
    NSInteger   _pageNum7;

    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;
    NSMutableArray *_dataArr3;
    NSMutableArray *_dataArr4;
    NSMutableArray *_dataArr5;
    NSMutableArray *_dataArr6;
    NSMutableArray *_dataArr7;


}
#pragma mark ====== get
-(MenueView *)menuView{
    if (!_menuView) {
        _menuView = [[MenueView alloc]init];
        _menuView.delegate = self;
    }
    
    return _menuView;
    
}

-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth,ScreenHeight-64-39)];
        _bgScrollView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
        _bgScrollView.contentSize = CGSizeMake(ScreenWidth *6, 10);
        [self.view addSubview:_bgScrollView];
        
    }
    return _bgScrollView;
}

-(UITableView *)AllTabView{
    
    if (!_AllTabView) {
        _AllTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _AllTabView.delegate = self;
        _AllTabView.dataSource = self;
        _AllTabView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _AllTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _AllTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _AllTabView.mj_footer = footer;
        _AllTabView.mj_footer.hidden = YES;
        
    }
    return _AllTabView;
    
}

-(UITableView *)UnPayOrderTabView{
    if (!_UnPayOrderTabView) {
        _UnPayOrderTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _UnPayOrderTabView.delegate = self;
        _UnPayOrderTabView.dataSource = self;
        _UnPayOrderTabView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _UnPayOrderTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _UnPayOrderTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _UnPayOrderTabView.mj_footer = footer;
        _UnPayOrderTabView.mj_footer.hidden = YES;
        
    }
    return _UnPayOrderTabView;
}

-(UITableView *)UnSentTabView{
    if (!_UnSentTabView) {
        _UnSentTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth *2,0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _UnSentTabView.delegate = self;
        _UnSentTabView.dataSource = self;
        _UnSentTabView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _UnSentTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _UnSentTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _UnSentTabView.mj_footer = footer;
        _UnSentTabView.mj_footer.hidden = YES;
        
    }
    return _UnSentTabView;
}

-(UITableView *)UnRefundTabView{
    if (!_UnRefundTabView) {
        _UnRefundTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth *3, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _UnRefundTabView.delegate = self;
        _UnRefundTabView.dataSource = self;
        _UnRefundTabView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _UnRefundTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _UnRefundTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _UnRefundTabView.mj_footer = footer;
        _UnRefundTabView.mj_footer.hidden = YES;
        
    }
    return _UnSentTabView;

}

-(UITableView *)SentedTabView{
    
    if (!_SentedTabView) {
        _SentedTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth *4, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _SentedTabView.delegate = self;
        _SentedTabView.dataSource = self;
        _SentedTabView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _SentedTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _SentedTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _SentedTabView.mj_footer = footer;
        _SentedTabView.mj_footer.hidden = YES;
        
    }
    return _SentedTabView;
    
}

-(UITableView *)CompletedTabView{
    
    if (!_CompletedTabView) {
        _CompletedTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth *5, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _CompletedTabView.delegate = self;
        _CompletedTabView.dataSource = self;
        _CompletedTabView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _CompletedTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _CompletedTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _CompletedTabView.mj_footer = footer;
        _CompletedTabView.mj_footer.hidden = YES;
        
    }
    return _CompletedTabView;
    
}

-(UITableView *)ClosedTabView{
    
    if (!_ClosedTabView) {
        _ClosedTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*6, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _ClosedTabView.delegate = self;
        _ClosedTabView.dataSource = self;
        _ClosedTabView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _ClosedTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _ClosedTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _ClosedTabView.mj_footer = footer;
        _ClosedTabView.mj_footer.hidden = YES;
        
    }
    return _ClosedTabView;
    
}

-(MoreSelectedView *)selectedView{
    if (!_selectedView) {
        _selectedView = [[MoreSelectedView alloc]init];
        [_selectedView.sentBtn addTarget:self action:@selector(sentBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_selectedView.comBtn addTarget:self action:@selector(comBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_selectedView.closeBtn addTarget:self action:@selector(closeBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }

    return _selectedView;
}

-(MakeSureSentView *)SentView{
    if (!_SentView) {
        _SentView = [[MakeSureSentView alloc]init];
        _SentView.delegate = self;
    }
    
    return _SentView;
}

#pragma mark ====== viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"我的订单";
    [self creatrRightBtnItem];
    [self initDatas];
    [self initUI];
    
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *(_btnType - 1), 0) animated:NO];
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshSellerOrder)
                                                 name:@"refreshSellerOrder"  object:nil];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
#pragma mark ====== initDatas and UI
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

- (void)initDatas{

    _btnArr = [NSMutableArray arrayWithCapacity:0];
    self.loadArray = [[NSMutableArray alloc]initWithCapacity:0];
    _pageNum1 = 1;
    _pageNum2 = 1;
    _pageNum3 = 1;
    _pageNum4 = 1;
    _pageNum5 = 1;
    _pageNum6 = 1;
    _pageNum7 = 1;

    _dataArr1 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr2 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr3 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr4 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr5 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr6 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr7 = [[NSMutableArray alloc]initWithCapacity:0];


}

- (void)initUI{

    NSArray *arr = @[@"全部",@"待付款",@"待发货",@"退款中",@"更多"];
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
        if (i==4) {
            UIImage *image = [UIImage imageNamed:@"Triangle-b"];
            [btn setImage:image forState:UIControlStateNormal];
            CGFloat labelWidth = [btn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:btn.titleLabel.font}].width;
            [btn setTitleEdgeInsets:UIEdgeInsetsMake(0, -image.size.width, 0, image.size.width)];
            [btn setImageEdgeInsets:UIEdgeInsetsMake(0,labelWidth, 0, -labelWidth)];
        }
        [_btnArr addObject:btn];
    }
    [self.bgScrollView addSubview:self.AllTabView];
    [self.bgScrollView addSubview:self.UnPayOrderTabView];
    [self.bgScrollView addSubview:self.UnSentTabView];
    [self.bgScrollView addSubview:self.UnRefundTabView];
    [self.bgScrollView addSubview:self.SentedTabView];
    [self.bgScrollView addSubview:self.CompletedTabView];
    [self.bgScrollView addSubview:self.ClosedTabView];
    
    
    
    
}
#pragma mark ====== 顶部按钮点击


- (void)rightbuttonClickEvent{
    
    self.menuView.OriginY = 60;
    [self.menuView show];
    
    
    
}

- (void)orderBtnclick:(YLButton *)button{
    
    if (button.tag !=1004) {
        for (YLButton *btn in _btnArr) {
            btn.on = NO;
        }
        button.on = YES;
    }else{
        for (YLButton *btn in _btnArr) {
            if (btn.tag !=1004) {
                btn.on = NO;
            }
        }

        button.on = !button.on;
    }

    if (button.tag ==1004) {
        for (YLButton *btn in _btnArr) {
            if (btn.tag !=1004) {
                if (btn.on) {
                    [btn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
                }else{
                    [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
                }
            }
        }

        [button setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
        
    }else{
        for (YLButton *btn in _btnArr) {
                if (btn.on) {
                    [btn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
                }else{
                    [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
                }
            }
        

    }
    
    
    
    switch (button.tag) {
        case 1000:{
            [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *(button.tag - 1000), 0) animated:NO];
            self.btnType = SBTN_ALL;
            [self.selectedView dismiss];
            [self reLoadData];
            break;
        }
        case 1001:{
            [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *(button.tag - 1000), 0) animated:NO];
            [self.selectedView dismiss];
            self.btnType = SBTN_UnPay;
            [self reLoadData];            break;
        }
        case 1002:{
            [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *(button.tag - 1000), 0) animated:NO];

            [self.selectedView dismiss];
            self.btnType = SBTN_UnSent;
            [self reLoadData];            break;
        }
        case 1003:{
            [self.selectedView dismiss];
            self.btnType = SBTN_Refund; //退款中
            [self reLoadData];            break;
        }
        case 1004:{
            if (button.on) {
                [self.selectedView showinView:self.view];

            }else{
                [self.selectedView dismiss];

            }
            break;
        }
            default:
            break;
    }
}

/**
 已发货
 */
- (void)sentBtnClick{
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *4, 0) animated:NO];

    [self.selectedView dismiss];
    
    for (YLButton *btn in _btnArr) {
        if (btn.tag ==1004) {
            btn.on = NO;
        }
    }

    self.btnType = SBTN_Sented; //退款中
    [self reLoadData];
}
/**
 完成的订单
 */
- (void)comBtnClick{
    [self.selectedView dismiss];
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *5, 0) animated:NO];

    for (YLButton *btn in _btnArr) {
        if (btn.tag ==1004) {
            btn.on = NO;
        }
    }

    self.btnType = SBTN_Completed; //退款中
    [self reLoadData];
}
/**
 关闭的订单
 */
- (void)closeBtnClick{
    [self.selectedView dismiss];
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth *6, 0) animated:NO];

    for (YLButton *btn in _btnArr) {
        if (btn.tag ==1004) {
            btn.on = NO;
        }
    }

    self.btnType = SBTN_Closed; //退款中
    [self reLoadData];

}
#pragma mark ====== 加载数据

- (void)loadOrderList{

    NSDictionary *infoDic;
    if (self.btnType == SBTN_ALL) {
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum1],
                    @"status":@"",
                    @"title":@""
                    };
    }else if (self.btnType == SBTN_UnPay){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum2],
                    @"status":@"0",
                    @"title":@""
                    };
    }else if (self.btnType == SBTN_UnSent){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum3],
                    @"status":@"1",
                    @"title":@""
                    };
    }else if (self.btnType == SBTN_Refund){
    //敬请期待
        [self showTextHud:@"敬请期待"];
    }else if (self.btnType == SBTN_Sented){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum5],
                    @"status":@"2",
                    @"title":@""
                    };
    }else if (self.btnType == SBTN_Completed){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum6],
                    @"status":@"3",
                    @"title":@""
                    };
    }else if (self.btnType == SBTN_Closed){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum7],
                    @"status":@"4",
                    @"title":@""
                    };
    }
    [MBProgressHUD showMessag:nil toView:self.view];
    [OrderPL SellerGetGroupItemOrderWithinfoDic:infoDic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        self.loadArray = [SellerOrderModel mj_objectArrayWithKeyValuesArray:returnValue[@"groupItemOrdersData"]];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self loadSuccess];
        [self endLoading];
        NSLog(@"%@",_loadArray);
        
    } andErrorBlock:^(NSString *msg) {
        [self endLoading];
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self showTextHud:msg];
    }];
}
#pragma mark ======== 上拉加载，下拉刷新
/**
 上拉加载
 */
- (void)loadMoreData{
    if (self.btnType == SBTN_ALL) {
        self.loadWay = LOAD_MORE_DATAS1;
        [self loadOrderList];
    }else if (self.btnType == SBTN_UnPay){
        self.loadWay = LOAD_MORE_DATAS2;
        [self loadOrderList];
    }else if (self.btnType == SBTN_UnSent){
        self.loadWay = LOAD_MORE_DATAS3;
        [self loadOrderList];
    }else if (self.btnType == SBTN_Refund){
        //敬请期待
        [self endLoading];
        [self showTextHud:@"敬请期待"];
    }else if (self.btnType == SBTN_Sented){
        self.loadWay = LOAD_MORE_DATAS5;
        [self loadOrderList];

    }else if (self.btnType == SBTN_Completed){
        self.loadWay = LOAD_MORE_DATAS6;
        [self loadOrderList];
    }else if (self.btnType == SBTN_Closed){
        self.loadWay = LOAD_MORE_DATAS7;
        [self loadOrderList];
    }
}
/**
 下拉刷新
 */
- (void)reLoadData{
    if (self.btnType == SBTN_ALL) {
        _pageNum1 = 1;
        self.loadWay = RELOAD_DADTAS1;
//        [self.AllTabView.mj_header beginRefreshing];
        [self loadOrderList];
    }else if (self.btnType ==SBTN_UnPay){
        _pageNum2 = 1;
        self.loadWay = RELOAD_DADTAS2;
//        [self.UnPayOrderTabView.mj_header beginRefreshing];

        [self loadOrderList];
    }else if (self.btnType == SBTN_UnSent){
        _pageNum3 = 1;
        self.loadWay = RELOAD_DADTAS3;
//        [self.UnSentTabView.mj_header beginRefreshing];

        [self loadOrderList];
    }else if (self.btnType ==SBTN_Refund){
        //敬请期待
        [self endLoading];
        [self showTextHud:@"敬请期待"];
    }else if (self.btnType == SBTN_Sented){
        _pageNum5 = 1;
        self.loadWay = RELOAD_DADTAS5;
//        [self.SentedTabView.mj_header beginRefreshing];

        [self loadOrderList];
    }else if (self.btnType == SBTN_Completed){
        _pageNum6 = 1;
        self.loadWay = RELOAD_DADTAS6;
//        [self.CompletedTabView.mj_header beginRefreshing];

        [self loadOrderList];
    }else if (self.btnType == SBTN_Closed){
        _pageNum7 = 1;
        self.loadWay = RELOAD_DADTAS7;
//        [self.ClosedTabView.mj_header beginRefreshing];

        [self loadOrderList];
    }
}

#pragma mark ======== 加载结果设置
- (void)loadSuccess{
    [self setPageCount];
    
    switch (self.btnType) {
        case SBTN_ALL:{
            if (self.loadWay == START_LOAD_FIRST1 || self.loadWay == RELOAD_DADTAS1) {
                [_dataArr1  removeAllObjects];
            }
            
            [_dataArr1 addObjectsFromArray:self.loadArray];
            [_AllTabView reloadData];
            if (self.loadArray.count < 30) {
                _AllTabView.mj_footer.hidden = YES;
                [self showTextHud:@"已经加载全部数据"];

            } else {
                _AllTabView.mj_footer.hidden = NO;
            }

            break;
        }
        case SBTN_UnPay:{
            if (self.loadWay == START_LOAD_FIRST2 || self.loadWay == RELOAD_DADTAS2) {
                [_dataArr2  removeAllObjects];
            }
            
            [_dataArr2 addObjectsFromArray:self.loadArray];
            [_UnPayOrderTabView reloadData];
            if (self.loadArray.count < 30) {
                _UnPayOrderTabView.mj_footer.hidden = YES;
                [self showTextHud:@"已经加载全部数据"];

            } else {
                _UnPayOrderTabView.mj_footer.hidden = NO;
            }

            break;
        }
        case SBTN_UnSent:{
            if (self.loadWay == START_LOAD_FIRST3 || self.loadWay == RELOAD_DADTAS3) {
                [_dataArr3  removeAllObjects];
            }
            
            [_dataArr3 addObjectsFromArray:self.loadArray];
            [_UnSentTabView reloadData];
            if (self.loadArray.count < 30) {
                _UnSentTabView.mj_footer.hidden = YES;
                [self showTextHud:@"已经加载全部数据"];

            } else {
                _UnSentTabView.mj_footer.hidden = NO;
            }

            break;
        }
        case SBTN_Refund:{
            if (self.loadWay == START_LOAD_FIRST4 || self.loadWay == RELOAD_DADTAS4) {
                [_dataArr4  removeAllObjects];
            }
            
            [_dataArr4 addObjectsFromArray:self.loadArray];
            [_UnRefundTabView reloadData];
            if (self.loadArray.count < 30) {
                _UnRefundTabView.mj_footer.hidden = YES;
                [self showTextHud:@"已经加载全部数据"];

            } else {
                _UnRefundTabView.mj_footer.hidden = NO;
            }

            break;
        }
        case SBTN_Sented:{
            if (self.loadWay == START_LOAD_FIRST5 || self.loadWay == RELOAD_DADTAS5) {
                [_dataArr5  removeAllObjects];
            }
            
            [_dataArr5 addObjectsFromArray:self.loadArray];
            [_SentedTabView reloadData];
            if (self.loadArray.count < 30) {
                _SentedTabView.mj_footer.hidden = YES;
                [self showTextHud:@"已经加载全部数据"];

            } else {
                _SentedTabView.mj_footer.hidden = NO;
            }

            break;
        }
        case SBTN_Completed:{
            if (self.loadWay == START_LOAD_FIRST6 || self.loadWay == RELOAD_DADTAS6) {
                [_dataArr6  removeAllObjects];
            }
            
            [_dataArr6 addObjectsFromArray:self.loadArray];
            [_CompletedTabView reloadData];
            if (self.loadArray.count < 30) {
                _CompletedTabView.mj_footer.hidden = YES;
                [self showTextHud:@"已经加载全部数据"];

            } else {
                _CompletedTabView.mj_footer.hidden = NO;
            }
            break;
        }
        case SBTN_Closed:{
            if (self.loadWay == START_LOAD_FIRST7 || self.loadWay == RELOAD_DADTAS7) {
                [_dataArr7 removeAllObjects];
            }
            
            [_dataArr7 addObjectsFromArray:self.loadArray];
            [_ClosedTabView reloadData];
            if (self.loadArray.count < 30) {
                _ClosedTabView.mj_footer.hidden = YES;
                [self showTextHud:@"已经加载全部数据"];

            } else {
                _ClosedTabView.mj_footer.hidden = NO;
            }

            break;
        }
        default:
            break;
    }
}

- (void)setPageCount{
    
    switch (self.btnType) {
        case SBTN_ALL:{
            if (self.loadArray.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS1)
                {
                    _pageNum1 = 1;
                }
                _pageNum1 ++;
            }
            break;
        }
        case SBTN_UnPay:{
            if (self.loadArray.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS2)
                {
                    _pageNum2 = 1;
                }
                _pageNum2 ++;
            }
            break;
        }
        case SBTN_UnSent:{
            if (self.loadArray.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS3)
                {
                    _pageNum3 = 1;
                }
                _pageNum3 ++;
            }
            
            break;
        }
        case SBTN_Refund:{
            if (self.loadArray.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS4)
                {
                    _pageNum4 = 1;
                }
                _pageNum4 ++;
            }            break;
        }
        case SBTN_Sented:{
            if (self.loadArray.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS5)
                {
                    _pageNum5 = 1;
                }
                _pageNum5 ++;
            }
            break;
        }
        case SBTN_Completed:{
            if (self.loadArray.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS6)
                {
                    _pageNum6 = 1;
                }
                _pageNum6 ++;
            }
            break;
        }
        case SBTN_Closed:{
            if (self.loadArray.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS7)
                {
                    _pageNum7 = 1;
                }
                _pageNum7 ++;
            }
            break;
        }
        default:
            break;
    }
}

- (void)endLoading{
    [self.AllTabView.mj_header endRefreshing];
    [self.AllTabView.mj_footer endRefreshing];
    [self.UnPayOrderTabView.mj_header endRefreshing];
    [self.UnPayOrderTabView.mj_footer endRefreshing];
    [self.UnSentTabView.mj_header endRefreshing];
    [self.UnSentTabView.mj_footer endRefreshing];
    [self.UnRefundTabView.mj_header endRefreshing];
    [self.UnRefundTabView.mj_footer endRefreshing];
    [self.SentedTabView.mj_header endRefreshing];
    [self.SentedTabView.mj_footer endRefreshing];
    [self.CompletedTabView.mj_header endRefreshing];
    [self.CompletedTabView.mj_footer endRefreshing];
    [self.ClosedTabView.mj_header endRefreshing];
    [self.ClosedTabView.mj_footer endRefreshing];

}


/*
 
 @property (nonatomic,strong)UITableView *AllTabView;             //全部
 
 @property (nonatomic,strong)UITableView *UnPayOrderTabView;      //待付款
 
 @property (nonatomic,strong)UITableView *UnSentTabView;          //待发货
 
 @property (nonatomic,strong)UITableView *UnRefundTabView;        //退款中
 
 @property (nonatomic,strong)UITableView *SentedTabView;          //已发货
 
 @property (nonatomic,strong)UITableView *CompletedTabView;       //已完成
 
 @property (nonatomic,strong)UITableView *ClosedTabView;          //已关闭

 */


#pragma mark ====== tableview

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _AllTabView) {
        return _dataArr1.count;
    }else if (tableView == _UnPayOrderTabView){
        return _dataArr2.count;
    }else if (tableView == _UnSentTabView){
        return _dataArr3.count;
    }else if (tableView == _UnRefundTabView){
        return _dataArr4.count;
    }else if (tableView == _SentedTabView){
        return _dataArr5.count;
    }else if (tableView == _CompletedTabView){
        return _dataArr6.count;
    }else{
        return _dataArr7.count;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _AllTabView) {
        SellerOrderModel *model = _dataArr1[section];
        return model.itemOrdersData.count + 1;
    }else if (tableView == _UnPayOrderTabView){
        SellerOrderModel *model = _dataArr2[section];
        return model.itemOrdersData.count + 1;
    }else if (tableView == _UnSentTabView){
        SellerOrderModel *model = _dataArr3[section];
        return model.itemOrdersData.count + 1;
    }else if (tableView == _UnRefundTabView){
        SellerOrderModel *model = _dataArr4[section];
        return model.itemOrdersData.count + 1;
    }else if (tableView == _SentedTabView){
        SellerOrderModel *model = _dataArr5[section];
        return model.itemOrdersData.count + 1;
    }else if (tableView == _CompletedTabView){
        SellerOrderModel *model = _dataArr6[section];
        return model.itemOrdersData.count + 1;
    }else{
        SellerOrderModel *model = _dataArr7[section];
        return model.itemOrdersData.count + 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 62;
    }else{
        if (tableView == _AllTabView) {
            SellerOrderModel *model = _dataArr1[indexPath.section];
            if (indexPath.row == model.itemOrdersData.count) {
                return 80;
            }else{
                return 100;
            }
        }else if (tableView == _UnPayOrderTabView){
            SellerOrderModel *model = _dataArr2[indexPath.section];
            if (indexPath.row == model.itemOrdersData.count) {
                return 80;
            }else{
                return 100;
            }
        }else if (tableView == _UnSentTabView){
            SellerOrderModel *model = _dataArr3[indexPath.section];
            if (indexPath.row == model.itemOrdersData.count) {
                return 80;
            }else{
                return 100;
            }
        }else if (tableView == _UnRefundTabView){
            SellerOrderModel *model = _dataArr4[indexPath.section];
            if (indexPath.row == model.itemOrdersData.count) {
                return 80;
            }else{
                return 100;
            }
        }else if (tableView == _SentedTabView){
            SellerOrderModel *model = _dataArr5[indexPath.section];
            if (indexPath.row == model.itemOrdersData.count) {
                return 80;
            }else{
                return 100;
            }
        }else if (tableView == _CompletedTabView){
            SellerOrderModel *model = _dataArr6[indexPath.section];
            if (indexPath.row == model.itemOrdersData.count) {
                return 80;
            }else{
                return 100;
            }
        }else{
            SellerOrderModel *model = _dataArr7[indexPath.section];
            if (indexPath.row == model.itemOrdersData.count) {
                return 80;
            }else{
                return 100;
            }
        }

    
    }
}


- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SellerOrderModel *model;
    if (tableView == _AllTabView) {
        model = _dataArr1[indexPath.section];
    }else if (tableView == _UnPayOrderTabView){
        model = _dataArr2[indexPath.section];
    }else if (tableView == _UnSentTabView){
        model = _dataArr3[indexPath.section];
    }else if (tableView == _UnRefundTabView){
        model = _dataArr4[indexPath.section];
    }else if (tableView == _SentedTabView){
        model = _dataArr5[indexPath.section];
    }else if (tableView == _CompletedTabView){
        model = _dataArr6[indexPath.section];
    }else{
        model = _dataArr7[indexPath.section];
    }

    if (indexPath.row == 0) {
        static NSString *topCellid = @"topCellid";
        SellerTopCell *cell = [tableView dequeueReusableCellWithIdentifier:topCellid];
        if (!cell) {
            cell = [[SellerTopCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:topCellid];
        }
        cell.model = model;
        return cell;
    }else if (indexPath.row == model.itemOrdersData.count){
        static NSString *boomcellid = @"boomCellid";
        SellerBoomCell *cell = [tableView dequeueReusableCellWithIdentifier:boomcellid];
        if (!cell) {
            cell = [[SellerBoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:boomcellid];
        }
        cell.delegate = self;
        cell.model = model;
        return cell;
    }else{
        static NSString *Ordercellid = @"OrderCellid";
        SellerOrderCell*cell = [tableView dequeueReusableCellWithIdentifier:Ordercellid];
        if (!cell) {
            cell = [[SellerOrderCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Ordercellid];
        }
        cell.model = model.itemOrdersData[indexPath.row-1];
        
        return cell;
    }

}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    OrderDetailController *deVc = [[OrderDetailController alloc]init];
    SellerOrderModel *model;
    if (tableView == _AllTabView) {
        model = _dataArr1[indexPath.section];
    }else if (tableView == _UnPayOrderTabView){
        model = _dataArr2[indexPath.section];
    }else if (tableView == _UnSentTabView){
        model = _dataArr3[indexPath.section];
    }else if (tableView == _UnRefundTabView){
        model = _dataArr4[indexPath.section];
    }else if (tableView == _SentedTabView){
        model = _dataArr5[indexPath.section];
    }else if (tableView == _CompletedTabView){
        model = _dataArr6[indexPath.section];
    }else{
        model = _dataArr7[indexPath.section];
    }
    deVc.model = model;
    [self.navigationController pushViewController:deVc animated:YES];

}


- (void)refreshSellerOrder{

    [self reLoadData];
}

#pragma mark ====== cancleBtnClick payBtnClick

-(void)didSelectedCancleBtnWithCell:(SellerBoomCell *)cell{
    
    itemOrdersDataModel *model =  cell.model.itemOrdersData[0];
    NSDictionary *thedic = model.userOrderAddress;
    NSDictionary *dic = @{@"sellerIds":thedic[@"accountId"]};
    
    [RCTokenPL getRcsellersinfoWithdic:dic ReturnBlock:^(id returnValue) {
        
        
        xxxxViewController *chat =[[xxxxViewController alloc] init];
        
        //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
        chat.conversationType = ConversationType_PRIVATE;
        //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
        chat.targetId = [NSString stringWithFormat:@"%@",thedic[@"accountId"]] ;
        NSArray *arr = returnValue[@"shopInfoList"];
        NSDictionary *thedic = arr[0];
        
        //设置聊天会话界面要显示的标题
        if (NULL_TO_NIL(thedic[@"shopName"]) ) {
            chat.title = NULL_TO_NIL(thedic[@"shopName"]);
        }else if (NULL_TO_NIL(thedic[@"shopContact"])){
            chat.title = NULL_TO_NIL(thedic[@"shopContact"]);
        } else{
            chat.title = NULL_TO_NIL(thedic[@"sellerInfo"]);
        }
        //显示聊天会话界面
        [self.navigationController pushViewController:chat animated:YES];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];

    
    

    if (cell.Type == 0) {
        //未付款   联系买家
        
    }else if (cell.Type == 1){
     //已支付，待发货  联系卖家   确认发货
        
    }else if (cell.Type == 2){
        
    }else if (cell.Type == 3){
        
    }else if (cell.Type == 4){
        
    }


}

-(void)didSelectedPayBtnWithCell:(SellerBoomCell *)cell{
    if (cell.Type == 0) {
        //未付款   联系买家
    }else if (cell.Type == 1){
        //已支付，待发货  联系买家   确认发货
        self.SentView.model = cell.model;
        [self.SentView showinView:self.view];
    }else if (cell.Type == 2){
        //已发货    联系买家
    }else if (cell.Type == 3){
        //买家取消订单  联系买家 删除订单
    }else if (cell.Type == 4){
        //交易结束  联系买家 删除订单

    }
}


- (void)CallPeopleWithmobile:(NSString *)phoneNumber{
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel:%@",phoneNumber];
    UIWebView * callWebview = [[UIWebView alloc] init];
    [callWebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    [self.view addSubview:callWebview];

}




/**
 确认发货

 @param model model
 */
-(void)DidSelectedMakeSureSentViewMakeSureBtnWithModel:(SellerOrderModel *)model{

    NSLog(@"%@",model);
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<model.itemOrdersData.count; i++) {
        itemOrdersDataModel *theModel = model.itemOrdersData[i];
        if ([theModel.itemId intValue]!= -1) {
            [arr addObject:theModel.theId];
        }
    }
    if (arr.count <=0) {
        return;
    }
    NSDictionary *infoDic = @{@"itemOrderIds":[arr componentsJoinedByString:@","],
                              @"logisticsNumber":self.SentView.traNumbertxt.text,
                              @"corporationCode":@"",
                              @"corporationName":self.SentView.traNametxt.text
                              };
    [MBProgressHUD showMessag:nil toView:self.view];

[OrderPL SellerupdatelogisticsItemWithinfoDic:infoDic ReturnBlock:^(id returnValue) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    [self showTextHud:@"发货成功"];
    [self performSelector:@selector(reLoadData) withObject:nil afterDelay:1.5];
  //  [self reLoadData];
    
} andErrorBlock:^(NSString *msg) {
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    [self showTextHud:msg];
}];

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
