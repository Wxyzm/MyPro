                                                                                                                                                                                                                                                                                                                                         //
//  GoodsDetailViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/22.
//  Copyright © 2017年 fyh. All rights reserved.
//  不期而遇、不言而喻、不药而愈

#import "GoodsDetailViewController.h"
#import "SDCycleScrollView.h"
#import "ItemsModel.h"
#import "GoodsItemsPL.h"
#import "GItemModel.h"
#import "GShopModel.h"
#import "GProductItemModel.h"

#import "ParameterView.h"
#import "UnitView.h"
#import "UnitModel.h"
#import "BusinessesShopViewController.h"
#import "CollectePL.h"
#import "MakeSureOrderViewController.h"
#import "ShopCartDataModel.h"
#import "ShopCartModel.h"

#import "PrintQrNewViewController.h"
#import "ShopSettingPL.h"
#import <UShareUI/UShareUI.h>

#import "LeiShopCartViewController.h"
#import "AppDelegate.h"
#import "DOTabBarController.h"
#import "MenueView.h"
#import "xxxxViewController.h"
#import "RCTokenPL.h"
#import "ChatListViewController.h"
#import "SpecificationModel.h"
#import "MJRefresh.h"


typedef enum {
    PRO_TYPE_DEF = 0,
    PRO_TYPE_OLD_ONE = 1,
    PRO_TYPE_OLD_MANY = 2,

    } PRO_TYPE;


@interface GoodsDetailViewController ()<SDCycleScrollViewDelegate,UIScrollViewDelegate,WKNavigationDelegate,MenueViewDelegate,UIWebViewDelegate>

@property (nonatomic , strong)  SDCycleScrollView  *sdcycleView;

@property (nonatomic , strong) UIScrollView *MainScrollView;

@property (nonatomic , strong) UIScrollView *TopScrollView;

@property (nonatomic , strong) UnitView *unitView;

@property (nonatomic , strong) ParameterView *paraView;

@property (nonatomic , strong) UIWebView *webView;

@property (nonatomic , strong) UIView *DownView;

@property (nonatomic , strong)     NSMutableDictionary *infoDic;              //选择的商品   id  数量

@property (nonatomic , strong)     GItemModel          *GitemModel;           //

@property (nonatomic , strong)     GShopModel          *GshopModel;           //商家信息model

@property (nonatomic , strong)     UILabel             *unitLab;


@property (nonatomic , strong) MenueView *menuView;

@property (nonatomic , assign) PRO_TYPE type;

@end

@implementation GoodsDetailViewController{

    CGFloat             _originY;
    NSMutableArray      *_GproductItemsArr;
    
    UIButton            *_chatBtn;              //聊天按钮
    UIButton            *_buyCartBtn;           //购物车按钮
    UIButton            *_collectBtn;           //收藏按钮
    SubBtn              *_joinBuyCartBtn;       //加入购物车
    SubBtn              *_buyAtTimeBtn;         //立即购买
    BOOL                _isCollected;           //是否收藏
    UIButton            *_QRBtn;                //二维码打印图标
    NSDictionary        *_printDic;             //二维码打印内容
    
    UIButton            *_unitBtn;
}
#pragma mark---------View


-(MenueView *)menuView{
    if (!_menuView) {
        _menuView = [[MenueView alloc]init];
        _menuView.delegate = self;
    }

    return _menuView;

}

