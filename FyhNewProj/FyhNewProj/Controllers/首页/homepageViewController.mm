//
//  homepageViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "homepageViewController.h"
#import "FyhwebViewController.h"
#import "MJRefresh.h"
#import "HomePagePL.h"
#import "SDCycleScrollView.h"
#import "UIButton+WebCache.h"
#import "EndlessLoopShowView.h"
#import "SearchProductCollectionCell.h"
#import "ItemsModel.h"
#import "GoodsDetailViewController.h"
#import "SearchResultViewController.h"
#import "AppDelegate.h" 
#import "DOTabBarController.h"

#import "LBXScanView.h"
#import <objc/message.h>
#import "ScanResultViewController.h"
#import "LBXScanResult.h"
#import "LBXScanWrapper.h"
#import "SubLBXScanViewController.h"
#import "ChatListViewController.h"
#import "CreaTeViewController.h"
#import "BannerViewController.h"
#import "StarView.h"

#define BANNERView_HEIGHT  161.0f
#define BTNView_HEIGHT  218.0f
#define ManView_HEIGHT  372.0f


@interface homepageViewController ()<SDCycleScrollViewDelegate,UITextFieldDelegate,EndlessLoopShowViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic , strong)  SDCycleScrollView  *sdcycleView;


@property (nonatomic , strong) UIScrollView *scrollView;

@property (nonatomic , strong) UIView * gongnengview;

@property (nonatomic , strong) UIView * qianggouview;

@property (nonatomic , strong) UIView * remenview;

@property (nonatomic , strong) UIView * banpiaoview;

@property (nonatomic , strong) UIView * mianliaoview;

@property (nonatomic , strong) UIView * fuliaoview;

@property (nonatomic, strong) UICollectionView *collectionview;

@property (nonatomic , strong) StarView * starView;


@property (nonatomic , strong) UIView * searchView;



@end

@implementation homepageViewController
{
    CGFloat _originY;
    NSMutableArray      *_bannerArr;    //轮播
    NSMutableArray      *_bannerDataArr;    //轮播
    NSMutableArray      *_btnArr;       //链接广告按钮8个
    NSMutableDictionary *_hotDic;       //热门
    NSMutableArray      *_kindRecArr;   //类目商品推荐
    NSMutableDictionary *_recDic;       //商品推荐
    NSMutableArray       *_manArr;       //设计师模块
    NSMutableArray      *_dataArr;
    UITextField         *_searchTxt;    //搜索txt
    

}

#pragma mark  ------ get

