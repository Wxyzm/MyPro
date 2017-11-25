//
//  ShopReleaseGoodsController.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ShopReleaseGoodsController.h"
#import "TagLIstButtonView.h"
#import "UnitModel.h"
#import "CategoryOneViewController.h"
#import "GoodsLvThreeModel.h"

#import "IdeaView.h"
#import "AddUnitView.h"
#import "AccessoriesView.h"
#import "FabricView.h"

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

#import "GoodsListController.h"
#import "AccessGoodsListController.h"
#import "AttributesModel.h"
#import "PublishGoodsPL.h"
#import "UpImagePL.h"
#import "HTMLViewController.h"
#import "IdeaCellModel.h"
#import "AccessCellModel.h"


@interface ShopReleaseGoodsController ()<IdeaViewDelegate,AddUnitViewDelegate,TZImagePickerControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,AccessoriesViewDelegate,FabricViewDelegate,UITextFieldDelegate>

@property (nonatomic , strong) UIScrollView *myscrollView;

@property (nonatomic , strong) IdeaView *ideaView;              //创意设计发布

@property (nonatomic , strong) FabricView *fabricView;          //面料

@property (nonatomic , strong) AccessoriesView *accView;        //辅料

@property (nonatomic , strong) AddUnitView *addView;

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;

@property (nonatomic, strong) UICollectionView *collectionView;


@property (nonatomic, assign) NSInteger editStatus;         // 0 未编辑  1 未完成  2 已完成


@end

@implementation ShopReleaseGoodsController{

    CGFloat   _OrginY;
    UIView    *_goodsUnitView;           //商品规格
    UIView    *_miaoshuView;             //商品描述
    UIView    *_line1;
    UIView    *_line2;
   
    TagLIstButtonView   *_kindView;     //类型

    CGFloat _itemWH;
    CGFloat _margin;
    NSMutableArray *_urlPhotos;         //照片数组
    
    UITextField   *_goodNameTxt;        //商品标题
    UILabel       *_kindLab;            //商品类目
    
    NSMutableArray  *_needResultArr;
    
    
    //发布数据名称
    NSString    *_itemList;             //Json格式的产品信息
    NSString    *_specificationIds;     //以英文逗号,隔开的规格id
    NSString    *_categoryId;           //类目id
    NSString    *_htmlStr;              //宝贝描述
    
    UpImagePL   *_upImagePL;
    NSMutableArray *_ListArr;
    
    UILabel     *_lengthLab;
}

#pragma mark ------- view重写get方法
-(UIScrollView *)myscrollView{
    
    if (!_myscrollView) {
        _myscrollView = [[UIScrollView alloc] init];
        _myscrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        self.myscrollView.backgroundColor = UIColorFromRGB(0xe6e9ed);
    }
    return _myscrollView;
}

-(IdeaView *)ideaView{
    if (!_ideaView) {
        _ideaView = [[IdeaView alloc]initWithFrame:CGRectMake(0, _OrginY, ScreenWidth, 0)];
        _ideaView.delegate = self;
        [_myscrollView addSubview:_ideaView];
        
    }

    return _ideaView;
}

-(AccessoriesView *)accView{
    if (!_accView) {
        _accView = [[AccessoriesView alloc]initWithFrame:CGRectMake(0, _OrginY, ScreenWidth, 0)];
        _accView.delegate = self;
        [_myscrollView addSubview:_accView];
        
    }
    
    return _accView;
}

-(FabricView *)fabricView{
    if (!_fabricView) {
        _fabricView = [[FabricView alloc]initWithFrame:CGRectMake(0, _OrginY, ScreenWidth, 0)];
        _fabricView.delegate = self;
        [_myscrollView addSubview:_fabricView];
        
    }
    
    return _fabricView;
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
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, _OrginY, self.view.tz_width, 122) collectionViewLayout:layout];
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
    self.title = @"发布商品";
    _urlPhotos = [NSMutableArray array];
    _needResultArr = [NSMutableArray array];
    _ListArr = [NSMutableArray array];
    _htmlStr = @"";
    _upImagePL = [[UpImagePL alloc]init];
    _editStatus = 0;
    [self initUI];
    //用户选择完类目
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHaveSelectedCategory:)
                                                 name:@"UserHaveSelectedCategory"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHavesetupGoodsList:)
                                                 name:@"UserHavesetupGoodsList"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHavesetupGoodsHTML:)
                                                 name:@"UserHavesetupGoodsHTML"  object:nil];

}


- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
}


#pragma mark ------- initUI

