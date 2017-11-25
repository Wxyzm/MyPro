//
//  GoodsManageViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GoodsManageViewController.h"
#import "MJRefresh.h"
#import "GoodsItemsPL.h"
#import "GItemModel.h"
#import "GoodsmanageCell.h"
#import "GoodsEditViewController.h"
#import "GoodsDetailViewController.h"
#import "ItemsModel.h"
#import "SettingupinventoryViewController.h"
#import "GoodsDetailViewController.h"
#import "ItemsModel.h"
#import "SearchboxViewController.h"
#import "PrintQrNewViewController.h"
#import "waTableTableViewCell.h"
#import "MasterProModel.h"
#import "ShopSettingPL.h"
#import "ProEditViewController.h"
#import "ProEditModel.h"
#import "AttributesModel.h"

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
    
};


@interface GoodsManageViewController ()<UITableViewDelegate,UITableViewDataSource,GoodsmanageCellDelegate,waTableTableViewCelldelegate,UITextFieldDelegate,UIScrollViewDelegate>

@property (nonatomic , strong) UIScrollView  *bgScrollView;

@property (nonatomic , strong) UITableView   *onTableView;

@property (nonatomic , strong) UITableView   *waTableView;

@property (nonatomic , strong) UITableView   *invTableView;

@property (nonatomic , strong) UITableView   *sampleTableView;

@property (nonatomic , strong) UIView   *footOnView;

@property (nonatomic , strong) UIView   *footDownView;

@property (nonatomic , strong) UIView   *footAlertView;

@property (nonatomic , strong) UIView   *footSampleView;



@property (nonatomic, strong) NSMutableArray *loadArray;

@property (nonatomic, strong) UIButton *quanxuanBtn;

@property (nonatomic, strong) UIButton *rightbutton;

@property (nonatomic,strong) UILabel *jinbaoshuLab;

@property (nonatomic, assign) LoadWayTypes       loadWay;    //加载的方式

@end

@implementation GoodsManageViewController{

    YLButton        *_onBtn;            //上架中
    YLButton        *_WarehouseBtn;     //仓库中
    YLButton        *_inventoryAlertBtn;//库存警报
    YLButton        *_sampleBtn;        //样品间
    NSMutableArray  *_btnArr;           //按钮数组
    NSInteger       _currpage1;
    NSInteger       _currpage2;
    NSInteger       _currpage3;
    NSInteger       _currpage4;

    NSMutableArray  *_dataArr1;
    NSMutableArray  *_dataArr2;
    NSMutableArray  *_dataArr3;
    NSMutableArray  *_dataArr4;
    YLButton        *_onSelectAllBtn;                //上架中
    YLButton        *_downSelectAllBtn;              //仓库中
    UITextField     *_alertTXT;             //库存警报
    YLButton        *_sampleSelectAllBtn;            //样品间
    UIView *_lineView;
    NSMutableArray  *_loadWayArr;
    NSString        *_myPrint;
    NSInteger       _printType;
}
#pragma mark ======== get

-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth,ScreenHeight-NaviHeight64-40-iPhoneX_DOWNHEIGHT)];
        _bgScrollView.backgroundColor = UIColorFromRGB(BGColorValue);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
        _bgScrollView.pagingEnabled = YES;
        _bgScrollView.delegate = self;
//        _bgScrollView.scrollEnabled = NO;
        _bgScrollView.contentSize = CGSizeMake(ScreenWidth *4, 10);

        [self.view addSubview:_bgScrollView];
        
    }
    return _bgScrollView;}

-(UITableView *)onTableView{

    if (!_onTableView) {
        _onTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 40 - NaviHeight64-45-iPhoneX_DOWNHEIGHT) style:UITableViewStylePlain];
        _onTableView.delegate = self;
        _onTableView.dataSource = self;
        _onTableView.backgroundColor = UIColorFromRGB(BGColorValue);
        _onTableView.separatorStyle = UITableViewStylePlain;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _onTableView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _onTableView.mj_footer = footer;
        _onTableView.mj_footer.hidden = YES;

    }
    return _onTableView;
}
- (UITableView *)waTableView{
    
    if (!_waTableView) {
        _waTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - 40 - NaviHeight64-45-iPhoneX_DOWNHEIGHT) style:UITableViewStylePlain];
        _waTableView.delegate = self;
        _waTableView.dataSource = self;
        _waTableView.backgroundColor = UIColorFromRGB(BGColorValue);
        _waTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _waTableView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _waTableView.mj_footer = footer;
        _waTableView.mj_footer.hidden = YES;
        
    }
    return _waTableView;
}
- (UITableView *)invTableView{
    
    if (!_invTableView) {
        _invTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth*2, 0, ScreenWidth, ScreenHeight - 40 - NaviHeight64-45-iPhoneX_DOWNHEIGHT) style:UITableViewStylePlain];
        _invTableView.delegate = self;
        _invTableView.dataSource = self;
        _invTableView.backgroundColor = UIColorFromRGB(BGColorValue);
        _invTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _invTableView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _invTableView.mj_footer = footer;
        _invTableView.mj_footer.hidden = YES;
        
    }
    return _invTableView;
}


- (UITableView *)sampleTableView{
    
    if (!_sampleTableView) {
        _sampleTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenWidth*3, 0, ScreenWidth, ScreenHeight - 40 - NaviHeight64-45-iPhoneX_DOWNHEIGHT) style:UITableViewStylePlain];
        _sampleTableView.delegate = self;
        _sampleTableView.dataSource = self;
        _sampleTableView.backgroundColor = UIColorFromRGB(BGColorValue);
        _sampleTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _sampleTableView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _sampleTableView.mj_footer = footer;
        _sampleTableView.mj_footer.hidden = YES;
        
    }
    return _sampleTableView;
}