-(UIView *)searchView{
    if (!_searchView) {
        
        _searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, NaviHeight64)];
        
        UIImageView *bgImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"home_top"]];
        [_searchView addSubview:bgImageView];
        bgImageView.frame = CGRectMake(0, 0, ScreenWidth, NaviHeight64);
        UIButton *scanBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [scanBtn setImage:[UIImage imageNamed:@"home-scan"] forState:UIControlStateNormal];
        [_searchView addSubview:scanBtn];
        scanBtn.frame = CGRectMake(20, 32+TOPSTATUSBAR_ADD, 20, 20);
        [scanBtn addTarget:self action:@selector(scanBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton *chatBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [chatBtn setImage:[UIImage imageNamed:@"home-chat"] forState:UIControlStateNormal];
        [_searchView addSubview:chatBtn];
        chatBtn.frame = CGRectMake(ScreenWidth -40, 32+TOPSTATUSBAR_ADD, 20, 20);
        [chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        UIView *searchview = [BaseViewFactory viewWithFrame:CGRectMake(50, 25+TOPSTATUSBAR_ADD, ScreenWidth -100, 34) color:UIColorFromRGB(WhiteColorValue)];
        searchview.layer.cornerRadius = 17;
        searchview.clipsToBounds = YES;
        [_searchView addSubview:searchview];
        
        UIImageView *searchImage = [BaseViewFactory icomWithWidth:25 imagePath:@"home_serch"];
        searchImage.frame = CGRectMake(10, 4.5, 25, 25);
        [searchview addSubview:searchImage];
        
        _searchTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(43, 0, searchview.width - 78, 34) font:APPFONT(13) placeholder:@"寻找感兴趣的商品" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
        _searchTxt.returnKeyType =UIReturnKeyDone;
        
        [searchview addSubview:_searchTxt];
        
        UIButton *creamBtn = [BaseViewFactory buttonWithWidth:25 imagePath:@"home_camra"];
        creamBtn.frame = CGRectMake(searchview.width - 35, 7.5+TOPSTATUSBAR_ADD, 25, 19);
        [creamBtn addTarget:self action:@selector(creamBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [searchview addSubview:creamBtn];
    }
    
    return _searchView;
}

-(StarView *)starView{
    if (!_starView) {
        _starView = [[StarView alloc]init];
    
    }
    return _starView;
    
}
-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, NaviHeight64, ScreenWidth, ScreenHeight - NaviHeight64-TABBAR_HEIGHT)];
        _scrollView.backgroundColor = UIColorFromRGB(0xe6e9ed);
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHomePageDatas)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.textColor = [UIColor lightGrayColor];
        header.lastUpdatedTimeLabel.textColor = [UIColor lightGrayColor];
        _scrollView.mj_header = header;
      //  _scrollView.mj_header.hidden = YES;
        
        if (@available(iOS 11.0, *)) {
            _scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
        
    }

    return _scrollView;
}
-(SDCycleScrollView *)sdcycleView{
    if (!_sdcycleView) {
        _sdcycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0 , ScreenWidth, BANNERView_HEIGHT) imageURLStringsGroup:nil]; // 模拟网络延时情景
        if (iPad) {
            _sdcycleView.frame = CGRectMake(0, 0 , ScreenWidth, BANNERView_HEIGHT*TimeScaleY);
        }
        _sdcycleView.pageDotColor = UIColorFromRGB(PlaColorValue);
        _sdcycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sdcycleView.delegate = self;
        _sdcycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
       // _sdcycleView.autoScroll = NO;
        
        
       
        
    }
    return _sdcycleView;
}
-(UICollectionView *)collectionview
{
    if (_collectionview == nil)
    {
        //确定是水平滚动，还是垂直滚动
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        
        _collectionview=[[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
        _collectionview.dataSource=self;
        _collectionview.delegate=self;
        _collectionview.backgroundColor =UIColorFromRGB(0xe6e9ed);
        _collectionview.bounces = NO;
        //注册Cell，必须要有
        [_collectionview registerClass:[SearchProductCollectionCell class] forCellWithReuseIdentifier:@"SearchProductCollectionCell"];
        
    }
    return _collectionview;
}

//设置字体颜色
- (UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}
#pragma mark  ------ viewDidLoad
- (void)viewDidLoad {
    
    [super viewDidLoad];
   // [[NSUserDefaults standardUserDefaults]removeObjectForKey: IS_FIRST_LOAD];

    [self showStarView];
    [self.view addSubview:self.searchView];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showQrcodeImfo:)
                                                 name:@"ScanStrQrcodeSuccess"
                                               object:nil];
    [self initDatas];
    [self.view addSubview:self.scrollView];
    [self loadHomePageDatas];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}

#pragma mark  ------ 设置启动页
- (void)showStarView{
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:IS_FIRST_LOAD]) {
        [self.starView showWinView];

    }
}


#pragma mark  ------ initDatas

- (void)initDatas{
    _bannerArr = [NSMutableArray arrayWithCapacity:0];
    _btnArr= [NSMutableArray arrayWithCapacity:0];
    _kindRecArr= [NSMutableArray arrayWithCapacity:0];
    _dataArr= [NSMutableArray arrayWithCapacity:0];
    _bannerDataArr = [NSMutableArray arrayWithCapacity:0];
    _manArr = [NSMutableArray arrayWithCapacity:0];
}

- (void)removeAllArr{
    [_bannerArr removeAllObjects];
    [_btnArr removeAllObjects];
    [_hotDic removeAllObjects];
    [_kindRecArr removeAllObjects];
    [_recDic removeAllObjects];
    [_manArr removeAllObjects];
    [_bannerDataArr removeAllObjects];

}

