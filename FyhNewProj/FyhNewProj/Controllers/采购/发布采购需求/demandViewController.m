//
//  demandViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "demandViewController.h"
#import "TZImagePickerController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "TZImageManager.h"
#import "TZVideoPlayerController.h"
#import "TZPhotoPreviewController.h"
#import "TZGifPhotoPreviewController.h"
#import "UIView+Layout.h"

#import "LxGridViewFlowLayout.h"
#import "ShowImageView.h"
#import "TZTestCell.h"

#import "UpImagePL.h"
#import "UserWantPL.h"
#import "ShopTypeView.h"
#import "MyNeedsModel.h"

#import "AppDelegate.h"
#import "MenueView.h"
#import "ChatListViewController.h"
#import "DOTabBarController.h"
#import "BusinessesShopViewController.h"
#import "ViewLogisticsControllerViewController.h"
@interface demandViewController ()<UITextFieldDelegate,UITextViewDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,ShopTypeViewDelegate>


@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic , strong) UIScrollView *myscrollView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic , strong) UITextField *biaotiTF;

@property (nonatomic , strong) UITextField *shuliangTF;

@property (nonatomic , strong) UITextView *miaosuTV;

@property (nonatomic,strong) UILabel *placeholderLabel;

@property (nonatomic , strong) UITextField *lianxifangshiTF;

@property (nonatomic , strong) UITextField *jiageTF;

@property (nonatomic , strong) SubBtn *shuliangBtn;

@property (nonatomic , strong) UITextField *shijianTF;

@property (nonatomic , strong) MenueView *menuView;

@property (nonatomic , strong) UIPopoverController *popoverController;

@end

@implementation demandViewController{

    CGFloat _originY;
    NSMutableArray *_selectedPhotos;
    NSMutableArray *_selectedAssets;
    NSMutableArray *_urlPhotos;
    NSMutableArray *_urlAssets;

    CGFloat _itemWH;
    CGFloat _margin;
    UpImagePL  *_upImagePL;
    NSString   *_categoryId;
    BOOL       _isSame;                    //相似程度
    BOOL       _demandCategory;            //需求类别
    BOOL       _isExistence;               //有无实体
    YLButton   * leisiBtn;              //类似BTN
    YLButton   * yiyangBtn;             //一样BTN
    YLButton   * xianhuoBtn;            //现货BTN
    YLButton   * qihuoBtn;              //期货BTN
    YLButton   * youBtn;                //有BTN
    YLButton   * wuBtn;                 //无BTN
    UIView     *view2;
    UIView     *view4;
    ShopTypeView    *_typeView;
    SubBtn          *_fenleiBtn;
    NSMutableArray  *_typeArr;      //分类
    NSMutableArray  *_unitArr;      //单位
    UILabel         *_unitLab;
    NSString        *_unit;
}

- (UIImagePickerController *)imagePickerVc {
    if (_imagePickerVc == nil) {
        _imagePickerVc = [[UIImagePickerController alloc] init];
        _imagePickerVc.delegate = self;

        // set appearance / 改变相册选择页的导航栏外观
        UIBarButtonItem *tzBarItem, *BarItem;
        if (iOS9Later) {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[TZImagePickerController class]]];
            BarItem = [UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UIImagePickerController class]]];
        } else {
            tzBarItem = [UIBarButtonItem appearanceWhenContainedIn:[TZImagePickerController class], nil];
            BarItem = [UIBarButtonItem appearanceWhenContainedIn:[UIImagePickerController class], nil];
        }
        NSDictionary *titleTextAttributes = [tzBarItem titleTextAttributesForState:UIControlStateNormal];
        [BarItem setTitleTextAttributes:titleTextAttributes forState:UIControlStateNormal];
    }
    return _imagePickerVc;
}

- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    _margin = 15;
    _itemWH = 62;
    layout.itemSize = CGSizeMake(_itemWH, _itemWH);
    layout.minimumInteritemSpacing = _margin;
    layout.minimumLineSpacing = _margin;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.tz_width, 122) collectionViewLayout:layout];
   // _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.myscrollView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}

-(MenueView *)menuView{
    if (!_menuView) {
        _menuView = [[MenueView alloc]init];
        _menuView.delegate = self;
    }
    
    return _menuView;
    
}

-(UIScrollView *)myscrollView{

    if (!_myscrollView) {
        _myscrollView = [[UIScrollView alloc] init];
        _myscrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-NaviHeight64-50-iPhoneX_DOWNHEIGHT);
        self.myscrollView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    }
    return _myscrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布采购需求";
    [self setBarBackBtnWithImage:nil];
    self.navigationController.delegate =self;
    _upImagePL = [[UpImagePL alloc]init];
    _selectedPhotos = [NSMutableArray array];
    _selectedAssets = [NSMutableArray array];
    _urlPhotos = [NSMutableArray array];

    _typeArr = [NSMutableArray array];
    _unitArr = [NSMutableArray arrayWithObjects:@"米",@"个",@"码",@"条",@"千克", nil];
    _unit = @"米";
     [self setUI];
}


