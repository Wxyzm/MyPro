//
//  GoodsEditViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/11.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GoodsEditViewController.h"
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

#import "GItemModel.h"
#import "GoodsItemsPL.h"
#import "UnitCell.h"
#import "AttributesModel.h"
#import "AddUnitView.h"
#import "HTMLViewController.h"
#import "ListEditViewController.h"
#import "IdeaCellModel.h"
#import "AccessCellModel.h"
#import "UpImagePL.h"
#import "PublishGoodsPL.h"

@interface GoodsEditViewController ()<TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,AddUnitViewDelegate>

@property (nonatomic , strong) UIScrollView *myscrollView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic , strong) UITableView *unitTabieView;

@property (nonatomic , strong) AddUnitView *addView;

@property (nonatomic , strong) UIView *setView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;


@end

@implementation GoodsEditViewController{
    CGFloat   _OrginY;
    UpImagePL   *_upImagePL;

    NSMutableArray *_urlPhotos;         //照片数组
    UITextField    *_goodNameTxt;        //商品标题
    UILabel        *_kindLab;            //商品类目
    NSMutableDictionary   *_resultDic;
    NSMutableArray *_unitDataArr;
    NSString    *_specificationIds;     //以英文逗号,隔开的规格id
    NSString    *_categoryId;           //类目id
    NSString    *_htmlStr;              //宝贝描述
    NSString    *_priceStr;             //价格
    NSString    *_stock;                //库存
    NSString    *_minbuy;               //库存
    NSString    *_limbuy;               //库存

    IdeaCellModel   *_idModel;
    AccessCellModel *_accModel;
    NSInteger   _type;
}
#pragma mark ------- view重写get方法
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


-(UIView *)setView{
    if (!_setView) {
        _setView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    
        [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:_setView Frame:CGRectMake(15, 0, 200, 50) Alignment:NSTextAlignmentLeft Text:@"宝贝描述"];
        
        UIImageView *rightimage = [BaseViewFactory icomWithWidth:9.5 imagePath:@"right"];
        [_setView addSubview:rightimage];
        rightimage.frame = CGRectMake(ScreenWidth - 25, 17, 9.5, 16);
        
        
        UIButton *miaoshuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        miaoshuBtn.frame = CGRectMake(0, 0, ScreenWidth, 50);
        [_setView addSubview:miaoshuBtn];
        [miaoshuBtn addTarget:self action:@selector(miaoshuBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
        UIView *bgView = [BaseViewFactory viewWithFrame:CGRectMake(0, 50, ScreenWidth, 128) color:UIColorFromRGB(0xe6e9ed)];
        [miaoshuBtn addSubview:bgView];
        
        SubBtn *putinBtn = [SubBtn buttonWithtitle:@"放入仓库" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(putGoodsIn)];
        putinBtn.titleLabel.font = APPFONT(18);
        putinBtn.frame = CGRectMake(20, 90, (ScreenWidth - 75)/2, 50);
        [_setView addSubview:putinBtn];
        
        
        SubBtn *setupBtn = [SubBtn buttonWithtitle:@"立即发布" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(setupGoodsatOnce) andframe:CGRectMake(ScreenWidth/2+17.5, 90, (ScreenWidth - 75)/2, 50)];
        setupBtn.titleLabel.font = APPFONT(18);
        [_setView addSubview:setupBtn];

    
    }
    return _setView;
}

-(UIScrollView *)myscrollView{
    
    if (!_myscrollView) {
        _myscrollView = [[UIScrollView alloc] init];
        _myscrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        self.myscrollView.backgroundColor = UIColorFromRGB(0xe6e9ed);
    }
    return _myscrollView;
}
- (void)configCollectionView {
    // 如不需要长按排序效果，将LxGridViewFlowLayout类改成UICollectionViewFlowLayout即可
    LxGridViewFlowLayout *layout = [[LxGridViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(62, 62);
    layout.minimumInteritemSpacing = 15;
    layout.minimumLineSpacing = 15;
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 39, self.view.tz_width, 122) collectionViewLayout:layout];
    // _collectionView.alwaysBounceVertical = YES;
    _collectionView.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _collectionView.contentInset = UIEdgeInsetsMake(0, 20, 0, 20);
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.myscrollView addSubview:_collectionView];
    [_collectionView registerClass:[TZTestCell class] forCellWithReuseIdentifier:@"TZTestCell"];
}
#pragma mark ------- viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"商品编辑";
    _urlPhotos = [NSMutableArray array];
    _unitDataArr = [NSMutableArray array];
    _htmlStr = @"";
    _upImagePL = [[UpImagePL alloc]init];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHavesetupGoodsHTML:)
                                                 name:@"UserHavesetupGoodsHTML"  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHavesetupGoodsList:)
                                                 name:@"UserHaveChangeGoodsList"  object:nil];

    [self loadGoodsInfo];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}