#pragma mark   获取首页数据
- (void)loadHomePageDatas{

    [HomePagePL getHomeDatasWithReturnBlock:^(id returnValue) {
        NSArray *resultArr = returnValue[@"configurations"];
        [self removeAllArr];
        for (NSDictionary *Dic in resultArr) {
            if ([Dic[@"type"] intValue] == 1) {
            //轮播
                NSArray *imageUrlListArr = Dic[@"itemList"];
                for (int i = 0; i<imageUrlListArr.count; i++) {
                    NSDictionary *imaDic = imageUrlListArr[i];
                    [_bannerArr addObject:imaDic[@"imageUrl"]];
                    if (!NULL_TO_NIL(imaDic[@"url"])||[imaDic[@"url"] isEqualToString:@""]) {
                        [_bannerDataArr addObject:@""];

                    }else{
                        [_bannerDataArr addObject:NULL_TO_NIL(imaDic[@"url"])];

                    }
                }
            }else if ([Dic[@"type"] intValue] == 2){
            //按钮8个
                NSArray *itemListArr = Dic[@"itemList"];
                [_btnArr addObjectsFromArray:itemListArr];
            }else if ([Dic[@"type"] intValue] == 3){
            //热门
                _hotDic = [Dic mutableCopy];
            }else if ([Dic[@"type"] intValue] == 4){
            //类目商品推荐
                [_kindRecArr addObject:Dic];
            }else if ([Dic[@"type"] intValue] == 5){
            //商品推荐
                _recDic = [Dic mutableCopy];
            }else if ([Dic[@"type"] intValue] == 6){
            //设计师
//                NSArray *itemListArr = Dic[@"itemList"];
                [_manArr addObject:Dic];
//                _manDic = [Dic mutableCopy];
            }
        }
        [self setupUI];
      //  self.scrollView.mj_header.hidden = YES;
        [self.scrollView.mj_header endRefreshing];

    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:@"首页加载失败，下拉可重新加载"];
     //   self.scrollView.mj_header.hidden = NO;
        [self.scrollView.mj_header endRefreshing];
    }];
}




-(void)setupUI
{
    
    NSLog(@"%f%f",ScreenWidth,ScreenHeight);
    _originY = 0;
//轮播
    [self setTopBanner];
    
//8主题
    [self setlianjieguanggao];
//热门
    [self setremenzhuanqu];
//类目商品推荐
    [self setbanpiaobu];
//创意设计
    [self setmiaoliao];
   
 
    
    [self setfuliao];
    
    
    self.scrollView .contentSize = CGSizeMake(10, _originY);
}

- (void)setTopBanner{
    if (_bannerArr.count<=0) {
        return;
    }
    [self.scrollView addSubview:self.sdcycleView];
    self.sdcycleView.imageURLStringsGroup = _bannerArr;
    if (iPad) {
        _originY += BANNERView_HEIGHT*TimeScaleY;
        
    }else{
        
        _originY += BANNERView_HEIGHT;
        
    }
}


/**
 8大主题
 */
