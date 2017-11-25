//
//  BusinessesShopViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BusinessesShopViewController.h"
#import "GoodsDetailViewController.h"
#import "SearchResultViewController.h"
#import "SearchRTopView.h"
#import "MJRefresh.h"
#import "BusinProCell.h"
#import "BussShowPL.h"
#import "ItemsModel.h"
#import "CollectePL.h"

#import "AppDelegate.h"
#import "MenueView.h"
#import "ChatListViewController.h"
#import "DOTabBarController.h"
#import "BusIntroController.h"
#import "xxxxViewController.h"
#import "BussShopSearchViewController.h"

@interface BusinessesShopViewController ()<MenueViewDelegate,UITextFieldDelegate,SearchRTopViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) NSMutableArray           *loadArray;

@property (nonatomic, assign) LoadWayType       loadWay;    //加载的方式

@property (nonatomic , strong) YLButton *collectedBtn;      //已收藏

@property (nonatomic , strong) YLButton *gotoCollectBtn;      //未收藏

@property (nonatomic , strong) YLButton *rightBtn;           //右侧按钮收藏


@property (nonatomic , strong) MenueView *menuView;

@property (nonatomic , strong) UIView *connectView;


@end

@implementation BusinessesShopViewController{

    UITextField       *_searchTF;
    NSMutableArray    *_dataArr;
    UIImageView       *_faceImageView;
    UILabel           *_nameLab;
    UILabel           *_saleKindLab;
//    UIButton          *_collectBtn;
    NSDictionary      *_resultDic;
    NSInteger         _itemPageNum;
    BOOL              _isCurrentUserCollectedShop;  //是否已收藏
    
}
-(MenueView *)menuView{
    if (!_menuView) {
        _menuView = [[MenueView alloc]init];
        _menuView.delegate = self;
    }
    
    return _menuView;
    
}

-(UIView *)connectView{
    

    if (!_connectView) {
        //
        _connectView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 39-iPhoneX_DOWNHEIGHT, ScreenWidth, 39)];
        _connectView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        //
        SubBtn *introBtn = [SubBtn buttonWithtitle:@"商家简介" backgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(0x434a54) cornerRadius:0 andtarget:self action:@selector(introBtnClick)];
        introBtn.titleLabel.font = APPFONT(15);
        [_connectView addSubview:introBtn];
        introBtn.frame = CGRectMake(0, 0, ScreenWidth/2, 39);
        //
        SubBtn *connectBtn = [SubBtn buttonWithtitle:@"联系客服" backgroundColor:UIColorFromRGB(WhiteColorValue) titlecolor:UIColorFromRGB(0x434a54) cornerRadius:0 andtarget:self action:@selector(connectBtnClick)];
        connectBtn.titleLabel.font = APPFONT(15);
        [_connectView addSubview:connectBtn];
        connectBtn.frame = CGRectMake(ScreenWidth/2, 0, ScreenWidth/2, 39);
        //
        [self createLineWithColor:UIColorFromRGB(0xccd1d9) frame:CGRectMake(0, 0, ScreenWidth, 1) Super:_connectView];
        //
        [self createLineWithColor:UIColorFromRGB(0xccd1d9) frame:CGRectMake(ScreenWidth/2-0.5, 0, 1, 39) Super:_connectView];
    }
    
    return _connectView;
    
    
}