- (UIWebView *)webView{
    if (!_webView) {
        _webView = [[UIWebView alloc]init];
        _webView.delegate = self;
        _webView.scrollView.delegate  = self;
        _webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
        _webView.scalesPageToFit=YES;
        _webView.multipleTouchEnabled=YES;
        _webView.userInteractionEnabled=YES;
        
        MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadHomePageDatas)];
        header.automaticallyChangeAlpha = YES;
        header.stateLabel.hidden = YES;
        header.lastUpdatedTimeLabel.hidden = YES;
        
        _webView.scrollView.mj_header = header;
    }

    return _webView;
}
-(UIView *)DownView{
    if (!_DownView) {
        _DownView = [[UIView alloc]init];
        _chatBtn = [BaseViewFactory setImagebuttonWithWidth:25 imagePath:@"service-50"];
        [_DownView addSubview:_chatBtn];
        [_chatBtn addTarget:self action:@selector(chatBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _chatBtn.frame = CGRectMake(0, 0, 48, 50);
        
        _buyCartBtn = [BaseViewFactory setImagebuttonWithWidth:25 imagePath:@"cart-50"];
        [_buyCartBtn addTarget:self action:@selector(buyCartBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [_DownView addSubview:_buyCartBtn];
        _buyCartBtn.frame = CGRectMake(48, 0, 48, 50);
        
        _collectBtn = [BaseViewFactory setImagebuttonWithWidth:25 imagePath:@"collect-b-50"];
        if (_isCollected) {
            [_collectBtn setImage:[UIImage imageNamed:@"collect-r-50"] forState:UIControlStateNormal];
        }else{
            [_collectBtn setImage:[UIImage imageNamed:@"collect-b-50"] forState:UIControlStateNormal];
            
        }
        [_collectBtn addTarget:self action:@selector(collectBtnClick) forControlEvents:UIControlEventTouchUpInside];

        [_DownView addSubview:_collectBtn];
        _collectBtn.frame = CGRectMake(96, 0, 48, 50);
        
        _joinBuyCartBtn = [SubBtn buttonWithtitle:@"加入购物车" backgroundColor:UIColorFromRGB(0xfbd30d) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(joinBuyCartBtnClick)];
        [_DownView addSubview:_joinBuyCartBtn];
        _joinBuyCartBtn.frame = CGRectMake(144, 0, (ScreenWidth - 144)/2, 50);
        
        _buyAtTimeBtn = [SubBtn buttonWithtitle:@"立即购买" backgroundColor:UIColorFromRGB(0xff4354) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(buyAtTimeBtnClick)];
        [_DownView addSubview:_buyAtTimeBtn];
        _buyAtTimeBtn.frame = CGRectMake(_joinBuyCartBtn.right, 0, (ScreenWidth - 144)/2, 50);
    }
    return _DownView;
}
-(ParameterView *)paraView{
    if (!_paraView) {
        _paraView = [ParameterView new];
        // _unitView.delegate = self;
    }
    return _paraView;
}

- (UnitView *)unitView
{
    if (!_unitView) {
        _unitView = [UnitView new];
       // _unitView.delegate = self;
    }
    return _unitView;
}
-(SDCycleScrollView *)sdcycleView{
    if (!_sdcycleView) {
        _sdcycleView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, _originY , ScreenWidth, ScreenWidth*2/3) imageURLStringsGroup:nil]; // 模拟网络延时情景
        _sdcycleView.pageControlAliment = SDCycleScrollViewPageContolAlimentCenter;
        _sdcycleView.delegate = self;
        _sdcycleView.bannerImageViewContentMode = UIViewContentModeScaleAspectFill;
        
//        _QRBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        [_QRBtn setImage:[UIImage imageNamed:@"QR"] forState:UIControlStateNormal];
//        [_sdcycleView addSubview:_QRBtn];
//        _QRBtn.frame = CGRectMake(ScreenWidth -53, ScreenWidth*2/3-53, 33, 33);
//        [_QRBtn addTarget:self action:@selector(QRBtnClick) forControlEvents:UIControlEventTouchUpInside];
//        _QRBtn.hidden = YES;
    }
    return _sdcycleView;
}
-(UIScrollView *)MainScrollView{
    if (!_MainScrollView) {
        _MainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        _MainScrollView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _MainScrollView.delegate = self;
      //  _MainScrollView.scrollEnabled = NO;
//        _MainScrollView.maximumZoomScale = 2.0;
//        _MainScrollView.minimumZoomScale = 1.0;
//        _MainScrollView.zoomScale = 1.0;
//        _MainScrollView.multipleTouchEnabled = YES;

        if (@available(iOS 11.0, *)) {
            _MainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _MainScrollView;
}
-(UIScrollView *)TopScrollView{
    if (!_TopScrollView) {
        _TopScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-50-iPhoneX_DOWNHEIGHT)];
        _TopScrollView.backgroundColor = UIColorFromRGB(LineColorValue);
        _TopScrollView.delegate = self;
//        _TopScrollView。s'c
        if (@available(iOS 11.0, *)) {
            _TopScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            // Fallback on earlier versions
        }
    }
    return _TopScrollView;
    
}


#pragma mark---------viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe6e9ed);
    _GproductItemsArr = [[NSMutableArray alloc]initWithCapacity:0];
    _GitemModel = [[GItemModel alloc]init];
    _GshopModel = [[GShopModel alloc]init];
    _infoDic = [[NSMutableDictionary  alloc]init];
    [self loadGoodsDetail];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    _webView.delegate = nil;
    _webView.scrollView.delegate  = nil;


}

- (void)LeftButtonClickEvent{
    
    if (_shopType == 3) {
        [self.navigationController popToRootViewControllerAnimated:YES];

    }
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)rightButtonClickEvent{

    self.menuView.OriginY = 75;
//    self.menuView.baseVc = self;
    [self.menuView show];

}

- (void)initUI{
    
    
    
    _originY = 0;
    [self.view addSubview:self.MainScrollView];
    
    UIImage *backImg= [UIImage imageNamed:@"back-item"];
    
    //    CGFloat height = 17;
    //    CGFloat width = height * backImg.size.width / backImg.size.height;
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(10, 40, 43, 43)];
    // [button setBackgroundImage:backImg forState:UIControlStateNormal];
    [button setImage:backImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(LeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];

    UIButton* rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(ScreenWidth - 43, 40, 43, 43)];
    // [button setBackgroundImage:backImg forState:UIControlStateNormal];
    [rightbutton setImage:[UIImage imageNamed:@"mesg-item"] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(rightButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:rightbutton];
    
    [self.MainScrollView addSubview:self.TopScrollView];
    [self.TopScrollView addSubview:self.sdcycleView];
    self.sdcycleView.imageURLStringsGroup = _GitemModel.imageUrlList;
    _originY += ScreenWidth*2/3;
    [self.view addSubview:self.DownView];
    self.DownView.frame = CGRectMake(0, ScreenHeight - 50-iPhoneX_DOWNHEIGHT, ScreenWidth, 50);
    
    
    
    UIView *view1 = [BaseViewFactory viewWithFrame:CGRectMake(0, _originY, ScreenWidth, 95) color:UIColorFromRGB(WhiteColorValue)];
    [self.TopScrollView addSubview:view1];
    _originY += 95;
    
    UILabel *goodsNameLab = [BaseViewFactory  labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:_GitemModel.title];
    [view1 addSubview:goodsNameLab];
    YLButton *sharebtn = [self buttonWithtitle:@"分享" imagename:@"share" andtextColor:UIColorFromRGB(BlackColorValue) font:APPFONT(11) textAli:NSTextAlignmentCenter titleFrame:CGRectMake(0, 28, 40, 12) andImageFrame:CGRectMake(10, 1, 20, 20)];
    [sharebtn addTarget:self action:@selector(shareInfo) forControlEvents:UIControlEventTouchUpInside];
    [view1 addSubview:sharebtn];
    
    UILabel *moneyLab = [BaseViewFactory  labelWithFrame:CGRectZero textColor:UIColorFromRGB(RedColorValue) font:APPFONT(18) textAligment:NSTextAlignmentLeft andtext:[NSString stringWithFormat:@"￥%@",_GitemModel.price]];
    [view1 addSubview:moneyLab];
    UILabel *areaLab = [BaseViewFactory  labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:_GshopModel.shopArea];
    [view1 addSubview:areaLab];
    
    sharebtn.sd_layout.rightSpaceToView(view1,15).topSpaceToView(view1,15).widthIs(40).heightIs(40);
    goodsNameLab.sd_layout.leftSpaceToView(view1,15).topSpaceToView(view1,15).rightSpaceToView(sharebtn,40).autoHeightRatio(0);
    [goodsNameLab setMaxNumberOfLinesToShow:2];
    moneyLab.sd_layout.leftEqualToView(goodsNameLab).bottomSpaceToView(view1,10).heightIs(20).widthIs(200);
    areaLab.sd_layout.rightSpaceToView(view1,15).bottomSpaceToView(view1,10).heightIs(15).leftSpaceToView(moneyLab,20);
    
    
    
    
    UIView *view2 = [BaseViewFactory viewWithFrame:CGRectMake(0, _originY, ScreenWidth, 146) color:UIColorFromRGB(WhiteColorValue)];
    [self.TopScrollView addSubview:view2];
    _originY += 146;
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(15, 0, ScreenWidth-30, 1) Super:view2];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(15, 40, ScreenWidth-30, 1) Super:view2];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(15, 80, ScreenWidth-30, 1) Super:view2];

    _unitLab = [BaseViewFactory labelWithFrame:CGRectMake(15, 0, ScreenWidth - 30, 40) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@"商品规格"];
    [view2 addSubview:_unitLab];
    

    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(14) WithSuper:view2 Frame:CGRectMake(15, 40, 60, 40) Alignment:NSTextAlignmentLeft Text:@"产品参数"];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(14) WithSuper:view2 Frame:CGRectMake(15, 80, 60, 40) Alignment:NSTextAlignmentLeft Text:@"好评晒单"];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(14) WithSuper:view2 Frame:CGRectMake(15, 80, 60, 40) Alignment:NSTextAlignmentLeft Text:@"好评晒单"];
    if (_GitemModel.sales) {
         [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(13) WithSuper:view2 Frame:CGRectMake(ScreenWidth -15, 80, 200, 40) Alignment:NSTextAlignmentRight Text:[NSString stringWithFormat:@"%@人购买",_GitemModel.sales]];
    }else{
        [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(13) WithSuper:view2 Frame:CGRectMake(ScreenWidth -15, 80, 200, 40) Alignment:NSTextAlignmentRight Text:@"0人购买"];
    }
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(14) WithSuper:view2 Frame:CGRectMake(15, 80, 60, 40) Alignment:NSTextAlignmentLeft Text:@""];
    
    UIImageView *rightImage = [BaseViewFactory icomWithWidth:8 imagePath:@"right"];
    rightImage.frame = CGRectMake(ScreenWidth - 39, 12, 10, 16);
    [view2 addSubview:rightImage];
    UIImageView *rightImage2 =[BaseViewFactory icomWithWidth:8 imagePath:@"right"];
    rightImage2.frame = CGRectMake(ScreenWidth - 39, 52, 10, 16);
    [view2 addSubview:rightImage2];
    
    
    _unitBtn  = [UIButton buttonWithType:UIButtonTypeCustom];
    _unitBtn.frame = CGRectMake(0, 0, ScreenWidth, 40);
    [_unitBtn addTarget:self action:@selector(unitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:_unitBtn];
   
    
    //商品规格选择
    if (_type != PRO_TYPE_DEF) {
        NSDictionary *proDic = _GitemModel.product;
        if (!proDic) {
            _unitLab.text = @"已选择:颜色:定制,状态:期货,类型:大货";
            _unitBtn.userInteractionEnabled = NO;
            
        }else{
            NSArray *arr = [_GitemModel.title componentsSeparatedByString:proDic[@"name"]];
            if (arr.count >1) {
                _unitLab.text = [NSString stringWithFormat:@"已选择：%@",arr[1]];
                _unitBtn.userInteractionEnabled = NO;
            }
        }

    }
    
    
    UIButton *proBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    proBtn.frame = CGRectMake(0, 40, ScreenWidth, 40);
    [proBtn addTarget:self action:@selector(proBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [view2 addSubview:proBtn];
    
    _originY += 12;

    UIView *view3 = [BaseViewFactory viewWithFrame:CGRectMake(0, _originY, ScreenWidth, 70) color:UIColorFromRGB(WhiteColorValue)];
    [self.TopScrollView addSubview:view3];
    _originY += 70;
    UIImageView *shopLogo = [[UIImageView alloc]initWithFrame:CGRectMake(15, 10, 50, 50)];
    [view3 addSubview:shopLogo];
    [shopLogo sd_setImageWithURL:[NSURL URLWithString:_GshopModel.shopLogoImageUrl] placeholderImage:[UIImage imageNamed:@"loding"]];
    
    UIImageView *typeImageView =[[UIImageView alloc]init];
    if (_GshopModel.shopCertificationType == 1) {
        typeImageView.image  = [UIImage imageNamed:@"per-idn"];

    }else{
        typeImageView.image  = [UIImage imageNamed:@"bus-din"];

    }
    [view3 addSubview:typeImageView];
    typeImageView.frame = CGRectMake(80, 10, 13, 15);
    
    UILabel *shopNameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:_GshopModel.shopName];
    if (_GshopModel.shopName) {
        shopNameLab.text = _GshopModel.shopName;
    }else{
        shopNameLab.text = _GshopModel.sellerInfo;
    
    }
    [view3 addSubview:shopNameLab];
    UILabel *saleTypeLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:_GshopModel.shopDescription];
    [view3 addSubview:saleTypeLab];

    SubBtn *shopBtn = [SubBtn buttonWithtitle:@"进入店铺" backgroundColor:UIColorFromRGB(0xfe4557) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(gotoShop)];
    shopBtn.titleLabel.font = APPFONT(13);
    [view3 addSubview:shopBtn];
    
    shopBtn.sd_layout.centerYEqualToView(view3).rightSpaceToView(view3,15).widthIs(60).heightIs(23);
    shopNameLab.sd_layout.leftSpaceToView(typeImageView,5).topEqualToView(typeImageView).heightIs(15).rightSpaceToView(shopBtn,20);
    saleTypeLab.sd_layout.leftEqualToView(typeImageView).centerYEqualToView(view3).heightIs(15).rightSpaceToView(shopBtn,20);
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(13) WithSuper:self.TopScrollView Frame:CGRectMake(0, _originY, ScreenWidth, 42) Alignment:NSTextAlignmentCenter Text:@"继续拖动，查看图文详情"];
    _originY+=42;
    
    if (_originY < ScreenHeight-50) {
        _TopScrollView.contentSize = CGSizeMake(10, ScreenHeight-46);

    }else{
        _TopScrollView.contentSize = CGSizeMake(10, _originY);

    }
   
    if (_isCollected) {
        [_collectBtn setImage:[UIImage imageNamed:@"collect-r-50"] forState:UIControlStateNormal];
    }else{
        [_collectBtn setImage:[UIImage imageNamed:@"collect-b-50"] forState:UIControlStateNormal];
        
    }
    
    [_MainScrollView addSubview:self.webView];
    self.webView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight-50-iPhoneX_DOWNHEIGHT);
    if (_GitemModel.detail.length>0) {
        [self.webView loadHTMLString:[self adaptWebViewForHtml:_GitemModel.detail] baseURL:nil];

    }
    //判断是否有打印权限
    [self getSHopSetingIsQRPrint];
    
}