-(void)setlianjieguanggao
{
    if (_btnArr.count<=0) {
        
        return;
    }
    
    _gongnengview = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, BTNView_HEIGHT)];
    _gongnengview.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self.scrollView addSubview:_gongnengview];
    
    [_gongnengview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    
    CGFloat btnWidth = ScreenWidth/4;
    CGFloat btnHeight = 93;

    for (int i = 0; i<_btnArr.count; i++) {
        NSInteger index = i % 4;   //列
        NSInteger page = i / 4;    //行
        NSDictionary *dic = _btnArr[i];
        YLButton *button = [YLButton buttonWithType:UIButtonTypeCustom];
        [button sd_setImageWithURL:dic[@"imageUrl"] forState:UIControlStateNormal];
        [button setTitle:dic[@"title"] forState:UIControlStateNormal];
        [button setImageRect:CGRectMake((btnWidth - 50)/2, 10, 50, 50)];
        [button setTitleRect:CGRectMake(0, 70, btnWidth, 13)];
        [button setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
        button.frame = CGRectMake(btnWidth *index, btnHeight *page+10, btnWidth, btnHeight);
        button.tag = 1000+i;
        button.titleLabel.textAlignment = NSTextAlignmentCenter;
        button.titleLabel.font = APPFONT(13);
        [button addTarget: self action:@selector(kindBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        [_gongnengview addSubview:button];
    }
    UIView *downView = [BaseViewFactory viewWithFrame:CGRectMake(0, _gongnengview.height-12, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [_gongnengview  addSubview:downView];
   
    _originY += BTNView_HEIGHT;

}


/**
 热门
 */
-(void)setremenzhuanqu
{
   
    NSArray *btnDicArr = _hotDic[@"itemList"];
    if (btnDicArr.count <=0) {
        return;
    }
    
    _remenview = [[UIView alloc]init];
    _remenview.backgroundColor = UIColorFromRGB(0xf9fafc);
    [self.scrollView addSubview:_remenview];
    [_remenview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    UIView *topbgView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 0, ScreenWidth, 39) color:UIColorFromRGB(WhiteColorValue)];
    [_remenview addSubview:topbgView];
    
    NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_hotDic[@"imageUrl"]]];
    UIImage *image = [UIImage imageWithData:data];

    
    UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, image.size.width*39/75, 39)];
    topView.image = image;
    [_remenview  addSubview:topView];
    
    
    
    UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0,39, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [_remenview  addSubview:lineView];

    
    
    CGFloat btnWidth = (ScreenWidth - 30)/2;
    CGFloat scaxWidth = btnWidth/374;
    CGFloat btnHeight = 160 *scaxWidth;

    for (int i = 0; i<btnDicArr.count; i++) {
        NSInteger index = i % 2;   //列
        NSInteger page = i / 2;    //行
        NSDictionary *dic = btnDicArr[i];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn sd_setImageWithURL:[NSURL URLWithString:dic[@"imageUrl"]]forState:UIControlStateNormal];
        btn.tag = 2000+i;
        btn.frame = CGRectMake(10 +(btnWidth +10)*index,50+(btnHeight +10)*page, btnWidth, btnHeight);
        [btn addTarget:self action:@selector(hotBtnclick:) forControlEvents:UIControlEventTouchUpInside];
        [_remenview addSubview:btn];
    }
    
    _remenview.frame = CGRectMake(0, _originY, ScreenWidth, 40+10+(btnHeight +10)*3+12);
    _originY += 40+10+(btnHeight +10)*3+12;
    UIView *downView = [BaseViewFactory viewWithFrame:CGRectMake(0, _remenview.height-12, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [_remenview  addSubview:downView];
    
    
    
    
}




/**
 类目商品推荐
 */
-(void)setbanpiaobu
{
    if (_kindRecArr.count<=0) {
        return;
    }
    
    _banpiaoview = [[UIView alloc]init];
    _banpiaoview.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:_banpiaoview];
    [_banpiaoview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    for (int i = 0; i <_kindRecArr.count;i++ ) {
        NSDictionary *dic = _kindRecArr[i];
        UIView *kindRecView = [BaseViewFactory viewWithFrame:CGRectMake(0, 193*i, ScreenWidth, 193) color:UIColorFromRGB(WhiteColorValue)];
        [_banpiaoview addSubview:kindRecView];
        if (iPad) {
            kindRecView.frame = CGRectMake(0, 193*i*TimeScaleY, ScreenWidth, 193*TimeScaleY);
        }
        
        
        
        UIScrollView *downScrrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 141)];
        downScrrollview.showsVerticalScrollIndicator  = NO;
        downScrrollview.showsHorizontalScrollIndicator = NO;
        [kindRecView addSubview:downScrrollview];
        downScrrollview.bounces = NO;
        if (iPad) {
            downScrrollview.frame =CGRectMake(0, 40*TimeScaleY, ScreenWidth, 141*TimeScaleY);
        }
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:dic[@"imageUrl"]]];
        UIImage *image = [UIImage imageWithData:data];
        UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, image.size.width*39/75, 39)];
        topView.image = image;
        [kindRecView  addSubview:topView];
        if (iPad) {
            topView.frame =CGRectMake(20, 0, image.size.width*39/75*TimeScaleY, 39*TimeScaleY);
        }
        YLButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(ScreenWidth - 200, 0, 180, 39);
        [kindRecView addSubview:btn];
       
        if (iPad) {
            btn.titleRect = CGRectMake(0, 0, 160, 39*TimeScaleY);
            btn.imageRect = CGRectMake(170, 11.5*TimeScaleY, 10*TimeScaleY, 16*TimeScaleY);
            btn.titleLabel.font = APPFONT(15);

        }else{
            btn.titleRect = CGRectMake(0, 0, 160, 39);
            btn.imageRect = CGRectMake(170, 11.5, 10, 16);
            btn.titleLabel.font = APPFONT(11);

        }
        [btn setTitle:@"精选优质商品" forState:UIControlStateNormal];
        [btn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xaab2bd) forState:UIControlStateNormal];
        btn.titleLabel.textAlignment = NSTextAlignmentRight;
        btn.tag = 2000 + i;
        [btn addTarget:self action:@selector(LookGoodsWithUrl:) forControlEvents:UIControlEventTouchUpInside];
        if (iPad) {
            btn.frame =CGRectMake(ScreenWidth - 200, 0, 180, 39*TimeScaleY);
        }
        UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 39, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [kindRecView addSubview:line];
        if (iPad) {
            line.frame =CGRectMake(0, 39*TimeScaleY, ScreenWidth, 1);
        }
        
        NSArray *dataArr = dic[@"itemList"];
        for (int j = 0; j < dataArr.count+1; j++) {
            if (j==dataArr.count) {
                UIView *bgView = [BaseViewFactory viewWithFrame:CGRectMake(10+100*j, 0, 53, 141) color:UIColorFromRGB(WhiteColorValue)];
                [downScrrollview addSubview:bgView];
                if (iPad) {
                    bgView.frame =CGRectMake((10+100*j)*TimeScaleY, 0, 53*TimeScaleY, 141*TimeScaleY);
                }
                UIButton *dataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                dataBtn.frame = CGRectMake(0, 0, 53, 141);
                [dataBtn setImage:[UIImage imageNamed:@"home-more"] forState:UIControlStateNormal];
                dataBtn.tag = 30000;
                [bgView addSubview:dataBtn];
                [dataBtn addTarget:self action:@selector(LookMoreGoods) forControlEvents:UIControlEventTouchUpInside];
                downScrrollview.contentSize = CGSizeMake(10+100*j +53, 10);
                if (iPad) {
                    downScrrollview.contentSize= CGSizeMake((10+100*j+53)*TimeScaleY, 10);
                    dataBtn.frame = CGRectMake(0, 0, 53*TimeScaleY, 141*TimeScaleY);
                }
            }else{
                UIView *bgView = [BaseViewFactory viewWithFrame:CGRectMake(10+100*j, 0, 100, 141) color:UIColorFromRGB(WhiteColorValue)];
                [downScrrollview addSubview:bgView];
                if (iPad) {
                    bgView.frame =CGRectMake((10+100*j)*TimeScaleY, 0, 100*TimeScaleY, 141*TimeScaleY);
                }
                NSDictionary *dataDic = dataArr[j];
                

                UIImageView *btnImageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 80, 80)];
                [bgView addSubview:btnImageview];
                [btnImageview  sd_setImageWithURL:[NSURL URLWithString:dataDic[@"imageUrl"]] placeholderImage:[UIImage imageNamed:@"loding"]];
                if (iPad) {
                    btnImageview.frame =CGRectMake(10*TimeScaleY, 10*TimeScaleY, 80*TimeScaleY, 80*TimeScaleY);
                }
                
                
                UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectMake(10, 100, 85, 11) textColor:UIColorFromRGB(0x434a54) font:APPFONT(11) textAligment:NSTextAlignmentLeft andtext:dataDic[@"title"]];
                [bgView addSubview:nameLab];
                if (iPad) {
                    nameLab.frame =CGRectMake(10*TimeScaleY, 100*TimeScaleY, 85*TimeScaleY, 11*TimeScaleY);
                }
                
                UILabel *priceLab = [BaseViewFactory labelWithFrame:CGRectMake(10, 116, 85, 15) textColor:UIColorFromRGB(0xff5d3b) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:dataDic[@"price"]];
                [bgView addSubview:priceLab];
                if (iPad) {
                    priceLab.frame =CGRectMake(10*TimeScaleY, 116*TimeScaleY, 85*TimeScaleY, 15*TimeScaleY);
                }
                UIButton *dataBtn = [UIButton buttonWithType:UIButtonTypeCustom];
                dataBtn.frame = CGRectMake(0, 0, 100, 141);
                [bgView addSubview:dataBtn];
                dataBtn.tag = 300000 +[dataDic[@"id"] integerValue];
                [dataBtn addTarget:self action:@selector(LookGoodWithBtn:) forControlEvents:UIControlEventTouchUpInside];
                if (iPad) {
                    dataBtn.frame =CGRectMake(0, 0, 100*TimeScaleY, 141*TimeScaleY);
                }
            }
            
            if (j>0) {
                UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(10+100*j, 10, 1, 121) color:UIColorFromRGB(LineColorValue)];
                [downScrrollview addSubview:lineview];
                if (iPad) {
                    lineview.frame =CGRectMake((10+100*j)*TimeScaleY, 10*TimeScaleY, 1, 121*TimeScaleY);
                }
            }
            
            
        }
        
        UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(0, 181, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
        [kindRecView addSubview:lineview];
        if (iPad){
            lineview.frame = CGRectMake(0, 181*TimeScaleY, ScreenWidth, 12);
            
        }
        
    }
    if (iPad) {
        _banpiaoview.frame = CGRectMake(0, _originY, ScreenWidth, 193*_kindRecArr.count*TimeScaleY);
        _originY += 193*_kindRecArr.count*TimeScaleY;
    }else{
        _banpiaoview.frame = CGRectMake(0, _originY, ScreenWidth, 193*_kindRecArr.count);
        _originY += 193*_kindRecArr.count;
        
    }
    
    
}