- (void)initUI{

    _addView = [[AddUnitView alloc]init];
    _addView.delegate = self;
   // _addView.baseVC = self;
    
    _OrginY = 0;
    [self.view addSubview:self.myscrollView];
    
    //照片
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:_myscrollView Frame:CGRectMake(15, _OrginY, 200, 39) Alignment:NSTextAlignmentLeft Text:@"商品主图(最多上传五张)"];
    _OrginY +=39;
    //照片显示区域
    //上传图片栏
//    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, _OrginY, ScreenWidth, 122)];
//    view1.backgroundColor = [UIColor whiteColor];
//    [self.myscrollView addSubview:view1];
    [self configCollectionView];

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
    
    _lengthLab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth -60, 0, 50, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentCenter andtext:@"0/60"];
    [goodsinfoView addSubview:_lengthLab];

    _goodNameTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(100, 0, ScreenWidth -160,50) font:APPFONT(13) placeholder:@"请输入商品标题(30字以内)" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _goodNameTxt.textAlignment = NSTextAlignmentRight;
    [goodsinfoView addSubview:_goodNameTxt];
    [_goodNameTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _kindLab = [BaseViewFactory labelWithFrame:CGRectMake(100, 50, ScreenWidth -115,50) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@""];
    [goodsinfoView addSubview:_kindLab];
    
    UIButton *categoryBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    categoryBtn.frame = CGRectMake(0, 50, ScreenWidth, 50);
    [goodsinfoView  addSubview:categoryBtn];
    [categoryBtn addTarget:self action:@selector(categoryBtnClick) forControlEvents:UIControlEventTouchUpInside];
    _OrginY +=100;

    _miaoshuView =[BaseViewFactory viewWithFrame:CGRectMake(0, _OrginY, ScreenWidth, 178) color:UIColorFromRGB(WhiteColorValue)];
    [_myscrollView addSubview:_miaoshuView];
    [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:_miaoshuView Frame:CGRectMake(15, 0, 200, 50) Alignment:NSTextAlignmentLeft Text:@"宝贝描述"];
    
    UIImageView *rightimage = [BaseViewFactory icomWithWidth:9.5 imagePath:@"right"];
    [_miaoshuView addSubview:rightimage];
    rightimage.frame = CGRectMake(ScreenWidth - 25, 17, 9.5, 16);


    UIButton *miaoshuBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    miaoshuBtn.frame = CGRectMake(0, 0, ScreenWidth, 50);
    [_miaoshuView addSubview:miaoshuBtn];
    [miaoshuBtn addTarget:self action:@selector(miaoshuBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
   
    UIView *bgView = [BaseViewFactory viewWithFrame:CGRectMake(0, 50, ScreenWidth, 128) color:UIColorFromRGB(0xe6e9ed)];
    [miaoshuBtn addSubview:bgView];
    
    SubBtn *putinBtn = [SubBtn buttonWithtitle:@"放入仓库" backgroundColor:UIColorFromRGB(PlaColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(putGoodsIn)];
    putinBtn.titleLabel.font = APPFONT(18);
    putinBtn.frame = CGRectMake(20, 90, (ScreenWidth - 75)/2, 50);
    [_miaoshuView addSubview:putinBtn];
    
    
    SubBtn *setupBtn = [SubBtn buttonWithtitle:@"立即发布" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(setupGoodsatOnce) andframe:CGRectMake(ScreenWidth/2+17.5, 90, (ScreenWidth - 75)/2, 50)];
    setupBtn.titleLabel.font = APPFONT(18);
    [_miaoshuView addSubview:setupBtn];


}




#pragma mark ------- 选择类目
/**
 选择类目
 */
- (void)categoryBtnClick{

    if ( _kindLab.text.length >0) {
        [self removeGoodsList];

    }
    CategoryOneViewController *oneVc = [[CategoryOneViewController alloc]init];
    [self.navigationController pushViewController:oneVc animated:YES];


}
#pragma mark ------- 发布商品

- (BOOL)itemsIsEditComplete{
    if (_itemList.length >0) {
        return YES;
    }else{
        return NO;
    }
}


/**
 放入仓库
 */
- (void)putGoodsIn{
    if (_urlPhotos.count<=0) {
        [self showTextHud:@"请添加商品主图"];
        return;
    }
    if (_goodNameTxt.text.length <=0) {
        [self showTextHud:@"请添加商品标题"];
        return;
    }
    if (_specificationIds.length <=0) {
        [self showTextHud:@"请编辑商品列表"];
        return;
    }
    if (_itemList.length <=0) {
        [self showTextHud:@"请编辑商品列表"];
        return;
    }
    if (_editStatus==0||_editStatus == 1) {
        [self showTextHud:@"请将商品编辑完成"];
        return;
    }
    if ([self convertToByte:_goodNameTxt.text] >30){
        
        [self showTextHud:@"商品标题需在30字以内"];
        return;
    }
    NSString *attributes;
    if (self.releaseType == ReleaseType_CreativeDesign) {
        NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<self.ideaView.unitArr.count; i++) {
            AttributesModel *model = self.ideaView.unitArr[i];
            NSDictionary *dic = @{@"attributeName":model.attributeName,
                                  @"attributeDefaultValue":model.attributeDefaultValue,
                                  @"attributeId":model.attributeId
                                  };
            [strArr addObject:[self dictionaryToJson:dic]];
            
        }
        attributes = [strArr componentsJoinedByString:@","];
    }else if (self.releaseType == ReleaseType_Accessories){
        NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<self.accView.unitArr.count; i++) {
            AttributesModel *model = self.accView.unitArr[i];
            NSDictionary *dic = @{@"attributeName":model.attributeName,
                                  @"attributeDefaultValue":model.attributeDefaultValue,
                                  @"attributeId":model.attributeId
                                  };
            [strArr addObject:[self dictionaryToJson:dic]];
            
        }
        attributes = [strArr componentsJoinedByString:@","];
    }else if (self.releaseType == ReleaseType_Fabric){
        NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<self.fabricView.unitArr.count; i++) {
            AttributesModel *model = self.fabricView.unitArr[i];
            NSDictionary *dic = @{@"attributeName":model.attributeName,
                                  @"attributeDefaultValue":model.attributeDefaultValue,
                                  @"attributeId":model.attributeId
                                  };
            [strArr addObject:[self dictionaryToJson:dic]];
            
        }
        attributes = [strArr componentsJoinedByString:@","];
    }

    [MBProgressHUD showMessag:nil toView:self.view];

    [_upImagePL shopUpdateToByGoodsImgArr:_urlPhotos WithReturnBlock:^(id returnValue) {
        NSArray *imageArr = returnValue[@"imageUrls"];
        NSDictionary *infoDic;
            infoDic = @{@"name":_goodNameTxt.text,
                        @"specificationIds":_specificationIds,
                        @"categoryId":_categoryId,
                        @"imageUrl":[imageArr componentsJoinedByString:@","],
                        @"detail":_htmlStr,
                        @"unit":@"",
                        @"attributes":[NSString stringWithFormat:@"[%@]",attributes],
                        };
        
        [PublishGoodsPL newProductWithInfoDic:infoDic ReturnBlock:^(id returnValue) {
            NSDictionary *returnDic = returnValue[@"data"][@"product"];

            NSDictionary *finaDic = @{@"productId":returnDic[@"id"],
                                      @"isOnSale":@"false",
                                      @"itemList":[NSString stringWithFormat:@"[%@]",_itemList],
                                      };
            [PublishGoodsPL GenerateitemsWithInfoDic:finaDic ReturnBlock:^(id returnValue) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                NSDictionary *resultDic = returnValue[@"data"][@"product"];
                [self showTextHud:@"商品已成功放入仓库"];
                [self.navigationController  popToRootViewControllerAnimated:YES];
                
            } andErrorBlock:^(NSString *msg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [self showTextHud:msg];

            }];
            
            
            
        } andErrorBlock:^(NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self showTextHud:msg];
        }];
    } withErrorBlock:^(NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self showTextHud:msg];
    }];
    
    
    
    

}

