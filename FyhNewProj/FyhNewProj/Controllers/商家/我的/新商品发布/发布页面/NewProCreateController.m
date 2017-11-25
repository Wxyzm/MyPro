//
//  NewProCreateController.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/30.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "NewProCreateController.h"

#import "PhotoChoseView.h"
#import "ProMessAgeView.h"
#import "NewParaMeterView.h"
#import "CategoryOneViewController.h"

#import "FabricUnitModel.h"
#import "CreateFlowerModel.h"


#import "ParaMeterModel.h"
#import "ComponentModel.h"
#import "BatchModel.h"

#import "UpImagePL.h"
#import "PublishGoodsPL.h"


#import "NewFaViewController.h"               //面料、坯布
#import "CreateFloTypeViewController.h"       //设计
#import "NewAccessViewController.h"           //辅料


@interface NewProCreateController ()<NewParaMeterViewDelegate>

@property (nonatomic , strong) UIScrollView     *myscrollView;          //底部scrollView

@property (nonatomic , strong) PhotoChoseView   *pictureView;           //照片展示View

@property (nonatomic , strong) ProMessAgeView   *proMessageView;        //产品信息View

@property (nonatomic , strong) NewParaMeterView    *paraMeterView;          //产品参数View

@property (nonatomic , strong) UIView           *describeView;          //产品参数View

@property (nonatomic, strong) UIImagePickerController *imagePickerVc;   //调用相机

@property (nonatomic , strong) SubBtn           *setUpBtn;            //立即发布

@property (nonatomic , strong) SubBtn           *putDownBtn;          //放入仓库


@end

@implementation NewProCreateController{
    
    NSMutableArray     *_urlPhotos;            //照片数组
    FabricUnitModel    *_fabricUnitModel;      //坯布面料模板
    CreateFlowerModel  *_flowerModel;          //花型设计模板
    UpImagePL          *_upImagePL;
    
    //发布数据名称
    NSString    *_itemList;             //Json格式的产品信息
    NSString    *_specificationIds;     //以英文逗号,隔开的规格id
    NSString    *_categoryId;           //类目id
    NSString    *_htmlStr;              //宝贝描述
    
}

-(NewParaMeterView *)paraMeterView{
    
    if (!_paraMeterView) {
        _paraMeterView = [[NewParaMeterView alloc]initWithFrame:CGRectMake(0, 119+183+39, ScreenWidth, 96)];
        _paraMeterView.delegate = self;
        [self.myscrollView addSubview:_paraMeterView];
    }
    return _paraMeterView;
}


-(UIScrollView *)myscrollView{
    
    if (!_myscrollView) {
        _myscrollView = [[UIScrollView alloc] init];
        _myscrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        self.myscrollView.backgroundColor = UIColorFromRGB(0xe6e9ed);
    }
    return _myscrollView;
}

-(SubBtn *)setUpBtn{
    
    if (!_setUpBtn) {
        _setUpBtn = [ SubBtn buttonWithtitle:@"立即发布" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:4 andtarget:self action:@selector(setupBtnClick) andframe: CGRectMake(16, 119+183+39 + _paraMeterView.height_sd+28, ScreenWidth - 32, 48)];
        [self.myscrollView addSubview:_setUpBtn];
        
    }
    return _setUpBtn;
}
-(SubBtn *)putDownBtn{
    
    if (!_putDownBtn) {
        _putDownBtn = [SubBtn buttonWithtitle:@"放入仓库" backgroundColor:UIColorFromRGB(0xccd1d9) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:4 andtarget:self action:@selector(putDownBtnClick)];
        [self.myscrollView addSubview:_putDownBtn];
    }
    return _putDownBtn;
}
#pragma mark ==========  ViewDidLoad
//viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发布商品";
    [self setBarBackBtnWithImage:nil];
    [self initData];
//UI
    [self initUI];