/**
 创意设计
 */

-(void)setmiaoliao
{
    if (_manArr.count<=0) {
        return;
    }
    
    _mianliaoview = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, ManView_HEIGHT*_manArr.count)];
    _mianliaoview.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_mianliaoview];
    [_mianliaoview.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (iPad) {
       _mianliaoview.frame = CGRectMake(0, _originY, ScreenWidth, ManView_HEIGHT*TimeScaleY*_manArr.count);
    }
    for (int i = 0; i<_manArr.count; i++) {
        NSDictionary *_manDic = _manArr[i];
        
        UIView *kindRecView = [BaseViewFactory viewWithFrame:CGRectMake(0, ManView_HEIGHT*i, ScreenWidth, 40) color:UIColorFromRGB(WhiteColorValue)];
        [_mianliaoview addSubview:kindRecView];
        if (iPad) {
            kindRecView.frame = CGRectMake(0, ManView_HEIGHT*TimeScaleY*i, ScreenWidth, 40*TimeScaleY);
        }
        
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:_manDic[@"imageUrl"]]];
        UIImage *image = [UIImage imageWithData:data];
        UIImageView *topView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 0, image.size.width*39/75, 39)];
        topView.image = image;
        [kindRecView  addSubview:topView];
        if (iPad) {
            topView.frame = CGRectMake(20, 0, image.size.width*39/75*TimeScaleY, 39*TimeScaleY);
        }
        
        
        UIView *line = [BaseViewFactory viewWithFrame:CGRectMake(0, 39, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [kindRecView addSubview:line];
        if (iPad) {
            line.frame = CGRectMake(0, 39*TimeScaleY, ScreenWidth, 1);
        }
        EndlessLoopShowView * showView;
        if (iPad) {
            showView = [[EndlessLoopShowView alloc]initWithFrame:CGRectMake(0, 50*TimeScaleY+ManView_HEIGHT*i*TimeScaleY, ScreenWidth, 289*TimeScaleY)];
        }else{
            
            showView = [[EndlessLoopShowView alloc]initWithFrame:CGRectMake(0, 50+ManView_HEIGHT*i, ScreenWidth, 289)];
            
        }
        showView.imageDataArr =_manDic[@"itemList"];
        showView.delegate = self;
        [_mianliaoview addSubview:showView];
        
        
        UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(0, 360+ManView_HEIGHT*i, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
        if (iPad) {
            lineview.frame = CGRectMake(0, 360*TimeScaleY+ManView_HEIGHT*i*TimeScaleY, ScreenWidth, 12);
        }
        [_mianliaoview addSubview:lineview];
        
        
    }
    if (iPad) {
        _originY += ManView_HEIGHT*TimeScaleY*_manArr.count;
    }else{
        _originY += ManView_HEIGHT*_manArr.count;
    }
   
    
}

- (void)endlessLoop:(EndlessLoopShowView *)showView scrollToIndex:(NSInteger)currentIndex {
    
    NSLog(@"currentIndex = %ld",currentIndex);
}

/**
 为你推荐
 */
-(void)setfuliao
{
    _fuliaoview = [[UIView alloc]init];
    _fuliaoview.backgroundColor = [UIColor whiteColor];
    [_scrollView addSubview:_fuliaoview];
    
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:_fuliaoview Frame:CGRectMake(0, 20, ScreenWidth, 15) Alignment:NSTextAlignmentCenter Text:@"为您推荐"];
     [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(11) WithSuper:_fuliaoview Frame:CGRectMake(0, 40, ScreenWidth, 12) Alignment:NSTextAlignmentCenter Text:@"带您挑选好产品"];
    UIView *leftLine  = [BaseViewFactory viewWithFrame:CGRectMake(20, 46, ScreenWidth/2 -45 - 20, 1) color:UIColorFromRGB(LineColorValue)];
    [_fuliaoview  addSubview:leftLine];
    
    UIView *rightLine  = [BaseViewFactory viewWithFrame:CGRectMake( ScreenWidth/2 +45,46, ScreenWidth/2 -45 - 20, 1) color:UIColorFromRGB(LineColorValue)];
    [_fuliaoview  addSubview:rightLine];
    
    NSInteger reportCnt = 0;
    NSArray *dataArr = _recDic[@"itemList"];
    _dataArr = [ItemsModel mj_objectArrayWithKeyValuesArray:dataArr];
    if (dataArr.count%2 == 0)
    {
        reportCnt = dataArr.count/2;
    }
    else
    {
        reportCnt = dataArr.count/2+1;
    }
    [_fuliaoview  addSubview:self.collectionview];
    [self.collectionview reloadData];
    self.collectionview.frame =  CGRectMake(0, 62, ScreenWidth, 325*reportCnt);
    _fuliaoview.frame = CGRectMake(0, _originY, ScreenWidth, 62+325*reportCnt);
    if (iPad) {
        self.collectionview.frame =  CGRectMake(0, 62, ScreenWidth, 325*reportCnt*TimeScaleY);
        _fuliaoview.frame = CGRectMake(0, _originY, ScreenWidth, 62+325*reportCnt*TimeScaleY);
    }
    _originY += _fuliaoview.height;
    
    
}