/**
 立即发布
 */
- (void)setupGoodsatOnce{
    if (_urlPhotos.count<=0) {
        [self showTextHud:@"请添加商品主图"];
        return;
    }
    if (_goodNameTxt.text.length <=0) {
        [self showTextHud:@"请添加商品标题"];
        return;
    }
    if (_specificationIds.length <=0) {
        [self showTextHud:@"请编辑商品列表"];
        return;
    }
    if (_itemList.length <=0) {
        [self showTextHud:@"请编辑商品列表"];
        return;
    }
    if (_editStatus==0||_editStatus == 1) {
        [self showTextHud:@"请将商品编辑完成"];
        return;
    }
    if ([self convertToByte:_goodNameTxt.text] >30){
        
        [self showTextHud:@"商品标题需在30字以内"];
        return;
    }
    NSString *attributes;
    if (self.releaseType == ReleaseType_CreativeDesign) {
        NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<self.ideaView.unitArr.count; i++) {
            AttributesModel *model = self.ideaView.unitArr[i];
            NSDictionary *dic = @{@"attributeName":model.attributeName,
                                  @"attributeDefaultValue":model.attributeDefaultValue,
                                  @"attributeId":model.attributeId
                                  };
            [strArr addObject:[self dictionaryToJson:dic]];
            
        }
        attributes = [strArr componentsJoinedByString:@","];
    }else if (self.releaseType == ReleaseType_Accessories){
        NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<self.accView.unitArr.count; i++) {
            AttributesModel *model = self.accView.unitArr[i];
            NSDictionary *dic = @{@"attributeName":model.attributeName,
                                  @"attributeDefaultValue":model.attributeDefaultValue,
                                  @"attributeId":model.attributeId
                                  };
            [strArr addObject:[self dictionaryToJson:dic]];
            
        }
        attributes = [strArr componentsJoinedByString:@","];
    }else if (self.releaseType == ReleaseType_Fabric){
        NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<self.fabricView.unitArr.count; i++) {
            AttributesModel *model = self.fabricView.unitArr[i];
            NSDictionary *dic = @{@"attributeName":model.attributeName,
                                  @"attributeDefaultValue":model.attributeDefaultValue,
                                  @"attributeId":model.attributeId
                                  };
            [strArr addObject:[self dictionaryToJson:dic]];
            
        }
        attributes = [strArr componentsJoinedByString:@","];
    }

    [MBProgressHUD showMessag:nil toView:self.view];

    [_upImagePL shopUpdateToByGoodsImgArr:_urlPhotos WithReturnBlock:^(id returnValue) {
        NSArray *imageArr = returnValue[@"imageUrls"];
        NSDictionary *infoDic;
        infoDic = @{@"name":_goodNameTxt.text,
                    @"specificationIds":_specificationIds,
                    @"categoryId":_categoryId,
                    @"imageUrl":[imageArr componentsJoinedByString:@","],
                    @"detail":_htmlStr,
                    @"unit":@"",
                    @"attributes":[NSString stringWithFormat:@"[%@]",attributes],
                    };

        [PublishGoodsPL newProductWithInfoDic:infoDic ReturnBlock:^(id returnValue) {
            NSDictionary *returnDic = returnValue[@"data"][@"product"];
            
            NSDictionary *finaDic = @{@"productId":returnDic[@"id"],
                                      @"isOnSale":@"true",
                                      @"itemList":[NSString stringWithFormat:@"[%@]",_itemList],
                                      };
            [PublishGoodsPL GenerateitemsWithInfoDic:finaDic ReturnBlock:^(id returnValue) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                NSDictionary *resultDic = returnValue[@"data"][@"product"];
                [self showTextHud:@"商品已成功发布"];
                [self.navigationController  popToRootViewControllerAnimated:YES];
                
            } andErrorBlock:^(NSString *msg) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];

                [self showTextHud:msg];
                
            }];
            
            
            
        } andErrorBlock:^(NSString *msg) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];

            [self showTextHud:msg];
        }];
    } withErrorBlock:^(NSString *msg) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];

        [self showTextHud:msg];
    }];
}