#pragma mark---------网络请求
- (void)loadGoodsDetail{
    
[GoodsItemsPL GETGoodsDetailWithGoodsId:_itemModel.itemId ReturnBlock:^(id returnValue) {
    NSDictionary *resultDic = returnValue[@"data"];
    
    _isCollected = [resultDic[@"isUserCollectedItem"] boolValue];
    _GitemModel = [GItemModel mj_objectWithKeyValues:resultDic[@"item"]];
    _GshopModel = [GShopModel mj_objectWithKeyValues:resultDic[@"shop"]];
    
    if (_GitemModel.specificationValues.count >0 ) {
        _type = PRO_TYPE_DEF;
    }else{
        if (_GitemModel.product) {
            _type = PRO_TYPE_OLD_MANY;

        }else{
            _type = PRO_TYPE_OLD_ONE;

        }
    }
    
    
    //打印
    NSArray *arr = _GitemModel.attributes;
    NSString *custom = @"";
     NSString *kind = @"";
    NSString *kezhong = @"";
    NSString *Width = @"";

    for (NSDictionary *attDic in arr) {
        if ([attDic[@"attributeName"] isEqualToString:@"货号"]) {
            custom = attDic[@"attributeValue"];
        }
        if ([attDic[@"attributeName"] isEqualToString:@"成分"]) {
            kind = attDic[@"attributeValue"];
        }
        if ([attDic[@"attributeName"] isEqualToString:@"克重"]) {
            kezhong = attDic[@"attributeValue"];
        }
        if ([attDic[@"attributeName"] isEqualToString:@"门幅"]) {
            Width = attDic[@"attributeValue"];
        }
    }
    
    _printDic = @{@"url":[NSString stringWithFormat:@"%@/item/%@",kbaseUrl,_itemModel.itemId],
                  @"title":resultDic[@"item"][@"title"],
                  @"customBn":custom,
                  @"bn":kezhong,
                   @"Width":Width,
                  @"ingredient":kind};
    
    //规格

    _GproductItemsArr = [GProductItemModel mj_objectArrayWithKeyValuesArray:resultDic[@"productItems"]];
    GProductItemModel *model;
    if (_GproductItemsArr.count>0) {
        model  = _GproductItemsArr[0];
    }else{
    
    }
   
    NSArray *unArr = model.specificationValues;
    if (unArr.count>=3) {
        UnitModel *unmodel0=unArr[0];
        unmodel0.on = YES;
        UnitModel *unmodel1=unArr[1];
        unmodel1.on = YES;
        UnitModel *unmodel2=unArr[2];
        unmodel2.on = YES;
    }
    
    
 
    [self initUI];
} andErrorBlock:^(NSString *msg) {
    [self showTextHud:@"商品信息获取失败"];
    [self.navigationController popViewControllerAnimated:YES];
}];
}