-(UIView *)footOnView{
    
    if (!_footOnView) {
        _footOnView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight - 45-40-NaviHeight64-iPhoneX_DOWNHEIGHT, ScreenWidth, 45) color:UIColorFromRGB(WhiteColorValue)];
        _onSelectAllBtn = [YLButton buttonWithType:UIButtonTypeCustom];
        [_footOnView addSubview:_onSelectAllBtn];
        [_onSelectAllBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        [_onSelectAllBtn addTarget:self action:@selector(onSelectAllBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_onSelectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_onSelectAllBtn setImageRect:CGRectMake(12, 14.5, 16, 16)];
        [_onSelectAllBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [_onSelectAllBtn setTitleRect:CGRectMake(40, 0, 50, 45)];
        _onSelectAllBtn.titleLabel.font = APPFONT(15);
        _onSelectAllBtn.frame = CGRectMake(0, 0, 100, 45);
        
        SubBtn *downBtn = [SubBtn buttonWithtitle:@"放入样品间" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(onputBtnClick) andframe:CGRectMake(ScreenWidth - 92, 0, 92, 45)];
        [_footOnView addSubview:downBtn];
        downBtn.titleLabel.font = APPFONT(15);
        [downBtn setTitleColor:UIColorFromRGB(0xfafafa) forState:UIControlStateNormal];
    }
    return _footOnView;
}

-(UIView *)footDownView{
    if (!_footDownView) {
        _footDownView = [BaseViewFactory viewWithFrame:CGRectMake(ScreenWidth, ScreenHeight - 45-40-NaviHeight64-iPhoneX_DOWNHEIGHT, ScreenWidth, 45) color:UIColorFromRGB(WhiteColorValue)];
        _downSelectAllBtn = [YLButton buttonWithType:UIButtonTypeCustom];
        [_footDownView addSubview:_downSelectAllBtn];
        [_downSelectAllBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        [_downSelectAllBtn addTarget:self action:@selector(downSelectAllBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_downSelectAllBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];

        [_downSelectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_downSelectAllBtn setImageRect:CGRectMake(12, 14.5, 16, 16)];
        [_downSelectAllBtn setTitleRect:CGRectMake(40, 0, 50, 45)];
        _downSelectAllBtn.titleLabel.font = APPFONT(15);
        _downSelectAllBtn.frame = CGRectMake(0, 0, 100, 45);

        SubBtn *downBtn = [SubBtn buttonWithtitle:@"放入样品间" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(downputBtnClick) andframe:CGRectMake(ScreenWidth - 92, 0, 92, 45)];
        [_footDownView addSubview:downBtn];
        downBtn.titleLabel.font = APPFONT(15);
        [downBtn setTitleColor:UIColorFromRGB(0xfafafa) forState:UIControlStateNormal];
    }
    return _footDownView;

}

-(UIView *)footAlertView{
    
    if (!_footAlertView) {
        _footAlertView = [BaseViewFactory viewWithFrame:CGRectMake(ScreenWidth*2, ScreenHeight - 45-40-NaviHeight64-iPhoneX_DOWNHEIGHT, ScreenWidth, 45) color:UIColorFromRGB(WhiteColorValue)];
        UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(16, 0, 65, 45) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"库存警报"];
        [_footAlertView addSubview:lab];
        _alertTXT = [BaseViewFactory textFieldWithFrame:CGRectMake(93, 7.5, 80, 30) font:APPFONT(15) placeholder:@"" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PLAHColorValue) delegate:self];
        [_footAlertView addSubview:_alertTXT];
        _alertTXT.layer.cornerRadius = 4;
        _alertTXT.layer.borderWidth = 1;
        _alertTXT.layer.borderColor = UIColorFromRGB(0xe6e9ed).CGColor;
        _alertTXT.textAlignment = NSTextAlignmentRight;
        _alertTXT.userInteractionEnabled = NO;
        CGRect frame = _alertTXT.frame;
        frame.size.width = 10;
        UIView *leftview = [[UIView alloc] initWithFrame:frame];
        _alertTXT.rightViewMode = UITextFieldViewModeAlways;
        _alertTXT.rightView = leftview;
        
        SubBtn *alertBtn = [SubBtn buttonWithtitle:@"设置" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(alertBtnClick) andframe:CGRectMake(ScreenWidth - 92, 0, 92, 45)];
        [_footAlertView addSubview:alertBtn];
        alertBtn.titleLabel.font = APPFONT(15);
        [alertBtn setTitleColor:UIColorFromRGB(0xfafafa) forState:UIControlStateNormal];
    }
    return _footAlertView;
}

-(UIView *)footSampleView{
    if (!_footSampleView) {
        _footSampleView = [BaseViewFactory viewWithFrame:CGRectMake(ScreenWidth *3, ScreenHeight - 45-40-NaviHeight64-iPhoneX_DOWNHEIGHT, ScreenWidth, 45) color:UIColorFromRGB(WhiteColorValue)];
        _sampleSelectAllBtn = [YLButton buttonWithType:UIButtonTypeCustom];
        [_footSampleView addSubview:_sampleSelectAllBtn];
        [_sampleSelectAllBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        [_sampleSelectAllBtn addTarget:self action:@selector(sampleSelectAllBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_sampleSelectAllBtn setTitle:@"全选" forState:UIControlStateNormal];
        [_sampleSelectAllBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
      
        [_sampleSelectAllBtn setImageRect:CGRectMake(12, 14.5, 16, 16)];
        [_sampleSelectAllBtn setTitleRect:CGRectMake(40, 0, 50, 45)];
        _sampleSelectAllBtn.titleLabel.font = APPFONT(15);
        _sampleSelectAllBtn.frame = CGRectMake(0, 0, 100, 45);
        
        SubBtn *samdeleteBtn = [SubBtn buttonWithtitle:@"删除" backgroundColor:UIColorFromRGB(0xffce54) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(samdeleteBtnClick)];
        [_footSampleView addSubview:samdeleteBtn];
        samdeleteBtn.titleLabel.font = APPFONT(15);
        [samdeleteBtn setTitleColor:UIColorFromRGB(0xfafafa) forState:UIControlStateNormal];
        samdeleteBtn.frame = CGRectMake(ScreenWidth-144, 0, 72, 45);
        
        
        SubBtn *samBtn = [SubBtn buttonWithtitle:@"打印" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(samprintBtnClick) andframe:CGRectMake(ScreenWidth - 72, 0, 72, 45)];
        [_footSampleView addSubview:samBtn];
        samBtn.titleLabel.font = APPFONT(15);
        [samBtn setTitleColor:UIColorFromRGB(0xfafafa) forState:UIControlStateNormal];
    }
    return _footSampleView;
}

#pragma mark ======== viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self setBarBackBtnWithImage:nil];
    self.title = @"商品仓库";
    [self initData];
    [self initUI];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (_onBtn.on) {
        [_onTableView.mj_header beginRefreshing];
    }else if (_WarehouseBtn.on){
        [_waTableView.mj_header beginRefreshing];

    }else{
        [_invTableView.mj_header beginRefreshing];
    }
    [self reLoadData];
}

- (void)initData{
    _currpage1 = 1;
    _currpage2 = 1;
    _currpage3= 1;
    _currpage3= 4;

    _btnArr = [NSMutableArray   arrayWithCapacity:0];
    _dataArr1 = [NSMutableArray   arrayWithCapacity:0];
    _dataArr2 = [NSMutableArray   arrayWithCapacity:0];
    _dataArr3 = [NSMutableArray   arrayWithCapacity:0];
    _dataArr4 = [NSMutableArray   arrayWithCapacity:0];
    _loadWayArr   =[ NSMutableArray arrayWithObjects:@(START_LOAD_FIRST1),@(START_LOAD_FIRST2),@(START_LOAD_FIRST3),@(START_LOAD_FIRST4), nil];
//    self.loadArray = [NSMutableArray arrayWithCapacity:0];
}

#pragma mark ======== UI
- (void)initUI{

 
    [self.view addSubview:self.bgScrollView];
    
    [self.bgScrollView addSubview:self.onTableView];
    [self.bgScrollView addSubview:self.waTableView];
    [self.bgScrollView addSubview:self.invTableView];
    [self.bgScrollView addSubview:self.sampleTableView];
    [self.bgScrollView addSubview:self.footOnView];
    [self.bgScrollView addSubview:self.footDownView];
    [self.bgScrollView addSubview:self.footAlertView];
    [self.bgScrollView addSubview:self.footSampleView];
    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 40) color:UIColorFromRGB(WhiteColorValue)];
    topView.clipsToBounds = NO;
    [self.view addSubview:topView];
    
    CGFloat  BtnWidth = ScreenWidth/4;
    _onBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_onBtn setTitle:@"上架中" forState:UIControlStateNormal];
    [_onBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
    _onBtn.frame = CGRectMake(0, 0, BtnWidth, 40);
    _onBtn.on = YES;
    [topView addSubview:_onBtn];
    [_onBtn addTarget:self action:@selector(onBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnArr addObject:_onBtn];
    
    _WarehouseBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_WarehouseBtn setTitle:@"仓库中" forState:UIControlStateNormal];
    [_WarehouseBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _WarehouseBtn.frame = CGRectMake(BtnWidth, 0, BtnWidth, 40);
    _WarehouseBtn.on = NO;
    [topView addSubview:_WarehouseBtn];
    [_WarehouseBtn addTarget:self action:@selector(warehouseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnArr addObject:_WarehouseBtn];
    
    
    _inventoryAlertBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_inventoryAlertBtn setTitle:@"库存警报" forState:UIControlStateNormal];
    [_inventoryAlertBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _inventoryAlertBtn.frame = CGRectMake(BtnWidth*2, 0, BtnWidth, 40);
    _inventoryAlertBtn.on = NO;
    [topView addSubview:_inventoryAlertBtn];
    [_inventoryAlertBtn addTarget:self action:@selector(inventoryAlertBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnArr addObject:_inventoryAlertBtn];
    
    _sampleBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_sampleBtn setTitle:@"样品间" forState:UIControlStateNormal];
    [_sampleBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _sampleBtn.frame = CGRectMake(BtnWidth*3, 0, BtnWidth, 40);
    _sampleBtn.on = NO;
    [topView addSubview:_sampleBtn];
    [_sampleBtn addTarget:self action:@selector(sampleBtntBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [_btnArr addObject:_sampleBtn];
    _lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 39, ScreenWidth/4, 2) color:UIColorFromRGB(RedColorValue)];
    [topView addSubview:_lineView];
    UIImage *grayimage = [UIImage imageNamed:@"search-white"];
    _rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, grayimage.size.width, grayimage.size.height)];
    [_rightbutton setImage:grayimage forState:UIControlStateNormal];
    [_rightbutton addTarget:self action:@selector(respondToRightButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:_rightbutton];
    self.navigationItem.rightBarButtonItem = right;
    self.loadWay = START_LOAD_FIRST1;
    [self loadMyGoods];
    
}
//搜索按钮
-(void)respondToRightButtonClickEvent
{
    SearchboxViewController *vc = [[SearchboxViewController alloc]init];
    [self.navigationController pushViewController:vc animated:YES];
    
}

////取消搜索
//-(void)cancelButtonClickEvent
//{
//
//}

#pragma mark ======== 按钮点击
- (void)onBtnClick{
    _onBtn.on = YES;
    _WarehouseBtn.on = NO;
    _inventoryAlertBtn.on = NO;
    _sampleBtn.on = NO;
    [self.bgScrollView setContentOffset:CGPointMake(0,0) animated:NO];
    [self refreshBtn];
    if (_dataArr1.count<=0) {
        [_onTableView.mj_header beginRefreshing];
        [self reLoadData];
    }
   
}

- (void)warehouseBtnClick{
    _WarehouseBtn.on = YES;
    _onBtn.on = NO;
    _inventoryAlertBtn.on = NO;
    _sampleBtn.on = NO;
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth,0) animated:NO];
    [self refreshBtn];
    if (_dataArr2.count<=0) {
        [_waTableView.mj_header beginRefreshing];
        [self reLoadData];
    }
   


}
- (void)inventoryAlertBtnClick{
    _inventoryAlertBtn.on = YES;
    _onBtn.on = NO;
    _WarehouseBtn.on = NO;
    _sampleBtn.on = NO;
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth*2,0) animated:NO];
    [self refreshBtn];
    if (_dataArr3.count<=0) {
        [_invTableView.mj_header beginRefreshing];
        [self reLoadData];
    }
  

}