#pragma mark ------- initUI

- (void)initUI{

    _addView = [[AddUnitView alloc]init];
    _addView.type = 1;
    _addView.delegate = self;
  //  _addView.baseVC = self;

    
    _OrginY = 0;
    [self.view addSubview:self.myscrollView];
    
    //照片
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:_myscrollView Frame:CGRectMake(15, _OrginY, 200, 39) Alignment:NSTextAlignmentLeft Text:@"商品主图"];
    _OrginY +=39;

    
    _OrginY +=122;
    
    //商品信息
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:_myscrollView Frame:CGRectMake(15, _OrginY, 200, 39) Alignment:NSTextAlignmentLeft Text:@"商品信息"];
    _OrginY +=39;

    UIView *goodsinfoView = [BaseViewFactory viewWithFrame:CGRectMake(0, _OrginY, ScreenWidth, 100) color:UIColorFromRGB(WhiteColorValue)];
    [_myscrollView addSubview:goodsinfoView];
    NSArray *titleArr = @[@"商品标题",@"类目"];
    for (int i = 0; i<2; i++) {
        [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:goodsinfoView Frame:CGRectMake(15, 50*i, 200, 50) Alignment:NSTextAlignmentLeft Text:titleArr[i]];
        [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0,49 + 50*i, ScreenWidth, 1) Super:goodsinfoView];
        
    }
    _goodNameTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(100, 0, ScreenWidth -115,50) font:APPFONT(15) placeholder:_resultDic[@"title"] textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(BlackColorValue) delegate:self];
    _goodNameTxt.textAlignment = NSTextAlignmentRight;
    _goodNameTxt.userInteractionEnabled = NO;
    [goodsinfoView addSubview:_goodNameTxt];
    
    _kindLab = [BaseViewFactory labelWithFrame:CGRectMake(100, 50, ScreenWidth -115,50) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:_resultDic[@"categoryDescription" ]];
    _kindLab.textColor = UIColorFromRGB(BlackColorValue);
    [goodsinfoView addSubview:_kindLab];
    _OrginY +=100;

    //商品信息
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:_myscrollView Frame:CGRectMake(15, _OrginY, 200, 39) Alignment:NSTextAlignmentLeft Text:@"商品规格"];
    _OrginY +=39;
    
    
    
    NSArray *unitArr = _resultDic[@"specificationValues"];
    UIView *unitinfoView = [BaseViewFactory viewWithFrame:CGRectMake(0, _OrginY, ScreenWidth, 50*unitArr.count) color:UIColorFromRGB(WhiteColorValue)];
    [_myscrollView addSubview:unitinfoView];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(68, 0, 1, unitinfoView.height) Super:unitinfoView];

    
    for (int i = 0; i<unitArr.count; i++) {
        NSDictionary *dic  = unitArr[i];
       UILabel *lab =  [BaseViewFactory labelWithFrame:CGRectMake(0, 50*i, 67, 50) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:dic[@"specificationName"]];
        [unitinfoView addSubview:lab];
        
        UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        tagBtn.frame=CGRectZero;
        [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        tagBtn.backgroundColor=UIColorFromRGB(RedColorValue);
        tagBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
        [tagBtn setTitle:dic[@"name"] forState:UIControlStateNormal];
        tagBtn.layer.cornerRadius = 10;
        [unitinfoView addSubview:tagBtn];
        
        NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12]};
        CGSize Size_str=[dic[@"name"] sizeWithAttributes:attrs];
        Size_str.width += 21;
        Size_str.height = 30;
        tagBtn.frame = CGRectMake(67+15, 10+50*i,  Size_str.width, Size_str.height);
        
        if (i!=0) {
            [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 49*i, ScreenWidth, 1) Super:unitinfoView];
        }
    }
    _OrginY +=50*unitArr.count +12;

    UIView *ListView = [BaseViewFactory viewWithFrame:CGRectMake(0, _OrginY, ScreenWidth, 50) color:UIColorFromRGB(WhiteColorValue)];
    [_myscrollView addSubview:ListView];
    
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:ListView Frame:CGRectMake(15, 0, 200, 50) Alignment:NSTextAlignmentLeft Text:@"商品列表"];
    UIButton *listBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [listBtn addTarget:self action:@selector(listBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [ListView addSubview:listBtn];
    listBtn.frame = CGRectMake(0, 0, ScreenWidth, 50);
    _OrginY +=50;

    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:ListView Frame:CGRectMake(15, 50, 200, 50) Alignment:NSTextAlignmentLeft Text:@"产品参数"];
    _OrginY +=50;

    
    
    if (!_unitTabieView) {
        _unitTabieView = [[UITableView alloc]initWithFrame:CGRectMake(0, _OrginY, ScreenWidth, _unitDataArr.count *50 +40) style:UITableViewStylePlain];
        _unitTabieView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _unitTabieView.delegate = self;
        _unitTabieView.dataSource = self;
        [_myscrollView addSubview:_unitTabieView];
    }
    _OrginY += _unitDataArr.count *50 +40;
    
    [_myscrollView addSubview:self.setView];
    self.setView.frame = CGRectMake(0, _OrginY, ScreenWidth, 178);
    
    NSArray * imagelistArr = _resultDic[@"imageUrlList"];
    [_urlPhotos addObjectsFromArray:imagelistArr];
    WeakSelf(self);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
       for (int i = 0; i<imagelistArr.count; i++) {
        __block UIImage *image1 = nil;  //要加一个 __block因为 block代码默认不能改外面的东西（记住语法即可）
        dispatch_group_async(group, queue, ^{
            NSURL *url1 = [NSURL URLWithString:imagelistArr[i]];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            image1 = [UIImage imageWithData:data1];
            [_urlPhotos replaceObjectAtIndex:i withObject:image1];
            
        });
    }
    dispatch_group_notify(group, queue, ^{
        
        // 5.回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself configCollectionView];

            [_collectionView reloadData];
        });
    });

    [self refreshViewFrame];
    
    
    
    
}