-(YLButton *)collectedBtn{

    if (!_collectedBtn) {
        _collectedBtn  = [YLButton buttonWithType:UIButtonTypeCustom];
        [_collectedBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        [_collectedBtn setTitle:@"已收藏" forState:UIControlStateNormal];
        _collectedBtn.imageRect = CGRectMake(12, 7, 16, 16);
        _collectedBtn.titleRect = CGRectMake(28, 0, 40, 30);
        _collectedBtn.titleLabel.font = APPFONT(12);
        _collectedBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _collectedBtn.frame = CGRectMake(ScreenWidth - 100, 55, 80, 30);
        _collectedBtn.layer.cornerRadius = 5;
        [_collectedBtn addTarget:self action:@selector(CollectBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _collectedBtn.clipsToBounds = YES;
        _collectedBtn.backgroundColor = UIColorFromRGB(RedColorValue);
//        //  创建 CAGradientLayer 对象
//        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
//        //  设置 gradientLayer 的 Frame
//        gradientLayer.frame = _collectedBtn.bounds;
//        //  gradientLayer.cornerRadius = 10;
//        //  创建渐变色数组，需要转换为CGColor颜色
//        gradientLayer.colors = @[(id)UIColorFromRGB(0xff2d66).CGColor,
//                                 (id)UIColorFromRGB(0xff4452).CGColor,
//                                 (id)UIColorFromRGB(0xff5d3b).CGColor];
//        //  设置三种颜色变化点，取值范围 0.0~1.0
//        gradientLayer.locations = @[@(0.1f) ,@(0.5f),@(1.0f)];
//        
//        //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
//        gradientLayer.startPoint = CGPointMake(0, 0);
//        gradientLayer.endPoint = CGPointMake(1, 0);
//        
//        //  添加渐变色到创建的 UIView 上去
//        [_collectedBtn.layer addSublayer:gradientLayer];
    }
    
    return _collectedBtn;
}
-(YLButton *)gotoCollectBtn{
    if (!_gotoCollectBtn) {
        _gotoCollectBtn  = [YLButton buttonWithType:UIButtonTypeCustom];
        [_gotoCollectBtn setImage:[UIImage imageNamed:@"collect"] forState:UIControlStateNormal];
        [_gotoCollectBtn setTitle:@"收藏" forState:UIControlStateNormal];
        _gotoCollectBtn.imageRect = CGRectMake(12, 7, 16, 16);
        _gotoCollectBtn.titleRect = CGRectMake(28, 0, 40, 30);
        _gotoCollectBtn.titleLabel.font = APPFONT(12);
        _gotoCollectBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _gotoCollectBtn.frame = CGRectMake(ScreenWidth - 100, 55, 80, 30);
        _gotoCollectBtn.backgroundColor = UIColorFromRGB(PlaColorValue);
        _gotoCollectBtn.layer.cornerRadius = 5;
        [_gotoCollectBtn addTarget:self action:@selector(CollectBtnClick) forControlEvents:UIControlEventTouchUpInside];

    }
    return _gotoCollectBtn;
}


-(UICollectionView *)collectionview{

    if (!_collectionview) {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 80, ScreenWidth, ScreenHeight-80-39) collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        _collectionview.backgroundColor = [UIColor clearColor];
        //注册Cell，必须要有
        [_collectionview registerClass:[BusinProCell class] forCellWithReuseIdentifier:@"BusinProCell"];
        //注册头视图
        [_collectionview registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"BusinProCellHeader"];
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


-(UIView *)topView{
    if (!_topView) {
        _topView  = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 202)];
        _topView.backgroundColor  = UIColorFromRGB(0xe6e9ed);
        
        UIImageView *colorImageView = [BaseViewFactory icomWithWidth:ScreenWidth imagePath:@"shop_topImage"];
        [_topView addSubview:colorImageView];
        colorImageView.frame = CGRectMake(0, 0, ScreenWidth, 100);
        
        UIView *downView = [BaseViewFactory viewWithFrame:CGRectMake(0, 112, ScreenWidth, 50) color:UIColorFromRGB(WhiteColorValue)];
        [_topView addSubview:downView];
        
        UIImageView *quanImage = [BaseViewFactory icomWithWidth:25 imagePath:@"coupon"];
        [downView addSubview:quanImage];
        quanImage.frame = CGRectMake(20, 15, 25, 20);
        
        UILabel *quanLab = [BaseViewFactory labelWithFrame:CGRectMake(50, 0, 100, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(20) textAligment:NSTextAlignmentLeft andtext:@"优惠券"];
        [downView addSubview:quanLab];
        
        UIImageView *rightImage = [BaseViewFactory icomWithWidth:10 imagePath:@"right"];
        rightImage.frame = CGRectMake(ScreenWidth - 30, 17, 10, 16);
        [downView addSubview:rightImage];
        
        [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:downView Frame:CGRectMake(ScreenWidth - 185, 0, 150, 50) Alignment:NSTextAlignmentRight Text:@"更多优惠券"];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [downView addSubview:button ];
        button.frame = CGRectMake(0, 0, ScreenWidth, 50);
        [button addTarget:self action:@selector(moreCouponBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:_topView Frame:CGRectMake(20, 162, 150, 50) Alignment:NSTextAlignmentLeft Text:@"全部商品"];
        
        
        _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 50, 50)];
        [_faceImageView setContentMode:UIViewContentModeScaleAspectFill];
        _faceImageView.clipsToBounds = YES;
        [_topView addSubview:_faceImageView];
        
        _nameLab = [BaseViewFactory labelWithFrame:CGRectMake(80, 47, ScreenWidth - 140, 15) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
        [_topView addSubview:_nameLab];

        _saleKindLab = [BaseViewFactory labelWithFrame:CGRectMake(80, 71, ScreenWidth - 180, 13) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(12) textAligment:NSTextAlignmentLeft andtext:@""];
        [_topView addSubview:_saleKindLab];
        
        
    }

    return _topView;
}

#pragma mark ========= viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe6e9ed);
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _loadArray = [NSMutableArray arrayWithCapacity:0];
    _itemPageNum = 1;
    [self setupUI];
    self.loadWay = START_LOAD_FIRST;

    [self loadShopInfo];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;

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
    
    
    CGFloat searchViewWidth = ScreenWidth-80;
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
    _searchTF.returnKeyType =UIReturnKeyDone;
    [searchView addSubview:_searchTF];
    
    
    
    UIImage *rightImg= [UIImage imageNamed:@"more-white"];
    UIButton* rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 40, 30, 40, 40)];
    [rightbutton setImage:rightImg forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightbuttonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:rightbutton];

    
    
    UIImage *backImg= [UIImage imageNamed:@"back-white"];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 40, 40)];
    [button setImage:backImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(LeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:button];
    
    
    
    [self.view addSubview:self.collectionview];
    [self.view addSubview:self.connectView];
    
}