-(void)setUI
{
    
    _typeView = [[ShopTypeView alloc]initWithFrame:CGRectMake(0, ScreenHeight -64-40, ScreenWidth, 10)];
    _typeView.delegate = self;
    
    UIImage *image = [UIImage imageNamed:@"more-white"];
    if (!image) return ;
    CGFloat imgHeight = 24;
    YLButton *button = [[YLButton alloc] initWithFrame:CGRectMake(0, 0, 40, imgHeight)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarItemClick) forControlEvents:UIControlEventTouchUpInside];
    [button setImageRect:CGRectMake(35, 4, 4, 16)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
        self.navigationItem.rightBarButtonItem = item;
    
    _originY = 0;
    [self.view addSubview: self.myscrollView];
    
    
    
    
    //上传图片栏
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 140)];
    view1.backgroundColor = [UIColor whiteColor];
    [self.myscrollView addSubview:view1];
    
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(11) WithSuper:view1 Frame:CGRectMake(20, 122, ScreenWidth, 11) Alignment:NSTextAlignmentLeft Text:@"注: 上传样布正面、反面、细节和边缘图片(最多五张)"];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 149, ScreenWidth, 1) Super:view1];
    _originY += 150;
    
     [self configCollectionView];
    
    
    
    //分类栏
    view2 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 50)];
    view2.backgroundColor = [UIColor whiteColor];
    [self.myscrollView addSubview:view2];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view2];

    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view2 Frame:CGRectMake(20, 17.5, 50, 15) Alignment:NSTextAlignmentLeft Text:@"分类"];
    
   _fenleiBtn = [SubBtn buttonWithtitle:@"坯布 ▼" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:14.5 andtarget:self action:@selector(fenlei) andframe:CGRectMake(ScreenWidth-20-90, 10.5, 90, 29)];
    _fenleiBtn.titleLabel.font = APPFONT(13);
    [view2 addSubview:_fenleiBtn];
    _categoryId = @"1000";
    
    _originY += 50;

    
    //标题和需求描述栏
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 285)];
    view3.backgroundColor = [UIColor whiteColor];
    [self.myscrollView addSubview:view3];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 284, ScreenWidth, 1) Super:view3];
    _originY += 285;

    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view3 Frame:CGRectMake(20, 15, 35, 15) Alignment:NSTextAlignmentLeft Text:@"标题"];
    
    UIView *biaotiview = [[UIView alloc]initWithFrame:CGRectMake(20+35, 15+15+10, ScreenWidth-20-35-20, 39)];
    biaotiview.layer.borderWidth = 1;
    biaotiview.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    biaotiview.layer.cornerRadius = 5;
    [view3 addSubview:biaotiview];
    
    
    _biaotiTF = [[UITextField alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth-20-35-20-20, 39)];
    _biaotiTF.placeholder = @"简单描述下你的需求(18字以内)";
    _biaotiTF.font = APPFONT(13);
    _biaotiTF.textColor = UIColorFromRGB(BlackColorValue);
    _biaotiTF.textAlignment = NSTextAlignmentLeft;
    _biaotiTF.delegate = self;
    [biaotiview addSubview:_biaotiTF];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view3 Frame:CGRectMake(20, CGRectGetMaxY(biaotiview.frame)+15, ScreenWidth, 15) Alignment:NSTextAlignmentLeft Text:@"需求描述"];
    
    UIView *miaosuview = [[UIView alloc]initWithFrame:CGRectMake(20+35, CGRectGetMaxY(biaotiview.frame)+15+15+10, ScreenWidth-20-35-20, 145)];
    miaosuview.layer.borderWidth = 1;
    miaosuview.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    miaosuview.layer.cornerRadius = 5;
    [view3 addSubview:miaosuview];
    
    _miaosuTV = [[UITextView alloc]initWithFrame:CGRectMake(10, 8, ScreenWidth-20-35-20-20, 145-15)];
    _miaosuTV.textColor = UIColorFromRGB(PlaColorValue);
    _miaosuTV.font = APPFONT(13);
    _miaosuTV.delegate = self;
    _miaosuTV.text = @"请尽可能多的提供信息，有助于供应商快速给您反馈信息";
    _miaosuTV.keyboardType = UIKeyboardTypeDefault;
    [miaosuview addSubview:_miaosuTV];
    
    //采购数量栏
   view4 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 50)];
    view4.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self.myscrollView addSubview:view4];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view4];
    _originY += 50;
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view4 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"采购数量"];
    
    _shuliangBtn = [SubBtn buttonWithtitle:@"米 ▼" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:14.5 andtarget:self action:@selector(caigoudanwei) andframe:CGRectMake(ScreenWidth-20-50, 10.5, 50, 29)];
    _shuliangBtn.titleLabel.font = APPFONT(13);
    [view4 addSubview:_shuliangBtn];
    
    _shuliangTF = [BaseViewFactory textFieldWithFrame:CGRectMake(ScreenWidth-40-50-150, 0, 150, 50) font:APPFONT(13) placeholder:@"请输入要采购的数量" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _shuliangTF.textAlignment = NSTextAlignmentRight;
    _shuliangTF.keyboardType = UIKeyboardTypeNumberPad;
    UILabel* placeholderLabel1 = [_shuliangTF valueForKey:@"_placeholderLabel"];
    
    placeholderLabel1.textAlignment=NSTextAlignmentRight;
    [view4 addSubview:_shuliangTF];
    
    //相似程度兰
    UIView *view5 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 50)];
    view5.backgroundColor= [UIColor whiteColor];
    [self.myscrollView addSubview:view5];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view5];
    _originY += 50;
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view5 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"相似程度"];
    
    
    CGFloat btnWidth = 55;
    CGFloat btnHeight = 50;

    leisiBtn  = [YLButton buttonWithType:UIButtonTypeCustom];
    [leisiBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    leisiBtn.frame = CGRectMake(ScreenWidth-50-2*btnWidth, 0, btnWidth, btnHeight);
    [leisiBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [leisiBtn setTitle:@"类似" forState:UIControlStateNormal];
    leisiBtn.titleLabel.font = APPFONT(13);
    [leisiBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [leisiBtn setImageRect:CGRectMake(0, 20, 10, 10)];
    [leisiBtn setTitleRect:CGRectMake(15, 0, 35, 50)];
    [leisiBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
    leisiBtn.tag = 5000;
    leisiBtn.on = NO;
    [view5 addSubview:leisiBtn];
    
//    UIButton *leisiBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-35-35-10-10-15-35-10-10, 20, 10, 10)];
//    [leisiBtn setImage:[UIImage imageNamed:@""] forState:0];
//    [leisiBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
//    leisiBtn.tag = 5000;
//    [view5 addSubview:leisiBtn];
//    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view5 Frame:CGRectMake(ScreenWidth-35-35-10-10-15-35, 17.5, 35, 15) Alignment:NSTextAlignmentCenter Text:@"类似"];
    yiyangBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [yiyangBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    yiyangBtn.frame = CGRectMake(ScreenWidth-30-btnWidth, 0, btnWidth, btnHeight);
    [yiyangBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [yiyangBtn setTitle:@"一样" forState:UIControlStateNormal];
    yiyangBtn.titleLabel.font = APPFONT(13);
    [yiyangBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [yiyangBtn setImageRect:CGRectMake(0, 20, 10, 10)];
    [yiyangBtn setTitleRect:CGRectMake(15, 0, 35, 50)];
    [yiyangBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
    yiyangBtn.tag = 5001;
    [view5 addSubview:yiyangBtn];
    yiyangBtn.on = NO;
    
//    UIButton *yiyangBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-35-35-10-10, 20, 10, 10)];
//    [yiyangBtn setImage:[UIImage imageNamed:@""] forState:0];
//    [yiyangBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
//    yiyangBtn.tag = 5001;
//    [view5 addSubview:yiyangBtn];
    
  //  [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view5 Frame:CGRectMake(ScreenWidth-35-35, 17.5, 35, 15) Alignment:NSTextAlignmentCenter Text:@"一样"];
    
    //需求类别栏
    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 50)];
    view6.backgroundColor= [UIColor whiteColor];
    [self.myscrollView addSubview:view6];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view6];
    _originY += 50;
    
     [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view6 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"需求类别"];
   xianhuoBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [xianhuoBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];

    xianhuoBtn.frame = CGRectMake(ScreenWidth-50-2*btnWidth, 0, btnWidth, btnHeight);
    [xianhuoBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [xianhuoBtn setTitle:@"现货" forState:UIControlStateNormal];
    xianhuoBtn.titleLabel.font = APPFONT(13);
    [xianhuoBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [xianhuoBtn setImageRect:CGRectMake(0, 20, 10, 10)];
    [xianhuoBtn setTitleRect:CGRectMake(15, 0, 35, 50)];
    [xianhuoBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
    xianhuoBtn.tag = 5002;
    [view6 addSubview:xianhuoBtn];
    xianhuoBtn.on = NO;
 
//    UIButton *xianhuoBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-35-35-10-10-15-35-10-10, 20, 10, 10)];
//    [xianhuoBtn setImage:[UIImage imageNamed:@""] forState:0];
//    [xianhuoBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
//    xianhuoBtn.tag = 5002;
//    [view6 addSubview:xianhuoBtn];
//    
//    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view6 Frame:CGRectMake(ScreenWidth-35-35-10-10-15-35, 17.5, 35, 15) Alignment:NSTextAlignmentCenter Text:@"现货"];
    
     qihuoBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [qihuoBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    qihuoBtn.frame = CGRectMake(ScreenWidth-30-btnWidth, 0, btnWidth, btnHeight);
    [qihuoBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [qihuoBtn setTitle:@"期货" forState:UIControlStateNormal];
    qihuoBtn.titleLabel.font = APPFONT(13);
    [qihuoBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [qihuoBtn setImageRect:CGRectMake(0, 20, 10, 10)];
    [qihuoBtn setTitleRect:CGRectMake(15, 0, 35, 50)];
    [qihuoBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
    qihuoBtn.tag = 5003;
    [view6 addSubview:qihuoBtn];
    qihuoBtn.on = NO;

//    UIButton *qihuoBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-35-35-10-10, 20, 10, 10)];
//    [qihuoBtn setImage:[UIImage imageNamed:@""] forState:0];
//    [qihuoBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
//    qihuoBtn.tag = 5003;
//    [view6 addSubview:qihuoBtn];
//    
//    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view6 Frame:CGRectMake(ScreenWidth-35-35, 17.5, 35, 15) Alignment:NSTextAlignmentCenter Text:@"期货"];
    
    //有无实样栏
    UIView *view7 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 50)];
    view7.backgroundColor= [UIColor whiteColor];
    [self.myscrollView addSubview:view7];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view7];
    _originY += 50;
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view7 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"有无实样"];
    
   youBtn  = [YLButton buttonWithType:UIButtonTypeCustom];
    [youBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];

    youBtn.frame = CGRectMake(ScreenWidth-50-2*btnWidth, 0, btnWidth, btnHeight);
    [youBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [youBtn setTitle:@"有" forState:UIControlStateNormal];
    youBtn.titleLabel.font = APPFONT(13);
    [youBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [youBtn setImageRect:CGRectMake(0, 20, 10, 10)];
    [youBtn setTitleRect:CGRectMake(15, 0, 35, 50)];
    [youBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
    youBtn.tag = 5004;
    [view7 addSubview:youBtn];
    youBtn.on = NO;
    
//    UIButton *youBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-35-35-10-10-15-35-10-10, 20, 10, 10)];
//    [youBtn setImage:[UIImage imageNamed:@""] forState:0];
//    [youBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
//    youBtn.tag = 5004;
//    [view7 addSubview:youBtn];
//    
//    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view7 Frame:CGRectMake(ScreenWidth-35-35-10-10-15-35, 17.5, 35, 15) Alignment:NSTextAlignmentCenter Text:@"有"];
    
    wuBtn  = [YLButton buttonWithType:UIButtonTypeCustom];
    [wuBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    wuBtn.frame = CGRectMake(ScreenWidth-30-btnWidth, 0, btnWidth, btnHeight);
    [wuBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    [wuBtn setTitle:@"无" forState:UIControlStateNormal];
    wuBtn.titleLabel.font = APPFONT(13);
    [wuBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [wuBtn setImageRect:CGRectMake(0, 20, 10, 10)];
    [wuBtn setTitleRect:CGRectMake(15, 0, 35, 50)];
    [wuBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
    wuBtn.tag = 5005;
    [view7 addSubview:wuBtn];
    wuBtn.on = NO;
    

    
//    UIButton *wuBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-35-35-10-10, 20, 10, 10)];
//    [wuBtn setImage:[UIImage imageNamed:@""] forState:0];
//    [wuBtn addTarget:self action:@selector(xuanzhong:) forControlEvents:UIControlEventTouchUpInside];
//    wuBtn.tag = 5005;
//    [view7 addSubview:wuBtn];
//    
//    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view7 Frame:CGRectMake(ScreenWidth-35-35, 17.5, 35, 15) Alignment:NSTextAlignmentCenter Text:@"无"];
    
    
    //联系方式栏
    UIView *view8 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 50)];
    view8.backgroundColor= [UIColor whiteColor];
    [self.myscrollView addSubview:view8];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view8];
    _originY += 50;
    
     [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view8 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"联系方式"];
    
    _lianxifangshiTF = [BaseViewFactory textFieldWithFrame:CGRectMake(20+70, 0, ScreenWidth-20-20-70, 50) font:APPFONT(13) placeholder:@"请输入手机号/QQ/邮箱" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _lianxifangshiTF.textAlignment = NSTextAlignmentRight;
    UILabel* placeholderLabel = [_lianxifangshiTF valueForKey:@"_placeholderLabel"];
    
    placeholderLabel.textAlignment=NSTextAlignmentRight;
    [view8 addSubview:_lianxifangshiTF];
    
    //希望价格栏
    UIView *view9 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 50)];
    view9.backgroundColor= [UIColor whiteColor];
    [self.myscrollView addSubview:view9];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view9];
    _originY += 50;
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view9 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"期望价格"];
    _unitLab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth-85, 17.5, 60, 15) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"元/米"];
    [view9  addSubview:_unitLab];
   // [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view9 Frame:CGRectMake(ScreenWidth-85, 17.5, 50, 15) Alignment:NSTextAlignmentRight Text:@"元/条"];

    _jiageTF = [BaseViewFactory textFieldWithFrame:CGRectMake(20+70, 0, ScreenWidth-20-20-70-65, 50) font:APPFONT(13) placeholder:@"请输入价格" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _jiageTF.textAlignment = NSTextAlignmentRight;
    _jiageTF.keyboardType = UIKeyboardTypeDecimalPad;
//    UILabel* placeh = [_jiageTF valueForKey:@"_placeholderLabel"];
//    
//    placeh.textAlignment=NSTextAlignmentRight;
    [view9 addSubview:_jiageTF];
    //注意价格后面带一个单位 上面有全局单位选择_shuliangBtn
    
    
   
    
    
    
    //到期时间栏
    UIView *view10 = [[UIView alloc]initWithFrame:CGRectMake(0, _originY, ScreenWidth, 50)];
    view10.backgroundColor= [UIColor whiteColor];
    [self.myscrollView addSubview:view10];
    [self createLineWithColor:UIColorFromRGB(PlaColorValue) frame:CGRectMake(0, 49, ScreenWidth, 1) Super:view10];
    _originY += 50;
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view10 Frame:CGRectMake(20, 17.5, 70, 15) Alignment:NSTextAlignmentLeft Text:@"到期时间"];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view10 Frame:CGRectMake(ScreenWidth-35-35, 17.5, 45, 15) Alignment:NSTextAlignmentRight Text:@"天"];
    
    _shijianTF = [BaseViewFactory textFieldWithFrame:CGRectMake(20+70, 18.5, ScreenWidth-20-20-70-35, 13) font:APPFONT(13) placeholder:@"请输入天数" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _shijianTF.textAlignment = NSTextAlignmentRight;
    _shijianTF.keyboardType = UIKeyboardTypeNumberPad;

    [view10 addSubview:_shijianTF];
    
    SubBtn *ReleaseBtn =[SubBtn buttonWithtitle:@"发布" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(Release) andframe:CGRectMake(0, ScreenHeight-50-NaviHeight64-iPhoneX_DOWNHEIGHT, ScreenWidth, 50)];
    ReleaseBtn.titleLabel.font = APPFONT(18);
    [self.view addSubview:ReleaseBtn];
    
    
    
    self.myscrollView.contentSize = CGSizeMake(ScreenWidth,_originY +50);


    //设置默认按钮
    _isSame = YES;
    _demandCategory = YES;
    _isExistence = YES;
    [self refreshChoseBtn];
    if (_model&&_model.categoryId) {
        [self loadInfo];

    }
    
}


-(void)refreshUIWithModel:(MyNeedsModel *)model{
    if (!model||!model.categoryId) {
        return;
    }
    _categoryId = model.categoryId;
    [_fenleiBtn setTitle:[NSString stringWithFormat:@"%@ ▼",model.categoryName] forState:UIControlStateNormal];
    _biaotiTF.text = model.title;
    _miaosuTV.textColor = UIColorFromRGB(BlackColorValue);
    _miaosuTV.text = model.goodsDescription;
    _shuliangTF.text = [NSString stringWithFormat:@"%ld",(long)model.quantity];
    _unitLab.text = [NSString stringWithFormat:@"元/%@",model.unit];
    _unit = model.unit;
    [_shuliangBtn setTitle:[NSString stringWithFormat:@"%@ ▼",model.unit] forState:UIControlStateNormal];
    _isSame = [model.isSame boolValue];
    _demandCategory = ![model.isCustom boolValue];
    _isExistence = ![model.hasSample boolValue];
    [self refreshChoseBtn];
    _lianxifangshiTF.text = model.contact;
    _jiageTF.text = model.expectUnitPrice;
//    int day = [model.expireTime intValue]/60/60/24;
    
    _shijianTF.text = [NSString stringWithFormat:@"%@",model.expireAfterDays];
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    for (int i = 0; i<model.imageUrlList.count; i++) {
        __block UIImage *image1 = nil;  //要加一个 __block因为 block代码默认不能改外面的东西（记住语法即可）
        dispatch_group_async(group, queue, ^{
            NSURL *url1 = [NSURL URLWithString:model.imageUrlList[i]];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            image1 = [UIImage imageWithData:data1];
            [_urlPhotos addObject:image1];
            
        });
    }
    dispatch_group_notify(group, queue, ^{
        
        // 5.回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            [_collectionView reloadData];
        });
    });


    
}

- (void)rightBarItemClick{

    self.menuView.OriginY = 60;
    [self.menuView show];

}
#pragma mark - 选取照片


-(void)shangchuan
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
    [sheet showInView:self.view];
    
}

#pragma mark - UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) { // take photo / 去拍照
        [self takePhoto];
    } else if (buttonIndex == 1) {
        [self pushImagePickerController];
    }
}
- (void)takePhoto {
    
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
        } else {
            NSLog(@"模拟器中无法打开照相机,请在真机中使用");
        }
    
}
#pragma mark - TZImagePickerController