-  (void)getSHopSetingIsQRPrint{

    [ShopSettingPL getTheShopSettingInfoWithReturnBlock:^(id returnValue) {
        if ([returnValue[@"isShopAllowUseAppPrinter"] boolValue]) {
            _QRBtn.hidden = NO;
        }else{
            _QRBtn.hidden = YES;
        }
    } andErrorBlock:^(NSString *msg) {
        _QRBtn.hidden = YES;
    }];

}

#pragma mark---------商品规格 产品参数等待
/**
 商品规格
 */
- (void)unitBtnClick{
//    NSArray *colorArr   = @[@"红色",@"酒红色",@"深蓝色",@"翡翠蓝色",@"神TM的橘黄色",@"黄黄黄黄黄黄黄黄黄",@"紫色",@"红色",@"今夕何夕",@"不知所言"];
//    self.unitView.colorArr = colorArr;
//    if (_GitemModel.specificationValues.count <= 0) {
//    }else{
//        
//    }
    
    if (_type == PRO_TYPE_DEF) {
        self.unitView.type = 1;

    }else {
        self.unitView.type = 0;

    }
    
        self.unitView.dataArr = _GproductItemsArr;
        self.unitView.ItemModel = _GitemModel;
        [self.unitView showinView:self.view];
        WeakSelf(self);
        [self.unitView setDidselectGoodsItemBlock:^(NSDictionary *dic) {
            NSLog(@"%@",dic);
            _infoDic = [dic mutableCopy];
            weakself.unitLab.text = [NSString stringWithFormat:@"已选择：%@",weakself.infoDic[@"unit"]];

           }];
    
}
/**
 产品参数
 */
