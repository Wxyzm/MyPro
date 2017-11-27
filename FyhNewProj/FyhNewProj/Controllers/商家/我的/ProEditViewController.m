//
//  ProEditViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ProEditViewController.h"

#import "BatchModel.h"
#import "ColorModel.h"
#import "SampleCardModel.h"
#import "SampleColthModel.h"
#import "ProEditModel.h"
#import "GItemModel.h"
#import "FabricUnitModel.h"
#import "CreateFlowerModel.h"
#import "SpecificationListEditModel.h"
#import "SpecificationModel.h"
#import "ParaMeterModel.h"
#import "ComponentModel.h"

#import "GoodsItemsPL.h"
#import "UpImagePL.h"
#import "PublishGoodsPL.h"

#import "PhotoChoseView.h"
#import "ProMessAgeView.h"
#import "NewParaMeterView.h"

#import "NewFaViewController.h"               //面料、坯布
#import "CreateFloTypeViewController.h"       //设计
#import "NewAccessViewController.h"           //辅料

@interface ProEditViewController ()<NewParaMeterViewDelegate>

@property (nonatomic , strong) UIScrollView     *myscrollView;          //底部scrollView
@property (nonatomic , strong) PhotoChoseView   *pictureView;           //照片展示View
@property (nonatomic , strong) ProMessAgeView   *proMessageView;        //产品信息View
@property (nonatomic , strong) NewParaMeterView    *paraMeterView;       //产品参数View
@property (nonatomic , strong) SubBtn           *setUpBtn;               //立即发布
@property (nonatomic , strong) SubBtn           *putDownBtn;             //放入仓库


@end



@implementation ProEditViewController{
    
    ProEditModel  *_model;
    FabricUnitModel    *_fabricUnitModel;      //坯布面料等模板
    CreateFlowerModel  *_flowerModel;          //花型设计等模板
    NSMutableArray     *_specificationListArr; //商品规格
    
    //发布数据名称
    NSString    *_itemList;             //Json格式的产品信息
    NSString    *_specificationIds;     //以英文逗号,隔开的规格id
    NSString    *_categoryId;           //类目id
    NSString    *_htmlStr;              //宝贝描述
    UpImagePL   *_upImagePL;
}


#pragma mark ===== viewDidLoad

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"产品编辑";
    [self.view addSubview:self.myscrollView];
    _specificationListArr = [NSMutableArray arrayWithCapacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newUserHavesetupGoodsHTML:)
                                                 name:@"newUserHavesetupGoodsHTML"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(newUserHavesetupGoodsList:)
                                                 name:@"newUserHavesetupGoodsList"  object:nil];
    _upImagePL =  [[UpImagePL alloc]init];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
    [self loadGoodsDetail];
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