- (void)sampleBtntBtnClick{
    _sampleBtn.on = YES;
    _inventoryAlertBtn.on = NO;
    _onBtn.on = NO;
    _WarehouseBtn.on = NO;
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth*3,0) animated:NO];
    [self refreshBtn];
    if (_dataArr4.count<=0) {
        [_sampleTableView.mj_header beginRefreshing];
        [self reLoadData];
    }
   
    
}
- (void)refreshBtn{
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            [btn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
        }else{
            [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        }
    }

}
#pragma mark ======== 上拉加载，下拉刷新
/**
 上拉加载
 */
- (void)loadMoreData{
    if (_onBtn.on) {
        self.loadWay = LOAD_MORE_DATAS1;
        [self loadMyGoods];
    }else if (_WarehouseBtn.on){
        self.loadWay = LOAD_MORE_DATAS2;
        [self loadMyGoods];
    }else if (_inventoryAlertBtn.on){
        self.loadWay = LOAD_MORE_DATAS3;
        [self loadMyGoods];
    }else{
        self.loadWay = LOAD_MORE_DATAS4;
        [self loadMyGoods];
    }
}
/**
 下拉刷新
 */
- (void)reLoadData{
    if (_onBtn.on) {
        _currpage1 = 1;
//        self.loadWay = RELOAD_DADTAS1;
        [_loadWayArr  replaceObjectAtIndex:0 withObject:@(START_LOAD_FIRST1)];
        [_onSelectAllBtn  setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        [self loadMyGoods];
    }else if (_WarehouseBtn.on){
        _currpage2 = 1;
//        self.loadWay = RELOAD_DADTAS2;
        [_loadWayArr  replaceObjectAtIndex:1 withObject:@(START_LOAD_FIRST2)];

        [_downSelectAllBtn  setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        [self loadMyGoods];
    }else if (_inventoryAlertBtn.on){
        _currpage3 = 1;
//        self.loadWay = RELOAD_DADTAS3;
        [_loadWayArr  replaceObjectAtIndex:2 withObject:@(START_LOAD_FIRST3)];

        [self loadMyGoods];
    }else{
        _currpage4 = 1;
//        self.loadWay = RELOAD_DADTAS4;
        [_loadWayArr  replaceObjectAtIndex:3 withObject:@(START_LOAD_FIRST4)];

        [_sampleSelectAllBtn  setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        [self loadMyGoods];
    }
}
#pragma mark ======== 加载数据
- (void)loadMyGoods{
    NSDictionary *infoDic;
    if (_onBtn.on) {
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_currpage1],
                    @"name":@"",
                    @"categoryId":@"",
                    @"status":@"1",
                    @"isSample":@""
                    };
        [self loadUpOrDownDataWithDic:infoDic andnumber:1];
    }else if (_WarehouseBtn.on){
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_currpage2],
                    @"name":@"",
                    @"categoryId":@"",
                    @"status":@"0",
                    @"isSample":@""
                    };
        [self loadUpOrDownDataWithDic:infoDic andnumber:2];

    }else if (_inventoryAlertBtn.on){
    
        [self loadUserCustomstockLessThanNumber:3];
        
    }else{
        infoDic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_currpage4],
                    @"name":@"",
                    @"categoryId":@"",
                    @"status":@"",
                    @"isSample":@"true"
                    };
        [self loadUpOrDownDataWithDic:infoDic andnumber:4] ;

    }
   

}