#pragma mark ------- 添加描述

- (void)miaoshuBtnClick{

    HTMLViewController * htmlVC = [[HTMLViewController alloc]init];
    if (_htmlStr.length >0) {
        htmlVC.inHtmlString = _htmlStr;
    }
    [self.navigationController pushViewController:htmlVC animated:YES];


}



#pragma mark ------- 添加新属性
/**
 创意设计

 @param type 1:添加新属性   0:添加类型
 */
-(void)didSelectedAddBtnwithType:(NSInteger)type{
    if (type == 0) {
        //添加新属性
        NSLog(@"%ld",(long)type);
        self.addView.type =1;
        
    }else{
        //添加类型
        NSLog(@"%ld",(long)type);
         self.addView.type =0;
        
    }
    [self refreshViewFrame];

    [self.addView showinView:self.view];

}
/**
 辅料专区
 
 @param type 1:添加新属性   0:添加类型
 */
- (void)didSelectedAccessoriesViewAddBtnwithType:(NSInteger)type{

    if (type == 0) {
        //添加新属性
        NSLog(@"%ld",(long)type);
        self.addView.type =1;
        
    }else{
        //添加类型
        NSLog(@"%ld",(long)type);
        self.addView.type =0;
        
    }
    
    [self.addView showinView:self.view];
    [self refreshViewFrame];

}
/**
 面料专区
 
 @param type 1:添加新属性   0:添加类型
 */
-(void)didSelectedFabricViewAddBtnwithType:(NSInteger)type{
    if (type == 0) {
        //添加新属性
        NSLog(@"%ld",(long)type);
        self.addView.type =1;
        
    }else{
        //添加类型
        NSLog(@"%ld",(long)type);
        self.addView.type =0;
        
    }
    
    [self.addView showinView:self.view];
    [self refreshViewFrame];

}



/**
 添加产品规格
 
 @param text 参数
 */