#pragma mark -- EndlessLoopShowViewDelegate

-(void)didSelectedGoodsWithDIc:(NSDictionary *)dic{

    ItemsModel  *model = [[ItemsModel alloc]init];
    model = [ItemsModel mj_objectWithKeyValues:dic];
    
    GoodsDetailViewController *devc = [[GoodsDetailViewController alloc]init];
    if ([model.shopCertificationType isEqualToString:@"1"]||!model.shopCertificationType||[model.shopCertificationType isEqualToString:@""]) {
        devc.shopType = 1; //个人
    }else{
        devc.shopType = 2; //商家
    }
    devc.itemModel = model;
    [self.navigationController pushViewController:devc animated:YES];


}

-(void)didSelectedEndlessLoopShowViewWithDIc:(NSDictionary *)dic{


    NSLog(@"%@",dic);
    
    CreaTeViewController *crVc = [[CreaTeViewController alloc]init];
    crVc.anniuStr = dic[@"url"];
    crVc.titlesStr = dic[@"title"];
    [self.navigationController pushViewController:crVc animated:YES];

}
#pragma mark -- 按钮

-(void)kindBtnclick:(UIButton *)btn
{
    FyhwebViewController *vc = [[FyhwebViewController alloc]init];
    NSString *str =_btnArr[btn.tag - 1000][@"url"];
    if (str.length<=0) {
        str = @"";
    }
    vc.anniuStr =str;
    vc.titlesStr = _btnArr[btn.tag - 1000][@"title"];

    [self.navigationController pushViewController:vc animated:YES];

}

