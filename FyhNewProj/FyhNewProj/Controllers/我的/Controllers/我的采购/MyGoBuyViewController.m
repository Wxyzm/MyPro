//
//  MyGoBuyViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyGoBuyViewController.h"
#import "MyGoBuyCell.h"

#import "MyNeedsNetModel.h"
#import "MyNeedsModel.h"
#import "UserWantPL.h"
#import "MJRefresh.h"
#import "AppDelegate.h"
#import "MenueView.h"
#import "ChatListViewController.h"
#import "DOTabBarController.h"
#import "demandViewController.h"
#import "MyBuyDetailViewController.h"
#import "PublicWantPL.h"
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



@interface MyGoBuyViewController ()<UITableViewDelegate,UITableViewDataSource,MyGoBuyCellDelegate,MenueViewDelegate>

@property (nonatomic , strong) UIScrollView *bgScrollView;

@property (nonatomic,strong)UITableView *AllTabView;           //全部

@property (nonatomic,strong)UITableView *GoOnTabView;          //进行中

@property (nonatomic,strong)UITableView *GoPriceTabView;       //报价中

@property (nonatomic,strong)UITableView *CompTabView;          //已完成

@property (nonatomic,strong)UITableView *TestTabView;          //审核中

@property (nonatomic, assign) LoadWayTypes       loadWay;    //加载的方式
@property (nonatomic, strong) NSMutableArray           *loadArray;

@property (nonatomic , strong) MenueView *menuView;

@end

@implementation MyGoBuyViewController{
    
    NSMutableArray *_btnArr;
    NSMutableArray *_dataArr0;
    NSMutableArray *_dataArr1;
    NSMutableArray *_dataArr2;
    NSMutableArray *_dataArr3;
    NSMutableArray *_dataArr4;
   
    MyNeedsNetModel *_model0;
    MyNeedsNetModel *_model1;
    MyNeedsNetModel *_model2;
    MyNeedsNetModel *_model3;
    MyNeedsNetModel *_model4;

}

#pragma  mark =======  view
-(UIScrollView *)bgScrollView{
    if (!_bgScrollView) {
        _bgScrollView = [[BaseScrollView alloc] initWithFrame:CGRectMake(0, 39, ScreenWidth,ScreenHeight-64-39)];
        _bgScrollView.backgroundColor = UIColorFromRGB(LineColorValue);
        _bgScrollView.showsVerticalScrollIndicator = NO;
        _bgScrollView.showsHorizontalScrollIndicator = NO;
        _bgScrollView.bounces = NO;
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

-(UITableView *)AllTabView{
    
    if (!_AllTabView) {
        _AllTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 12, ScreenWidth,ScreenHeight-115) style:UITableViewStylePlain];
        //_AllTabView.bounces = NO;
        _AllTabView.delegate = self;
        _AllTabView.dataSource = self;
        _AllTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
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

-(UITableView *)GoOnTabView{
    
    if (!_GoOnTabView) {
        _GoOnTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth, 12, ScreenWidth,ScreenHeight-115) style:UITableViewStylePlain];
        //_GoOnTabView.bounces = NO;
        _GoOnTabView.delegate = self;
        _GoOnTabView.dataSource = self;
        _GoOnTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _GoOnTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _GoOnTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _GoOnTabView.mj_footer = footer;
        _GoOnTabView.mj_footer.hidden = YES;
    }
    return _GoOnTabView;
    
}