- (void)proBtnClick{
    self.paraView.dataArr = _GitemModel.attributes;
    [self.paraView showinView:self.view];


    
}



/**
 进入店铺
 */
- (void)gotoShop{

    BusinessesShopViewController  *bussVc = [[BusinessesShopViewController alloc]init];
    bussVc.shopId = _GshopModel.shopId;
    [self.navigationController  pushViewController:bussVc animated:YES];
}

/**
 加入购物车
 */
- (void)joinBuyCartBtnClick{
    
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    if ([_GitemModel.minBuyQuantity intValue]<=0&&[_GitemModel.limitUserTotalBuyQuantity intValue]<=0) {
        
        NSDictionary *dic = @{@"goodId":_GitemModel.itemID,
                @"quantity":@"1"
                };
        [GoodsItemsPL AddGoodsIntoBuyCartWithGoodsInfo:dic ReturnBlock:^(id returnValue) {
            [self showTextHud:@"添加成功"];
            NSLog(@"%@",returnValue);
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
    }else{
        if (!_infoDic[@"goodId"]) {
            self.unitView.dataArr = _GproductItemsArr;
            //商品规格选择
            
            if (_type == PRO_TYPE_DEF) {
                self.unitView.type = 1;
                
            }else {
                self.unitView.type = 0;
                
            }
            self.unitView.ItemModel = _GitemModel;
            [self.unitView showinView:self.view];
            WeakSelf(self);
            [self.unitView setDidselectGoodsItemBlock:^(NSDictionary *dic) {
                NSLog(@"%@",dic);
                _infoDic = [dic mutableCopy];
                weakself.unitLab.text = [NSString stringWithFormat:@"已选择：%@",weakself.infoDic[@"unit"]];

                [GoodsItemsPL AddGoodsIntoBuyCartWithGoodsInfo:weakself.infoDic ReturnBlock:^(id returnValue) {
                    [weakself showTextHud:@"添加成功"];
                    NSLog(@"%@",returnValue);
                } andErrorBlock:^(NSString *msg) {
                    [weakself showTextHud:msg];
                }];

                
            }];
            return;
        }
        
        
        [GoodsItemsPL AddGoodsIntoBuyCartWithGoodsInfo:_infoDic ReturnBlock:^(id returnValue) {
            [self showTextHud:@"添加成功"];
            NSLog(@"%@",returnValue);
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];

    }
    
}

/**
 立即购买
 */
- (void)buyAtTimeBtnClick{
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    
    
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    ShopCartDataModel *model = [[ShopCartDataModel alloc]init];
    ShopCartModel *cartModel = [[ShopCartModel alloc]init];
  
    ShopCartitemsModel *itemModel = [[ShopCartitemsModel alloc]init];
    itemModel.imageUrlList = _GitemModel.imageUrlList;
    cartModel.item = itemModel;
    cartModel.edit = NO;
    cartModel.selected = YES;
    cartModel.proId = _GitemModel.productId;
    cartModel.itemTitle = _GitemModel.title;
    cartModel.isChecked = @"0";
    cartModel.currencyCode = @"CYN";
    model.edit = NO;
    model.selected  = NO;
    model.sellerId  = _GshopModel.shopId;
    model.sellerInfo  = _GshopModel.shopName;
    
    
    if (_type == PRO_TYPE_DEF) {
        self.unitView.type = 1;
        if (!_infoDic[@"goodId"]) {
            self.unitView.dataArr = _GproductItemsArr;
            //商品规格选择
            self.unitView.type = 1;
            self.unitView.ItemModel = _GitemModel;
            [self.unitView showinView:self.view];
            
            WeakSelf(self);
            [self.unitView setDidselectGoodsItemBlock:^(NSDictionary *dic) {
                _infoDic = [dic mutableCopy];
                cartModel.quantity = weakself.infoDic[@"quantity"];
                cartModel.itemTitle =  weakself.infoDic[@"title"];
                cartModel.itemId = weakself.infoDic[@"goodId"];
                cartModel.price = weakself.infoDic[@"price"];
                cartModel.priceDisplay = weakself.infoDic[@"price"];

                itemModel.specificationValues =  weakself.infoDic[@"unitArr"];
                
                [model.cartItems  addObject:cartModel];;
                [arr addObject:model];
                weakself.unitLab.text = [NSString stringWithFormat:@"已选择：%@",weakself.infoDic[@"unit"]];
                
                MakeSureOrderViewController  *makeVc = [[MakeSureOrderViewController alloc]init];
                makeVc.dataArr = arr;
                makeVc.type = 0;
                [weakself.navigationController pushViewController:makeVc animated:YES];

                
                
            }];
            return;
        }else{
            cartModel.quantity =_infoDic[@"quantity"];
            cartModel.itemTitle =  _infoDic[@"title"];
            itemModel.specificationValues =  _infoDic[@"unitArr"];
            cartModel.itemId = _infoDic[@"goodId"];
            cartModel.price =_infoDic[@"price"];
            cartModel.priceDisplay =_infoDic[@"price"];

            [model.cartItems  addObject:cartModel];;
            [arr addObject:model];

            MakeSureOrderViewController  *makeVc = [[MakeSureOrderViewController alloc]init];
            makeVc.dataArr = arr;
            makeVc.type = 0;
            [self.navigationController pushViewController:makeVc animated:YES];

        }

    }else{
        if ([_GitemModel.limitUserTotalBuyQuantity integerValue]>0 || [_GitemModel.minBuyQuantity integerValue]>0) {
                self.unitView.type = 0;
                self.unitView.ItemModel = _GitemModel;
                [self.unitView showinView:self.view];
                
                WeakSelf(self);
                [self.unitView setDidselectGoodsItemBlock:^(NSDictionary *dic) {
                    _infoDic = [dic mutableCopy];
                    cartModel.quantity = weakself.infoDic[@"quantity"];
                    cartModel.itemId = weakself.infoDic[@"goodId"];
                    cartModel.price = weakself.infoDic[@"price"];
                    cartModel.priceDisplay = weakself.infoDic[@"price"];

                    [model.cartItems  addObject:cartModel];;
                    [arr addObject:model];
                    
                    MakeSureOrderViewController  *makeVc = [[MakeSureOrderViewController alloc]init];
                    makeVc.dataArr = arr;
                    makeVc.type = 0;
                    [weakself.navigationController pushViewController:makeVc animated:YES];
                    
                    
                }];
                return;

        }else{
            cartModel.quantity = @"1";
            cartModel.itemId = _GitemModel.itemID;
            cartModel.price = _GitemModel.price;
            cartModel.priceDisplay = _GitemModel.price;

        }
        [model.cartItems  addObject:cartModel];;
        [arr addObject:model];
        MakeSureOrderViewController  *makeVc = [[MakeSureOrderViewController alloc]init];
        makeVc.dataArr = arr;
        makeVc.type = 0;
        [self.navigationController pushViewController:makeVc animated:YES];
    }
}

/**
 聊天
 */
- (void)chatBtnClick{
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    
    if (!_infoDic[@"title"]) {
        
        if (_type == PRO_TYPE_DEF){
            NSMutableString *unitStr = [NSMutableString string];
          

            for (int i = 0; i<_GitemModel.specificationValues.count; i++) {
                SpecificationModel *model = _GitemModel.specificationValues[i];
                [unitStr appendString:[NSString stringWithFormat:@"%@",model.name]];

            }
            NSDictionary *dic   = @{@"goodId":_GitemModel.itemID,
                         @"price":_GitemModel.price,
                         @"imageUrl":_GitemModel.imageUrlList[0],
                         @"unit":unitStr,
                         @"title":_GitemModel.title,
                         @"unitArr":@[],
                         @"quantity":@(1)
                         };
            _infoDic = [dic mutableCopy];
        
        }else{
            NSString *unitStr;
            NSDictionary *proDic = _GitemModel.product;
            NSArray *arr;
            if (proDic) {
                arr  = [_GitemModel.title componentsSeparatedByString:proDic[@"name"]];
                
            }
            
            if (arr.count >0) {
                unitStr  = arr[1];
                
            }

            NSDictionary *dic   = @{@"goodId":_GitemModel.itemID,
                                    @"price":_GitemModel.price,
                                    @"imageUrl":_GitemModel.imageUrlList[0],
                                    @"unit":unitStr,
                                    @"title":_GitemModel.title,
                                    @"unitArr":@[],
                                    @"quantity":@(1)
                                    };
            _infoDic = [dic mutableCopy];

        }
        
    }
    if ([self ChatManiSHisSelfwithHisId:[NSString stringWithFormat:@"%@",_GshopModel.shopId]]) {
        [self showTextHud:@"您不能跟自己聊天对话哦"];
        return;
    }
    xxxxViewController *chat =[[xxxxViewController alloc] init];
           //设置会话的类型，如单聊、讨论组、群聊、聊天室、客服、公众服务会话等
    chat.conversationType = ConversationType_PRIVATE;
            //设置会话的目标会话ID。（单聊、客服、公众服务会话为对方的ID，讨论组、群聊、聊天室为会话的ID）
    chat.targetId = _GshopModel.shopId;
    
            //设置聊天会话界面要显示的标题
    if (_GshopModel.shopName) {
        chat.title = _GshopModel.shopName;

    }else{
        chat.title = _GshopModel.sellerInfo;

    }
    chat.infoDic = @{@"title":_infoDic[@"title"],
                     @"proId":_infoDic[@"goodId"],
                     @"imageUrl":_infoDic[@"imageUrl"],
                     @"type":@"detail",
                     @"content":_infoDic[@"unit"],
                     @"price":_infoDic[@"price"]
                     };
            //显示聊天会话界面
    [self.navigationController pushViewController:chat animated:YES];

}



- (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType
{
    if (platformType == UMSocialPlatformType_Copy) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _printDic[@"url"];
        [self showTextHud:@"复制成功"];
        return;
    }
    
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    //创建网页内容对象
    NSString* thumbURL =  _GitemModel.imageUrlList[0];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:@"找坯布/半漂布、找面料就上丰云汇" descr:_GitemModel.title thumImage:thumbURL];
    //设置网页地址
    shareObject.webpageUrl = _printDic[@"url"];
    
    //分享消息对象设置分享内容对象
    messageObject.shareObject = shareObject;
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:self completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
       // [self alertWithError:error];
    }];
}


