    //
//  MyCollectionController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyCollectionController.h"
#import "MyCollectionCell.h"
#import "GoodsDetailViewController.h"
#import "BusinessesShopViewController.h"
#import "OfferViewController.h"

#import "ItemsModel.h"
#import "CollectePL.h"
#import "UserWantPL.h"
#import "MyNeedsModel.h"

#import "MJRefresh.h"
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
    LOAD_MORE_DATAS3          = 9
};

@interface MyCollectionController ()<UITableViewDelegate,UITableViewDataSource,MyCollectionCellDelegate>

@property (nonatomic , strong) UIScrollView *bgScrollView;

@property (nonatomic,strong)UITableView *goodsTabView;           //商品

@property (nonatomic,strong)UITableView *shopTabView;            //店铺

@property (nonatomic,strong)UITableView *needTabView;            //店铺

@property (nonatomic, assign) LoadWayTypes       loadWay;    //加载的方式

@property (nonatomic, strong) NSMutableArray           *loadArray;



@end

@implementation MyCollectionController{

    NSMutableArray *_btnArr;
    NSInteger  _pageNum1;
    NSInteger  _pageNum2;
    NSInteger  _pageNum3;

    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;
    NSMutableArray *_dataArr3;


}
#pragma  mark =======  view
-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth,ScreenHeight-64-39)];
        _bgScrollView.backgroundColor = UIColorFromRGB(LineColorValue);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
        _bgScrollView.scrollEnabled  = NO;
        _bgScrollView.contentSize = CGSizeMake(ScreenWidth *3, 10);
        [self.view addSubview:_bgScrollView];
        
    }
    return _bgScrollView;
}
-(UITableView *)goodsTabView{
    
    if (!_goodsTabView) {
        _goodsTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 12, ScreenWidth,ScreenHeight-115) style:UITableViewStylePlain];
        _goodsTabView.delegate = self;
        _goodsTabView.dataSource = self;
        _goodsTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _goodsTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _goodsTabView.mj_header = header;
            
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _goodsTabView.mj_footer = footer;
        _goodsTabView.mj_footer.hidden = YES;

    }
    return _goodsTabView;
    
}

-(UITableView *)shopTabView{
    
    if (!_shopTabView) {
        _shopTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 12, ScreenWidth,ScreenHeight-115) style:UITableViewStylePlain];
        _shopTabView.delegate = self;
        _shopTabView.dataSource = self;
        _shopTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _shopTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _shopTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _shopTabView.mj_footer = footer;
        _shopTabView.mj_footer.hidden = YES;
    }
    return _shopTabView;
    
}

-(UITableView *)needTabView{
    if (!_needTabView) {
        _needTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 12, ScreenWidth,ScreenHeight-115) style:UITableViewStylePlain];
        _needTabView.delegate = self;
        _needTabView.dataSource = self;
        _needTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _needTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _needTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _needTabView.mj_footer = footer;
        _needTabView.mj_footer.hidden = YES;
    }
    return _needTabView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.navigationItem.title = @"我的收藏";
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self initUI];
    self.loadWay = START_LOAD_FIRST1;
    [self loadGoodsShoucangList];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initUI{
    _btnArr = [[NSMutableArray alloc]initWithCapacity:0];
    _pageNum1 = 1;
    _pageNum2 = 1;
    _pageNum3 = 1;

    _dataArr1 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr2 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr3 = [[NSMutableArray alloc]initWithCapacity:0];
    self.loadArray = [[NSMutableArray alloc]init];

    NSArray *arr = @[@"商品",@"店铺",@"采购"];
    for (int i = 0; i<3; i++) {
        YLButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = APPFONT(15);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(shoucangBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(ScreenWidth/3*i, 0, ScreenWidth/3, 39);
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
    [self.bgScrollView addSubview:self.goodsTabView];
    [self.bgScrollView addSubview:self.shopTabView];
    [self.bgScrollView addSubview:self.needTabView];


}

- (void)shoucangBtnclick:(YLButton *)button{

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
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            if (btn.tag == 1000) {
                //全部
                if (_dataArr1.count>0) {
                    
                }else{
                    [self loadGoodsShoucangList];
                    
                }
            }else if (btn.tag == 1001){
                //进行中
                if (_dataArr2.count>0) {
                    
                }else{
                    [self loadShopsShoucangList];
                    
                }
            }else{
                //进行中
                if (_dataArr3.count>0) {
                    
                }else{
                    [self loadNeeds];
                    
                }
            }
        }
    }
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth*(button.tag - 1000),0) animated:NO];
}