- (void)pushImagePickerController {
//    if (iPad) {
//        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:5 delegate:self pushPhotoPickerVc:YES];
//        
//        
//#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
//        imagePickerVc.isSelectOriginalPhoto = NO;
//        
//        if (_urlPhotos.count>0) {
//            
//        }else{
//            imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
//            
//        }
//        
//        imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
//        
//        // 2. Set the appearance
//        // 2. 在这里设置imagePickerVc的外观
//        imagePickerVc.navigationBar.barTintColor = UIColorFromRGB(RedColorValue);
//        imagePickerVc.oKButtonTitleColorDisabled = UIColorFromRGB(RedColorValue);
//        imagePickerVc.oKButtonTitleColorNormal = UIColorFromRGB(RedColorValue);
//        imagePickerVc.navigationBar.translucent = NO;
//        
//        // 3. Set allow picking video & photo & originalPhoto or not
//        // 3. 设置是否可以选择视频/图片/原图
//        imagePickerVc.allowPickingVideo = NO;
//        imagePickerVc.allowPickingImage = YES;
//        imagePickerVc.allowPickingOriginalPhoto = NO;
//        imagePickerVc.allowPickingGif = NO;
//        
//        // 4. 照片排列按修改时间升序
//        imagePickerVc.sortAscendingByModificationDate = YES;
//        
//        // imagePickerVc.minImagesCount = 3;
//        // imagePickerVc.alwaysEnableDoneBtn = YES;
//        
//        // imagePickerVc.minPhotoWidthSelectable = 3000;
//        // imagePickerVc.minPhotoHeightSelectable = 2000;
//        
//        /// 5. Single selection mode, valid when maxImagesCount = 1
//        /// 5. 单选模式,maxImagesCount为1时才生效
//        imagePickerVc.showSelectBtn = NO;
//        imagePickerVc.allowCrop = YES;
//        imagePickerVc.needCircleCrop =NO;
//        imagePickerVc.circleCropRadius = 100;
//        /*
//         [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
//         cropView.layer.borderColor = [UIColor redColor].CGColor;
//         cropView.layer.borderWidth = 2.0;
//         }];*/
//        
//        //imagePickerVc.allowPreview = NO;
//#pragma mark - 到这里为止
//        
//        // You can get the photos by block, the same as by delegate.
//        // 你可以通过block或者代理，来得到用户选择的照片.
//        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
//            
//        }];
//        //        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
////        imagePicker.delegate = self;
////        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
////        imagePicker.allowsEditing = NO;
//        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
//            [self presentViewController:imagePickerVc animated:YES completion:nil];
//
////            UIPopoverController *popover = [[UIPopoverController alloc] initWithContentViewController:imagePickerVc];
////            _popoverController= popover;
////            [_popoverController presentPopoverFromRect:CGRectMake(0, 0, 600, 800) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
//            
//        }];
//    }else{
        
        TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:5 delegate:self pushPhotoPickerVc:YES];
        
        
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
        imagePickerVc.isSelectOriginalPhoto = NO;
        
        if (_urlPhotos.count>0) {
            
        }else{
            imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
            
        }
        
        imagePickerVc.allowTakePicture = NO; // 在内部显示拍照按钮
        
        // 2. Set the appearance
        // 2. 在这里设置imagePickerVc的外观
        imagePickerVc.navigationBar.barTintColor = UIColorFromRGB(RedColorValue);
        imagePickerVc.oKButtonTitleColorDisabled = UIColorFromRGB(RedColorValue);
        imagePickerVc.oKButtonTitleColorNormal = UIColorFromRGB(RedColorValue);
        imagePickerVc.navigationBar.translucent = NO;
        
        // 3. Set allow picking video & photo & originalPhoto or not
        // 3. 设置是否可以选择视频/图片/原图
        imagePickerVc.allowPickingVideo = NO;
        imagePickerVc.allowPickingImage = YES;
        imagePickerVc.allowPickingOriginalPhoto = NO;
        imagePickerVc.allowPickingGif = NO;
        
        // 4. 照片排列按修改时间升序
        imagePickerVc.sortAscendingByModificationDate = YES;
        
        // imagePickerVc.minImagesCount = 3;
        // imagePickerVc.alwaysEnableDoneBtn = YES;
        
        // imagePickerVc.minPhotoWidthSelectable = 3000;
        // imagePickerVc.minPhotoHeightSelectable = 2000;
        
        /// 5. Single selection mode, valid when maxImagesCount = 1
        /// 5. 单选模式,maxImagesCount为1时才生效
        imagePickerVc.showSelectBtn = NO;
        imagePickerVc.allowCrop = YES;
        imagePickerVc.needCircleCrop =NO;
        imagePickerVc.circleCropRadius = 100;
        /*
         [imagePickerVc setCropViewSettingBlock:^(UIView *cropView) {
         cropView.layer.borderColor = [UIColor redColor].CGColor;
         cropView.layer.borderWidth = 2.0;
         }];*/
        
        //imagePickerVc.allowPreview = NO;