//选择类目通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newUserHaveSelectedCategory:)
                                                 name:@"newUserHaveSelectedCategory"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newUserHavesetupGoodsList:)
                                                 name:@"newUserHavesetupGoodsList"  object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newUserHavesetupGoodsHTML:)
                                                 name:@"newUserHavesetupGoodsHTML"  object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (self.paraMeterView.paraMeterType ==FABRIC_TYPE||self.paraMeterView.paraMeterType ==ACCESS_WAY||self.paraMeterView.paraMeterType ==DRESS_WAY||self.paraMeterView.paraMeterType ==HOMETEXT_WAY) {
        if (_fabricUnitModel.editType ==0) {
            self.proMessageView.UnitLab.text = @"未编辑";
        }else if (_fabricUnitModel.editType ==1||_fabricUnitModel.editType ==3){
            self.proMessageView.UnitLab.text = @"未完成";

        }else if (_fabricUnitModel.editType ==2){
            self.proMessageView.UnitLab.text = @"已完成";
            
        }
    }else{
        if (_flowerModel.editType ==0) {
            self.proMessageView.UnitLab.text = @"未编辑";
        }else if (_flowerModel.editType ==1||_flowerModel.editType ==3){
            self.proMessageView.UnitLab.text = @"未完成";
            
        }else if (_flowerModel.editType ==2){
            self.proMessageView.UnitLab.text = @"已完成";
            
        }
        
    }
   
    [self.paraMeterView reloadTableView];
     [self refreshScrollViewContentSize];
    
}


- (void)initData{
    
    _upImagePL = [[UpImagePL alloc]init];
    _htmlStr = @"";
    _categoryId = @"";
    _specificationIds = @"";
    _fabricUnitModel = [[FabricUnitModel alloc]init];
    _flowerModel = [[CreateFlowerModel alloc]init];
    
}

#pragma mark ==========  initUI


/**
 initUI
 */
- (void)initUI
{
    
    [self.view addSubview:self.myscrollView];
    
//照片展示
    _pictureView =[[PhotoChoseView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 119)];
    [self.myscrollView addSubview:_pictureView];
    
    _proMessageView = [[ProMessAgeView alloc]initWithFrame:CGRectMake(0, 119, ScreenWidth, 183)];
    [self.myscrollView addSubview:_proMessageView];
    UIButton *kindBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_proMessageView addSubview:kindBtn];
    kindBtn.frame = CGRectMake(100, 87, ScreenWidth - 100, 48);
    [kindBtn addTarget:self action:@selector(kindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    UIButton *unitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_proMessageView addSubview:unitBtn];
    unitBtn.frame = CGRectMake(100, 135, ScreenWidth - 100, 48);
    [unitBtn addTarget:self action:@selector(unitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *topView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 119+183, ScreenWidth, 39) color:UIColorFromRGB(0xe6e9ed)];
    [self.myscrollView addSubview:topView];
    
    UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 0, ScreenWidth - 32, 39) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"产品参数"];
    [topView addSubview:showLab];
    
    
    
    
}





#pragma mark ==========  按钮点击



/**
 选择类目
 */
- (void)kindBtnClick
{
    CategoryOneViewController *caVc = [[CategoryOneViewController alloc]init];
    [self.navigationController pushViewController:caVc animated:YES];
    
}

/**
 选择规格
 */