-(UITableView *)GoPriceTabView{
    
    if (!_GoPriceTabView) {
        _GoPriceTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*2, 12, ScreenWidth,ScreenHeight-115) style:UITableViewStylePlain];
        //_GoPriceTabView.bounces = NO;
        _GoPriceTabView.delegate = self;
        _GoPriceTabView.dataSource = self;
        _GoPriceTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _GoPriceTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _GoPriceTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _GoPriceTabView.mj_footer = footer;
        _GoPriceTabView.mj_footer.hidden = YES;
    }
    return _GoPriceTabView;
    
}
-(UITableView *)CompTabView{
    
    if (!_CompTabView) {
        _CompTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*3, 12, ScreenWidth,ScreenHeight-115) style:UITableViewStylePlain];
       // _CompTabView.bounces = NO;
        _CompTabView.delegate = self;
        _CompTabView.dataSource = self;
        _CompTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _CompTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _CompTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _CompTabView.mj_footer = footer;
        _CompTabView.mj_footer.hidden = YES;
    }
    return _CompTabView;
    
}
-(UITableView *)TestTabView{
    
    if (!_TestTabView) {
        _TestTabView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth*4, 12, ScreenWidth,ScreenHeight-115) style:UITableViewStylePlain];
        //_TestTabView.bounces = NO;
        _TestTabView.delegate = self;
        _TestTabView.dataSource = self;
        _TestTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _TestTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _TestTabView.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _TestTabView.mj_footer = footer;
        _TestTabView.mj_footer.hidden = YES;
    }
    return _TestTabView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.navigationItem.title = @"我的采购";
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshtableview:)
                                                 name:@"userNeedsHaveChanged"
                                               object:nil];
 

    [self creatrRightBtnItem];

    [self initData];
    [self initUI];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth*(btn.tag - 1000),0) animated:NO];

        }
    }

    self.navigationController.navigationBar.hidden = NO;
}


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


- (void)initData{
    
    
    self.loadArray = [[NSMutableArray alloc]init];
    _btnArr = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr0 = [[NSMutableArray alloc]initWithCapacity:0];

    _dataArr1 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr2 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr3 = [[NSMutableArray alloc]initWithCapacity:0];
    _dataArr4 = [[NSMutableArray alloc]initWithCapacity:0];
    _model0 = [[MyNeedsNetModel alloc]init];
    _model0.status = @"";
    _model1 = [[MyNeedsNetModel alloc]init];
    _model1.status = @"4";
    _model2 = [[MyNeedsNetModel alloc]init];
    _model2.status = @"6";
    _model3 = [[MyNeedsNetModel alloc]init];
    _model3.status = @"9";
    _model4 = [[MyNeedsNetModel alloc]init];
    _model4.status = @"1";



}


- (void)initUI{
    NSArray *arr = @[@"全部",@"进行中",@"报价中",@"已完成",@"审核中"];
    for (int i = 0; i<5; i++) {
        YLButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:arr[i] forState:UIControlStateNormal];
        btn.titleLabel.font = APPFONT(15);
        btn.tag = 1000+i;
        [btn addTarget:self action:@selector(caigoBtnclick:) forControlEvents:UIControlEventTouchUpInside];
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
    
    [self.bgScrollView addSubview:self.AllTabView];
    [self.bgScrollView addSubview:self.GoOnTabView];
    [self.bgScrollView addSubview:self.GoPriceTabView];
    [self.bgScrollView addSubview:self.CompTabView];
    [self.bgScrollView addSubview:self.TestTabView];
    [self loadAllNeedsData];
    self.loadWay = START_LOAD_FIRST1;
}


#pragma  mark ======= 按钮点击方法

- (void)rightbuttonClickEvent{

    self.menuView.OriginY = 60;
    [self.menuView show];



}