- (void)loadUpOrDownDataWithDic:(NSDictionary *)dic andnumber:(NSInteger)tag{
    
    [GoodsItemsPL UserGetHisMasterProWithGoodsInfo:dic ReturnBlock:^(id returnValue) {
        NSDictionary *resultDic = returnValue[@"data"];
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        arr = [MasterProModel mj_objectArrayWithKeyValuesArray:resultDic[@"products"]];
        [self loadSuccessWithArr:arr andtag:tag];
        [self endLoadingwithTag:tag];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        [self endLoadingwithTag:tag];
    }];
    
}


- (void)loadUserCustomstockLessThanNumber:(NSInteger)tag{
    
    NSDictionary *numDic = @{@"key":@"stockLessThanNumber"};
    [ShopSettingPL GetCustomShopInfoWithDic:numDic andReturnBlock:^(id returnValue) {
        NSDictionary *infoDic;
        if (IsEmptyStr(returnValue[@"value"])) {
            infoDic = @{@"stockLessThanNumber":@"10"};
            _alertTXT.text = @"10";
        }else{
            infoDic = @{@"stockLessThanNumber":returnValue[@"value"]};
            _alertTXT.text = returnValue[@"value"];

        }
 
        [self loadstockLessThanNumberProWithDic:infoDic andtag:tag];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        [self endLoadingwithTag:tag];
    }];
    
    
}