#pragma mark - 到这里为止
        
        // You can get the photos by block, the same as by delegate.
        // 你可以通过block或者代理，来得到用户选择的照片.
        [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
            
        }];
        if (iPad) {
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [self presentViewController:imagePickerVc animated:YES completion:nil];
            }];
        }else{
        
            [self presentViewController:imagePickerVc animated:YES completion:nil];
        }
    
   
}

- (void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:nil];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    if ([type isEqualToString:@"public.image"]) {
        TZImagePickerController *tzImagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:self];
       // tzImagePickerVc.sortAscendingByModificationDate = self.sortAscendingSwitch.isOn;
        [tzImagePickerVc showProgressHUD];
        UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
        // save photo and get asset / 保存图片，获取到asset
        [[TZImageManager manager] savePhotoWithImage:image completion:^(NSError *error){
            if (error) {
                [tzImagePickerVc hideProgressHUD];
                NSLog(@"图片保存失败 %@",error);
            } else {
                [[TZImageManager manager] getCameraRollAlbum:NO allowPickingImage:YES completion:^(TZAlbumModel *model) {
                    [[TZImageManager manager] getAssetsFromFetchResult:model.result allowPickingVideo:NO allowPickingImage:YES completion:^(NSArray<TZAssetModel *> *models) {
                        [tzImagePickerVc hideProgressHUD];
                        TZAssetModel *assetModel = [models firstObject];
                        if (tzImagePickerVc.sortAscendingByModificationDate) {
                            assetModel = [models lastObject];
                        }
                       
                        [self refreshCollectionViewWithAddedAsset:assetModel.asset image:image];

                        
                    }];
                }];
            }
        }];
    }
}
- (void)refreshCollectionViewWithAddedAsset:(id)asset image:(UIImage *)image {
    
    if (_urlPhotos.count>0) {
            if (_urlPhotos.count<5) {
                [_urlPhotos addObject:image];
            }else{
                [self showTextHud:@"最多添加五张图片"];
            }
        [_collectionView reloadData];

    }else{
        if (_selectedPhotos.count>=5) {
            [self showTextHud:@"最多选取五张图片"];
            return;
        }
        [_selectedAssets addObject:asset];
        [_selectedPhotos addObject:image];
        [_collectionView reloadData];
    }
    

}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if ([picker isKindOfClass:[UIImagePickerController class]]) {
        [picker dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) { // 去设置界面，开启相机访问权限
        if (iOS8Later) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        } else {
            NSURL *privacyUrl;
            if (alertView.tag == 1) {
             //   privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
              //  privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
            }
            if ([[UIApplication sharedApplication] canOpenURL:privacyUrl]) {
                [[UIApplication sharedApplication] openURL:privacyUrl];
            } else {
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"抱歉" message:@"无法跳转到隐私设置页面，请手动前往设置页面，谢谢" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
            }
        }
    }
}
#pragma mark - TZImagePickerControllerDelegate