- (void)loadGoodsInfo{
    WeakSelf(self);
    _resultDic= nil;
    _resultDic = [[NSMutableDictionary alloc]init];
[GoodsItemsPL getEditGoodsInfoWithId:_model.itemID andReturnBlock:^(id returnValue) {
    NSLog(@"商品信息===%@",returnValue);
    _resultDic = returnValue[@"data"][@"item"];
    
    
    NSLog(@"====%@",_resultDic[@"categoryDescription"] );
  
    NSArray *attArr = _resultDic[@"attributes"];
    _unitDataArr = [AttributesModel mj_objectArrayWithKeyValuesArray:attArr];
    if (![_resultDic[@"detail"] isKindOfClass:[NSNull class]]) {
        _htmlStr = _resultDic[@"detail"];
    }
    _specificationIds = _resultDic[@"specificationValueIds"];
    _categoryId = _resultDic[@"categoryId"];
    _priceStr = _resultDic[@"price"];
    _stock = _resultDic[@"stock"];
    if (NULL_TO_NIL(_resultDic[@"minBuyQuantity"])) {
        [_resultDic setObject:[NSString stringWithFormat:@"%@",_resultDic[@"minBuyQuantity"]] forKey:@"minBuyQuantity"];

    }
    if (NULL_TO_NIL(_resultDic[@"limitUserTotalBuyQuantity"])) {
        [_resultDic setObject:[NSString stringWithFormat:@"%@",_resultDic[@"limitUserTotalBuyQuantity"]] forKey:@"limitUserTotalBuyQuantity"];
        
    }
    [weakself initUI];
} andErrorBlock:^(NSString *msg) {
    [weakself.navigationController popViewControllerAnimated:YES];
    [weakself showTextHud:msg];
}];
}

#pragma mark ============= 按钮点击

/**
 商品列表
 */
- (void)listBtnClick{

    ListEditViewController *listVc = [[ListEditViewController alloc]init];
    listVc.infoDic = [_resultDic mutableCopy];
    listVc.showImage = _urlPhotos[0];
    if (_urlPhotos.count <5) {
        listVc.isChangeImage = YES;
    }else{
        listVc.isChangeImage = NO;

    }
    [self.navigationController pushViewController:listVc animated:YES];
}

/**
 html描述页面
 */
- (void)miaoshuBtnClick{
    HTMLViewController * htmlVC = [[HTMLViewController alloc]init];
    if (_htmlStr) {
        htmlVC.inHtmlString = _htmlStr;
    }
    [self.navigationController pushViewController:htmlVC animated:YES];}

/**
 加入仓库
 */