#pragma mark ===== 获取详情
- (void)loadGoodsDetail{
    
    if (!_idStr||_idStr.length<=0) {
        [self showTextHud:@"产品详情获取失败"];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    [GoodsItemsPL UserGetHisMasterProDETAILWithProId:_idStr ReturnBlock:^(id returnValue) {
        _model = [ProEditModel mj_objectWithKeyValues:returnValue[@"data"][@"product"]];
        _specificationListArr = [SpecificationListEditModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"][@"specificationList"]];
        NSLog(@"%@",_model);
        if (_model.ProId) {
            [self setDatasWithView];
        }
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:@"产品详情获取失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}

- (void)setDatasWithView{
    
    //顶部图片
    WeakSelf(self);
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    NSMutableArray  *imageArr = [NSMutableArray arrayWithCapacity:0];
    [imageArr addObjectsFromArray:_model.imageUrlList];
    for (int i = 0; i<_model.imageUrlList.count; i++) {
        __block UIImage *image1 = nil;  //要加一个 __block因为 block代码默认不能改外面的东西（记住语法即可）
        dispatch_group_async(group, queue, ^{
            NSURL *url1 = [NSURL URLWithString:_model.imageUrlList[i]];
            NSData *data1 = [NSData dataWithContentsOfURL:url1];
            image1 = [UIImage imageWithData:data1];
            if (!image1) {
                image1 = [UIImage imageNamed:@"loding"];
            }
            [imageArr replaceObjectAtIndex:i withObject:image1];
        });
    }
    dispatch_group_notify(group, queue, ^{
        // 5.回到主线程显示图片
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakself.pictureView.urlPhotos addObjectsFromArray:imageArr];
            [weakself.pictureView reloadTableView];
        });
    });
    //确认所编辑商品种类
    self.proMessageView.ProNameTxt.text = _model.name;
    self.proMessageView.UnitLab.text = @"已完成";
    self.proMessageView.KindLab.text = _model.categoryDescription;
    
    UIView *topView = [BaseViewFactory  viewWithFrame:CGRectMake(0, 119+183, ScreenWidth, 39) color:UIColorFromRGB(0xe6e9ed)];
    [self.myscrollView addSubview:topView];
    
    UILabel *showLab = [BaseViewFactory labelWithFrame:CGRectMake(16, 0, ScreenWidth - 32, 39) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"产品参数"];
    [topView addSubview:showLab];
    
    if ([_model.categoryDescriptionArray[0] isEqualToString:@"坯布/半漂布"]||[_model.categoryDescriptionArray[0] isEqualToString:@"面料专区"])
    {
       // self.paraMeterView.paraMeterType = FABRIC_TYPE;
        [self.paraMeterView setParaMeterType:FABRIC_TYPE andDataArr: _model.attributes];
        [self setFaModel];
    }
    else if ([_model.categoryDescriptionArray[0] isEqualToString:@"创意设计"])
    {
        if ([_model.categoryDescriptionArray[1] isEqualToString:@"花型设计"])
        {
           // self.paraMeterView.paraMeterType = PATTERNDES_WAY;
            [self.paraMeterView setParaMeterType:PATTERNDES_WAY andDataArr: _model.attributes];

        }else if ([_model.categoryDescriptionArray[1] isEqualToString:@"服装设计"])
        {
            //self.paraMeterView.paraMeterType = CLOTHINGDES_WAY;
            [self.paraMeterView setParaMeterType:CLOTHINGDES_WAY andDataArr: _model.attributes];

        }
        [self setCreateModel];
    }
    else if ([_model.categoryDescriptionArray[0] isEqualToString:@"辅料专区"])
    {
        //self.paraMeterView.paraMeterType = ACCESS_WAY;
        [self.paraMeterView setParaMeterType:ACCESS_WAY andDataArr: _model.attributes];
        [self setFaModel];

    }
    else if ([_model.categoryDescriptionArray[0] isEqualToString:@"服装服饰"])
    {
       // self.paraMeterView.paraMeterType = DRESS_WAY;
        [self.paraMeterView setParaMeterType:DRESS_WAY andDataArr: _model.attributes];
        [self setFaModel];


    }else if ([_model.categoryDescriptionArray[0] isEqualToString:@"窗帘家纺"])
    {
        //self.paraMeterView.paraMeterType = HOMETEXT_WAY;
        [self.paraMeterView setParaMeterType:DRESS_WAY andDataArr: _model.attributes];
        [self setFaModel];

    }
//    self.paraMeterView.unitArr = _model.attributes;
    
    UIButton *unitBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [_proMessageView addSubview:unitBtn];
    unitBtn.frame = CGRectMake(100, 135, ScreenWidth - 100, 48);
    [unitBtn addTarget:self action:@selector(unitBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _specificationIds = _model.specificationIds;
    _categoryId = [NSString stringWithFormat:@"%ld",_model.categoryId];
    _htmlStr = _model.detail;
      [self refreshScrollViewContentSize];
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
            fabVc.ProIdStr = [NSString stringWithFormat:@"%ld",(long)_model.ProId];
            [self.navigationController pushViewController:fabVc animated:YES];
            break;
        }
        case PATTERNDES_WAY:        //花型设计
        {
            _flowerModel.photoArr = _pictureView.urlPhotos;
            for (BatchModel *model in _flowerModel.dataArr) {
                model.pictureArr = _flowerModel.photoArr;
            }
            CreateFloTypeViewController *crVc = [[CreateFloTypeViewController alloc]init];
            crVc.ProIdStr = [NSString stringWithFormat:@"%ld",(long)_model.ProId];

            crVc.dataModel =_flowerModel;
            [self.navigationController  pushViewController:crVc animated:YES];
            
            break;
        }
        case CLOTHINGDES_WAY:        //服装设计
        {
            _flowerModel.photoArr = _pictureView.urlPhotos;
            for (BatchModel *model in _flowerModel.dataArr) {
                model.pictureArr = _flowerModel.photoArr;
            }
            CreateFloTypeViewController *crVc = [[CreateFloTypeViewController alloc]init];
            crVc.dataModel =_flowerModel;
            crVc.TYPE = 2;
            crVc.ProIdStr = [NSString stringWithFormat:@"%ld",(long)_model.ProId];

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
            fabVc.ProIdStr = [NSString stringWithFormat:@"%ld",(long)_model.ProId];

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
            fabVc.ProIdStr = [NSString stringWithFormat:@"%ld",(long)_model.ProId];

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
            fabVc.ProIdStr = [NSString stringWithFormat:@"%ld",(long)_model.ProId];
            [self.navigationController pushViewController:fabVc animated:YES];
            break;
        }
        default:
            break;
    }
    
    
}


- (void)refreshScrollViewContentSize{
    
    self.setUpBtn.frame = CGRectMake(16, 119+183+39 + _paraMeterView.height_sd+28, ScreenWidth - 32, 48);
    self.putDownBtn.frame = CGRectMake(16, 119+183+39 + _paraMeterView.height_sd+92, ScreenWidth - 32, 48);
    
    _myscrollView.contentSize = CGSizeMake(ScreenWidth, 119+183+39 + _paraMeterView.height_sd+160);
    
    
}


-(void)didSelectedaddunitBtn{
    
    [self refreshScrollViewContentSize];
    
}
#pragma mark ===== 立即发布  放入仓库
//立即发布
- (void)setupBtnClick{
    //1.上传图片 2.编辑产品 3.从产品根据规格组合批量创建商品 
    
    if (![self isAllDataReady]) {
        return;
    }
    [self setupOrPutDownGoodsWithImage:self.pictureView.urlPhotos andstatus:@"1"];
}

//放入仓库
- (void)putDownBtnClick{
    if (![self isAllDataReady]) {
        return;
    }
    [self setupOrPutDownGoodsWithImage:self.pictureView.urlPhotos andstatus:@"0"];

    
}

//上下架
- (void)setupOrPutDownGoodsWithImage:(NSArray *)imageArr andstatus:(NSString *)status{
    
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
    [_upImagePL shopUpdateToByGoodsImgArr:imageArr WithReturnBlock:^(id returnValue) {
        NSArray *imageArr = returnValue[@"imageUrls"];
        NSDictionary *infoDic;
        infoDic = @{@"name":self.proMessageView.ProNameTxt.text,
                    @"specificationIds":_specificationIds,
                    @"categoryId":_categoryId,
                    @"imageUrl":[imageArr componentsJoinedByString:@","],
                    @"detail":_htmlStr,
                    @"unit":@"",
                    @"attributes":[NSString stringWithFormat:@"[%@]",attributes],
                    @"skuCode":@"",
                    @"status":status
                    };
        [PublishGoodsPL changeProductWithInfoDic:infoDic andid:[NSString stringWithFormat:@"%ld",(long)_model.ProId] ReturnBlock:^(id returnValue) {
            NSDictionary *dic;
            NSMutableArray *specificationValueIds = [NSMutableArray arrayWithCapacity:0];

            if (!_itemList) {
                for (int i = 0; i<_model.itemsInCurrentSpecification.count; i++)
                {
                    GItemModel *model = _model.itemsInCurrentSpecification[i];
                    NSDictionary *goodDic = @{@"specificationValueIds":model.specificationValueIds,
                                              @"price":model.price,
                                              @"stock":model.stock,
                                              @"minBuyQuantity":model.minBuyQuantity,
                                              @"limitUserTotalBuyQuantity":model.limitUserTotalBuyQuantity,
                                              @"skuCode":@"",
                                              @"mainImageUrl":@""
                                              };
                    [specificationValueIds addObject:[GlobalMethod dictionaryToJson:goodDic]];

                    
                    
                }
               _itemList = [specificationValueIds componentsJoinedByString:@","];

                
            }
            if ([status isEqualToString:@"1"]) {
                dic = @{@"productId":[NSString stringWithFormat:@"%ld",(long)_model.ProId],
                        @"isOnSale":@"true",
                        @"itemList":[NSString stringWithFormat:@"[%@]",_itemList]
                        };
            }else{
                dic = @{@"productId":[NSString stringWithFormat:@"%ld",(long)_model.ProId],
                        @"isOnSale":@"false",
                        @"itemList":[NSString stringWithFormat:@"[%@]",_itemList]
                        };
            }
            NSLog(@"%@",dic);
            [PublishGoodsPL GenerateitemsWithInfoDic:dic ReturnBlock:^(id returnValue) {
                
                 [self showTextHud:@"修改成功"];
                [self.navigationController popViewControllerAnimated:YES];
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

#pragma mark ==========  通知  //选择类目

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


#pragma mark ====== 判断数据完整

- (BOOL)isAllDataReady{
    
    if (self.proMessageView.ProNameTxt.text.length <=0) {
        [self showTextHud:@"请添加商品标题"];
        return NO;
    }
    if ([self convertToByte:self.proMessageView.ProNameTxt.text] >30){
        
        [self showTextHud:@"商品标题需在30字以内"];
        return NO;
    }
    if (self.pictureView.urlPhotos.count<=0) {
        [self showTextHud:@"请添加商品主图"];
        return NO;
    }
    if (_specificationIds.length <=0) {
        [self showTextHud:@"请编辑商品列表"];
        return NO;
    }
    
    return YES;
}

#pragma mark ===== get
-(PhotoChoseView *)pictureView{
    
    if (!_pictureView) {
        _pictureView =[[PhotoChoseView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 119)];
        [self.myscrollView addSubview:_pictureView];
    }
    return _pictureView;
}

-(UIScrollView *)myscrollView{
    
    if (!_myscrollView) {
        _myscrollView = [[BaseScrollView alloc] init];
        _myscrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        self.myscrollView.backgroundColor = UIColorFromRGB(0xe6e9ed);
    }
    return _myscrollView;
}

-(ProMessAgeView *)proMessageView{
    
    if (!_proMessageView) {
        _proMessageView = [[ProMessAgeView alloc]initWithFrame:CGRectMake(0, 119, ScreenWidth, 183)];
        _proMessageView.KindLab.userInteractionEnabled = NO;
        [self.myscrollView addSubview:_proMessageView];

    }
    return _proMessageView;
}
-(NewParaMeterView *)paraMeterView{
    
    if (!_paraMeterView) {
        _paraMeterView = [[NewParaMeterView alloc]initWithFrame:CGRectMake(0, 119+183+39, ScreenWidth, 96)];
        _paraMeterView.delegate = self;
        [self.myscrollView addSubview:_paraMeterView];
    }
    return _paraMeterView;
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


- (void)setFaModel{
    
    _fabricUnitModel = [[FabricUnitModel alloc]init];
    _fabricUnitModel.isFirstEdit = NO;
    _fabricUnitModel.editType = 2;
    //三大规格
    NSString *   _sampleCardId = @"";
    NSString *   _sampleClothId = @"";
    NSString *   _bigId = @"";
    
    for (SpecificationListEditModel *model in _specificationListArr) {
        if ([model.name isEqualToString:@"类型"]) {
            for (SpecificationModel *smodel in model.specificationValues) {
                [_fabricUnitModel.kindArr addObject:smodel.name];
                if ([smodel.name isEqualToString:@"样卡"]) {
                  _sampleCardId   = smodel.kindId;
                }else if ([smodel.name isEqualToString:@"样布"]||[smodel.name isEqualToString:@"零售"]){
                  _sampleClothId   = smodel.kindId;
                }else if ([smodel.name isEqualToString:@"大货"]||[smodel.name isEqualToString:@"批发"]){
                    _bigId = smodel.kindId;
                }
            }
        }else if ([model.name isEqualToString:@"状态"]){
            for (SpecificationModel *smodel in model.specificationValues) {
                [_fabricUnitModel.statusArr addObject:smodel.name];
            }
        }else if ([model.name isEqualToString:@"颜色"]){
            for (SpecificationModel *smodel in model.specificationValues) {
                ColorModel *colormodel = [[ColorModel alloc]init];
                colormodel.IsSelected = YES;
                colormodel.colorName = smodel.name;
                [_fabricUnitModel.colorArr addObject:colormodel];
            }
        }
    }
    //样卡样布
    GItemModel *sampleCardModel ;    //样卡
    GItemModel *sampleClothModel;    //样布
    for (GItemModel *model in _model.itemsInCurrentSpecification) {
        //样卡
       
        if ([model.specificationValueIds containsString:_sampleCardId]) {
            if (!sampleCardModel) {
                sampleCardModel = model;
            }else{
                if ([sampleCardModel.stock intValue]>[model.stock intValue]) {
                    sampleCardModel = model;
                }
            }
        }
        //样布
        if ([model.specificationValueIds containsString:_sampleClothId]) {
            if (!sampleClothModel) {
                sampleClothModel = model;
            }else{
                if ([sampleClothModel.stock intValue]>[model.stock intValue]) {
                    sampleClothModel = model;
                }
            }
        }
        //大货
        if ([model.specificationValueIds containsString:_bigId]) {
            BatchModel *bamodel = [[BatchModel alloc]init];
            bamodel.isOn = YES;
            bamodel.type = 0;
            NSMutableArray *unitArr = [NSMutableArray arrayWithCapacity:0];
            for (SpecificationModel *smodel in model.specificationValues) {
                [unitArr addObject:smodel.name];
            }
            bamodel.kind = [unitArr componentsJoinedByString:@","];
            bamodel.price =model.price;
            bamodel.stock = model.stock;
            bamodel.mineBuy = model.minBuyQuantity;
            bamodel.limitBuy = model.limitUserTotalBuyQuantity;
            [_fabricUnitModel.dataArr addObject:bamodel];
        }
    }
    if (sampleCardModel.itemID) {
        SampleCardModel *model = [[SampleCardModel alloc]init];
        model.stock = sampleCardModel.stock;
        model.price = sampleCardModel.price;
        model.limitBuy = sampleCardModel.limitUserTotalBuyQuantity;
        _fabricUnitModel.cardModel = model;
    }
    if (sampleClothModel.itemID) {
        SampleColthModel *model = [[SampleColthModel alloc]init];
        model.stock = sampleClothModel.stock;
        model.price = sampleClothModel.price;
        model.limitBuy = sampleClothModel.limitUserTotalBuyQuantity;
        _fabricUnitModel.colthModel = model;
    }
    
    
}
- (void)setCreateModel{
    
    _flowerModel = [[CreateFlowerModel alloc]init];
    _flowerModel.isFirstEdit = NO;
    _flowerModel.editType = 2;
    //三大规格
    NSString *   _sampleClothId = @"";
    NSString *   _bigId = @"";
    /*
     for (SpecificationModel *smodel in model.specificationValues) {
     ColorModel *colormodel = [[ColorModel alloc]init];
     colormodel.IsSelected = YES;
     colormodel.colorName = smodel.name;
     [_fabricUnitModel.colorArr addObject:colormodel];
     }
     */
    
    for (SpecificationListEditModel *model in _specificationListArr) {
        if ([model.name isEqualToString:@"类型"]) {
            for (SpecificationModel *smodel in model.specificationValues) {
                ColorModel *colormodel = [[ColorModel alloc]init];
                colormodel.IsSelected = YES;
                colormodel.colorName = smodel.name;
                [_flowerModel.kindArr addObject:colormodel];
                
            }
        }else if ([model.name isEqualToString:@"状态"]){
            for (SpecificationModel *smodel in model.specificationValues) {
                [_flowerModel.statusArr addObject:smodel.name];
                if ([smodel.name isEqualToString:@"买断"]){
                    _sampleClothId   = smodel.kindId;
                }else if ([smodel.name isEqualToString:@"授权"]){
                    _bigId = smodel.kindId;
                }
            }
        }
    }
    //零售
    GItemModel *sampleClothModel;    //零售
    for (GItemModel *model in _model.itemsInCurrentSpecification) {
       
        //零售
        if ([model.specificationValueIds containsString:_sampleClothId]) {
            if (!sampleClothModel) {
                sampleClothModel = model;
            }else{
                if ([sampleClothModel.stock intValue]>[model.stock intValue]) {
                    sampleClothModel = model;
                }
            }
        }
        //批发
        if ([model.specificationValueIds containsString:_bigId]) {
            BatchModel *bamodel = [[BatchModel alloc]init];
            bamodel.isOn = YES;
            bamodel.type = 1;
            NSMutableArray *unitArr = [NSMutableArray arrayWithCapacity:0];
            for (SpecificationModel *smodel in model.specificationValues) {
                [unitArr addObject:smodel.name];
            }
            bamodel.kind = [unitArr componentsJoinedByString:@","];
            bamodel.price =model.price;
            bamodel.stock = model.stock;
            bamodel.mineBuy = model.minBuyQuantity;
            bamodel.limitBuy = model.limitUserTotalBuyQuantity;
            [_flowerModel.dataArr addObject:bamodel];
        }
    }
    
    if (sampleClothModel.itemID) {
        SampleColthModel *model = [[SampleColthModel alloc]init];
        model.stock = sampleClothModel.stock;
        model.price = sampleClothModel.price;
        model.limitBuy = sampleClothModel.limitUserTotalBuyQuantity;
        _flowerModel.colthModel = model;
    }
    
    
}

@end