- (void)loadstockLessThanNumberProWithDic:(NSDictionary *)dic andtag:(NSInteger)tag{
    [GoodsItemsPL UserGetHisInventoryAlertProductwithInfoDic:dic ReturnBlock:^(id returnValue) {
        NSDictionary *resultDic = returnValue[@"data"];
         NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        arr = [MasterProModel mj_objectArrayWithKeyValuesArray:resultDic[@"products"]];
        [self loadSuccessWithArr:arr andtag:tag];
        [self endLoadingwithTag:tag];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        [self endLoadingwithTag:tag];
    }];
    
    
}

#pragma mark ======== 加载结果设置
- (void)loadSuccessWithArr:(NSMutableArray *)arr andtag:(NSInteger)tag{
    [self setPageCountWithArr:arr andTag:tag];
    
    switch (tag) {
        case 1:{
            if ([_loadWayArr[0] integerValue] == START_LOAD_FIRST1 || [_loadWayArr[0] integerValue] == RELOAD_DADTAS1) {
                [_dataArr1  removeAllObjects];
            }
            
            [_dataArr1 addObjectsFromArray:arr];
            [_onTableView reloadData];
            if (arr.count < 30) {
                _onTableView.mj_footer.hidden = YES;
            } else {
                _onTableView.mj_footer.hidden = NO;
            }
            break;
        }
        case 2:{
            if ([_loadWayArr[1] integerValue] == START_LOAD_FIRST2 ||[_loadWayArr[1] integerValue] == RELOAD_DADTAS2) {
                [_dataArr2  removeAllObjects];
            }
            
            [_dataArr2 addObjectsFromArray:arr];
            [_waTableView reloadData];
            if (arr.count < 30) {
                _waTableView.mj_footer.hidden = YES;
            } else {
                _waTableView.mj_footer.hidden = NO;
            }
            break;
            
        }
        case 3:{
                [_dataArr3  removeAllObjects];
            
            
            [_dataArr3 addObjectsFromArray:arr];
            [_invTableView reloadData];
            _invTableView.mj_footer.hidden = YES;
            break;
        }
        case 4:{
            if ([_loadWayArr[3] integerValue] == START_LOAD_FIRST4 || [_loadWayArr[3] integerValue] == RELOAD_DADTAS4) {
                [_dataArr4  removeAllObjects];
            }
            [_dataArr4 addObjectsFromArray:arr];
            [_sampleTableView reloadData];
            if (arr.count < 30) {
                _sampleTableView.mj_footer.hidden = YES;
            } else {
                _sampleTableView.mj_footer.hidden = NO;
            }
            break;
        }
        default:
            break;
    }
    

    
}

- (void)setPageCountWithArr:(NSMutableArray *)arr andTag:(NSInteger)tag{
    
    
    
    switch (tag) {
        case 1:{
            if (arr.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS1)
                {
                    _currpage1 = 1;
                }
                _currpage1 ++;
            }
            break;
        }
        case 2:{
            if (arr.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS2)
                {
                    _currpage2 = 1;
                }
                _currpage2 ++;
            }
            break;
            
        }
        case 3:{
            
            break;
        }
        case 4:{
            if (arr.count > 0 )
            {
                if (self.loadWay != LOAD_MORE_DATAS4)
                {
                    _currpage4 = 1;
                }
                _currpage4 ++;
            }
            break;
        }
        default:
            break;
    }
//    if (_onBtn.on) {
//        //上架中
//        if (self.loadArray.count > 0 )
//        {
//            if (self.loadWay != LOAD_MORE_DATAS1)
//            {
//                _currpage1 = 1;
//            }
//            _currpage1 ++;
//        }
//    }else if (_WarehouseBtn.on){
//        //仓库中
//        if (self.loadArray.count > 0 )
//        {
//            if (self.loadWay != LOAD_MORE_DATAS2)
//            {
//                _currpage2 = 1;
//            }
//            _currpage2 ++;
//        }
//    }else if (_inventoryAlertBtn.on){
//
//
//    }
//    else{
//        //库存警报
//        if (self.loadArray.count > 0 )
//        {
//            if (self.loadWay != LOAD_MORE_DATAS4)
//            {
//                _currpage4 = 1;
//            }
//            _currpage4 ++;
//        }
//    }
}

- (void)endLoadingwithTag:(NSInteger)tag{
    
    switch (tag) {
        case 1:{
            [self.onTableView.mj_header endRefreshing];
            [self.onTableView.mj_footer endRefreshing];
            break;
        }
        case 2:{
            [self.waTableView.mj_header endRefreshing];
            [self.waTableView.mj_footer endRefreshing];
            break;
            
        }
        case 3:{
            [self.invTableView.mj_header endRefreshing];
            [self.invTableView.mj_footer endRefreshing];
            break;
        }
        case 4:{
            [self.sampleTableView.mj_header endRefreshing];
            [self.sampleTableView.mj_footer endRefreshing];
            break;
        }
        default:
            break;
    }
 
  
   
  
}