/// User click cancel button
/// 用户点击了取消
- (void)tz_imagePickerControllerDidCancel:(TZImagePickerController *)picker {
    // NSLog(@"cancel");
}

// The picker should dismiss itself; when it dismissed these handle will be called.
// If isOriginalPhoto is YES, user picked the original photo.
// You can get original photo with asset, by the method [[TZImageManager manager] getOriginalPhotoWithAsset:completion:].
// The UIImage Object in photos default width is 828px, you can set it by photoWidth property.
// 这个照片选择器会自己dismiss，当选择器dismiss的时候，会执行下面的代理方法
// 如果isSelectOriginalPhoto为YES，表明用户选择了原图
// 你可以通过一个asset获得原图，通过这个方法：[[TZImageManager manager] getOriginalPhotoWithAsset:completion:]
// photos数组里的UIImage对象，默认是828像素宽，你可以通过设置photoWidth属性的值来改变它
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingPhotos:(NSArray *)photos sourceAssets:(NSArray *)assets isSelectOriginalPhoto:(BOOL)isSelectOriginalPhoto {
    
    if (_urlPhotos.count>0) {
        _selectedAssets = [NSMutableArray arrayWithArray:assets];
        for (UIImage *image in photos) {
            if (_urlPhotos.count<5) {
                [_urlPhotos addObject:image];
            }else{
                [self showTextHud:@"最多添加五张图片"];
            }
        }
    }else{
        _selectedPhotos = [NSMutableArray arrayWithArray:photos];
        _selectedAssets = [NSMutableArray arrayWithArray:assets];

    }
        [_collectionView reloadData];

    
    // 1.打印图片名字
    [self printAssetsName:assets];
}