- (void)loadGoodsShoucangList{
    NSDictionary *dic = @{@"pageNum":[NSString stringWithFormat:@"%ld",_pageNum1],
                          @"title":@"",
                          @"categoryId":@""};
    [CollectePL GetUserGoodsCollecteShopWithDic:dic andReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        self.loadArray = returnValue[@"itemCollectionList"];

        [self loadSuccess];
        [self endLoading];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        [self endLoading];

    }];



}

- (void)loadShopsShoucangList{
    NSDictionary *dic = @{@"pageNum":[NSString stringWithFormat:@"%ld",_pageNum2]
                          };
    [CollectePL GetUserShopsCollecteShopWithDic:dic andReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        self.loadArray = returnValue[@"shopCollectionList"];
        
        [self loadSuccess];
        [self endLoading];

    } andErrorBlock:^(NSString *msg) {
          [self showTextHud:msg];
        [self endLoading];

    }];
    
}

- (void)loadNeeds{
    
    NSDictionary *dic = @{@"pageNum":[NSString stringWithFormat:@"%ld",_pageNum3]
                          };
    [UserWantPL getUserCollectNeedWithDic:dic andReturnBlock:^(id returnValue) {
      
        NSLog(@"需求%@",returnValue);

        self.loadArray = returnValue[@"data"][@"purchasingNeedCollectionList"];
        [self loadSuccess];
        [self endLoading];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    
    
    
}



#pragma mark ======= 下拉刷新，上啦加载设置

- (void)loadSuccess
{
    [self setPageCount];
    for (YLButton *btn in _btnArr)
    {
        if (btn.on)
        {
            if (btn.tag == 1000) {
                //全部
                if (self.loadWay == START_LOAD_FIRST1 || self.loadWay == RELOAD_DADTAS1) {
                    [_dataArr1  removeAllObjects];
                }
                
                [_dataArr1 addObjectsFromArray:self.loadArray];
                [_goodsTabView reloadData];
                if (self.loadArray.count < 30) {
                    _goodsTabView.mj_footer.hidden = YES;
//                    [self showTextHud:@"已经加载全部数据"];
                } else {
                    _goodsTabView.mj_footer.hidden = NO;
                }
                
            }else if (btn.tag == 1001){
                //进行中
                if (self.loadWay == START_LOAD_FIRST2 || self.loadWay == RELOAD_DADTAS2) {
                    [_dataArr2  removeAllObjects];
                }
                
                [_dataArr2 addObjectsFromArray:self.loadArray];
                [_shopTabView reloadData];
                if (self.loadArray.count < 30) {
//                    [self showTextHud:@"已经加载全部数据"];

                    _shopTabView.mj_footer.hidden = YES;
                } else {
                    _shopTabView.mj_footer.hidden = NO;
                }
                
            }else{
                if (self.loadWay == START_LOAD_FIRST3 || self.loadWay == RELOAD_DADTAS3) {
                    [_dataArr3 removeAllObjects];
                }
                
                [_dataArr3 addObjectsFromArray:self.loadArray];
                [_needTabView reloadData];
                if (self.loadArray.count < 30) {
//                    [self showTextHud:@"已经加载全部数据"];
                    
                    _needTabView.mj_footer.hidden = YES;
                } else
                {
                    _needTabView.mj_footer.hidden = NO;
                }
            
            }
        }
    }
}
- (void)setPageCount{
    
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            if (btn.tag == 1000) {
                //全部
                if (self.loadArray.count > 0 )
                {
                    if (self.loadWay != LOAD_MORE_DATAS1)
                    {
                        _pageNum1 = 1;
                    }
                    _pageNum1 ++;
                }
                
            }else if (btn.tag == 1001){
                //进行中
                if (self.loadArray.count > 0 )
                {
                    if (self.loadWay != LOAD_MORE_DATAS2)
                    {
                        _pageNum2 = 1;
                    }
                    _pageNum2 ++;
                }
                
            }else{
                if (self.loadArray.count > 0 )
                {
                    if (self.loadWay != LOAD_MORE_DATAS3)
                    {
                        _pageNum3 = 1;
                    }
                    _pageNum3 ++;
                }
            }
        }
    }
}

