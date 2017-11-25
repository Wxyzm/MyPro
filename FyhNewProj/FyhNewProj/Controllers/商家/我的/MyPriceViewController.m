//
//  MyPriceViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyPriceViewController.h"
#import "MyPriceDetailViewController.h"
#import "PublicWantPL.h"
#import "MJRefresh.h"
#import "MyPriceCell.h"
#import "MyPriceModel.h"

//加载的方式
typedef NS_ENUM(NSInteger, BtnType) {
    LEFT_BTN_CLICK  = 1,
    RIGTH_BTN_CLICK  = 2

};
@interface MyPriceViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UIScrollView *bgScrollView;

@property (nonatomic,strong)UITableView *priceTabView;           //商品

@property (nonatomic,strong)UITableView *acceptTabView;            //店铺

@property (nonatomic, assign) LoadWayType   loadWay;    //加载的方式

@property (nonatomic, assign) BtnType       selectWay;    //按钮点击样式

@property (nonatomic, strong) NSMutableArray *loadArray;

@end

@implementation MyPriceViewController{

    SubBtn          *_Btn1;
    SubBtn          *_Btn2;
    NSInteger       _pagenum1;
    NSInteger       _pagenum2;
    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;

}
#pragma  mark =======  view
-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth,ScreenHeight-64)];
        _bgScrollView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
        _bgScrollView.contentSize = CGSizeMake(ScreenWidth*2, 10);
        _bgScrollView.scrollEnabled = NO;
        [self.view addSubview:_bgScrollView];
        
    }
    return _bgScrollView;
}
-(UITableView *)priceTabView{
    
    if (!_priceTabView) {
        _priceTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
        _priceTabView.backgroundColor = UIColorFromRGB(PlaColorValue);

        _priceTabView.delegate = self;
        _priceTabView.dataSource = self;
        _priceTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _priceTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _priceTabView.mj_footer = footer;
        _priceTabView.mj_footer.hidden = YES;
        
    }
    return _priceTabView;
    
}

-(UITableView *)acceptTabView{
    
    if (!_acceptTabView) {
        _acceptTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 0, ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
        _acceptTabView.delegate = self;
        _acceptTabView.dataSource = self;
        _acceptTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _acceptTabView.backgroundColor = UIColorFromRGB(PlaColorValue);

        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _acceptTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _acceptTabView.mj_footer = footer;
        _acceptTabView.mj_footer.hidden = YES;
    }
    return _acceptTabView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"抢单管理";
    [self setBarBackBtnWithImage:nil];
    [self initData];
    [self initUI];
    [self loadMyPriceList];


}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}
- (void)initData{
    _pagenum1 = 1;
    _pagenum2 = 1;
    self.loadArray = [NSMutableArray  arrayWithCapacity:0];
    _dataArr1 = [NSMutableArray  arrayWithCapacity:0];
    _dataArr2 = [NSMutableArray  arrayWithCapacity:0];

}



- (void)initUI{

    _Btn1 = [SubBtn buttonWithtitle:@"报价中" backgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(RedColorValue) cornerRadius:0 andtarget:self action:@selector(Btn1Click)];
    _Btn1.frame = CGRectMake(0, 0, ScreenWidth/2-0.5, 40);
    _Btn1.titleLabel.font = APPFONT(15);
    
    _Btn2 = [SubBtn buttonWithtitle:@"已接受" backgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(BlackColorValue) cornerRadius:0 andtarget:self action:@selector(Btn2Click)];
    _Btn2.frame = CGRectMake(ScreenWidth/2+0.5, 0, ScreenWidth/2-0.5, 40);

    _Btn2.titleLabel.font = APPFONT(15);

    [self.view addSubview:_Btn1];
    [self.view addSubview:_Btn2];

    _selectWay = LEFT_BTN_CLICK;
    
    [self.view addSubview:self.bgScrollView];
    [self.bgScrollView addSubview:self.priceTabView];
    [self.bgScrollView addSubview:self.acceptTabView];


}


- (void)loadMyPriceList{

    NSDictionary *infodic;
    if (_selectWay == LEFT_BTN_CLICK) {
        infodic = @{@"pageNum":[NSString stringWithFormat:@"%ld",_pagenum1],
                    @"status":@"1"
                    };
    }else{
        infodic = @{@"pageNum":[NSString stringWithFormat:@"%ld",_pagenum2],
                    @"status":@"2"
                    };

    }
[PublicWantPL SellerLookHisNeedwithPricewithDic:infodic WithReturnBlock:^(id returnValue) {
    
    self.loadArray = [MyPriceModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"][@"quotationList"]];
    [self loadSuccess];
    [self endLoading];

} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];
    [self endLoading];

}];
}