- (void)unitBtnClick
{
    if (!self.paraMeterView.paraMeterType) {
        [self showTextHud:@"请选择类目"];
        return;
    }
    if (_pictureView.urlPhotos.count<=0) {
        [self showTextHud:@"请添加商品主图"];
        return;
    }
    switch ( self.paraMeterView.paraMeterType) {
        case FABRIC_TYPE:      //坯布半漂布、面料
        {
            _fabricUnitModel.photoArr = _pictureView.urlPhotos;
            for (BatchModel *model in _fabricUnitModel.dataArr) {
                model.pictureArr = _fabricUnitModel.photoArr;
            }
            NewFaViewController *fabVc = [[NewFaViewController alloc]init];
            fabVc.dataModel = _fabricUnitModel;
            [self.navigationController pushViewController:fabVc animated:YES];
            break;
        }
        case PATTERNDES_WAY:        //花型设计
        {
            _flowerModel.photoArr = _pictureView.urlPhotos;
            for (BatchModel *model in _fabricUnitModel.dataArr) {
                model.pictureArr = _fabricUnitModel.photoArr;
            }
            CreateFloTypeViewController *crVc = [[CreateFloTypeViewController alloc]init];

            crVc.dataModel =_flowerModel;
            [self.navigationController  pushViewController:crVc animated:YES];
            
            break;
        }
        case CLOTHINGDES_WAY:        //服装设计
        {
            _flowerModel.photoArr = _pictureView.urlPhotos;
            for (BatchModel *model in _fabricUnitModel.dataArr) {
                model.pictureArr = _fabricUnitModel.photoArr;
            }
            CreateFloTypeViewController *crVc = [[CreateFloTypeViewController alloc]init];
            crVc.dataModel =_flowerModel;
            crVc.TYPE = 2;

            [self.navigationController  pushViewController:crVc animated:YES];
            break;
        }
        case ACCESS_WAY:        //辅料设计
        {
            _fabricUnitModel.photoArr = _pictureView.urlPhotos;
            for (BatchModel *model in _fabricUnitModel.dataArr) {
                model.pictureArr = _fabricUnitModel.photoArr;
            }
            NewAccessViewController *fabVc = [[NewAccessViewController alloc]init];
            fabVc.dataModel = _fabricUnitModel;
            [self.navigationController pushViewController:fabVc animated:YES];
            
            break;
        }
        case DRESS_WAY:        //服装服饰
        {
            _fabricUnitModel.photoArr = _pictureView.urlPhotos;
            for (BatchModel *model in _fabricUnitModel.dataArr) {
                model.pictureArr = _fabricUnitModel.photoArr;
            }
            NewAccessViewController *fabVc = [[NewAccessViewController alloc]init];
            fabVc.dataModel = _fabricUnitModel;
            [self.navigationController pushViewController:fabVc animated:YES];
            break;
        }
        case HOMETEXT_WAY:       //窗帘家纺
        {
            _fabricUnitModel.photoArr = _pictureView.urlPhotos;
            for (BatchModel *model in _fabricUnitModel.dataArr) {
                model.pictureArr = _fabricUnitModel.photoArr;
            }
            NewAccessViewController *fabVc = [[NewAccessViewController alloc]init];
            fabVc.dataModel = _fabricUnitModel;
            [self.navigationController pushViewController:fabVc animated:YES];
            break;
        }
        default:
            break;
    }
    
    
}

#pragma mark ==========  通知  //选择类目

- (void)newUserHaveSelectedCategory:(NSNotification *)noti{
    
    // GoodsLvThreeModel  *model = noti.object;
    NSMutableArray *arr =  noti.object;
    NSDictionary *Onedic = arr[0];
    if (!arr[0]) {
        return;
    }
    _categoryId =arr[2][@"modelid"];
    self.proMessageView.KindLab.text = [NSString stringWithFormat:@"%@/%@/%@",Onedic[@"name"],arr[1][@"name"],arr[2][@"name"]];
    if ([Onedic[@"name"] isEqualToString:@"坯布/半漂布"]||[Onedic[@"name"] isEqualToString:@"面料专区"])
    {
        self.paraMeterView.paraMeterType = FABRIC_TYPE;
        _fabricUnitModel.isFirstEdit = YES;
    }
    else if ([Onedic[@"name"] isEqualToString:@"创意设计"])
    {
        NSDictionary *Twodic = arr[1];
        if ([Twodic[@"name"] isEqualToString:@"花型设计"])
        {
             self.paraMeterView.paraMeterType = PATTERNDES_WAY;
            _flowerModel.isFirstEdit = YES;
        }else if ([Twodic[@"name"] isEqualToString:@"服装设计"])
        {
            self.paraMeterView.paraMeterType = CLOTHINGDES_WAY;
            _flowerModel.isFirstEdit = YES;

        }
        
    }
    else if ([Onedic[@"name"] isEqualToString:@"辅料专区"])
    {
        self.paraMeterView.paraMeterType = ACCESS_WAY;
        _fabricUnitModel.isFirstEdit = YES;

        
    }
    else if ([Onedic[@"name"] isEqualToString:@"服装服饰"])
    {
        self.paraMeterView.paraMeterType = DRESS_WAY;
        _fabricUnitModel.isFirstEdit = YES;

        
    }else if ([Onedic[@"name"] isEqualToString:@"窗帘家纺"])
    {
        self.paraMeterView.paraMeterType = HOMETEXT_WAY;
        _fabricUnitModel.isFirstEdit = YES;

        
    }
    [self refreshScrollViewContentSize];
    
}
/**
 创建完商品列表反馈
 
 @param noti 返回字典
 */