// If user picking a video, this callback will be called.
// If system version > iOS8,asset is kind of PHAsset class, else is ALAsset class.
// 如果用户选择了一个视频，下面的handle会被执行
// 如果系统版本大于iOS8，asset是PHAsset类的对象，否则是ALAsset类的对象
- (void)imagePickerController:(TZImagePickerController *)picker didFinishPickingVideo:(UIImage *)coverImage sourceAssets:(id)asset {
    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
    // open this code to send video / 打开这段代码发送视频
    // [[TZImageManager manager] getVideoOutputPathWithAsset:asset completion:^(NSString *outputPath) {
    // NSLog(@"视频导出到本地完成,沙盒路径为:%@",outputPath);
    // Export completed, send video here, send by outputPath or NSData
    // 导出完成，在这里写上传代码，通过路径或者通过NSData上传
    
    // }];
    // _collectionView.contentSize = CGSizeMake(0, ((_selectedPhotos.count + 2) / 3 ) * (_margin + _itemWH));
}

#pragma mark - Private

/// 打印图片名字
- (void)printAssetsName:(NSArray *)assets {
    NSString *fileName;
    for (id asset in assets) {
        if ([asset isKindOfClass:[PHAsset class]]) {
            PHAsset *phAsset = (PHAsset *)asset;
            fileName = [phAsset valueForKey:@"filename"];
        } else if ([asset isKindOfClass:[ALAsset class]]) {
            ALAsset *alAsset = (ALAsset *)asset;
            fileName = alAsset.defaultRepresentation.filename;;
        }
        NSLog(@"图片名字:%@",fileName);
    }
}
#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (_urlPhotos.count>0) {
        return _urlPhotos.count+1;
    }
    return _selectedPhotos.count + 1;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
    if (_urlPhotos.count >0) {
        if (indexPath.row == _urlPhotos.count) {
            cell.imageView.image = [UIImage imageNamed:@"upload-photo"];
            cell.deleteBtn.hidden = YES;
            cell.gifLable.hidden = YES;
        } else {
            cell.imageView.image = _urlPhotos[indexPath.row];
            cell.deleteBtn.hidden = NO;
        }
        
        cell.gifLable.hidden = YES;
        
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    }else{
        if (indexPath.row == _selectedPhotos.count) {
            cell.imageView.image = [UIImage imageNamed:@"upload-photo"];
            cell.deleteBtn.hidden = YES;
            cell.gifLable.hidden = YES;
        } else {
            cell.imageView.image = _selectedPhotos[indexPath.row];
            if (_selectedAssets.count >= indexPath.row+1) {
                cell.asset = _selectedAssets[indexPath.row];
            }
            
            cell.deleteBtn.hidden = NO;
        }
        
        cell.gifLable.hidden = YES;
        
        cell.deleteBtn.tag = indexPath.row;
        [cell.deleteBtn addTarget:self action:@selector(deleteBtnClik:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_urlPhotos.count>0) {
        if (indexPath.row ==_urlPhotos.count) {
            BOOL showSheet = YES;
            if (showSheet) {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
                [sheet showInView:self.view];
            } else {
                [self pushImagePickerController];
            }

        }
    }else{
        if (indexPath.row == _selectedPhotos.count) {
            BOOL showSheet = YES;
            if (showSheet) {
                UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
                [sheet showInView:self.view];
            } else {
                [self pushImagePickerController];
            }
        } 
    }
   }
#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    if (_urlPhotos.count>0) {
        return indexPath.item < _urlPhotos.count;

    }
    return indexPath.item < _selectedPhotos.count;
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (_urlPhotos.count>0) {
        return (sourceIndexPath.item < _urlPhotos.count && destinationIndexPath.item < _urlPhotos.count);
        
    }
    return (sourceIndexPath.item < _selectedPhotos.count && destinationIndexPath.item < _selectedPhotos.count);
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    if (_urlPhotos.count>0) {
        UIImage *image = _urlPhotos[sourceIndexPath.item];
        [_urlPhotos removeObjectAtIndex:sourceIndexPath.item];
        [_urlPhotos insertObject:image atIndex:destinationIndexPath.item];

    }else{
        UIImage *image = _selectedPhotos[sourceIndexPath.item];
        [_selectedPhotos removeObjectAtIndex:sourceIndexPath.item];
        [_selectedPhotos insertObject:image atIndex:destinationIndexPath.item];
        
        id asset = _selectedAssets[sourceIndexPath.item];
        if (asset) {
            [_selectedAssets removeObjectAtIndex:sourceIndexPath.item];
            [_selectedAssets insertObject:asset atIndex:destinationIndexPath.item];
            
        }

    }

    
    [_collectionView reloadData];
}