-(void)didSelectedaddkindBtnwithtext:(NSString *)text{
    if (self.releaseType == ReleaseType_CreativeDesign) {
        NSMutableArray *kindnameArr = self.ideaView.kindArr;
        UnitModel  *model = [[UnitModel alloc]init];
        model.on = YES;
        model.name = text;
        [kindnameArr addObject:model];
        [self.ideaView.outPutArr addObject:model];
        self.ideaView.kindArr = kindnameArr;

    }else if (self.releaseType == ReleaseType_Fabric){
        NSMutableArray *kindnameArr = self.fabricView.kindArr ;
        UnitModel  *model = [[UnitModel alloc]init];
        model.on = YES;
        model.name = text;
        [kindnameArr addObject:model];
        [self.fabricView.outPutArr1 addObject:model];

        self.fabricView.kindArr = kindnameArr;
        
    }else if ( self.releaseType == ReleaseType_Accessories){
        NSMutableArray *kindnameArr = self.accView.kindArr ;
        UnitModel  *model = [[UnitModel alloc]init];
        model.on = YES;
        model.name = text;
        [kindnameArr addObject:model];
        [self.accView.outPutArr1 addObject:model];
        self.accView.kindArr = kindnameArr;
 
    }
    [self refreshViewFrame];

}
/**
 添加产品参数
 
 @param text 参数
 */
-(void)didSelectedaddunitBtnwithtext:(NSString *)text{
    if (self.releaseType == ReleaseType_CreativeDesign) {
        NSMutableArray *kindnameArr = self.ideaView.unitArr;
        AttributesModel *model = [[AttributesModel alloc]init];
        model.attributeName = text;
        model.attributeDefaultValue = @"";
        model.attributeId = @"";
        [kindnameArr addObject:model];
        self.ideaView.unitArr = kindnameArr;
        
    }else if (self.releaseType == ReleaseType_Fabric){
        NSMutableArray *kindnameArr = self.fabricView.unitArr ;
        AttributesModel *model = [[AttributesModel alloc]init];
        model.attributeName = text;
        model.attributeDefaultValue = @"";
        model.attributeId = @"";
        [kindnameArr addObject:model];
        self.fabricView.unitArr = kindnameArr;
        
    }else if ( self.releaseType == ReleaseType_Accessories){
        NSMutableArray *kindnameArr = self.accView.unitArr;
        AttributesModel *model = [[AttributesModel alloc]init];
        model.attributeName = text;
        model.attributeDefaultValue = @"";
        model.attributeId = @"";
        [kindnameArr addObject:model];
        self.accView.unitArr = kindnameArr;
    }
    [self refreshViewFrame];

}

-(void)didSelectedIdeaViewRemoveListArrBtn{

    [self removeGoodsList];
}

- (void)didSelectedAccessoriesViewRemoveListArrBtn{

    [self removeGoodsList];

}

- (void)didSelectedFabricViewRemoveListArrBtn{

    [self removeGoodsList];

}


#pragma mark ------- 删除按钮
-(void)didSelectedFabricViewdeleteBtn{
    [self refreshViewFrame];
}
- (void)didSelectedAccessoriesViewdeleteBtn{
    [self refreshViewFrame];
}
- (void)didSelectedIdeaViewdeleteBtn{
    [self refreshViewFrame];
}
#pragma mark ------- 商品列表
/**
 创意设计
 */
-(void)didSelectedIdeaViewGoodsList{
    NSLog(@"aaaa ====  %@ ===== %@",self.ideaView.outPutArr,self.ideaView.outPutArr1);
    NSLog(@"aaaa ====  %@ ===== %@",self.ideaView.outPutArr,self.ideaView.outPutArr1);
    if (_urlPhotos.count <=0) {
        [self showTextHud:@"至少添加一张图片"];
        return;
    }
    
    if (_goodNameTxt.text.length <=0) {
//        [self showTextHud:@"请输入商品标题"];
//        return;
    }else if ([self convertToByte:_goodNameTxt.text] >30){
        
        [self showTextHud:@"商品标题需在30字以内"];
        return;
    }
    if (_kindLab.text <= 0 ) {
        [self showTextHud:@"请选择商品类目"];
        return;
    }
    if (self.ideaView.outPutArr.count<=0) {
        [self showTextHud:@"请选择商品类型"];
        return;
    }
    if (self.ideaView.outPutArr1.count<=0) {
        [self showTextHud:@"请选择商品状态"];
        return;
    }
    [_needResultArr removeAllObjects];
    NSMutableArray* result = [NSMutableArray array];
    NSMutableArray* array_data = [NSMutableArray arrayWithObjects:
                                  self.ideaView.outPutArr,
                                  self.ideaView.outPutArr1,
                                  nil];
    [self combine:result data:array_data curr:0 count:(int)array_data.count];
    NSLog(@"%@",result);
    
    GoodsListController *listVc = [[GoodsListController alloc]init];
    listVc.imageArr = _urlPhotos;
    listVc.dataArr = [_needResultArr mutableCopy];
    
    for (IdeaCellModel *model in _ListArr) {
        model.image = _urlPhotos[0];
    }
    listVc.tabArr = _ListArr;
  
    
    [self.navigationController pushViewController:listVc animated:YES];
}

