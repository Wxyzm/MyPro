//
//  ShopViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/4.
//  Copyright © 2017年 fyh. All rights reserved.
//
    
#import "ShopViewController.h"
#import "MemberLoginController.h"
#import "PrintQrcodeViewController.h"
#import "demandViewController.h"
#import "OfferViewController.h"
#import "ShopChoseView.h"
#import "ShopTypeView.h"
#import "PublicWantPL.h"
#import "MyNeedsNetModel.h"
#import "MyNeedsModel.h"
#import "MJRefresh.h"
#import "MyGoBuyCell.h"
#import "UserWantPL.h"
#import "OfferViewController.h"
#import "NewGoBuyCell.h"
////加载的方式
//typedef NS_ENUM(NSInteger, LoadWayType) {
//    START_LOAD_FIRST         = 1,
//    RELOAD_DADTAS            = 2,
//    LOAD_MORE_DATAS          = 3
//    };
//
@interface ShopViewController ()<ShopTypeViewDelegate,UITableViewDelegate,UITableViewDataSource,NewGoBuyCellDelegate>

@property (nonatomic,strong)UITableView             *wantTabView;           //全部

@property (nonatomic, assign) LoadWayType           loadWay;                //加载的方式

@property (nonatomic, strong) NSMutableArray        *loadArray;


@end

@implementation ShopViewController{

    ShopChoseView   *_topView;
    ShopTypeView    *_typeView;
    MyNeedsNetModel *_netModel;
    NSMutableArray  *_dataArr;
    NSMutableArray  *_classArr;
    NSInteger        _topBtnIndex;
}
-(UITableView *)wantTabView{
    
    if (!_wantTabView) {
        _wantTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 40, ScreenWidth,ScreenHeight-64-40-TABBAR_HEIGHT) style:UITableViewStylePlain];
        //_AllTabView.bounces = NO;
        _wantTabView.delegate = self;
        _wantTabView.dataSource = self;
        _wantTabView.backgroundColor = UIColorFromRGB(LineColorValue);
        _wantTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _wantTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _wantTabView.mj_footer = footer;
//        _wantTabView.mj_footer.hidden = YES;
        
    }
    return _wantTabView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    [self createNavigationItem];
    self.loadArray = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    _classArr = [[NSMutableArray alloc]initWithCapacity:0];
    _netModel = [[MyNeedsNetModel alloc]init];
    _netModel.status = @"";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reLoadData)
                                                 name:@"NeedsShouldRefresh"  object:nil];
   
    
    [self loadPublicNeedList];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self reLoadData];
}
-(void)initUI{
    
    _topView = [[ShopChoseView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 52)];
    [_topView.classifyBtn addTarget:self action:@selector(classifyBtnclick) forControlEvents:UIControlEventTouchUpInside];
    [_topView.allBtn addTarget:self action:@selector(allBtnclick) forControlEvents:UIControlEventTouchUpInside];
    [_topView.timeBtn addTarget:self action:@selector(timeBtnclick) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_topView];
    _typeView = [[ShopTypeView alloc]initWithFrame:CGRectMake(0, ScreenHeight -64-40, ScreenWidth, 10)];
    _typeView.shoptype  = 0;
    _typeView.delegate = self;
    [self.view addSubview:self.wantTabView];
}

- (void)createNavigationItem
{
    UIBarButtonItem *item = [BaseViewFactory barItemWithImagePath:@"pub-pur" height:24 target:self action:@selector(shareBtnclick)];
    self.navigationItem.rightBarButtonItem = item;
}


- (void)shareBtnclick{
    if (![[UserPL shareManager]userIsLogin]){
        MemberLoginController *vc = [[MemberLoginController alloc] init];
        vc.type = 2;
        DOHNavigationController *navigationController = [[DOHNavigationController alloc] initWithRootViewController:vc];
        [self presentViewController:navigationController animated:YES completion:^{}];
        return ;
    }
    demandViewController *fabuVc = [[demandViewController alloc]init];
    [self.navigationController pushViewController:fabuVc animated:YES];
}


#pragma mark ---------- topBtn