#pragma mark -------------- btnclick

- (void)deleteBtnClik:(UIButton *)sender {
    if (_urlPhotos.count>0) {
        [_urlPhotos removeObjectAtIndex:sender.tag];
        [_collectionView reloadData];

    }else{
        [_selectedPhotos removeObjectAtIndex:sender.tag];
        [_selectedAssets removeObjectAtIndex:sender.tag];
        
        [_collectionView performBatchUpdates:^{
            NSIndexPath *indexPath = [NSIndexPath indexPathForItem:sender.tag inSection:0];
            [_collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:^(BOOL finished) {
            [_collectionView reloadData];
        }];

    }
    }



/**
 选择分类
 */
-(void)fenlei
{
    
    CGRect frame = [_myscrollView convertRect:view2.frame toView:self.view];

    _typeView.shoptype  = 1;
    if (_typeArr.count>0) {
        NSMutableArray *dataArr = [[NSMutableArray alloc]init];
        for (NSDictionary *caDic in _typeArr) {
            [dataArr addObject:caDic[@"name"]];
        }
        _typeView.dataArr =dataArr;
        [_typeView UserWantshowInView:self.view withFrame:frame];

    }else{
        [UserWantPL getUserCategorylistwithReturnBlock:^(id returnValue) {
            NSDictionary *dic = returnValue[@"data"];
            NSArray *ListArr = dic[@"purchasingNeedCategoryList"];
            NSMutableArray *dataArr = [[NSMutableArray alloc]init];
            for (NSDictionary *caDic in ListArr) {
                [_typeArr addObject:caDic];
                [dataArr addObject:caDic[@"name"]];
            }
            
            _typeView.dataArr =dataArr;
            [_typeView UserWantshowInView:self.view withFrame:frame];
            
            NSLog(@"%@",dic);
            
        } andErrorBlock:^(NSString *msg) {
            [self showTextHudInSelfView:msg];
            
        }];
    }
}

#pragma mark =========== shopTypeview
-(void)didSelectedcancelPickerBtn{
    [_typeView UserWantcancelPicker];
    
    
}

-(void)didSelectedtableviewRow:(NSInteger)index{
    [_typeView UserWantcancelPicker];
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    for (NSDictionary *caDic in _typeArr) {
        [dataArr addObject:caDic[@"name"]];
    }
    _categoryId = _typeArr[index][@"id"];
    [_fenleiBtn setTitle:[NSString stringWithFormat:@"%@ ▼",dataArr[index]] forState:UIControlStateNormal];

}

-(void)didSelectedunitRow:(NSInteger)index{
    [_typeView UserWantcancelPicker];
    _unitLab.text = [NSString stringWithFormat:@"元/%@",_unitArr[index]];
    _unit = _unitArr[index];
    [_shuliangBtn setTitle:[NSString stringWithFormat:@"%@ ▼",_unitArr[index]] forState:UIControlStateNormal];



}

-(void)caigoudanwei
{
    CGRect frame = [_myscrollView convertRect:view4.frame toView:self.view];
    // frame = (origin = (x = 0, y = 435), size = (width = 375, height = 50))
    if (_myscrollView.contentOffset.y<250) {
        CGPoint position = CGPointMake(0, 250);
        [_myscrollView setContentOffset:position animated:YES];
        frame.origin.y = 235;
        
    }
    
    _typeView.shoptype  = 2;
    _typeView.dataArr = _unitArr;
    [_typeView UserWantshowInView:self.view withFrame:frame];
    
}

-(void)xuanzhong:(UIButton *)btn
{
    switch (btn.tag) {
        case 5000:{
            _isSame = YES;
            
            break;
        }
        case 5001:{
            _isSame = NO;
            break;
        }
        case 5002:{
            _demandCategory = YES;
            break;
        }
        case 5003:{
            _demandCategory = NO;
            break;
        }
        case 5004:{
            _isExistence = YES;
            break;
        }
        case 5005:{
             _isExistence = NO;
            break;
        }
        default:
            break;
    }
    [self refreshChoseBtn];
    
}

- (void)loadInfo{
[UserWantPL userGetNeedWithNeedId:_model.needsId andReturnBlock:^(id returnValue) {
    NSDictionary *dic   = returnValue[@"data"];
    NSDictionary *infodic   = dic[@"purchasingNeed"];
    _model.expireAfterDays = infodic[@"expireAfterDays"];
    [self refreshUIWithModel:_model];

} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];
}];
}


/**
 发布需求
 */