/**
 去购物车
 */
- (void)buyCartBtnClick{
    if (![[UserPL shareManager] userIsLogin]) {
        [self gotoLoginViewController];
        return;
    }
    LeiShopCartViewController *shopVc = [[LeiShopCartViewController alloc]init];
    [self.navigationController pushViewController:shopVc animated:YES];



}

- (void)shareInfo{
    [UMSocialUIManager setPreDefinePlatforms:@[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_Sina),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone)]];
    [UMSocialUIManager addCustomPlatformWithoutFilted:UMSocialPlatformType_Copy withPlatformIcon:[UIImage imageNamed:@"umsocial_copy1"] withPlatformName:@"复制链接"];
    [UMSocialUIManager showShareMenuViewInWindowWithPlatformSelectionBlock:^(UMSocialPlatformType platformType, NSDictionary *userInfo) {
        // 根据获取的platformType确定所选平台进行下一步操作
        [self shareWebPageToPlatformType:platformType];
    }];

}

/**
 收藏
 */
- (void)collectBtnClick{
    
    if (![[UserPL shareManager] userIsLogin]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshView)
                                                     name:@"userHaveLoginIn" object:nil];
        [self gotoLoginViewController];
        return;
    }
    if (_isCollected) {
        [CollectePL userCancleCollectGoodsWithGoodsId:_itemModel.itemId ndReturnBlock:^(id returnValue) {
            _isCollected = NO;
            [self showTextHud:@"收藏删除成功"];
            [_collectBtn setImage:[UIImage imageNamed:@"collect-b-50"] forState:UIControlStateNormal];

        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];

        }];
    }else{
        [CollectePL userCollectGoodsWithGoodsId:_itemModel.itemId ndReturnBlock:^(id returnValue) {
            _isCollected = YES;
            [self showTextHud:@"收藏成功"];
            [_collectBtn setImage:[UIImage imageNamed:@"collect-r-50"] forState:UIControlStateNormal];

        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
    }

    
    
}


/**
 二维码打印
 */
- (void)QRBtnClick{
    PrintQrNewViewController *priVc = [[PrintQrNewViewController alloc]init];
    priVc.infoDic = _printDic;
    [self.navigationController pushViewController:priVc animated:YES];

}



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


- (void)refreshView{
    [self loadGoodsDetail];
}

#pragma mark---------scrollviewdelegate

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _TopScrollView) {
        CGPoint size = _TopScrollView.contentOffset;
        NSLog(@"%f",size.y);
    }


}