- (void)loadShopInfo{

    NSDictionary *dic = @{@"itemPageNum":[NSString stringWithFormat:@"%ld",(long)_itemPageNum],
                          @"itemTitle":@"",
                          @"itemCategoryId":@""
                          };
    
    [BussShowPL GetShopInfoWithShopID:_shopId andDic:dic andReturnBlock:^(id returnValue) {
        _resultDic = returnValue;
        _isCurrentUserCollectedShop = [returnValue[@"shopInfo"][@"isCurrentUserCollectedShop"] boolValue];
        [self IsCollected];
        self.loadArray = [ItemsModel mj_objectArrayWithKeyValuesArray:returnValue[@"items"]];
        [self loadSuccess];
        [self endLoading];
} andErrorBlock:^(NSString *msg) {
    [self endLoading];
    [self showTextHud:msg];
}];


}

#pragma mark ======== 收藏取消收藏

- (void)CollectBtnClick{
    NSDictionary *dic = @{@"sellerId":_shopId};
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    
    if (_isCurrentUserCollectedShop) {
        [CollectePL userCancleCollecteShopWithDic:dic andReturnBlock:^(id returnValue) {
            _isCurrentUserCollectedShop = NO;
            [self IsCollected];
            [self showTextHud:@"已取消收藏"];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
    }else{
        [CollectePL userCollecteShopWithDic:dic andReturnBlock:^(id returnValue) {
            _isCurrentUserCollectedShop = YES;
            [self IsCollected];
            [self showTextHud:@"收藏成功"];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
    }
}


/**
 判读是否收藏
 */
- (void)IsCollected{
    if (_isCurrentUserCollectedShop) {
        self.rightBtn = self.collectedBtn;
        [self.gotoCollectBtn removeFromSuperview];
    }else{
        self.rightBtn = self.gotoCollectBtn;
        [self.collectedBtn removeFromSuperview];

    }
    [self.topView  addSubview:self.rightBtn];
}

#pragma mark ======== 商家简介。联系客服

/**
 商家简介
 */
- (void)introBtnClick{
    
    BusIntroController *busIntroVc = [[BusIntroController  alloc]init];
    busIntroVc.shopId = _shopId;
    [self.navigationController pushViewController:busIntroVc animated:YES];
}

/**
 联系客服
 */
- (void)connectBtnClick{
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    if ([self ChatManiSHisSelfwithHisId:[NSString stringWithFormat:@"%@",_shopId]]) {
        [self showTextHud:@"您不能跟自己聊天对话哦"];
        return;
    }
    
    xxxxViewController *_conversationVC = [[xxxxViewController alloc]init];
    _conversationVC.conversationType = ConversationType_PRIVATE;
    //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    _conversationVC.targetId = [NSString stringWithFormat:@"%@",_shopId];
    
    //设置聊天会话界面要显示的标题
    _conversationVC.title = _nameLab.text;
    
    [self.navigationController pushViewController:_conversationVC animated:YES];
    
}
#pragma mark ======== 上啦加载下拉刷新设置



- (void)reLoadData{
    _itemPageNum = 1;
    self.loadWay = RELOAD_DADTAS;
    [self loadShopInfo];

}
- (void)loadMoreData
{
    self.loadWay = LOAD_MORE_DATAS;
    [self loadShopInfo];
}

- (void)loadSuccess
{
    [self setPageCount];
    if (self.loadWay == START_LOAD_FIRST || self.loadWay == RELOAD_DADTAS) {
        [_dataArr  removeAllObjects];
    }
    
    [_dataArr addObjectsFromArray:self.loadArray];
    [self.collectionview reloadData];
    if (self.loadArray.count <= 0) {
        self.collectionview.mj_footer.hidden = YES;
        
    } else {
        self.collectionview.mj_footer.hidden = NO;
    }

    


}
- (void)setPageCount{
    if (self.loadArray.count > 0 )
    {
        if (self.loadWay != LOAD_MORE_DATAS)
        {
            _itemPageNum = 1;
        }
        _itemPageNum++;
    }

}

- (void)endLoading{

    [self.collectionview.mj_header endRefreshing];
    [self.collectionview.mj_footer endRefreshing];

}

/**
 更多优惠券
 */
- (void)moreCouponBtnClick{

    [self showTextHud:@"暂未开放"];

}

/**
 右侧按钮
 */
- (void)rightbuttonClickEvent{

    self.menuView.OriginY = 60;
    [self.menuView show];

}

- (void)LeftButtonClickEvent{

    if (_goType == 1) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }else{
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _dataArr.count;
    
    
}


//每个UICollectionView展示的内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"BusinProCell";
    BusinProCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
    //    NSDictionary *dic = self.productArray[indexPath.row];
    //    [cell setDataDic:dic];
    // cell.productByFidModel = self.productArray[indexPath.row];
    cell.model = _dataArr[indexPath.row];
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout

//定义每个Item 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat itemW = (ScreenWidth-15)/2;
    if (iPad) {
        return CGSizeMake(itemW, 240*TimeScaleY);
    }
    return CGSizeMake(itemW, 240);
}
//  返回头视图
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    //如果是头视图
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header=[collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"BusinProCellHeader" forIndexPath:indexPath];
        //添加头视图的内容
       // [self addContent];
        //头视图添加view
        [header addSubview:self.topView];
        //_nameLab.text =NULL_TO_NIL(_resultDic[@"shopInfo"][@"shopName"]) ;
        if (NULL_TO_NIL(_resultDic[@"shopInfo"][@"shopName"])) {
            _nameLab.text =  NULL_TO_NIL(_resultDic[@"shopInfo"][@"shopName"]);

            
        }else{
            _nameLab.text =  NULL_TO_NIL(_resultDic[@"shopInfo"][@"sellerInfo"]);

            
        }
        if (NULL_TO_NIL( _resultDic[@"shopInfo"][@"shopLogoImageUrl"])) {
            [_faceImageView  sd_setImageWithURL:[NSURL URLWithString:NULL_TO_NIL(_resultDic[@"shopInfo"][@"shopLogoImageUrl"])] placeholderImage:[UIImage imageNamed:@"loding"]];

        }else{
            _faceImageView.image = [UIImage imageNamed:@"loding"];
        }
        if (NULL_TO_NIL(_resultDic[@"shopInfo"][@"shopMainBusiness"])) {
            _saleKindLab.text =[NSString stringWithFormat:@"主营：%@",NULL_TO_NIL(_resultDic[@"shopInfo"][@"shopMainBusiness"])]  ;

        }else{
            _saleKindLab.text =@"主营："  ;

            
        }
        return header;
    }
    //如果底部视图
    //    if([kind isEqualToString:UICollectionElementKindSectionFooter]){
    //
    //    }
    return nil;
}

// 设置section头视图的参考大小，与tableheaderview类似
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout
referenceSizeForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        return CGSizeMake(self.view.frame.size.width, 202);
    }
    else {
        return CGSizeMake(0, 0);
    }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

    GoodsDetailViewController *deVc = [[GoodsDetailViewController alloc]init];

    deVc.itemModel = _dataArr[indexPath.row];
    [self.navigationController pushViewController:deVc animated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    if (_searchTF.text.length>0) {
        BussShopSearchViewController *resultVc = [[BussShopSearchViewController alloc]init];
        resultVc.searchStr = _searchTF.text;
        resultVc.shopId = _shopId;
        [self.navigationController pushViewController:resultVc animated:YES];
    }
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
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

-(void)respondToLeftButtonClickEvent{
    
    
    
}

@end