- (void)reLoadData
{
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            if (btn.tag == 1000) {
                //全部
                _pageNum1= 1;
                self.loadWay = RELOAD_DADTAS1;
                [self loadGoodsShoucangList ];
                
            }else if (btn.tag == 1001){
                //进行中
               _pageNum2 = 1;
                self.loadWay = RELOAD_DADTAS2;
                [self loadShopsShoucangList];
            }else{
                _pageNum3 = 1;
                self.loadWay = RELOAD_DADTAS3;
                [self loadNeeds];
            }
        }
    }
    
}

- (void)loadMoreData
{
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            if (btn.tag == 1000) {
                //全部
                self.loadWay = LOAD_MORE_DATAS1;
                [self loadGoodsShoucangList];
                
            }else if (btn.tag == 1001){
                //进行中
                self.loadWay = LOAD_MORE_DATAS2;
                [self loadShopsShoucangList];
            }else{
                self.loadWay = LOAD_MORE_DATAS3;
                [self loadNeeds];
            }
            
        }
    }
    
    
}

- (void)endLoading{
    
    [_goodsTabView.mj_footer endRefreshing];
    [_goodsTabView.mj_header endRefreshing];
    [_shopTabView.mj_footer endRefreshing];
    [_shopTabView.mj_header endRefreshing];
    [_needTabView.mj_footer endRefreshing];
    [_needTabView.mj_header endRefreshing];
}