- (void)putGoodsIn{
    if (_urlPhotos.count<=0) {
        [self showTextHud:@"请添加商品主图"];
        return;
    }
    NSMutableArray *attArr = [NSMutableArray arrayWithCapacity:0];
    if (_unitDataArr.count >0) {
        for (int i = 0; i<_unitDataArr.count; i++) {
            AttributesModel *attmodel = _unitDataArr[i];
            NSDictionary *dic;
            if (attmodel.attributeDefaultValue.length>0) {
                dic =@{@"attributeName":attmodel.attributeName,
                       @"attributeValue":attmodel.attributeDefaultValue?attmodel.attributeDefaultValue:@"",
                       @"attributeId":@""
                       };
                
            }else if (attmodel.attributeValue.length>0){
                dic =@{@"attributeName":attmodel.attributeName,
                       @"attributeValue":attmodel.attributeValue?attmodel.attributeValue:@"",
                       @"attributeId":@""
                       };
                
            }else{
                dic =@{@"attributeName":attmodel.attributeName,
                       @"attributeValue":@"",
                       @"attributeId":@""
                       };
            }

            [attArr addObject:[self dictionaryToJson:dic]];
            
        }
    }
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.label.text = @"正在上传商品";
    
    WeakSelf(self);
    [_upImagePL shopUpdateToByGoodsImgArr:_urlPhotos WithReturnBlock:^(id returnValue) {
        NSArray *imageArr = returnValue[@"imageUrls"];
        NSDictionary *infoDic;
        infoDic = @{@"currencyCode":@"CNY",
                    @"detail":_htmlStr,
                    @"imageUrl":[imageArr componentsJoinedByString:@","],
                    @"price":_priceStr,
                    @"skuCode":@"",
                    @"stock":_stock,
                    @"minBuyQuantity":[_minbuy integerValue]>0?_minbuy:@"",
                    @"limitUserTotalBuyQuantity":[_limbuy integerValue]>0?_limbuy:@"",
                    @"title":_resultDic[@"title"],
                    @"categoryId":_resultDic[@"categoryId"],
                    @"productId":_resultDic[@"productId"],
                    @"specificationValueIds":_resultDic[@"specificationValueIds"],
                    @"unit":@"",
                    @"attributes":[NSString stringWithFormat:@"[%@]",[attArr componentsJoinedByString:@","]]
                    };
        [PublishGoodsPL updataGoodsInfoWithId:_resultDic[@"id"] WithGoodsInfo:infoDic andReturnBlock:^(id returnValue) {
            NSDictionary *returnDic = returnValue[@"data"][@"item"];
            [GoodsItemsPL userDownGoodsWithGoodsid:returnDic[@"id"] ReturnBlock:^(id returnValue) {
                
                
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                [weakself showTextHudInSelfView:@"上传成功"];
                [weakself performSelector:@selector(backVc) withObject:nil afterDelay:1.5];
            } andErrorBlock:^(NSString *msg) {
                [weakself showTextHud:msg];
            }];
            
            
        } andErrorBlock:^(NSString *msg) {
            [weakself showTextHudInSelfView:msg];
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
            
        }];
        
    } withErrorBlock:^(NSString *msg) {
        [weakself showTextHudInSelfView:msg];
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
        
    }];
    
    

}


- (void)backVc{
    [self.navigationController popViewControllerAnimated:YES];


}

/**
 立即发布
 */