#pragma mark ======== tableview 

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _onTableView) {
        return _dataArr1.count;
    }else if (tableView == _waTableView){
        return _dataArr2.count;
    }else if (tableView == _invTableView){
        return _dataArr3.count;
    }
    else{
        return _dataArr4.count;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView ==_sampleTableView) {
        return 112;
    }
    return 152;
}              

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _onTableView) {
        static NSString *oncellId = @"oncell";
        waTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oncellId];
        if (!cell) {
            cell = [[waTableTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oncellId];
            cell.delegate = self;
            
            
        }
        cell.type = 1;
        cell.model = _dataArr1[indexPath.row];
        return cell;
    }else if (tableView == _waTableView){
        static NSString *oncellId = @"wacell";
        waTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oncellId];
        if (!cell) {
            cell = [[waTableTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oncellId];
            cell.delegate = self;
        }
        cell.type = 2;
        cell.model = _dataArr2[indexPath.row];
        return cell;
    }else if (tableView == _invTableView){
        static NSString *oncellId = @"wacell";
        waTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oncellId];
        if (!cell) {
            cell = [[waTableTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oncellId];
            cell.delegate = self;
        }
        cell.type = 3;
        cell.model = _dataArr3[indexPath.row];
        return cell;
    }
    else{
        static NSString *oncellId = @"incell";
        waTableTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:oncellId];
        if (!cell) {
            cell = [[waTableTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:oncellId];
            cell.delegate = self;
        }
         cell.type = 4;
        cell.model = _dataArr4[indexPath.row];
        return cell;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    waTableTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSArray *itemArr = cell.model.itemList;
    
    if (itemArr.count<=0) {
        return;
    }
    GItemModel *itemModel = itemArr[0];
    GoodsDetailViewController *deVC= [[GoodsDetailViewController alloc]init];
    ItemsModel *model = [[ItemsModel alloc]init];
    model.itemId = itemModel.itemID;
    deVC.itemModel = model;
    [self.navigationController  pushViewController:deVC animated:YES];
}



#pragma mark ======== GoodsManageCellDelegate
/**
 编辑

 @param cell cell
 */
-(void)didselectedEditBtnWithCell:(waTableTableViewCell *)cell{

    ProEditViewController   *editVc = [[ProEditViewController alloc]init];
    editVc.idStr  = [NSString stringWithFormat:@"%ld",(long)cell.model.masterId];
    [self.navigationController pushViewController:editVc animated:YES];

}


/**
 下架/上架

 @param cell cell
 */
-(void)didselectedDownBtnWithCell:(waTableTableViewCell *)cell{
    if (_onBtn.on) {
        [GoodsItemsPL UserNotSaleProductwithIProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId ] ReturnBlock:^(id returnValue) {
            [self showTextHud:@"下架成功"];
            [_dataArr1 removeObject:cell.model];
            [_onTableView reloadData];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];

        }];

    }else if (_WarehouseBtn.on){
        [GoodsItemsPL UserOnSaleProductwithIProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId ] ReturnBlock:^(id returnValue) {
            [self showTextHud:@"上架成功"];
            [_dataArr2 removeObject:cell.model];
            [_waTableView reloadData];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];

        }];
    }else{
        if (cell.model.status == 0) {
            //仓库中
            [GoodsItemsPL UserOnSaleProductwithIProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId ] ReturnBlock:^(id returnValue) {
                [self showTextHud:@"上架成功"];
                cell.model.status = 1;
                [_invTableView reloadData];
            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];
                
            }];
            
        }else{
            //上架中
            [GoodsItemsPL UserNotSaleProductwithIProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId ] ReturnBlock:^(id returnValue) {
                [self showTextHud:@"下架成功"];
                cell.model.status = 0;
                [_invTableView reloadData];
                
            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];
                
            }];

        }
 
    }

}

/**
 删除

 @param cell cell
 */
-(void)didselectedDeleteBtnWithCell:(waTableTableViewCell *)cell{
    
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除么" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [GoodsItemsPL UserDeleteProductwithIProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId ] ReturnBlock:^(id returnValue) {
            [self showTextHud:@"删除成功"];
            if (_onBtn.on) {
                [_dataArr1 removeObject:cell.model];
                [_onTableView reloadData];
                
            }else if (_WarehouseBtn.on){
                [_dataArr2 removeObject:cell.model];
                [_waTableView reloadData];
                
                
            }else if (_inventoryAlertBtn.on){
                [_dataArr3 removeObject:cell.model];
                [_invTableView reloadData];
            }
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    

}

//打印