-(void)hotBtnclick:(UIButton *)btn
{
    if (btn.tag ==2004) {
        NSString *str = @"telprompt://400-878-0966";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        return;
    }
    FyhwebViewController *vc = [[FyhwebViewController alloc]init];
    NSString *str =_hotDic[@"itemList"][btn.tag - 2000][@"url"];
    if (str.length<=0) {
        str = @"";
    }

    vc.anniuStr = str;
    vc.titlesStr = @"热门服务";
    [self.navigationController pushViewController:vc animated:YES];

    
}

/**
 查看更多
 */
- (void)LookMoreGoods{

    AppDelegate *app = (AppDelegate *)[[UIApplication  sharedApplication] delegate];
    app.mainController.selectedIndex = 2;
}

- (void)LookGoodWithBtn:(UIButton *)btn{

    ItemsModel *model = [[ItemsModel alloc]init];
    for (NSDictionary *dic in _kindRecArr) {
        for (NSDictionary *resuDic in dic[@"itemList"]) {
            if ([resuDic[@"id"] integerValue]==btn.tag - 300000) {
                model = [ItemsModel mj_objectWithKeyValues:resuDic];
//                model.itemId = resuDic[@"id"] ;
//                model.shopCertificationType = [NSString stringWithFormat:@"%@",resuDic[@"shopCertificationType"]];
            }
        }
    }

    
    GoodsDetailViewController *devc = [[GoodsDetailViewController alloc]init];
    if ([model.shopCertificationType isEqualToString:@"1"]||!model.shopCertificationType||[model.shopCertificationType isEqualToString:@""]) {
        devc.shopType = 1; //个人
    }else{
        devc.shopType = 2; //商家
    }
    devc.itemModel = model;
    [self.navigationController pushViewController:devc animated:YES];
}