- (void)setupGoodsatOnce{
    if (_urlPhotos.count<=0) {
        [self showTextHud:@"请添加商品主图"];
        return;
    }
    NSMutableArray *attArr = [NSMutableArray arrayWithCapacity:0];
    if (_unitDataArr.count >0) {
        for (int i = 0; i<_unitDataArr.count; i++) {
            AttributesModel *attmodel = _unitDataArr[i];
            NSDictionary *dic;
            if (attmodel.attributeDefaultValue.length>0) {
                dic =@{@"attributeName":attmodel.attributeName,
                       @"attributeValue":attmodel.attributeDefaultValue?attmodel.attributeDefaultValue:@"",
                       @"attributeId":@""
                       };

            }else if (attmodel.attributeValue.length>0){
                dic =@{@"attributeName":attmodel.attributeName,
                       @"attributeValue":attmodel.attributeValue?attmodel.attributeValue:@"",
                       @"attributeId":@""
                       };

            }else{
                dic =@{@"attributeName":attmodel.attributeName,
                       @"attributeValue":@"",
                       @"attributeId":@""
                       };
            }
                       [attArr addObject:[self dictionaryToJson:dic]];

        }
    }
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.label.text = @"正在上传商品";
    WeakSelf(self);

    [_upImagePL shopUpdateToByGoodsImgArr:_urlPhotos WithReturnBlock:^(id returnValue) {
        NSArray *imageArr = returnValue[@"imageUrls"];
        NSDictionary *infoDic;
        infoDic = @{@"currencyCode":@"CNY",
                    @"detail":_htmlStr,
                    @"imageUrl":[imageArr componentsJoinedByString:@","],
                    @"price":_priceStr,
                    @"skuCode":@"",
                    @"stock":_stock,
                    @"minBuyQuantity":[_minbuy integerValue]>0?_minbuy:@"",
                    @"limitUserTotalBuyQuantity":[_limbuy integerValue]>0?_limbuy:@"",
                    @"title":_resultDic[@"title"],
                    @"categoryId":_resultDic[@"categoryId"],
                    @"productId":_resultDic[@"id"],
                    @"specificationValueIds":_resultDic[@"specificationValueIds"],
                    @"unit":@"",
                    @"attributes":[NSString stringWithFormat:@"[%@]",[attArr componentsJoinedByString:@","]]
                    };
        [PublishGoodsPL updataGoodsInfoWithId:_resultDic[@"id"] WithGoodsInfo:infoDic andReturnBlock:^(id returnValue) {
            NSDictionary *returnDic = returnValue[@"data"][@"item"];
            [GoodsItemsPL userUpGoodsWithGoodsid:returnDic[@"id"] ReturnBlock:^(id returnValue) {
                
                
                [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
                [weakself showTextHudInSelfView:@"上传成功"];
                [weakself performSelector:@selector(backVc) withObject:nil afterDelay:1.5];
                
            } andErrorBlock:^(NSString *msg) {
                [weakself showTextHud:msg];
            }];

            
        } andErrorBlock:^(NSString *msg) {
            [weakself showTextHudInSelfView:msg];
            [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];

        }];
    
    } withErrorBlock:^(NSString *msg) {
        [weakself showTextHudInSelfView:msg];
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];

    }];
}


/**
 编辑Html通知

 @param noti 编辑结束
 */
- (void)UserHavesetupGoodsHTML:(NSNotification *)noti{
    
    _htmlStr = noti.object;
    
}


/**
 创建完商品列表反馈
 
 @param noti 返回字典
 */
- (void)UserHavesetupGoodsList:(NSNotification *)noti{
    
    NSLog(@"====%@",_resultDic[@"categoryDescription"] );

    NSArray *arr = [_resultDic[@"categoryDescription"] componentsSeparatedByString:@"/"];
    if ([arr[0] isEqualToString:@"创意设计"]) {
        _idModel = noti.object;
        _stock  = [NSString stringWithFormat:@"%ld",(long)_idModel.stock];
        _priceStr = _idModel.price;
        if (_idModel.image&&_urlPhotos.count<=5) {
            [_urlPhotos insertObject:_idModel.image atIndex:0];
        }
        [_resultDic setObject:[NSNumber numberWithInteger:_idModel.stock] forKey:@"stock"];
        [_resultDic setObject:_idModel.price forKey:@"price"];

    }else{
        _accModel = noti.object;
        _stock  = [NSString stringWithFormat:@"%ld",(long)_accModel.stock];
//        if (_accModel.minBuy>=0) {
            _minbuy = [NSString stringWithFormat:@"%ld",(long)_accModel.minBuy];
            [_resultDic setObject:_minbuy forKey:@"minBuyQuantity"];
//
//        }else{
//            _minbuy = @"-1";
//        }
//        if (_accModel.limitBuy>=0) {
            _limbuy = [NSString stringWithFormat:@"%ld",(long)_accModel.limitBuy];
            [_resultDic setObject:_limbuy forKey:@"limitUserTotalBuyQuantity"];

//        }else{
//            _limbuy = @"-1";
//        }
        _priceStr = _accModel.price;
        if (_accModel.image&&_urlPhotos.count<=5) {
            [_urlPhotos insertObject:_idModel.image atIndex:0];
        }
        [_resultDic setObject:[NSNumber numberWithInteger:_accModel.stock] forKey:@"stock"];
        [_resultDic setObject:_accModel.price forKey:@"price"];

    }
    [_collectionView reloadData];
}


