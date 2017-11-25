//
//  DrawDetailViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "DrawDetailViewController.h"
#import "WithdrawalListModel.h"
#import "DrawalRequestListCell.h"
#import "MJRefresh.h"
#import "BankCardPL.h"
@interface DrawDetailViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *AssTabView;           //全部

@property (nonatomic , assign) LoadWayType loadWay;

@property (nonatomic , assign) NSInteger pageNum;

@property (nonatomic, strong) NSMutableArray *loadArray;

@property (nonatomic, strong) NSMutableArray *dataArr;


@end

@implementation DrawDetailViewController
-(NSMutableArray *)loadArray{
    if (!_loadArray) {
        _loadArray = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _loadArray;
    
}
-(NSMutableArray *)dataArr{
    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
    
}

-(UITableView *)AssTabView{
    
    if (!_AssTabView) {
        _AssTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-52-TABBAR_HEIGHT) style:UITableViewStylePlain];
        //_AllTabView.bounces = NO;
        _AssTabView.delegate = self;
        _AssTabView.dataSource = self;
        _AssTabView.backgroundColor = UIColorFromRGB(0xf5f7fa);
        _AssTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _AssTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _AssTabView.mj_footer = footer;
        _AssTabView.mj_footer.hidden = YES;
        [self.view addSubview:self.AssTabView];
        
    }
    return _AssTabView;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    //顶部导航栏
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(17) textAligment:NSTextAlignmentCenter andtext:@"明细"];
    self.navigationItem.titleView = titlelab;
    _pageNum = 1;
    [self loadAssetDetails];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
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
}
#pragma mark ====== 数据

- (void)loadAssetDetails{
    
    NSDictionary *dic = @{@"pageNum":[NSString stringWithFormat:@"%ld",(long)_pageNum],
                          };
    [BankCardPL userCheckDrawalRequestListWithDic:dic withReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSMutableArray *arr = returnValue[@"withdrawalRequestList"];
        
        self.loadArray = [WithdrawalListModel   mj_objectArrayWithKeyValuesArray:arr];
        
        [self loadSuccess];
        [self endLoading];

    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
}
- (void)loadSuccess
{
    [self setPageCount];
    if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
        [_dataArr  removeAllObjects];
    }
    
    [self.dataArr addObjectsFromArray:self.loadArray];
    [self.AssTabView reloadData];
    if (self.loadArray.count <= 30) {
        [self showTextHud:@"已加载全部记录"];
        self.AssTabView.mj_footer.hidden = YES;
    } else {
        self.AssTabView.mj_footer.hidden = NO;
    }
    
}

#pragma mark ====== 刷新
- (void)setPageCount{
    if (self.loadWay != LOAD_MORE_DATAS)
    {
        _pageNum = 1;
    }
    _pageNum ++;
    
}
- (void)endLoading{
    [self.AssTabView.mj_footer endRefreshing];
    [self.AssTabView.mj_header endRefreshing];
}
- (void)reLoadData
{
    //全部
    _pageNum = 1;
    self.loadWay = RELOAD_DADTAS;
    [self loadAssetDetails];
}
- (void)loadMoreData
{
    self.loadWay = LOAD_MORE_DATAS;
    [self loadAssetDetails];
    
}

#pragma mark ====== tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _dataArr.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellid = @"cellid";
    DrawalRequestListCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[DrawalRequestListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model = _dataArr[indexPath.row];
    
    return cell;
}


@end