- (void)didselectedPrintBtnClickWithCell:(waTableTableViewCell *)cell
{
    if (!_myPrint) {
        [ShopSettingPL getTheShopSettingInfoWithReturnBlock:^(id returnValue) {
            if ([returnValue[@"isShopAllowUseAppPrinter"] boolValue]) {
                _myPrint = @"YES";
                [self printWithCell:cell];
                
            }else{
                _myPrint = @"NO";
                [self showTextHud:@"您没有打印权限，详情请联系客服"];
            }
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }else{
        if ([_myPrint isEqualToString:@"NO"]) {
            [self showTextHud:@"您没有打印权限，详情请联系客服"];
            return;
        }else{
            [self printWithCell:cell];
        }
        
    }
    
    
    
    

    
}

- (void)printWithCell:(waTableTableViewCell *)cell{
    [GoodsItemsPL UserGetHisMasterProDETAILWithProId:[NSString stringWithFormat:@"%ld",(long)cell.model.masterId] ReturnBlock:^(id returnValue) {
        ProEditModel *model = [ProEditModel mj_objectWithKeyValues:returnValue[@"data"][@"product"]];
        NSLog(@"%@",returnValue);
        NSMutableArray *chenfenArr = model.attributes;
        NSString *customBn= @"";
        NSString *Width=@"";
        NSString *bn=@"";
        NSString *ingredient=@"";
        for (AttributesModel *attModel in chenfenArr) {
            if ([attModel.attributeName isEqualToString:@"货号"]) {
                customBn = attModel.attributeDefaultValue;
            }
            if ([attModel.attributeName isEqualToString:@"门幅"]) {
                Width = attModel.attributeDefaultValue;
            }
            if ([attModel.attributeName isEqualToString:@"克重"]) {
                bn = attModel.attributeDefaultValue;
            }
            if ([attModel.attributeName isEqualToString:@"成分"]) {
                ingredient = attModel.attributeDefaultValue;
            }
        }
        GItemModel *itModel  = model.itemsInCurrentSpecification[0];
        NSDictionary *  printDic = @{@"url":[NSString stringWithFormat:@"%@/item/%@",kbaseUrl,itModel.itemID],
                                     @"title":model.name,
                                     @"customBn":customBn,             //货号
                                     @"Width":Width,                   //门幅
                                     @"bn":bn,                         //克重
                                     @"ingredient":ingredient          //成分
                                     };
        
        PrintQrNewViewController *prVc = [[PrintQrNewViewController alloc]init];
        prVc.infoDic = printDic;
        [self.navigationController pushViewController:prVc animated:YES];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    
}

#pragma mark ========== 按钮

/**
 上架中全选
 */
- (void)onSelectAllBtnClick{
    _onSelectAllBtn.on = !_onSelectAllBtn.on;
    if (_onSelectAllBtn.on) {
        [_onSelectAllBtn setImage:[UIImage imageNamed:@"manager_red"] forState:UIControlStateNormal];
        for (MasterProModel *model in _dataArr1) {
            model.isSelected = YES;
        }
    }else{
        [_onSelectAllBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];

        for (MasterProModel *model in _dataArr1) {
            model.isSelected = NO;
        }
    }
    [_onTableView reloadData];
}


/**
 仓库中全选
 */
- (void)downSelectAllBtnClick{
    _downSelectAllBtn.on = !_downSelectAllBtn.on;
    if (_downSelectAllBtn.on) {
        [_downSelectAllBtn setImage:[UIImage imageNamed:@"manager_red"] forState:UIControlStateNormal];

        for (MasterProModel *model in _dataArr2) {
            model.isSelected = YES;
        }
    }else{
        [_downSelectAllBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];

        for (MasterProModel *model in _dataArr2) {
            model.isSelected = NO;
        }
    }
    [_waTableView reloadData];
    
}

/**
 样品间全选
 */
- (void)sampleSelectAllBtnClick{
    
    _sampleSelectAllBtn.on = !_sampleSelectAllBtn.on;
    if (_sampleSelectAllBtn.on) {
        [_sampleSelectAllBtn setImage:[UIImage imageNamed:@"manager_red"] forState:UIControlStateNormal];
        
        for (MasterProModel *model in _dataArr4) {
            model.isSelected = YES;
        }
    }else{
        [_sampleSelectAllBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        
        for (MasterProModel *model in _dataArr4) {
            model.isSelected = NO;
        }
    }
    [_sampleTableView reloadData];
}

/**
 上架中放入样品间
 */
- (void)onputBtnClick{
    NSMutableArray *numArr = [NSMutableArray arrayWithCapacity:0];
    for (MasterProModel *model in _dataArr1) {
        if (model.isSelected) {
            [numArr addObject:[NSString stringWithFormat:@"%ld",(long)model.masterId]];
        }
    }
    NSDictionary *infoDic = @{@"productIds":[numArr componentsJoinedByString:@","]};
    [GoodsItemsPL UserbatchsetissamplewithInfo:infoDic ReturnBlock:^(id returnValue) {
        [self showTextHud:@"加入成功"];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    
    
}

/**
 仓库中放入样品间
 */
- (void)downputBtnClick{
    NSMutableArray *numArr = [NSMutableArray arrayWithCapacity:0];
    for (MasterProModel *model in _dataArr2) {
        if (model.isSelected) {
            [numArr addObject:[NSString stringWithFormat:@"%ld",(long)model.masterId]];
        }
    }
    NSDictionary *infoDic = @{@"productIds":[numArr componentsJoinedByString:@","]};
    [GoodsItemsPL UserbatchsetissamplewithInfo:infoDic ReturnBlock:^(id returnValue) {
        [self showTextHud:@"加入成功"];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
}
/**
 库存警报设置
 */
- (void)alertBtnClick{
    
    SettingupinventoryViewController *setVc = [[SettingupinventoryViewController alloc]init];
    setVc.numStr  = _alertTXT.text;
    [setVc setDidSetNumberBlock:^(NSString *number) {
        _alertTXT.text = number;
    }];
    [self.navigationController  pushViewController:setVc animated:YES];
}
/**
 样品间删除
 */
- (void)samdeleteBtnClick{
    NSMutableArray *numArr = [NSMutableArray arrayWithCapacity:0];
    for (MasterProModel *model in _dataArr4) {
        if (model.isSelected) {
            [numArr addObject:[NSString stringWithFormat:@"%ld",(long)model.masterId]];
        }
    }
    NSDictionary *infoDic = @{@"productIds":[numArr componentsJoinedByString:@","]};
    [GoodsItemsPL UserbatchsetnotsamplewithInfo:infoDic ReturnBlock:^(id returnValue) {
        [self showTextHud:@"删除成功"];
        [self reLoadData];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];

    }];
}

- (void)makeSurePrint{
    
        [ShopSettingPL getTheShopSettingInfoWithReturnBlock:^(id returnValue) {
            if ([returnValue[@"isShopAllowUseAppPrinter"] boolValue]) {
                _myPrint = @"YES";
                if (_printType == 1) {
                    [self samprintBtnClick];
                }
                
            }else{
                  _myPrint = @"NO";
                [self showTextHud:@"您没有打印权限，详情请联系客服"];
            }
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
    
    
}

/**
 样品间打印
 */
- (void)samprintBtnClick{
    
    _printType = 1;
    if (!_myPrint) {
        [self makeSurePrint];
    }
    if ([_myPrint isEqualToString:@"NO"]) {
        [self showTextHud:@"您没有打印权限，详情请联系客服"];
        return;
    }

    
    NSLog(@"%@",_dataArr4);
    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    for (MasterProModel *model in _dataArr4) {
        if (model.isSelected) {
            [dataArr addObject:model];
        }
    }
    if (dataArr.count<=0) {
        [self showTextHud:@"请选择要打印的商品"];
        return;
    }
    NSMutableArray  *printArr = [NSMutableArray arrayWithCapacity:0];
    for (MasterProModel *model in dataArr) {
        NSArray *chenfenArr = model.attributes;
        NSString *customBn= @"";
        NSString *Width=@"";
        NSString *bn=@"";
        NSString *ingredient=@"";
        for (NSMutableDictionary *attModel in chenfenArr) {
            if ([attModel[@"attributeName"] isEqualToString:@"货号"]) {
                customBn = attModel[@"attributeDefaultValue"];
            }
            if ([attModel[@"attributeName"] isEqualToString:@"门幅"]) {
                Width = attModel[@"attributeDefaultValue"];
            }
            if ([attModel[@"attributeName"]isEqualToString:@"克重"]) {
                bn = attModel[@"attributeDefaultValue"];
            }
            if ([attModel[@"attributeName"] isEqualToString:@"成分"]) {
                ingredient = attModel[@"attributeDefaultValue"];
            }
        }
        GItemModel*itemModel =model.itemList[0];
        NSDictionary *  printDic = @{@"url":[NSString stringWithFormat:@"%@/item/%@",kbaseUrl,itemModel.itemID],
                                     @"title":model.name,
                                     @"customBn":customBn,             //货号
                                     @"Width":Width,                   //门幅
                                     @"bn":bn,                         //克重
                                     @"ingredient":ingredient          //成分
                                     };
        [printArr addObject:printDic];
    
    }
    
    PrintQrNewViewController *prVc = [[PrintQrNewViewController alloc]init];
    prVc.dataArr = printArr;
    prVc.infoDic = printArr[0];
    prVc.type = 1;
    [self.navigationController pushViewController:prVc animated:YES];
    
    
}

-(void)didselectedSelectedBtnWithCell:(waTableTableViewCell *)cell{
    if (cell.type == 1) {
        if ([self isAllSelectedWithArr:_dataArr1]) {
            [_onSelectAllBtn setImage:[UIImage imageNamed:@"manager_red"] forState:UIControlStateNormal];
        }else{
            [_onSelectAllBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        }
        
    }else if (cell.type == 2){
        if ([self isAllSelectedWithArr:_dataArr2]) {
            [_downSelectAllBtn setImage:[UIImage imageNamed:@"manager_red"] forState:UIControlStateNormal];
        }else{
            [_downSelectAllBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        }
        
    }else if (cell.type == 3){
        
        
    }else if (cell.type == 4){
        if ([self isAllSelectedWithArr:_dataArr4]) {
            [_sampleSelectAllBtn setImage:[UIImage imageNamed:@"manager_red"] forState:UIControlStateNormal];
        }else{
            [_sampleSelectAllBtn setImage:[UIImage imageNamed:@"manager_gray"] forState:UIControlStateNormal];
        }
    }
}

- (BOOL)isAllSelectedWithArr:(NSMutableArray *)dataArr{
    
    for (MasterProModel *model in dataArr) {
        if (!model.isSelected) {
            return NO;
        }
    }
    return YES;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.bgScrollView) {
        CGPoint point = scrollView.contentOffset;
        CGFloat contentX = point.x/ScreenWidth;
        CGRect frame = _lineView.frame;
        frame.origin.x = ScreenWidth/4 *contentX;
        _lineView.frame = frame;
        NSLog(@"%f",contentX);
        if (contentX<0.5) {
            _WarehouseBtn.on = NO;
            _inventoryAlertBtn.on = NO;
            _onBtn.on = YES;
            _sampleBtn.on = NO;
            [self refreshBtn];
            if (_dataArr1.count<=0&&contentX==0) {
                [_onTableView.mj_header beginRefreshing];
                [self reLoadData];
            }
        }else if (contentX>0.5&&contentX<=1.5) {
            _WarehouseBtn.on = YES;
            _inventoryAlertBtn.on = NO;
            _onBtn.on = NO;
            _sampleBtn.on = NO;
            [self refreshBtn];
            if (_dataArr2.count<=0&&contentX==1) {
                [_waTableView.mj_header beginRefreshing];
                [self reLoadData];
            }
            
        }
        else if (contentX>1.5&&contentX<=2.5){
            _inventoryAlertBtn.on = YES;
            _WarehouseBtn.on = NO;
            _onBtn.on = NO;
            _sampleBtn.on = NO;
            [self refreshBtn];
            if (_dataArr3.count<=0&&contentX==2) {
                [_invTableView.mj_header beginRefreshing];
                [self reLoadData];
            }
            
        }else if (contentX>2.5&&contentX<=3.5){
            _sampleBtn.on = YES;
            _WarehouseBtn.on = NO;
            _inventoryAlertBtn.on = NO;
            _onBtn.on = NO;
            [self refreshBtn];
            if (_dataArr4.count<=0&&contentX==3) {
                [_sampleTableView.mj_header beginRefreshing];
                [self reLoadData];
            }
        }
    }
}



@end