- (void)caigoBtnclick:(YLButton *)button{

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
                if (_dataArr0.count>0) {
                    
                }else{
                    [self loadAllNeedsData];

                }
            }else if (btn.tag == 1001){
                //进行中
                if (_dataArr1.count>0) {
                    
                }else{
                    [self loadAllNeedsData];
                    
                }
            }else if (btn.tag == 1002){
                //报价中
                if (_dataArr2.count>0) {
                    
                }else{
                    [self loadAllNeedsData];
                    
                }
            }else if (btn.tag == 1003){
                //已完成
                if (_dataArr3.count>0) {
                    
                }else{
                    [self loadAllNeedsData];
                    
                }
            }else if (btn.tag == 1004){
                //审核中
                if (_dataArr4.count>0) {
                    
                }else{
                    [self loadAllNeedsData];
                    
                }
            }
        }
    }
    [self.bgScrollView setContentOffset:CGPointMake(ScreenWidth*(button.tag - 1000),0) animated:NO];

}
#pragma  mark ======= tableViewdelegate and datasource



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _AllTabView) {
        return _dataArr0.count;
    }else if (tableView == _GoOnTabView){
        return _dataArr1.count;

    }else if (tableView == _GoPriceTabView){
        return _dataArr2.count;

    }else if (tableView == _CompTabView){
        return _dataArr3.count;

    }else{
        return _dataArr4.count;

    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _AllTabView) {
        static NSString *cellid = @"allcell";
        MyGoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MyGoBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.bgscrollView.contentSize = CGSizeMake(10, 10);
        [cell.bgscrollView setContentOffset:CGPointMake(0,0) animated:NO];
        MyNeedsModel *model = _dataArr0[indexPath.row];
        cell.model = model;
        cell.delegate = self;

        return cell;
        
    }else if (tableView == _GoOnTabView){
        static NSString *cellid = @"GoOncell";
        MyGoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MyGoBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.bgscrollView.contentSize = CGSizeMake(10, 10);
        [cell.bgscrollView setContentOffset:CGPointMake(0,0) animated:NO];
        MyNeedsModel *model = _dataArr1[indexPath.row];
        cell.model = model;
        cell.delegate = self;

        return cell;
    }else if (tableView == _GoPriceTabView){
        static NSString *cellid = @"GoPricecell";
        MyGoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MyGoBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.acceptBtn.hidden = NO;
        cell.bgscrollView.contentSize = CGSizeMake(10, 10);
        [cell.bgscrollView setContentOffset:CGPointMake(0,0) animated:NO];
        MyNeedsModel *model = _dataArr2[indexPath.row];
        cell.model = model;
        cell.delegate = self;

        return cell;
    }else if (tableView == _CompTabView){
        static NSString *cellid = @"Compcell";
        MyGoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MyGoBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        cell.bgscrollView.contentSize = CGSizeMake(10, 10);
        [cell.bgscrollView setContentOffset:CGPointMake(0,0) animated:NO];
        MyNeedsModel *model = _dataArr3[indexPath.row];
        cell.model = model;
        cell.delegate = self;

        return cell;
    }else{
        static NSString *cellid = @"testcell";
        MyGoBuyCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[MyGoBuyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
        }
        [cell.bgscrollView setContentOffset:CGPointMake(0,0) animated:NO];
        MyNeedsModel *model = _dataArr4[indexPath.row];
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
    
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//   
//    MyBuyDetailViewController *deVc = [[MyBuyDetailViewController alloc]init];
//    MyNeedsModel *model ;
//    if (tableView == _AllTabView) {
//      model  = _dataArr0[indexPath.row];
//    }else if (tableView == _GoOnTabView){
//        model = _dataArr1[indexPath.row];
//        
//    }else if (tableView == _GoPriceTabView){
//       model = _dataArr2[indexPath.row];
//        
//    }else if (tableView == _CompTabView){
//        model = _dataArr3[indexPath.row];
//        
//    }else{
//        model = _dataArr4[indexPath.row];
//        
//    }
//    deVc.needId = model.needsId;
//    [self.navigationController pushViewController:deVc animated:YES];
//}


#pragma mark ======= 左滑删除

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView != _TestTabView) {
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
   
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            if (tableView == _AllTabView) {
                MyNeedsModel *model = _dataArr0[indexPath.row];
                [UserWantPL userDeleteNeedWithNeedId:model.needsId andReturnBlock:^(id returnValue) {
                    // 删除数据源的数据,self.cellData是你自己的数据
                    [_dataArr0 removeObjectAtIndex:indexPath.row];
                    // 删除列表中数据
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self havedeletedNeedWithModelId:model.needsId];
                } andErrorBlock:^(NSString *msg) {
                    [self showTextHud:@"删除失败"];
                }];
            }else if (tableView == _GoOnTabView){
                MyNeedsModel *model = _dataArr1[indexPath.row];
                [UserWantPL userDeleteNeedWithNeedId:model.needsId andReturnBlock:^(id returnValue) {
                    // 删除数据源的数据,self.cellData是你自己的数据
                    [_dataArr1 removeObjectAtIndex:indexPath.row];
                    // 删除列表中数据
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self havedeletedNeedWithModelId:model.needsId];
                } andErrorBlock:^(NSString *msg) {
                    [self showTextHud:@"删除失败"];
                }];
            }else if (tableView == _GoPriceTabView){
                MyNeedsModel *model = _dataArr2[indexPath.row];
                [UserWantPL userDeleteNeedWithNeedId:model.needsId andReturnBlock:^(id returnValue) {
                    // 删除数据源的数据,self.cellData是你自己的数据
                    [_dataArr2 removeObjectAtIndex:indexPath.row];
                    // 删除列表中数据
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self havedeletedNeedWithModelId:model.needsId];
                } andErrorBlock:^(NSString *msg) {
                    [self showTextHud:@"删除失败"];
                }];

            }else if (tableView == _CompTabView){
                MyNeedsModel *model = _dataArr3[indexPath.row];
                [UserWantPL userDeleteNeedWithNeedId:model.needsId andReturnBlock:^(id returnValue) {
                    // 删除数据源的数据,self.cellData是你自己的数据
                    [_dataArr3 removeObjectAtIndex:indexPath.row];
                    // 删除列表中数据
                    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self havedeletedNeedWithModelId:model.needsId];
                } andErrorBlock:^(NSString *msg) {
                    [self showTextHud:@"删除失败"];
                }];
            }
           }
    
}
#pragma mark =======  cell代理