/**
 辅料
 */
-(void)didSelectedAccessoriesViewGoodsList{
    if (_urlPhotos.count <=0) {
        [self showTextHud:@"至少添加一张图片"];
        return;
    }
    if (_goodNameTxt.text.length <=0) {
//        [self showTextHud:@"请输入商品标题"];
//        return;
    }else if ([self convertToByte:_goodNameTxt.text] >30){
        [self showTextHud:@"商品标题需在30字以内"];
        return;
    }
    if (_kindLab.text <= 0 ) {
        [self showTextHud:@"请选择商品类目"];
        return;
    }
    if (self.accView.outPutArr.count<=0) {
        [self showTextHud:@"请选择商品类型"];
        return;
    }
    if (self.accView.outPutArr1.count<=0) {
        [self showTextHud:@"请选择商品颜色"];
        return;
    }
    if (self.accView.outPutArr2.count<=0) {
        [self showTextHud:@"请选择商品状态"];
        return;
    }
    [_needResultArr removeAllObjects];
    NSMutableArray* result = [NSMutableArray array];
    NSMutableArray* array_data = [NSMutableArray arrayWithObjects:
                                  self.accView.outPutArr,
                                  self.accView.outPutArr1,
                                  self.accView.outPutArr2,
                                  nil];
    [self combine:result data:array_data curr:0 count:(int)array_data.count];
    NSLog(@"%@",result);
    AccessGoodsListController *listVc = [[AccessGoodsListController alloc]init];
    listVc.imageArr = _urlPhotos;
    listVc.dataArr = [_needResultArr mutableCopy];
    for (AccessCellModel *model in _ListArr) {
        model.image = _urlPhotos[0];
    }
    listVc.tabArr = _ListArr;
    [self.navigationController pushViewController:listVc animated:YES];

}

/**
 面料
 */