#pragma  mark ======= tableViewdelegate and datasource



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _goodsTabView) {
        return _dataArr1.count;
    }else if (tableView == _needTabView){
        
        return _dataArr3.count;
    }
    else{
        return _dataArr2.count;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _goodsTabView) {
        static NSString *cellid = @"goodsTabViewcell";
        MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MyCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if (_dataArr1.count >indexPath.row) {
            cell.dataDic = _dataArr1[indexPath.row];
            
        }
        cell.delegate = self;
        return cell;

    }else if (tableView == _needTabView){
        static NSString *cellid = @"needcell";
        MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MyCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if (_dataArr3.count >indexPath.row) {
            cell.needDic = _dataArr3[indexPath.row];

        }
        cell.delegate = self;
        return cell;

    }else {
        
        static NSString *cellid = @"shopcell";
        MyCollectionCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MyCollectionCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        if (_dataArr2.count >indexPath.row) {
            cell.shopDic = _dataArr2[indexPath.row];
            
        }
        cell.delegate = self;
        return cell;

    }
    
   

    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    if (_Type ==1) {
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否发送该收藏" preferredStyle:UIAlertControllerStyleAlert];
        [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSDictionary *dic;
            if (tableView == _goodsTabView) {
              NSDictionary *thedic = _dataArr1[indexPath.row];
                NSArray *arr =thedic[@"item"][@"specificationValues"];
                NSMutableString *connt = [[NSMutableString alloc]initWithString:@""];;
                if (arr.count<=0) {

                }else{
                    for (int i = 0; i<arr.count; i++) {
                        NSString *name =  arr[i][@"name"];
                        if (i != 0) {
                            [connt appendString:[NSString stringWithFormat:@",%@",name]];
                        }else{
                            [connt appendString:name];
                        }
                    }
                }
                dic = @{
                        @"title":thedic[@"item"][@"title"],
                        @"proId":thedic[@"item"][@"id"],
                        @"imageUrl":thedic[@"item"][@"imageUrlList"][0],
                        @"type":@"detail",
                        @"content":connt,
                        @"price":thedic[@"item"][@"price"]
                        };
                
            }else if (tableView == _shopTabView){
                NSDictionary *thedic = _dataArr2[indexPath.row];
                
                dic = @{
                        @"title":thedic[@"shopName"],
                        @"proId":thedic[@"id"],
                        @"imageUrl":thedic[@"shopLogoImageUrl"],
                        @"type":@"shop",
                        @"content":[NSString stringWithFormat:@"主营:%@",thedic[@"shopMainBusiness"]],
                        @"price":@""
                        };
                

            }else if (tableView == _needTabView){
                NSDictionary *thedic = _dataArr3[indexPath.row];
               dic = @{@"title":thedic[@"purchasingNeed"][@"title"],
                    @"proId":thedic[@"purchasingNeed"][@"id"],
                    @"imageUrl":thedic[@"purchasingNeed"][@"imageUrlList"][0],
                    @"price":@"",
                    @"content":[NSString stringWithFormat:@"数量：%@%@",thedic[@"purchasingNeed"][@"quantity"],thedic[@"purchasingNeed"][@"unit"]],
                    @"type":@"quote"
                    };
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:@"sendCollection" object:dic];
            [self.navigationController popViewControllerAnimated:YES];
        }]];
        [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        
        if (tableView == _goodsTabView) {
            NSDictionary *dic = _dataArr1[indexPath.row];
            ItemsModel  *model = [[ItemsModel alloc]init];
            model = [ItemsModel mj_objectWithKeyValues:dic[@"item"]];
            
            GoodsDetailViewController *devc = [[GoodsDetailViewController alloc]init];
            if ([model.shopCertificationType isEqualToString:@"1"]||!model.shopCertificationType||[model.shopCertificationType isEqualToString:@""]) {
                devc.shopType = 1; //个人
            }else{
                devc.shopType = 2; //商家
            }
            devc.itemModel = model;
            [self.navigationController pushViewController:devc animated:YES];
            
        }else if (tableView == _shopTabView){
            NSDictionary *dic = _dataArr2[indexPath.row];
            
            BusinessesShopViewController  *bussvc = [[BusinessesShopViewController alloc]init];
            bussvc.shopId = dic[@"id"];
            [self.navigationController pushViewController:bussvc animated:YES];
            
        }else if (tableView == _needTabView){
            NSDictionary *dic = _dataArr3[indexPath.row];
            
            OfferViewController *offVc = [[OfferViewController alloc]init];
            offVc.needId = dic[@"purchasingNeedId"];
            [self.navigationController pushViewController:offVc animated:YES];
        }

    }
    
    
   

}
#pragma  mark ======= celldelegate

-(void)didselectedGoingBtnWithShopId:(NSString *)ShopId{
    BusinessesShopViewController  *bussvc = [[BusinessesShopViewController alloc]init];
    bussvc.shopId =ShopId;
    [self.navigationController pushViewController:bussvc animated:YES];
}


-(void)didselectedDelegateBtnWithDic:(NSDictionary *)dic andType:(NSInteger)type{

    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定取消收藏么" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (type == 0) {
            [CollectePL userCancleCollectGoodsWithGoodsId:dic[@"itemId"] ndReturnBlock:^(id returnValue) {
                [_dataArr1 removeObject:dic];
                [self showTextHud:@"取消收藏成功"];
                [_goodsTabView reloadData];
            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];
            }];
            
            
        }else if (type == 2){
            NSDictionary *thedic = @{@"purchasingNeedId": dic[@"purchasingNeedId"]};
            
            [UserWantPL userCancleCollectNeedWithDic:thedic andReturnBlock:^(id returnValue) {
                [_dataArr3 removeObject:dic];
                [self showTextHud:@"取消收藏成功"];
                [_needTabView reloadData];
            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];

            }];
            
        }
        else{
            NSDictionary *infoDic = @{@"sellerId":dic[@"id"]};
            [CollectePL userCancleCollecteShopWithDic:infoDic andReturnBlock:^(id returnValue) {
                [_dataArr2 removeObject:dic];
                [self showTextHud:@"取消收藏成功"];
                [_shopTabView reloadData];
            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];
            }];
        }
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];

    
    
}
@end