- (void)didSelectedBgBtnWithcell:(MyGoBuyCell *)cell{

    MyBuyDetailViewController *deVc = [[MyBuyDetailViewController alloc]init];
        deVc.needId = cell.model.needsId;
    [self.navigationController pushViewController:deVc animated:YES];
}

-(void)didSelectedacceptWithcell:(MyGoBuyCell *)cell{

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定接受商家报价？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [PublicWantPL UserAcceptNeedwithPricewithId:cell.model.needsId WithReturnBlock:^(id returnValue) {
            [self showTextHud:@"您已成功接受商家报价"];
            [self reLoadData];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}
/**
 删除

 @param cell 删除
 */
-(void)didSelectedDeleteBtnWithcell:(MyGoBuyCell *)cell{

    [UserWantPL userDeleteNeedWithNeedId:cell.priceDic[@"id"] andReturnBlock:^(id returnValue) {
        // 删除数据源的数据,self.cellData是你自己的数据
        [_dataArr4 removeObject:cell.model];
        // 删除列表中数据
        [self havedeletedNeedWithModelId:cell.model.needsId];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:@"删除失败"];
    }];
}
/**
 编辑

 @param cell cell
 */
-(void)didSelectedEditBtnWithcell:(MyGoBuyCell *)cell{

    demandViewController *deVc = [[demandViewController alloc]init];
    deVc.model = cell.model;
    deVc.type = 2;
    [self.navigationController  pushViewController:deVc animated:YES];
}

- (void)havedeletedNeedWithModelId:(NSString *)needID{

    NSMutableArray *data0 = [_dataArr0 mutableCopy];
    for (MyNeedsModel *model in data0) {
        if ([model.needsId isEqualToString:needID]) {
            [_dataArr0 removeObject:model];
        }
    }
    NSMutableArray *data1 = [_dataArr1 mutableCopy];
    for (MyNeedsModel *model in data1) {
        if ([model.needsId isEqualToString:needID]) {
            [_dataArr1 removeObject:model];
        }
    }
    NSMutableArray *data2 = [_dataArr2 mutableCopy];
    for (MyNeedsModel *model in data2) {
        if ([model.needsId isEqualToString:needID]) {
            [_dataArr2 removeObject:model];
        }
    }
    NSMutableArray *data3 = [_dataArr3 mutableCopy];
    for (MyNeedsModel *model in data3) {
        if ([model.needsId isEqualToString:needID]) {
            [_dataArr3 removeObject:model];
        }
    }
    NSMutableArray *data4 = [_dataArr4 mutableCopy];
    for (MyNeedsModel *model in data4) {
        if ([model.needsId isEqualToString:needID]) {
            [_dataArr4 removeObject:model];
        }
    }
    [self reloadTableview];


}

- (void)reloadTableview{
    [_AllTabView reloadData];
    [_GoOnTabView reloadData];
    [_GoPriceTabView reloadData];
    [_CompTabView reloadData];
    [_TestTabView reloadData];
}


#pragma mark ======= 网络请求

/**
 加载全部
 */
- (void)loadAllNeedsData{
    NSDictionary *dic;
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            if (btn.tag == 1000) {
               dic = @{
                    @"pageNum":@(_model0.pageNum),
                    @"title":@"",
                    @"status":@"",
                    @"categoryId":@"",
                    @"sort":@""
                    };
            }else if (btn.tag == 1001){
                //进行中
                dic = @{
                        @"pageNum":@(_model1.pageNum),
                        @"title":@"",
                        @"status":_model1.status,
                        @"categoryId":@"",
                        @"sort":@""
                        };
            }else if (btn.tag == 1002){
                //报价中
                dic = @{
                        @"pageNum":@(_model2.pageNum),
                        @"title":@"",
                        @"status":_model2.status,
                        @"categoryId":@"",
                        @"sort":@""
                        };

            }else if (btn.tag == 1003){
                //已完成
                dic = @{
                        @"pageNum":@(_model3.pageNum),
                        @"title":@"",
                        @"status":_model3.status,
                        @"categoryId":@"",
                        @"sort":@""
                        };

            }else if (btn.tag == 1004){
                //审核中
                dic = @{
                        @"pageNum":@(_model4.pageNum),
                        @"title":@"",
                        @"status":_model4.status,
                        @"categoryId":@"",
                        @"sort":@""
                        };

            }
        }
    }

    