#pragma mark ======== 加载结果设置
- (void)loadSuccess{
    [self setPageCount];
    if (self.selectWay == LEFT_BTN_CLICK) {
        if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
            [_dataArr1  removeAllObjects];
        }
        [_dataArr1 addObjectsFromArray:self.loadArray];
        [_priceTabView reloadData];
        if (self.loadArray.count < 30) {
            _priceTabView.mj_footer.hidden = YES;
            [self showTextHud:@"已加载全部数据"];
        } else {
            _priceTabView.mj_footer.hidden = NO;
        }

    }else{
        if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
            [_dataArr2  removeAllObjects];
        }
        [_dataArr2 addObjectsFromArray:self.loadArray];
        [_acceptTabView reloadData];
        if (self.loadArray.count < 30) {
            _acceptTabView.mj_footer.hidden = YES;
            [self showTextHud:@"已加载全部数据"];

        } else {
            _acceptTabView.mj_footer.hidden = NO;
        }

    
    }
    
}
- (void)setPageCount{
    
    
    if (self.selectWay == LEFT_BTN_CLICK) {
        if (self.loadArray.count > 0 )
        {
            if (self.loadWay != LOAD_MORE_DATAS)
            {
                _pagenum1 = 1;
            }
            _pagenum1 ++;
        }

        
    }else{
        if (self.loadArray.count > 0 )
        {
            if (self.loadWay != LOAD_MORE_DATAS)
            {
                _pagenum2 = 1;
            }
            _pagenum2 ++;
        }
  
    }

}

- (void)endLoading{
    [_priceTabView.mj_header endRefreshing];
    [_priceTabView.mj_footer endRefreshing];
    [_acceptTabView.mj_header endRefreshing];
    [_acceptTabView.mj_footer endRefreshing];
}

- (void)reLoadData
{
    if (_selectWay == LEFT_BTN_CLICK) {
        _pagenum1 = 1;
        self.loadWay = RELOAD_DADTAS;
        [self loadMyPriceList];
    }else if (_selectWay == RIGTH_BTN_CLICK){
        _pagenum2 = 1;
        self.loadWay = RELOAD_DADTAS;
        [self loadMyPriceList];
    }
    
}

- (void)loadMoreData
{
    self.loadWay = LOAD_MORE_DATAS;
    [self loadMyPriceList];

}
- (void)Btn1Click{

    [_Btn1 setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
    [_Btn2 setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    _selectWay = LEFT_BTN_CLICK;
    [self.bgScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    [self reLoadData];

}


- (void)Btn2Click{
    
    [_Btn1 setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_Btn2 setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
    _selectWay = RIGTH_BTN_CLICK;
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth, 0) animated:NO];
    [self reLoadData];


}


#pragma mark ========= tableviewdelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    if (tableView == _priceTabView) {
        return _dataArr1.count;
    }else{
        return _dataArr2.count;
    
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 112;

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (tableView == _priceTabView) {
        static NSString *leftCellid = @"leftCell";
        MyPriceCell *cell = [tableView  dequeueReusableCellWithIdentifier:leftCellid];
        if (!cell) {
            cell = [[MyPriceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftCellid];
        }
        cell.model = _dataArr1[indexPath.row];
        return cell;
    }else{
        static NSString *rightCellid = @"rightCellid";
        MyPriceCell *cell = [tableView  dequeueReusableCellWithIdentifier:rightCellid];
        if (!cell) {
            cell = [[MyPriceCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightCellid];
        }
        cell.model = _dataArr2[indexPath.row];
        return cell;
        
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    MyPriceDetailViewController *deVc = [[MyPriceDetailViewController alloc]init];
    
    MyPriceModel *model;
    if (tableView == _priceTabView) {
        model= _dataArr1[indexPath.row];
    }else{
    
        model = _dataArr2[indexPath.row];
    }
    deVc.needId =model.priceId;
    [self.navigationController pushViewController:deVc animated:YES];

}

#pragma mark ======= 左滑删除

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _acceptTabView) {
        return YES;
    }
    return NO;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";//默认文字为 Delete
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    MyPriceCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [PublicWantPL SellerDeleteHisNeedwithPricewithDic:cell.model.priceId WithReturnBlock:^(id returnValue) {
            [_dataArr2 removeObject:cell.model];
            [_acceptTabView reloadData];
            
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
    
    }
    
}



@end
