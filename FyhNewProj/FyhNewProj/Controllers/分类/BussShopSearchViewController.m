//
//  BussShopSearchViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BussShopSearchViewController.h"
#import "SearchProductCollectionCell.h"
#import "MJRefresh.h"
#import "ItemsModel.h"
#import "GoodsDetailViewController.h"
#import "MBProgressHUD+Add.h"
#import "GoodItemsNetModel.h"
#import "BussShowPL.h"

@interface BussShopSearchViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITextFieldDelegate>
@property (nonatomic, strong) UICollectionView *collectionview;
/**
 *  产品数组
 */
@property (nonatomic, strong) NSMutableArray *productArray;

@property (nonatomic, strong) NSMutableArray        *loadArray;

@property (nonatomic, assign) LoadWayType           loadWay;                //加载的方式
@end

@implementation BussShopSearchViewController{
    
    
    UITextField       *_searchTF;
}
-(UICollectionView *)collectionview
{
    if (_collectionview == nil)
    {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight-80) collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        _collectionview.backgroundColor = [UIColor clearColor];
        //注册Cell，必须要有
        [_collectionview registerClass:[SearchProductCollectionCell class] forCellWithReuseIdentifier:@"SearchProductCollectionCell"];
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(reLoadData)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _collectionview.mj_header = header;
        
        MJRefreshAutoNormalFooter *footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
        footer.stateLabel.textColor = [UIColor lightGrayColor];
        _collectionview.mj_footer = footer;
        _collectionview.mj_footer.hidden = YES;
        
    }
    return _collectionview;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe6e9ed);
    if (!_netModel) {
        _netModel = [[GoodItemsNetModel alloc]init];
        
    }
    if (self.searchStr) {
        _netModel.title = self.searchStr;
    }
    self.loadArray = [[NSMutableArray alloc]initWithCapacity:0];
    self.productArray = [[NSMutableArray alloc]initWithCapacity:0];
    [self setupUI];
    [self loadGoodsItems];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}
#pragma mark ========= 界面

- (void)setupUI{
    
    
    
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 80)];
    [self.view addSubview:topView];
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
    
    
    CGFloat searchViewWidth = ScreenWidth-60;
    UIView *searchView = [[UIView alloc]initWithFrame:CGRectMake(40, 30, searchViewWidth, 40)];
    searchView.layer.cornerRadius = 5;
    searchView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    searchView.clipsToBounds = YES;
    [topView addSubview:searchView];
    
    UIButton *searchImageBtn = [BaseViewFactory buttonWithWidth:25 imagePath:@"search"];
    [searchView addSubview:searchImageBtn];
    searchImageBtn.frame = CGRectMake(10, 7.5, 25, 25);
    
    UIButton *camBtn = [BaseViewFactory buttonWithWidth:25 imagePath:@"camera"];
    [searchView addSubview:camBtn];
    camBtn.frame = CGRectMake(searchViewWidth - 35, 10.5, 25, 19);
    
    _searchTF = [BaseViewFactory textFieldWithFrame:CGRectMake(45, 0, searchViewWidth - 90, 40) font:APPFONT(15) placeholder:@"寻找店铺内的商品" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    if (_searchStr.length >0) {
        _searchTF.text = _searchStr;
    }
    _searchTF.returnKeyType =UIReturnKeyDone;
    [searchView addSubview:_searchTF];
    
    
    
    
    
    UIImage *backImg= [UIImage imageNamed:@"back-white"];
    
    //    CGFloat height = 17;
    //    CGFloat width = height * backImg.size.width / backImg.size.height;
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 40, 40)];
    // [button setBackgroundImage:backImg forState:UIControlStateNormal];
    [button setImage:backImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(LeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button];
    
    
    
    [self.view addSubview:self.collectionview];
    
    
}


- (void)LeftButtonClickEvent{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)loadGoodsItems{
    NSDictionary *dic = @{@"itemPageNum":[NSString stringWithFormat:@"%ld",(long)_netModel.pageNum],
                          @"itemTitle":_netModel.title,
                          };
    
    [BussShowPL GetShopInfoWithShopID:_shopId andDic:dic andReturnBlock:^(id returnValue) {
//        NSDictionary *resultDic = returnValue[@"data"];
        self.loadArray = [ItemsModel mj_objectArrayWithKeyValuesArray:returnValue[@"items"]];
        [self loadSuccess];
        [self endLoading];
    } andErrorBlock:^(NSString *msg) {
        [self endLoading];
        [self showTextHud:msg];
    }];

}
- (void)loadSuccess
{
    [self setPageCount];
    if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
        [_productArray  removeAllObjects];
        [_collectionview  reloadData];
    }
    
    [_productArray addObjectsFromArray:self.loadArray];
    [_collectionview reloadData];
    if (self.loadArray.count < 30) {
        _collectionview.mj_footer.hidden = YES;
    } else {
        _collectionview.mj_footer.hidden = NO;
    }
    
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
    [_collectionview.mj_footer endRefreshing];
    [_collectionview.mj_header endRefreshing];
}
- (void)reLoadData
{
    //全部
    _netModel.pageNum = 1;
    self.loadWay = RELOAD_DADTAS;
    [self loadGoodsItems];
}
- (void)loadMoreData
{
    self.loadWay = LOAD_MORE_DATAS;
    [self loadGoodsItems];
    
}
#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.productArray.count;
    
    
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"SearchProductCollectionCell";
    SearchProductCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    //    NSDictionary *dic = self.productArray[indexPath.row];
    //    [cell setDataDic:dic];
    // cell.productByFidModel = self.productArray[indexPath.row];
    cell.model = self.productArray[indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = (ScreenWidth-15)/2;
    if (iPad) {
        return CGSizeMake(itemW, 305*TimeScaleY);
        
    }
    return CGSizeMake(itemW, 305);
}

//定义每个UICollectionView 的 margin//定义每个Section的四边间距

/*UIEdgeInsets UIEdgeInsetsMake (
 CGFloat top,
 CGFloat left,
 CGFloat bottom,
 CGFloat right
 );*/
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(12, 5, 0, 5);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 12;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 5;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    ItemsModel  *model = self.productArray[indexPath.row];
    
    GoodsDetailViewController *devc = [[GoodsDetailViewController alloc]init];
    if ([model.shopCertificationType isEqualToString:@"1"]||!model.shopCertificationType||[model.shopCertificationType isEqualToString:@""]) {
        devc.shopType = 1; //个人
    }else{
        devc.shopType = 2; //商家
    }
    devc.itemModel = model;
    [self.navigationController pushViewController:devc animated:YES];
}


- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    if (_searchTF.text.length>0) {
        _netModel.title = _searchTF.text;
        _netModel.pageNum = 1;
        _netModel.sort = @"";
        _netModel.categoryId = @"";
        self.loadWay = RELOAD_DADTAS;
        [self loadGoodsItems];
    }
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}
@end