-(void)Release
{
    
    if (_selectedPhotos.count<=0&&_urlPhotos.count<=0) {
        [self showTextHud:@"请添加商品图片"];
        return;
    }
    if (_lianxifangshiTF.text.length <= 0) {
        [self showTextHud:@"请添加联系方式"];
        return;
    }
    if (_shuliangTF.text.length <= 0) {
        [self showTextHud:@"请添加采购数量"];
        return;
    }
    if (_biaotiTF.text.length <= 0) {
        [self showTextHud:@"请添加采购标题"];
        return;
    }
    if (_shijianTF.text.length <= 0) {
        [self showTextHud:@"请添加有效时间"];
        return;
    }
    

   /*
    {
    cdnUrl = "http://114.55.5.207:82";
    imageUrls =     (
    "upload/5-36bcb6648730a8ee4041a39e7f5f273d.jpeg"
    );
    }
    
    {
    cdnUrl = "http://114.55.5.207:82";
    imageUrls =     (
    "upload/5-dd6e15297241266fd6e5a9795c45d1b8.jpeg",
    "upload/5-f2bf2675359512c5f03c455c322627e0.jpeg",
    "upload/5-468294714e47854a553d2135952f1547.jpeg",
    "upload/5-72bb70592e732e996b47ad89551be2e4.jpeg"
    );
    }
    
    */
    NSMutableArray *imageArr;
    if (_urlPhotos.count>0) {
        imageArr = _urlPhotos;
    }else{
        imageArr =_selectedPhotos;
    }
    
    
   [_upImagePL updateToByGoodsImgArr:imageArr WithReturnBlock:^(id returnValue) {
       NSDictionary *dic = returnValue;
       NSArray *imageArr = dic[@"imageUrls"];
     //  [self showTextHudInSelfView:@"图片上传成功"];
       
       NSString *needDis;//需求描述
       if ([_miaosuTV.text isEqualToString: @"多行输入"]||_miaosuTV.text.length<=0) {
           needDis = @"";
       }else{
           needDis = _miaosuTV.text;
       }
       //期望价格，可以为空
       if (_jiageTF.text.length<=0) {
           _jiageTF.text = @"";
       }
       //图片地址
       NSString *ImageUrls;
       ImageUrls = [imageArr componentsJoinedByString:@","];
       //现货期货
       NSString  *isXianHuo;
       if (_demandCategory) {
           isXianHuo = @"0";
       }else{
           isXianHuo = @"1";
       }

       //是否有实样
       NSString  *isExistence;
       if (_isExistence) {
           isExistence = @"1";
       }else{
           isExistence = @"0";
       }
       //是否一样
        NSString  *TheSame;
       if (_isSame) {
           TheSame = @"0";
       }else{
           TheSame = @"1";
       }
       
       NSDictionary *infoDic = @{
                                 @"categoryId":_categoryId,                                     //类目Id
                                 @"contact":_lianxifangshiTF.text,                              //联系方式
                                 @"description":needDis,                                        //需求描述，可以为空
                                 @"expectUnitPrice":_jiageTF.text,                              //期望价格，可以为空
                                 @"hasSample":isExistence,                                      //是否有实样
                                 @"imageUrl":ImageUrls,                                         //不带域名的图片地址，多个地址时以英文逗号隔开，可以为空
                                 @"isCustom":isXianHuo,                                         //是否定制（期货
                                 @"isSame":TheSame,                                             //是否完全一样，
                                 @"quantity":_shuliangTF.text,                                  //采购数量
                                 @"title":_biaotiTF.text,                                       //采购标题
                                 @"unit":_unit,                                                 //单位
                                 @"expireAfterDays":_shijianTF.text                             //几天后过期
                                 };
       if (_type == 2) {
           [UserWantPL userEditNeedWithNeedId:_model.needsId andDic:infoDic andReturnBlock:^(id returnValue) {
               MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
               hud.mode = MBProgressHUDModeText;
               hud.label.text = @"上传成功";
               hud.margin = 10.0f;
               hud.removeFromSuperViewOnHide = YES;
               // [hud hide:YES afterDelay:1.5];
               [hud hideAnimated:YES afterDelay:1.5];
               [[NSNotificationCenter defaultCenter] postNotificationName:@"userNeedsHaveChanged" object:nil userInfo:nil];

               [self.navigationController popViewControllerAnimated:YES];

           } andErrorBlock:^(NSString *msg) {
               [self showTextHudInSelfView:msg];

           }];
       }else{
           [UserWantPL addGoodsWithDic:infoDic withReturnBlock:^(id returnValue) {
               [self showTextHudInSelfView:@"上传成功"];
               [self.navigationController popViewControllerAnimated:YES];
               
               NSLog(@"上传成功=====%@",returnValue);
               
           } andErrorBlock:^(NSString *msg) {
               [self showTextHudInSelfView:msg];
               
           }];

       
       }
       
       
       
       
       
       
       NSLog(@"%@",dic);
       
       
   } withErrorBlock:^(NSString *msg) {
       [self showTextHudInSelfView:msg];

   }];
    
    
    
}


#pragma mark -------------- 单选状态

- (void)refreshChoseBtn{
    if (_isSame) {
        //类似
        [leisiBtn setImage:[UIImage imageNamed:@"radio-btn-pre"] forState:UIControlStateNormal];
        [yiyangBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    }else{
        //一样
        [yiyangBtn setImage:[UIImage imageNamed:@"radio-btn-pre"] forState:UIControlStateNormal];
        [leisiBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    }
    if (_demandCategory) {
        //现货
        [xianhuoBtn setImage:[UIImage imageNamed:@"radio-btn-pre"] forState:UIControlStateNormal];
        [qihuoBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    }else{
        //期货
        [qihuoBtn setImage:[UIImage imageNamed:@"radio-btn-pre"] forState:UIControlStateNormal];
        [xianhuoBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
        
    }
    if (_isExistence) {
        //有实样
        [youBtn setImage:[UIImage imageNamed:@"radio-btn-pre"] forState:UIControlStateNormal];
        [wuBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
    }else{
        //无实样
        [wuBtn setImage:[UIImage imageNamed:@"radio-btn-pre"] forState:UIControlStateNormal];
        [youBtn setImage:[UIImage imageNamed:@"radio-btn"] forState:UIControlStateNormal];
        
    }
}




#pragma mark ===== textview

-(BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@"请尽可能多的提供信息，有助于供应商快速给您反馈信息"]) {
        textView.text = @"";
        textView.textColor = UIColorFromRGB(BlackColorValue);
    }
    
    
    return YES;
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([textView.text isEqualToString:@""]||!textView.text) {
        textView.text = @"请尽可能多的提供信息，有助于供应商快速给您反馈信息";
        textView.textColor = UIColorFromRGB(PlaColorValue);
    }
    
    
    return YES;


}

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if (textView == _miaosuTV) {
        if ([text isEqualToString:@""]) {
            return YES;
        }
        if (_miaosuTV.text.length>=150) {
            return NO;
        }
    }
    
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView{
    
    if (textView == _miaosuTV) {
        
        if (_miaosuTV.text.length>150) {
            _miaosuTV.text = [_miaosuTV.text substringToIndex:150];
        }
    }
    
}



-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    if (textField == _biaotiTF) {
        if (string.length == 0) return YES;
        
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        if (existedLength - selectedLength + replaceLength > 18) {
            return NO;
        }
    }
    
    return YES;    return YES;
}
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField == _biaotiTF) {
        if (textField.text.length > 20) {
            textField.text = [textField.text substringToIndex:20];
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

@end