#pragma mark ============= tableviewdelegate  tableviewdatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _unitDataArr.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _unitDataArr.count ) {
        return 40;
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _unitDataArr.count ) {
        static NSString *cellid = @"downcell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.contentView.backgroundColor = UIColorFromRGB(LineColorValue);
            cell.textLabel.font = APPFONT(15);
            cell.textLabel.textColor = UIColorFromRGB(0x434a54);
            cell.textLabel.text = @"+ 添加新属性";
        }
        
        return cell;
    }else{
        static NSString *cellid = @"unitcell";
        UnitCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
        if (!cell) {
            cell = [[UnitCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.font = APPFONT(15);
            cell.textLabel.textColor = UIColorFromRGB(0x434a54);
            UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(0, 49, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
            [cell.contentView   addSubview:lineview];
            
            
        }
        
        cell.attModel = _unitDataArr[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _unitDataArr.count ) {
    
        [self.addView showinView:self.view];
    
    }
}




- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 删除数据源的数据,self.cellData是你自己的数据
        [_unitDataArr removeObjectAtIndex:indexPath.row];
        // 删除列表中数据
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshViewFrame];
        
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";//默认文字为 Delete
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _unitDataArr.count) {
        return NO;
    }
    return YES;
}

- (void)refreshViewFrame{
    _unitTabieView.frame = CGRectMake(0, _unitTabieView.top, ScreenWidth, _unitDataArr.count*50 +40);
    self.setView.frame = CGRectMake(0, _unitTabieView.bottom, ScreenWidth, 178);
    _myscrollView.contentSize = CGSizeMake(10, self.setView.bottom);


}

-(void)didSelectedaddunitBtnwithtext:(NSString *)text{
    AttributesModel *model = [[AttributesModel alloc]init];
    model.attributeName = text;
    model.attributeDefaultValue = @"";
    model.attributeId = @"";
    [_unitDataArr addObject:model];
    [_unitTabieView reloadData];
    [self refreshViewFrame];
}

#pragma mark ------- 删除照片

- (void)deleteBtnClik:(UIButton *)sender {
    [_urlPhotos removeObjectAtIndex:sender.tag];
    [_collectionView reloadData];
    
}


#pragma mark UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _urlPhotos.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TZTestCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"TZTestCell" forIndexPath:indexPath];
    cell.videoImageView.hidden = YES;
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
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==_urlPhotos.count) {
        BOOL showSheet = YES;
        if (showSheet) {
            UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"去相册选择", nil];
            [sheet showInView:self.view];
        } else {
            [self pushImagePickerController];
        }
        
    }
}
#pragma mark - LxGridViewDataSource

/// 以下三个方法为长按排序相关代码
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.item < _urlPhotos.count;
    
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath canMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    return (sourceIndexPath.item < _urlPhotos.count && destinationIndexPath.item < _urlPhotos.count);
    
}

- (void)collectionView:(UICollectionView *)collectionView itemAtIndexPath:(NSIndexPath *)sourceIndexPath didMoveToIndexPath:(NSIndexPath *)destinationIndexPath {
    UIImage *image = _urlPhotos[sourceIndexPath.item];
    [_urlPhotos removeObjectAtIndex:sourceIndexPath.item];
    [_urlPhotos insertObject:image atIndex:destinationIndexPath.item];
    
    
    
    
    [_collectionView reloadData];
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
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    
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
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:5 columnNumber:5 delegate:self pushPhotoPickerVc:YES];
    
    
#pragma mark - 四类个性化设置，这些参数都可以不传，此时会走默认设置
    imagePickerVc.isSelectOriginalPhoto = NO;
    
    //    if (_urlPhotos.count>0) {
    //
    //    }else{
    //        imagePickerVc.selectedAssets = _selectedAssets; // 目前已经选中的图片数组
    //
    //    }
    
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
    }}

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
    
    if (_urlPhotos.count<5) {
        [_urlPhotos addObject:image];
    }else{
        [self showTextHud:@"最多添加五张图片"];
    }
    [_collectionView reloadData];
    
    
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
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=PHOTOS"];
            } else {
                privacyUrl = [NSURL URLWithString:@"prefs:root=Privacy&path=CAMERA"];
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
    
    for (UIImage *image in photos) {
        if (_urlPhotos.count<5) {
            [_urlPhotos addObject:image];
        }else{
            [self showTextHud:@"最多添加五张图片"];
        }
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
    //    _selectedPhotos = [NSMutableArray arrayWithArray:@[coverImage]];
    //    _selectedAssets = [NSMutableArray arrayWithArray:@[asset]];
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
//词典转换为字符串
- (NSString*)dictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}




@end