-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index{
    
    BannerViewController *bannerVc = [[BannerViewController alloc]init];
    if (index>_bannerDataArr.count) {
        bannerVc.anniuStr = @"";
    }else{
        bannerVc.anniuStr = _bannerDataArr[index];
    }
    [self.navigationController pushViewController:bannerVc animated:YES];
    
    
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
    static NSString * CellIdentifier = @"SearchProductCollectionCell";
    SearchProductCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    [cell sizeToFit];
    if (!cell) {
        NSLog(@"无法创建CollectionViewCell时打印，自定义的cell就不可能进来了。");
    }
   
    cell.model = _dataArr[indexPath.row];
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
    
    ItemsModel  *model = _dataArr[indexPath.row];
    
    GoodsDetailViewController *devc = [[GoodsDetailViewController alloc]init];
    if ([model.shopCertificationType isEqualToString:@"1"]||!model.shopCertificationType||[model.shopCertificationType isEqualToString:@""]) {
        devc.shopType = 1; //个人
    }else{
        devc.shopType = 2; //商家
    }
    devc.itemModel = model;
    [self.navigationController pushViewController:devc animated:YES];
}


#pragma mark =============    顶部按钮点击

/**
 扫码
 */
- (void)scanBtnClick{

    if (![self cameraPemission])
    {
        [self showTextHud:@"没有摄像机权限"];
        return;
    }
    [self qqStyle];

}

/**
 聊天
 */
- (void)chatBtnClick{
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    ChatListViewController *chatVc = [[ChatListViewController alloc]init];
    [self.navigationController pushViewController:chatVc animated:YES];

}

/**
 拍照
 */
- (void)creamBtnClick{
    [self showTextHud:@"敬请期待"];


}

/**
 精选
 
 @param btn btn description
 */
- (void)LookGoodsWithUrl:(YLButton *)btn{

    NSDictionary *dic = _kindRecArr[btn.tag - 2000];
    NSLog(@"%@",dic[@"url"]);
    NSString *titleStr = dic[@"title"];
    if (titleStr.length<=0) {
        titleStr = @"丰云汇";
    }

    FyhwebViewController *vc = [[FyhwebViewController alloc]init];
    vc.anniuStr = dic[@"url"];
    vc.titlesStr = titleStr;
    [self.navigationController pushViewController:vc animated:YES];

    

}
#pragma mark - 扫码模仿qq界面
- (void)qqStyle
{
    //设置扫码区域参数设置
    
    //创建参数对象
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    //矩形区域中心上移，默认中心点为屏幕中心点
    style.centerUpOffset = 44;
    
    //扫码框周围4个角的类型,设置为外挂式
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Outer;
    
    //扫码框周围4个角绘制的线条宽度
    style.photoframeLineW = 6;
    
    //扫码框周围4个角的宽度
    style.photoframeAngleW = 24;
    
    //扫码框周围4个角的高度
    style.photoframeAngleH = 24;
    
    //扫码框内 动画类型 --线条上下移动
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //线条上下移动图片
    style.animationImage = [UIImage imageNamed:@"qrcode_scan_light_green"];
    
    //SubLBXScanViewController继承自LBXScanViewController
    //添加一些扫码或相册结果处理
    SubLBXScanViewController *vc = [SubLBXScanViewController new];
    vc.style = style;
    
    vc.isQQSimulator = YES;
    vc.isVideoZoom = YES;
    [self.navigationController pushViewController:vc animated:YES];
}
/**
 判断照相机权限
 
 @return 是否
 */
- (BOOL)cameraPemission
{
    
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    
    return isHavePemission;
}

#pragma mark =============    文字扫码


- (void)showQrcodeImfo:(NSNotification*)notificaition{
    NSDictionary *dic = notificaition.userInfo;
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"扫码信息" message:dic[@"message"] preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

#pragma mark =============    搜索
- (BOOL)textFieldShouldReturn:(UITextField *)aTextfield {
    
    if (_searchTxt.text.length>0) {
        SearchResultViewController *resultVc = [[SearchResultViewController alloc]init];
        resultVc.searchStr = _searchTxt.text;
        _searchTxt.text = @"";
        [self.navigationController pushViewController:resultVc animated:YES];
    }
    [aTextfield resignFirstResponder];//关闭键盘
    return YES;
}
@end