- (void)newUserHavesetupGoodsList:(NSNotification *)noti{
    
    NSDictionary *dic = noti.object;
    _itemList =  dic[@"goodStr"];
    _specificationIds = dic[@"specificationIds"];
 
  
}

/**
 html编辑

 @param noti noti description
 */
- (void)newUserHavesetupGoodsHTML:(NSNotification *)noti{
    
    _htmlStr = noti.object;
    self.paraMeterView.htmlStr = _htmlStr;
}

#pragma mark ==========  发布、放入仓库

- (void)setupBtnClick{
    
    if (![self isAllDataReady]) {
        return;
    }
    
     NSString *attributes;
    NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:0];

    for (int i = 0 ; i<self.paraMeterView.unitArr.count; i++) {
        ParaMeterModel *model = self.paraMeterView.unitArr[i];
        NSDictionary *dic;
        if (model.KindWay == INPUT_WAY) {
            dic = @{@"attributeName":model.ParaKind,
                    @"attributeDefaultValue":model.inputValue,
                    @"attributeId":@""
                    };
        }else if (model.KindWay == SELECT_WAY){
            if ([model.ParaKind isEqualToString:@"成分"]) {
                dic = @{@"attributeName":model.ParaKind,
                        @"attributeDefaultValue":model.componentModel.upStr,
                        @"attributeId":@""
                        };
            }else{
                dic = @{@"attributeName":model.ParaKind,
                        @"attributeDefaultValue":[model.ParaNameArr componentsJoinedByString:@","],
                        @"attributeId":@""
                        };
            }
           
        }else if (model.KindWay == ALLTWO_WAY){
            NSString *str;
            if (model.twoValue.length<=0) {
                str = @"";
            }else{
                str = model.twoUnit;
            }
            dic = @{@"attributeName":model.ParaKind,
                    @"attributeDefaultValue":[NSString stringWithFormat:@"%@%@",model.twoValue,str],
                    @"attributeId":@""
                    };
        }
        [strArr addObject:[GlobalMethod dictionaryToJson:dic]];

    }
    [MBProgressHUD showMessag:nil toView:self.view];

    attributes = [strArr componentsJoinedByString:@","];
    [_upImagePL shopUpdateToByGoodsImgArr:self.pictureView.urlPhotos WithReturnBlock:^(id returnValue) {
        NSArray *imageArr = returnValue[@"imageUrls"];
        NSDictionary *infoDic;
        infoDic = @{@"name":self.proMessageView.ProNameTxt.text,
                    @"specificationIds":_specificationIds,
                    @"categoryId":_categoryId,
                    @"imageUrl":[imageArr componentsJoinedByString:@","],
                    @"detail":_htmlStr,
                    @"unit":@"",
                    @"attributes":[NSString stringWithFormat:@"[%@]",attributes],
                    @"status":@"1"
                    };
        
        [PublishGoodsPL newProductWithInfoDic:infoDic ReturnBlock:^(id returnValue) {
            NSDictionary *returnDic = returnValue[@"data"][@"product"];
            
            NSDictionary *finaDic = @{@"productId":returnDic[@"id"],
                                      @"isOnSale":@"true",
                                      @"itemList":[NSString stringWithFormat:@"[%@]",_itemList],
                                      };
            [PublishGoodsPL GenerateitemsWithInfoDic:finaDic ReturnBlock:^(id returnValue) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (void)putDownBtnClick{
    if (![self isAllDataReady]) {
        return;
    }
    NSString *attributes;
    NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:0];
    
    for (int i = 0 ; i<self.paraMeterView.unitArr.count; i++) {
        ParaMeterModel *model = self.paraMeterView.unitArr[i];
        NSDictionary *dic;
        if (model.KindWay == INPUT_WAY) {
            dic = @{@"attributeName":model.ParaKind,
                    @"attributeDefaultValue":model.inputValue,
                    @"attributeId":@""
                    };
        }else if (model.KindWay == SELECT_WAY){
            if ([model.ParaKind isEqualToString:@"成分"]) {
                dic = @{@"attributeName":model.ParaKind,
                        @"attributeDefaultValue":model.componentModel.upStr,
                        @"attributeId":@""
                        };
            }else{
                dic = @{@"attributeName":model.ParaKind,
                        @"attributeDefaultValue":[model.ParaNameArr componentsJoinedByString:@","],
                        @"attributeId":@""
                        };
            }
            
        }else if (model.KindWay == ALLTWO_WAY){
            NSString *str;
            if (model.twoValue.length<=0) {
                str = @"";
            }else{
                str = model.twoUnit;
            }
            dic = @{@"attributeName":model.ParaKind,
                    @"attributeDefaultValue":[NSString stringWithFormat:@"%@%@",model.twoValue,str],
                    @"attributeId":@""
                    };
        }
        [strArr addObject:[GlobalMethod dictionaryToJson:dic]];
        
    }
    attributes = [strArr componentsJoinedByString:@","];
    [MBProgressHUD showMessag:nil toView:self.view];

    [_upImagePL shopUpdateToByGoodsImgArr:_urlPhotos WithReturnBlock:^(id returnValue) {
        NSArray *imageArr = returnValue[@"imageUrls"];
        NSDictionary *infoDic;
        infoDic = @{@"name":self.proMessageView.ProNameTxt.text,
                    @"specificationIds":_specificationIds,
                    @"categoryId":_categoryId,
                    @"imageUrl":[imageArr componentsJoinedByString:@","],
                    @"detail":_htmlStr,
                    @"unit":@"",
                    @"attributes":[NSString stringWithFormat:@"[%@]",attributes],
                    @"status":@"0"
                    };
        
        [PublishGoodsPL newProductWithInfoDic:infoDic ReturnBlock:^(id returnValue) {
            NSDictionary *returnDic = returnValue[@"data"][@"product"];
            
            NSDictionary *finaDic = @{@"productId":returnDic[@"id"],
                                      @"isOnSale":@"false",
                                      @"itemList":[NSString stringWithFormat:@"[%@]",_itemList],
                                      };
            [PublishGoodsPL GenerateitemsWithInfoDic:finaDic ReturnBlock:^(id returnValue) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
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

- (void)refreshScrollViewContentSize{
    
    self.setUpBtn.frame = CGRectMake(16, 119+183+39 + _paraMeterView.height_sd+28, ScreenWidth - 32, 48);
    self.putDownBtn.frame = CGRectMake(16, 119+183+39 + _paraMeterView.height_sd+92, ScreenWidth - 32, 48);
    
    _myscrollView.contentSize = CGSizeMake(ScreenWidth, 119+183+39 + _paraMeterView.height_sd+160);
    
    
}

#pragma mark ====== 判断数据完整

- (BOOL)isAllDataReady{
    
    if (self.pictureView.urlPhotos.count<=0) {
        [self showTextHud:@"请添加商品主图"];
        return NO;
    }
    if (self.proMessageView.ProNameTxt.text.length <=0) {
        [self showTextHud:@"请添加商品标题"];
        return NO;
    }
    if (_specificationIds.length <=0) {
        [self showTextHud:@"请编辑商品列表"];
        return NO;
    }
    if (_itemList.length <=0) {
        [self showTextHud:@"请编辑商品列表"];
        return NO;
    }
//    if (_editStatus==0||_editStatus == 1) {
//        [self showTextHud:@"请将商品编辑完成"];
//        return NO;
//    }
    if ([self convertToByte:self.proMessageView.ProNameTxt.text] >30){
        
        [self showTextHud:@"商品标题需在30字以内"];
        return NO;
    }
    return YES;
}

-(void)didSelectedaddunitBtn{
    
    [self refreshScrollViewContentSize];
    
}

@end