#pragma mark------UIScrollView Delegate------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (scrollView == _TopScrollView) {
        CGFloat difference = _TopScrollView.contentSize.height-_TopScrollView.frame.size.height;
        if (difference < 0) {
            difference = 0;
        }
        // Load more~
        if (_TopScrollView.contentOffset.y >= difference+40) {
            [_MainScrollView setContentOffset:CGPointMake(0, ScreenHeight) animated:YES];
        }

    }
//    else if (scrollView == _webView.scrollView){
//        if (_webView.scrollView.contentOffset.y <= 40 ) {
//            [_MainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//
//        }
//
//    }
    
    
    
}

- (void)loadHomePageDatas{
    if (_webView.scrollView.contentOffset.y <= 40 ) {
        [_MainScrollView setContentOffset:CGPointMake(0, 0) animated:YES];
//        _webView.scrollView.zoomScale = 1;

        [_webView.scrollView.mj_header endRefreshing];
        
    }}


- (NSString *)adaptWebViewForHtml:(NSString *) htmlStr
{
    NSMutableString *headHtml = [[NSMutableString alloc] initWithCapacity:0];
    [headHtml appendString : @"<html>" ];
    
    [headHtml appendString : @"<head>" ];
    
    [headHtml appendString : @"<meta charset=\"utf-8\">" ];
    
    [headHtml appendString : @"<meta id=\"viewport\" name=\"viewport\" content=\"width=device-width,initial-scale=1.0,maximum-scale=2.0,user-scalable=yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-capable\" content=\"yes\" />" ];
    
    [headHtml appendString : @"<meta name=\"apple-mobile-web-app-status-bar-style\" content=\"black\" />" ];
    
    [headHtml appendString : @"<meta name=\"black\" name=\"apple-mobile-web-app-status-bar-style\" />" ];
    
    [headHtml appendString : @"<style>img{width:100%;}</style>" ];
    
    [headHtml appendString : @"<style>table{width:100%;}</style>" ];
    
    [headHtml appendString : @"<title>webview</title>" ];
    
    NSString *bodyHtml;
    bodyHtml = [NSString stringWithString:headHtml];
    bodyHtml = [bodyHtml stringByAppendingString:htmlStr];
    return bodyHtml;
    
}


//-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
//{
//    if ([scrollView isEqual:_MainScrollView]) {
//        return _webView;
//    }
//    return nil;
//}
//-(void)scrollViewDidZoom:(UIScrollView *)scrollView
//{
////    if ([scrollView isEqual:_MainScrollView]) {
////        CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
////        (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
////        CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
////        (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
////        _webView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
////                                      scrollView.contentSize.height * 0.5 + offsetY);
////    }
//}


@end