-(void)didSelectedFabricViewGoodsList{
    if (_urlPhotos.count <=0) {
        [self showTextHud:@"至少添加一张图片"];
        return;
    }
    if (_goodNameTxt.text.length <=0) {
    }else if ([self convertToByte:_goodNameTxt.text] >30){
        [self showTextHud:@"商品标题需在30字以内"];
        return;
    }
    if (_kindLab.text <= 0 ) {
        [self showTextHud:@"请选择商品类目"];
        return;
    }
    if (self.fabricView.outPutArr.count<=0) {
        [self showTextHud:@"请选择商品类型"];
        return;
    }
    if (self.fabricView.outPutArr1.count<=0) {
        [self showTextHud:@"请选择商品颜色"];
        return;
    }
    if (self.fabricView.outPutArr2.count<=0) {
        [self showTextHud:@"请选择商品状态"];
        return;
    }
    
    
    [_needResultArr removeAllObjects];
    NSMutableArray* result = [NSMutableArray array];
    NSMutableArray* array_data = [NSMutableArray arrayWithObjects:
                                  self.fabricView.outPutArr,
                                  self.fabricView.outPutArr1,
                                  self.fabricView.outPutArr2,
                                  nil];

    [self combine:result data:array_data curr:0 count:(int)array_data.count];
    
    NSLog(@" \n%@ ",_needResultArr);
    NSLog(@"%@",result);
    AccessGoodsListController *listVc = [[AccessGoodsListController alloc]init];
    listVc.imageArr = _urlPhotos;
    listVc.dataArr = [_needResultArr mutableCopy];
    for (AccessCellModel *model in _ListArr) {
        model.image = _urlPhotos[0];
    }
    listVc.tabArr = _ListArr;
    [self.navigationController pushViewController:listVc animated:YES];

}
- (void)combine:(NSMutableArray *)result data:(NSArray *)data curr:(int)currIndex count:(int)count {
    
    if (currIndex == count) {
        
        [_needResultArr addObject:[result mutableCopy]];
        [result removeLastObject];
        
    }else {
        NSArray* array = [data objectAtIndex:currIndex];
        
        for (int i = 0; i < array.count; ++i) {
            [result addObject:[array objectAtIndex:i]];
            //进入递归循环
            [self combine:result data:data curr:currIndex+1 count:count];
            
            if ((i+1 == array.count) && (currIndex-1>=0)) {
                [result removeObjectAtIndex:currIndex-1];
            }
        }
    }
}
#pragma mark ------- 刷新UI
- (void)removeAllViews{
    [self.ideaView removeFromSuperview];
    self.ideaView = nil;
    [self.accView removeFromSuperview];
    self.accView = nil;
    [self.fabricView removeFromSuperview];
    self.fabricView = nil;
}
- (void)refreshViewFrame{
    
    if (self.releaseType == ReleaseType_CreativeDesign) {
        _miaoshuView.frame = CGRectMake(0, self.ideaView.bottom, ScreenWidth, 178);
    }else if (self.releaseType == ReleaseType_Fabric){
        _miaoshuView.frame = CGRectMake(0, self.fabricView.bottom, ScreenWidth, 178);

    }else if ( self.releaseType == ReleaseType_Accessories){
        _miaoshuView.frame = CGRectMake(0, self.accView.bottom, ScreenWidth, 178);
    }
    _myscrollView.contentSize = CGSizeMake(10, _miaoshuView.bottom);

   
    
    
}
#pragma mark ------- 选完类目通知
- (void)UserHaveSelectedCategory:(NSNotification *)noti{

   // GoodsLvThreeModel  *model = noti.object;
    NSMutableArray *arr =  noti.object;
    NSLog(@"选择的三级类目======%@",arr);
    if (!arr[0]) {
        return;
    }
    NSDictionary *dic = arr[0];
    _kindLab.text = [NSString stringWithFormat:@"%@/%@/%@",dic[@"name"],arr[1][@"name"],arr[2][@"name"]];
    _categoryId =arr[2][@"modelid"];
    [self removeAllViews];

    if ([dic[@"name"] isEqualToString:@"创意设计"]) {
        
        NSDictionary *creatdic = arr[1];

        self.releaseType = ReleaseType_CreativeDesign;
        NSMutableArray *kindnameArr = [NSMutableArray arrayWithObjects:@"JPG",@"源文件",@"纸稿",@"自定义", nil];
        NSMutableArray *kindmodelArr = [NSMutableArray arrayWithCapacity:0];
        [kindmodelArr removeAllObjects];
        for (int i = 0; i<kindnameArr .count; i++) {
            UnitModel  *model = [[UnitModel alloc]init];
            if (i<kindnameArr .count) {
                model.originId = 999+i;
                
            }
            model.name = kindnameArr[i];
            [kindmodelArr addObject:model];
        }

        self.ideaView.kindArr = kindmodelArr;
        NSMutableArray *kindnameArr1;
        if ([creatdic[@"name"] isEqualToString:@"花型设计"]) {
            //花型设计
            kindnameArr1 = [NSMutableArray arrayWithObjects:@"颜色",@"尺寸",@"分辨率dpi",@"回位",@"印染工艺",@"风格", nil];

        }else{
            kindnameArr1 = [NSMutableArray arrayWithObjects:@"应用",@"图案",@"衣长",@"廓型",@"腰型",@"领型",@"袖长",@"风格", nil];

        }
        
        NSMutableArray  *modelArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<kindnameArr1.count; i++) {
            AttributesModel *model = [[AttributesModel alloc]init];
            model.attributeName = kindnameArr1[i];
            model.attributeDefaultValue = @"";
            model.attributeId = @"";
            [modelArr addObject:model];
        }
        self.ideaView.unitArr = modelArr;
        
    }else if ([dic[@"name"] isEqualToString:@"面料专区"]||[dic[@"name"] isEqualToString:@"坯布/半漂布"]){
        self.releaseType = ReleaseType_Fabric;
        NSMutableArray *kindnameArr = [NSMutableArray arrayWithObjects:@"定制",@"自定义", nil];
        NSMutableArray *kindmodelArr = [NSMutableArray arrayWithCapacity:0];
        [kindmodelArr removeAllObjects];
        for (int i = 0; i<kindnameArr .count; i++) {
            UnitModel  *model = [[UnitModel alloc]init];
            
            if (i<2) {
                if (i==1) {
                    model.originId = 1002;
                    
                }else{
                    model.originId = 1000+i;
                }
            }
            model.name = kindnameArr[i];
            [kindmodelArr addObject:model];
        }
        

        self.fabricView.kindArr = kindmodelArr;
      
        NSMutableArray *kindnameArr1 = [NSMutableArray arrayWithObjects:@"货号",@"成分",@"克重",@"门幅",@"编织方式",@"组织",@"工艺", nil];
        NSMutableArray  *modelArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<kindnameArr1.count; i++) {
            AttributesModel *model = [[AttributesModel alloc]init];
            model.attributeName = kindnameArr1[i];
            model.attributeDefaultValue = @"";
            model.attributeId = @"";
            [modelArr addObject:model];
        }
        self.fabricView.unitArr = modelArr;
    }else if ([dic[@"name"] isEqualToString:@"辅料专区"]){
        self.releaseType = ReleaseType_Accessories;
        NSMutableArray *kindnameArr = [NSMutableArray arrayWithObjects:@"多色/定制",@"自定义", nil];
        NSMutableArray *kindmodelArr = [NSMutableArray arrayWithCapacity:0];

        [kindmodelArr removeAllObjects];
        for (int i = 0; i<kindnameArr .count; i++) {
            UnitModel  *model = [[UnitModel alloc]init];
            
            if (i<2) {
                if (i==1) {
                    model.originId = 1002;
                    
                }else{
                    model.originId = 1000+i;
                }
            }else{
                model.on = YES;
            }
            model.name = kindnameArr[i];
            [kindmodelArr addObject:model];
        }
        self.accView.kindArr = kindmodelArr;
        
        NSMutableArray *kindnameArr1 = [NSMutableArray arrayWithObjects:@"货号",@"成分",@"面料",@"材质",@"工艺", nil];
        NSMutableArray  *modelArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<kindnameArr1.count; i++) {
            AttributesModel *model = [[AttributesModel alloc]init];
            model.attributeName = kindnameArr1[i];
            model.attributeDefaultValue = @"";
            model.attributeId = @"";
            [modelArr addObject:model];
        }
        self.accView.unitArr = modelArr;

    }
    
    _editStatus = 0;
    [self setrightLabtext];
   
    [self refreshViewFrame];
    
}