- (void)classifyBtnclick{
    _topBtnIndex = 0;
    _topView.timeBtn.on = NO;
    [_topView.timeBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_topView.timeBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];

    if (_topView.allBtn.on) {
        _topView.allBtn.on = NO;
        [ _topView.allBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [ _topView.allBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
         [_typeView cancelPicker];

    }else{
        _topView.classifyBtn.on =  !_topView.classifyBtn.on;
        if ( _topView.classifyBtn.on) {
            [ _topView.classifyBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
            [ _topView.classifyBtn setImage:[UIImage imageNamed:@"Triangle-up"] forState:UIControlStateNormal];
            //showview
            if (_classArr.count <=0) {
                [self loadFenLei];
            }else{
                NSMutableArray *dataArr = [[NSMutableArray alloc]initWithObjects:@"全部", nil];
                for (NSDictionary *caDic in _classArr) {
                    [dataArr addObject:caDic[@"name"]];
                }
                _typeView.dataArr = dataArr;
                if ([_topView.classifyBtn.titleLabel.text isEqualToString:@"全部分类"]) {
                    _typeView.nameStr = @"全部";

                }else{
                    _typeView.nameStr = _topView.classifyBtn.titleLabel.text;

                }
                [_typeView showInView:self.view];
            }
                   }else{
            [ _topView.classifyBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
            [ _topView.classifyBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
            [_typeView cancelPicker];
        }
    }
     
}

- (void)allBtnclick{
    _topBtnIndex = 1;
    _topView.timeBtn.on = NO;
    [_topView.timeBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_topView.timeBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];

    if (_topView.classifyBtn.on) {
        _topView.classifyBtn.on = NO;
        [ _topView.classifyBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        [ _topView.classifyBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
         [_typeView cancelPicker];
    }else{
        _topView.allBtn.on =  !_topView.allBtn.on;
        if ( _topView.allBtn.on) {
            [ _topView.allBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
            [ _topView.allBtn setImage:[UIImage imageNamed:@"Triangle-up"] forState:UIControlStateNormal];
            NSMutableArray *dataArr = [NSMutableArray arrayWithObjects:@"全部",@"进行中",@"报价中", nil];
            _typeView.dataArr = dataArr;
            if ([_topView.allBtn.titleLabel.text isEqualToString:@"全部状态"]) {
                _typeView.nameStr = @"全部";
                
            }else{
                _typeView.nameStr = _topView.allBtn.titleLabel.text;
                
            }
            [_typeView showInView:self.view];
        }else{
            [ _topView.allBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
            [ _topView.allBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
            [_typeView cancelPicker];
        }
    }
    
}

- (void)timeBtnclick{
    _topBtnIndex = 2;
     [_typeView cancelPicker];
   
    _topView.classifyBtn.on = NO;
    [ _topView.classifyBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [ _topView.classifyBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
    _topView.allBtn.on = NO;
    
    [ _topView.allBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [ _topView.allBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];

    _topView.timeBtn.on =  !_topView.timeBtn.on;
        if (_topView.timeBtn.on) {
            [_topView.timeBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
            [_topView.timeBtn setImage:[UIImage imageNamed:@"Triangle-up"] forState:UIControlStateNormal];
            _netModel.sort = @"3";
            [self reLoadData];

        }else{
            [_topView.timeBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
            [_topView.timeBtn setImage:[UIImage imageNamed:@"Triangle"] forState:UIControlStateNormal];
            _netModel.sort = @"2";
            [self reLoadData];

        }
    
}



#pragma mark ---------- ShopTypeViewDelegate

-(void)didSelectedcancelPickerBtn{
   
    _topView.classifyBtn.on = NO;
    _topView.allBtn.on = NO;
    _topView.timeBtn.on = NO;
    [ _topView.classifyBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [ _topView.classifyBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
    
    [ _topView.allBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [ _topView.allBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
}

-(void)didSelectedtableviewRow:(NSInteger)index{
    _topView.classifyBtn.on = NO;
    _topView.allBtn.on = NO;
    _topView.timeBtn.on = NO;
    [ _topView.classifyBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [ _topView.classifyBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];
    [ _topView.allBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [ _topView.allBtn setImage:[UIImage imageNamed:@"Triangle-b"] forState:UIControlStateNormal];

     [_typeView cancelPicker];
    if (_topBtnIndex == 0) {
        if (index == 0) {
            _netModel.categoryId = @"";
            _netModel.sort = @"";
            [_topView.classifyBtn setTitle:@"全部" forState:UIControlStateNormal];

        }else{
            NSDictionary *Dic = _classArr[index - 1];
            _netModel.categoryId = Dic[@"id"];
            _netModel.sort = @"";
            [_topView.classifyBtn setTitle:Dic[@"name"] forState:UIControlStateNormal];
            NSLog(@"%@",Dic);
            
        }
        [self reLoadData];
    }else if (_topBtnIndex == 1){
        if (index == 0) {
            _netModel.status = @"";
            _netModel.sort = @"";
            [_topView.allBtn setTitle:@"全部" forState:UIControlStateNormal];
             [self reLoadData];
        }else if (index == 1){
            _netModel.status = @"4";
            _netModel.sort = @"";
            [_topView.allBtn setTitle:@"进行中" forState:UIControlStateNormal];
            [self reLoadData];

        
        }else if (index == 2){
            _netModel.status = @"6";
            _netModel.sort = @"";
            [_topView.allBtn setTitle:@"报价中" forState:UIControlStateNormal];
            [self reLoadData];
            
        }else{
            //已过期
            _netModel.sort = @"";
            [_topView.allBtn setTitle:@"已过期" forState:UIControlStateNormal];

        }
    }
}

#pragma mark ---------- tarviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 156;
    }
    return 144;

}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
        static NSString *cellid = @"allcell";
        NewGoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[NewGoBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
//            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        MyNeedsModel *model = _dataArr[indexPath.row];
        cell.model = model;
        cell.delegate = self;
    if (indexPath.row == 0) {
        cell.backView.frame = CGRectMake(12, 12, ScreenWidth - 24, 132);
    }else{
        cell.backView.frame = CGRectMake(12, 0, ScreenWidth - 24, 132);
    }
        return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewGoBuyCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    [_wantTabView deselectRowAtIndexPath:indexPath animated:NO];
    OfferViewController *offVc = [[OfferViewController alloc]init];
    offVc.needId = cell.model.needsId;
    [self.navigationController pushViewController:offVc animated:YES];

}
#pragma mark ---------- cell代理方法   收藏

-(void)didSelectedCollectBtnWithcell:(NewGoBuyCell *)cell{
    
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    if (cell.model.isUserCollectedPurchasingNeed) {
        NSDictionary *dic = @{@"purchasingNeedId":cell.model.needsId,
                              };
        [UserWantPL userCancleCollectNeedWithDic:dic andReturnBlock:^(id returnValue) {
            [self showTextHud:@"已取消收藏"];
            cell.model.isUserCollectedPurchasingNeed = NO;
            [_wantTabView reloadData];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
    }else{
        NSDictionary *dic = @{@"purchasingNeedId":cell.model.needsId};
        [UserWantPL userCollectNeedWithDic:dic andReturnBlock:^(id returnValue) {
            [self showTextHud:@"收藏成功"];
            cell.model.isUserCollectedPurchasingNeed = YES;
            [_wantTabView reloadData];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];

        }];
        
    }
    
    
}


#pragma mark ---------- 网络请求

- (void)loadFenLei{
    [UserWantPL getUserCategorylistwithReturnBlock:^(id returnValue) {
        NSDictionary *dic = returnValue[@"data"];
        NSArray *ListArr = dic[@"purchasingNeedCategoryList"];
        NSMutableArray *dataArr = [[NSMutableArray alloc]initWithObjects:@"全部", nil];
        for (NSDictionary *caDic in ListArr) {
            [_classArr addObject:caDic];
            [dataArr addObject:caDic[@"name"]];
        }
        _typeView.dataArr = dataArr;
        if ([_topView.classifyBtn.titleLabel.text isEqualToString:@"全部分类"]) {
            _typeView.nameStr = @"全部";
            
        }else{
            _typeView.nameStr = _topView.classifyBtn.titleLabel.text;
            
        }
        [_typeView showInView:self.view];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHudInSelfView:msg];
        
    }];


}

- (void)loadPublicNeedList{
    NSDictionary *infoDic = @{
                              @"pageNum":[NSString stringWithFormat:@"%ld",(long)_netModel.pageNum],
                              @"title":_netModel.title,
                              @"status":_netModel.status,
                              @"categoryId":_netModel.categoryId,
                              @"sort":_netModel.sort
                              };
    
    [PublicWantPL PublicgetPurchasingNeedlistWithdic:infoDic ReturnBlock:^(id returnValue) {
        NSDictionary *resultDic = returnValue[@"data"];
        self.loadArray = [MyNeedsModel mj_objectArrayWithKeyValuesArray:resultDic[@"purchasingNeedList"]];
        [self loadSuccess];
        [self endLoading];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        [self endLoading];

    }];
}
- (void)loadSuccess
{
    [self setPageCount];
    if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
        [_dataArr  removeAllObjects];
    }
    
    [_dataArr addObjectsFromArray:self.loadArray];
    [_wantTabView reloadData];
//    if (self.loadArray.count < 30) {
//        _wantTabView.mj_footer.hidden = YES;
//    } else {
//        _wantTabView.mj_footer.hidden = NO;
//    }

}
#pragma mark ------------ 下拉刷新上拉加载

- (void)setPageCount{
    if (self.loadWay != LOAD_MORE_DATAS)
    {
        _netModel.pageNum = 1;
    }
    _netModel.pageNum ++;

}

- (void)endLoading{
    [_wantTabView.mj_footer endRefreshing];
    [_wantTabView.mj_header endRefreshing];
}
- (void)reLoadData
{
    //全部
     _netModel.pageNum = 1;
    self.loadWay = RELOAD_DADTAS;
    [self loadPublicNeedList];
}
- (void)loadMoreData
{
    self.loadWay = LOAD_MORE_DATAS;
    [self loadPublicNeedList];
    
}


@end