[UserWantPL userLookPurchasingneedWithDic:dic andReturnBlock:^(id returnValue) {
    NSDictionary *resultDic = returnValue[@"data"];
    self.loadArray = [MyNeedsModel mj_objectArrayWithKeyValuesArray:resultDic[@"purchasingNeedList"]];
     [self loadSuccess];
     [self endLoading];
} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];
    [self endLoading];
}];
}

#pragma mark ======= 下拉刷新，上啦加载设置

- (void)loadSuccess
{
    [self setPageCount];
    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            if (btn.tag == 1000) {
                //全部
                if (self.loadWay == START_LOAD_FIRST1 || self.loadWay == RELOAD_DADTAS1) {
                    [_dataArr0  removeAllObjects];
                }
                
                [_dataArr0 addObjectsFromArray:self.loadArray];
                [_AllTabView reloadData];
                if (self.loadArray.count < 30) {
                    _AllTabView.mj_footer.hidden = YES;
                } else {
                    _AllTabView.mj_footer.hidden = NO;
                }

            }else if (btn.tag == 1001){
                //进行中
                if (self.loadWay == START_LOAD_FIRST2 || self.loadWay == RELOAD_DADTAS2) {
                    [_dataArr1  removeAllObjects];
                }
                
                [_dataArr1 addObjectsFromArray:self.loadArray];
                [_GoOnTabView reloadData];
                if (self.loadArray.count < 30) {
                    _GoOnTabView.mj_footer.hidden = YES;
                } else {
                    _GoOnTabView.mj_footer.hidden = NO;
                }

            }else if (btn.tag == 1002){
                //报价中
                if (self.loadWay == START_LOAD_FIRST3 || self.loadWay == RELOAD_DADTAS3) {
                    [_dataArr2  removeAllObjects];
                }
                
                [_dataArr2 addObjectsFromArray:self.loadArray];
                [_GoPriceTabView reloadData];
                if (self.loadArray.count < 30) {
                    _GoPriceTabView.mj_footer.hidden = YES;
                } else {
                    _GoPriceTabView.mj_footer.hidden = NO;
                }

            }else if (btn.tag == 1003){
                //已完成
                if (self.loadWay == START_LOAD_FIRST4 || self.loadWay == RELOAD_DADTAS4) {
                    [_dataArr3  removeAllObjects];
                }
                
                [_dataArr3 addObjectsFromArray:self.loadArray];
                [_CompTabView reloadData];
                if (self.loadArray.count < 30) {
                    _CompTabView.mj_footer.hidden = YES;
                } else {
                    _CompTabView.mj_footer.hidden = NO;
                }

            }else if (btn.tag == 1004){
               //审核中
                if (self.loadWay == START_LOAD_FIRST5 || self.loadWay == RELOAD_DADTAS5) {
                    [_dataArr4  removeAllObjects];
                }
                
                [_dataArr4 addObjectsFromArray:self.loadArray];
                [_TestTabView reloadData];
                if (self.loadArray.count < 30) {
                    _TestTabView.mj_footer.hidden = YES;
                } else {
                    _TestTabView.mj_footer.hidden = NO;
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
                        _model0.pageNum = 1;
                    }
                    _model0.pageNum ++;
                }

            }else if (btn.tag == 1001){
                //进行中
                if (self.loadArray.count > 0 )
                {
                    if (self.loadWay != LOAD_MORE_DATAS2)
                    {
                        _model1.pageNum = 1;
                    }
                    _model1.pageNum ++;
                }

            }else if (btn.tag == 1002){
                //报价中
                if (self.loadArray.count > 0 )
                {
                    if (self.loadWay != LOAD_MORE_DATAS3)
                    {
                        _model2.pageNum = 1;
                    }
                    _model2.pageNum ++;
                }

            }else if (btn.tag == 1003){
                //已完成
                if (self.loadArray.count > 0 )
                {
                    if (self.loadWay != LOAD_MORE_DATAS4)
                    {
                        _model3.pageNum = 1;
                    }
                    _model3.pageNum ++;
                }

            }else if (btn.tag == 1004){
                //审核中
                if (self.loadArray.count > 0 )
                {
                    if (self.loadWay != LOAD_MORE_DATAS5)
                    {
                        _model4.pageNum = 1;
                    }
                    _model4.pageNum ++;
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
                _model0.pageNum = 1;
                self.loadWay = RELOAD_DADTAS1;
                [self loadAllNeedsData];
                
            }else if (btn.tag == 1001){
                //进行中
                _model1.pageNum = 1;
                self.loadWay = RELOAD_DADTAS2;
                [self loadAllNeedsData];
            }else if (btn.tag == 1002){
                //报价中
                _model2.pageNum = 1;
                self.loadWay = RELOAD_DADTAS3;
                [self loadAllNeedsData];
            }else if (btn.tag == 1003){
                //已完成
                _model3.pageNum = 1;
                self.loadWay = RELOAD_DADTAS4;
                [self loadAllNeedsData];
            }else if (btn.tag == 1004){
                //审核中
                _model4.pageNum = 1;
                self.loadWay = RELOAD_DADTAS5;
                [self loadAllNeedsData];
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
                [self loadAllNeedsData];
                
            }else if (btn.tag == 1001){
                //进行中
                self.loadWay = LOAD_MORE_DATAS2;
                [self loadAllNeedsData];
            }else if (btn.tag == 1002){
                //报价中
                self.loadWay = LOAD_MORE_DATAS3;
                [self loadAllNeedsData];
            }else if (btn.tag == 1003){
                //已完成
                self.loadWay = LOAD_MORE_DATAS4;
                [self loadAllNeedsData];
            }else if (btn.tag == 1004){
                //审核中
                self.loadWay = LOAD_MORE_DATAS5;
                [self loadAllNeedsData];
            }
        }
    }
    

}

- (void)endLoading{

    for (YLButton *btn in _btnArr) {
        if (btn.on) {
            if (btn.tag == 1000) {
                //全部
                [_AllTabView.mj_footer endRefreshing];
                [_AllTabView.mj_header endRefreshing];
            }else if (btn.tag == 1001){
                //进行中
                [_GoOnTabView.mj_footer endRefreshing];
                [_GoOnTabView.mj_header endRefreshing];
            }else if (btn.tag == 1002){
                //报价中
                [_GoPriceTabView.mj_footer endRefreshing];
                [_GoPriceTabView.mj_header endRefreshing];
            }else if (btn.tag == 1003){
                //已完成
                [_CompTabView.mj_footer endRefreshing];
                [_CompTabView.mj_header endRefreshing];
            }else if (btn.tag == 1004){
                //审核中
                [_TestTabView.mj_footer endRefreshing];
                [_TestTabView.mj_header endRefreshing];
                
            }
        }
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

#pragma mark -------- 通知
- (void)refreshtableview:(NSNotification*)notificaition{
    [_dataArr0 removeAllObjects];
    [_AllTabView reloadData];
    _model0.pageNum = 1;
    [self reLoadData];

}


@end