/**
 创建完商品列表反馈

 @param noti 返回字典
 */
- (void)UserHavesetupGoodsList:(NSNotification *)noti{

    NSDictionary *dic = noti.object;
    _itemList =  dic[@"goodStr"];
    _specificationIds = dic[@"specificationIds"];
    _ListArr = dic[@"listArr"];
    _editStatus = [dic[@"edit"] integerValue];
    
    if (_itemList.length <=0) {
        return;
    }
    if (self.releaseType == ReleaseType_CreativeDesign) {
        self.ideaView.itemIsEditComplete  = YES;
    }else if (self.releaseType == ReleaseType_Fabric){
        self.fabricView.itemIsEditComplete = YES;
    }else if (self.releaseType == ReleaseType_Accessories){
        self.accView.itemIsEditComplete = YES;
    }
    [self setrightLabtext];
}


- (void)removeGoodsList{
    _itemList =  @"";
    _specificationIds = @"";
    [_ListArr removeAllObjects];
    _editStatus = 0;
    [self setrightLabtext];
}


- (void)setrightLabtext{
    
    switch (_editStatus) {
        case 0:{
            if (self.releaseType == ReleaseType_CreativeDesign) {
                self.ideaView.rightLab.text = @"未编辑";
            }else if (self.releaseType == ReleaseType_Fabric){
                self.fabricView.rightLab.text = @"未编辑";
            }else if (self.releaseType == ReleaseType_Accessories){
                self.accView.rightLab.text = @"未编辑";
            }
            break;
        }
        case 1:{
            if (self.releaseType == ReleaseType_CreativeDesign) {
                self.ideaView.rightLab.text = @"未完成";
            }else if (self.releaseType == ReleaseType_Fabric){
                self.fabricView.rightLab.text = @"未完成";
            }else if (self.releaseType == ReleaseType_Accessories){
                self.accView.rightLab.text = @"未完成";
            }
            break;
        }
        case 2:{
            if (self.releaseType == ReleaseType_CreativeDesign) {
                self.ideaView.rightLab.text = @"已完成";
            }else if (self.releaseType == ReleaseType_Fabric){
                self.fabricView.rightLab.text = @"已完成";
            }else if (self.releaseType == ReleaseType_Accessories){
                self.accView.rightLab.text = @"已完成";
            }

            break;
        }
        default:
            break;
    }
    
    


}

- (void)UserHavesetupGoodsHTML:(NSNotification *)noti{
    
    _htmlStr = noti.object;

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
   
        UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            self.imagePickerVc.sourceType = sourceType;
            if(iOS8Later) {
                _imagePickerVc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
            }
            [self presentViewController:_imagePickerVc animated:YES completion:nil];
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if (textField == _goodNameTxt) {
//        if ([string isEqualToString:@""]) {
//            return YES;
//        }
//        if ([self convertToByte:_goodNameTxt.text]>30) {
//            [self showTextHud:@"最多输入30个字符"];
//            return NO;
//        }
//    }
    
    return YES;
    
}

- (void)textFieldDidChange:(UITextField *)textField {
    
    if (textField == _goodNameTxt){
        int count=[self textLength:_goodNameTxt.text];
        
        _lengthLab.text = [NSString stringWithFormat:@"%d/60",count];
        
    
    }

}
- (int)textLength:(NSString *)text//计算字符串长度
{
    int strlength = 0;
    char* p = (char*)[text cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[text lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return strlength;
}
@end
