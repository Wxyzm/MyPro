//
//  NewFaViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "NewFaViewController.h"
#import "FabricProUnitView.h"
#import "FabricUnitModel.h"
#import "SampleCardView.h"
#import "BatchView.h"
#import "SampleColth.h"
#import "BatchSetView.h"
#import "SampleCardModel.h"
#import "SampleColthModel.h"
#import "PublishGoodsPL.h"
#import "CompleteSpecificationModel.h"
#import "SpecificationModel.h"
#import "ColorModel.h"
#import "BatchModel.h"
#define TOPVIEWBOOM  183


@interface NewFaViewController ()<FabricProUnitViewDelegate>

@property (nonatomic,strong) FabricProUnitView   *fabView;               //顶部View

@property (nonatomic,strong) SampleCardView      *cardView;              //样卡

@property (nonatomic,strong) SampleColth         *colthView;             //样布

@property (nonatomic,strong) BatchSetView        *batchView;             //批量设置大货

@property (nonatomic , strong) UIScrollView      *myscrollView;          //底部scrollVie

@property (nonatomic , strong) BatchView          *mybatchView;          //底部scrollView


@end

@implementation NewFaViewController{
    
    CGFloat  _clothOriginY;     //样布Y
    CGFloat  _batchOriginY;     //批量Y
    //    NSMutableArray  *_dataArr;
    BOOL _IsHaVeSampleCard;
    BOOL _IsHaVeSampleCloth;
    BOOL _IsHaVeSBat;
    NSMutableArray *_needResultArr;
    CGFloat _originY;
    
}

-(BatchView *)mybatchView{
    
    if (!_mybatchView) {
        _mybatchView = [[BatchView alloc]init];
        [_mybatchView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _mybatchView.type = 1;
    }
    return _mybatchView;
}

//scrollView
-(UIScrollView *)myscrollView{
    
    if (!_myscrollView) {
        _myscrollView = [[UIScrollView alloc] init];
        _myscrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        self.myscrollView.backgroundColor = UIColorFromRGB(0xf5f7fa);
    }
    return _myscrollView;
}


//样卡
-(SampleCardView *)cardView{
    if (!_cardView) {
        _cardView = [[SampleCardView alloc] initWithFrame:CGRectMake(0, TOPVIEWBOOM, ScreenWidth, 152)];
    }
    return _cardView;
}

//样布
-(SampleColth *)colthView{
    if (!_colthView) {
        _colthView = [[SampleColth alloc] initWithFrame:CGRectMake(0, _clothOriginY, ScreenWidth, 104)];
    }
    return _colthView;
}

//批量设置
-(BatchSetView *)batchView{
    if (!_batchView) {
        _batchView = [[BatchSetView alloc] initWithFrame:CGRectMake(0, _batchOriginY, ScreenWidth, self.dataModel.dataArr.count *112 +51)];
        [_batchView.batchBtn addTarget:self action:@selector(batchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _batchView;
}

-(FabricUnitModel *)dataModel{
    
    if (!_dataModel) {
        _dataModel = [[FabricUnitModel alloc]init];
    }
    return _dataModel;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品列表";
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    [self setBarBackBtnWithImage:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHaveSelectedColor:)
                                                 name:@"UserHaveSelectedColor"  object:nil];
    _needResultArr = [NSMutableArray arrayWithCapacity:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHaveChangeData)
                                                 name:@"UserHaveChangeData"  object:nil];
    _needResultArr = [NSMutableArray arrayWithCapacity:0];
    [self initUI];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    //会调用两次，需要改进
    [self refreshHeight];
}


#pragma mark ==========  initUI

/**
 initUI
 */
- (void)initUI{
    
    
    UIButton* rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [rightbutton setTitle:@"确认" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = APPFONT(14);
    [rightbutton addTarget:self action:@selector(respondToRightButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    
    self.navigationItem.rightBarButtonItem = right;
    
    
    [self.view addSubview:self.myscrollView];
    
    _fabView = [[FabricProUnitView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, TOPVIEWBOOM)];
    _fabView.delegate = self;
    _fabView.kindTitleArr = self.dataModel.kindArr;
    _fabView.statusTitleArr = self.dataModel.statusArr;
    if (self.dataModel.isFirstEdit) {
        NSArray *color =@[@"白色系",@"黑色系",@"红色系"];
        for (NSString *colorstr in color) {
            ColorModel *model   = [[ColorModel alloc]init];
            model.colorName = colorstr;
            model.IsSelected = YES;
            [self.dataModel.colorArr addObject:model];
        }
    }
    _fabView.colorTitleArr = self.dataModel.colorArr;
    [self.myscrollView addSubview:_fabView];
    self.dataModel.isFirstEdit = NO;
    
    //样卡
    [self.myscrollView addSubview:self.cardView];
    self.cardView.cardModel = self.dataModel.cardModel;
    if ([self.dataModel.kindArr containsObject:@"样卡"]) {
        _IsHaVeSampleCard = YES;
    }
    //样布
    [self.myscrollView addSubview:self.colthView];
    self.colthView.clothModel = self.dataModel.colthModel;
    if ([self.dataModel.kindArr containsObject:@"样布"]) {
        _IsHaVeSampleCloth = YES;
    }
    //批量设置
    
    self.batchView.dataArr =self.dataModel.dataArr;
    [self.myscrollView addSubview:self.batchView];
    if (self.dataModel.dataArr.count>0) {
        _IsHaVeSBat = YES;
        
    }
    
    
    [self refreshHeight];
}


/**
 改变高度
 */
- (void)refreshHeight{
    
    _originY=0;
    [_fabView refreshColorBtnView];
    _originY +=  _fabView.height_sd;
    if (_IsHaVeSampleCard) {
        self.cardView.hidden = NO;
        self.cardView.frame = CGRectMake(0, _originY, ScreenWidth, 152);
        _originY += 152 ;
    }else{
        self.cardView.hidden = YES;
    }
    if (_IsHaVeSampleCloth) {
        _colthView.hidden = NO;
        _colthView.frame = CGRectMake(0, _originY, ScreenWidth, 104);
        _originY +=104;
    }else{
        _colthView.hidden = YES;
        
    }
    if (_IsHaVeSBat) {
        NSMutableArray *arr = [[NSMutableArray alloc]init];
        for (BatchModel *model in self.dataModel.dataArr) {
            if (model.isOn) {
                [arr addObject:model];
            }
        }
        self.batchView.frame = CGRectMake(0, _originY, ScreenWidth, arr.count *112 +51);
        self.batchView.hidden = NO;
        _originY +=arr.count *112 +51;
    }else{
        self.batchView.hidden = YES;
        
    }
    
    [self setScrollViewContSize];
    
}

- (void)setScrollViewContSize{
    
    
    _myscrollView.contentSize = CGSizeMake(ScreenWidth,_originY);
    
}
#pragma mark ==========  按钮点击

/**
 右侧tabbarItem
 */
- (void)respondToRightButtonClickEvent{
    [self.view endEditing:YES];
    if (![self makesureAllDatas]) {
        return;
    }
    
    NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:0];
    for (ColorModel *model in self.dataModel.colorArr) {
        if (model.IsSelected) {
            [colorArr addObject:model.colorName];
        }
    }
    NSString *kindStr = [self.dataModel.kindArr componentsJoinedByString:@","];
    NSString *colorStr = [colorArr componentsJoinedByString:@","];
    NSString *stateStr = [self.dataModel.statusArr  componentsJoinedByString:@","];
    
    NSDictionary *infoDic = @{@"specificationName":@"类型",
                              @"specificationValues":kindStr,
                              @"memo":@"",
                              };
  
    NSDictionary *infoDic1 = @{@"specificationName":@"状态",
                               @"specificationValues":stateStr,
                               @"memo":@"",
                               };
    NSDictionary *infoDic2 = @{@"specificationName":@"颜色",
                               @"specificationValues":colorStr,
                               @"memo":@"",
                               };
    
    NSArray *infoArr = @[[GlobalMethod dictionaryToJson:infoDic],[GlobalMethod dictionaryToJson:infoDic1],[GlobalMethod dictionaryToJson:infoDic2]];
    NSDictionary *setDic;
    if (_ProIdStr) {
        setDic  = @{@"completeSpecificationList":[NSString stringWithFormat:@"[%@,%@,%@]",infoArr[0],infoArr[1],infoArr[2]],@"productId":_ProIdStr};

    }else{
        setDic  = @{@"completeSpecificationList":[NSString stringWithFormat:@"[%@,%@,%@]",infoArr[0],infoArr[1],infoArr[2]]};

    }
    
    [PublishGoodsPL batchspecificationWithInfoDic:setDic ReturnBlock:^(id returnValue) {
        NSLog(@"%@",returnValue);
        NSDictionary *AllDic = returnValue[@"data"];
        NSArray *completeSpecificationList = AllDic[@"completeSpecificationList"];
        NSArray *arr = [CompleteSpecificationModel  mj_objectArrayWithKeyValuesArray:completeSpecificationList];
        NSLog(@"%@",arr);
        NSMutableArray *specificationValueIds = [NSMutableArray arrayWithCapacity:0];
        CompleteSpecificationModel *model0 = arr[0];
        CompleteSpecificationModel *model1 = arr[1];
        CompleteSpecificationModel *model2 = arr[2];
        
        
        for (int i = 0; i<self.dataModel.dataArr.count; i++)
        {
            BatchModel *model = self.dataModel.dataArr[i];
            NSArray *unitArr = [model.kind componentsSeparatedByString:@","];
            NSString *kindId = @"";
            NSString *stateId = @"";
            NSString *colorId = @"";

            for (SpecificationModel *specificatioModel in model0.specificationValueList) {
                if ([unitArr[0] isEqualToString:specificatioModel.name]) {
                    kindId = specificatioModel.kindId;
                }
            }
           
            for (SpecificationModel *specificatioModel in model1.specificationValueList) {
                if ([unitArr[1] isEqualToString:specificatioModel.name]) {
                    stateId = specificatioModel.kindId;
                }
            }
            for (SpecificationModel *specificatioModel in model2.specificationValueList) {
                if ([unitArr[2]  isEqualToString:specificatioModel.name]) {
                    colorId = specificatioModel.kindId;
                }
            }
            NSDictionary *goodDic = @{@"specificationValueIds":[NSString stringWithFormat:@"%@,%@,%@",kindId,stateId,colorId],
                                      @"price":model.price,
                                      @"stock":model.stock,
                                      @"minBuyQuantity":model.mineBuy,
                                      @"limitUserTotalBuyQuantity":model.limitBuy,
                                      @"mainImageUrl":model.minePictureStr
                                      };
            [specificationValueIds addObject:[GlobalMethod dictionaryToJson:goodDic]];
            
        }
        //加入样卡样布属性
        
        NSMutableArray *outArr = [self.dataModel.kindArr mutableCopy];
        NSMutableArray* resultArr = [NSMutableArray array];
        
        if ([outArr containsObject:@"大货"]) {
            [outArr removeObject:@"大货"];
        }
        [_needResultArr removeAllObjects];
        NSMutableArray* result = [NSMutableArray array];
        NSMutableArray* array_data = [NSMutableArray arrayWithObjects:
                                      outArr,
                                      self.dataModel.statusArr,
                                      colorArr,
                                      nil];
        
        [self combine:result data:array_data curr:0 count:(int)array_data.count];
        
        for (NSArray *kind in _needResultArr)
        {
            if ([kind[0] isEqualToString:@"样卡"]) {
                BatchModel *model = [[BatchModel alloc]init];
                model.price = self.cardView.cardModel.price;
                model.stock = self.cardView.cardModel.stock;
                model.limitBuy = self.cardView.cardModel.limitBuy;
                
                model.isOn = YES;
                model.pictureArr = self.dataModel.photoArr;
                model.kind = [kind componentsJoinedByString:@","];
                [resultArr addObject:model];
            }else if ([kind[0] isEqualToString:@"样布"]){
                BatchModel *model = [[BatchModel alloc]init];
                model.price = self.colthView.clothModel.price;
                model.stock = self.colthView.clothModel.stock;
                model.isOn = YES;
                model.pictureArr = self.dataModel.photoArr;
                model.kind = [kind componentsJoinedByString:@","];
                [resultArr addObject:model];
                
            }
            
            
        }
        for (int i = 0; i<resultArr.count; i++)
        {
            BatchModel *model =resultArr[i];
            NSArray *unitArr = [model.kind componentsSeparatedByString:@","];
            NSString *kindId = @"";
            NSString *stateId = @"";
            NSString *colorId = @"";

            for (SpecificationModel *specificatioModel in model0.specificationValueList) {
                if ([unitArr[0] isEqualToString:specificatioModel.name]) {
                    kindId = specificatioModel.kindId;
                }
            }
            for (SpecificationModel *specificatioModel in model1.specificationValueList) {
                if ([unitArr[1] isEqualToString:specificatioModel.name]) {
                    stateId = specificatioModel.kindId;
                }
            }
            for (SpecificationModel *specificatioModel in model2.specificationValueList) {
                if ([unitArr[2]  isEqualToString:specificatioModel.name]) {
                    colorId = specificatioModel.kindId;
                }
            }
           
            NSDictionary *goodDic = @{@"specificationValueIds":[NSString stringWithFormat:@"%@,%@,%@",kindId,stateId,colorId],
                                      @"price":model.price,
                                      @"stock":model.stock,
                                      @"minBuyQuantity":model.mineBuy,
                                      @"limitUserTotalBuyQuantity":model.limitBuy,
                                      @"mainImageUrl":model.minePictureStr
                                      };
            [specificationValueIds addObject:[GlobalMethod dictionaryToJson:goodDic]];
            
        }
        
        
        
        NSString *goodStr = [specificationValueIds componentsJoinedByString:@","];
        NSString *specificationIds = [NSString stringWithFormat:@"%@,%@,%@",model0.specification.kindId,model1.specification.kindId,model2.specification.kindId];
        NSLog(@"%@====%@",goodStr,specificationIds);
        NSDictionary *returndic = @{@"goodStr":goodStr,
                                    @"specificationIds":specificationIds,
                                    
                                    };
        self.dataModel.editType = 2;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"newUserHavesetupGoodsList" object:returndic];
        [self.navigationController popViewControllerAnimated:YES];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        
    }];
}

- (BOOL)makesureAllDatas{
    if (_IsHaVeSampleCard) {
        //样卡
        if (!self.dataModel.cardModel.price||!self.dataModel.cardModel.stock||!self.dataModel.cardModel.limitBuy) {
            [self showTextHud:@"请将样卡数据填写完整"];
            return NO;
        }
    }
    if (_IsHaVeSampleCloth) {
        //样布
        if (!self.dataModel.colthModel.price||!self.dataModel.colthModel.stock) {
            [self showTextHud:@"请将样布数据填写完整"];
            return NO;
        }
    }
    NSMutableArray *onArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (BatchModel *model in self.dataModel.dataArr) {
        if (model.isOn) {
            [onArr addObject:model];
        }
    }
    
    for (int i = 0; i<onArr.count; i++) {
        BatchModel *model = onArr[i];
        if (!model.stock||!model.price||!model.mineBuy||model.stock.length<=0||model.price.length<=0||model.mineBuy.length<=0) {
            [self showTextHud:[NSString stringWithFormat:@"请将%@数据填写完整",model.kind]];
            return NO;
        }
    }
    if (self.fabView.kindTitleArr<=0||self.fabView.colorTitleArr<=0||self.fabView.statusTitleArr<=0) {
        [self showTextHud:@"每样规格至少选择一种"];
        return NO;
    }
    
    return YES;
    
}
/**
 返回按钮
 */
//-(void)respondToLeftButtonClickEvent{
//
//
//
//}


#pragma mark ==========  View的代理

-(void)DidSelectedFabricProUnitViewOutPutBtn:(NSMutableArray *)kindTitleArr andstatusTitleArr:(NSMutableArray *)statusTitleArr andcolorTitleArr:(NSMutableArray *)colorTitleArr andType:(NSInteger)type{
    
    [self setDataWithkindTitleArr:kindTitleArr andstatusTitleArr:statusTitleArr andcolorTitleArr:colorTitleArr];
    
}

- (void)UserHaveSelectedColor:(NSNotification *)noti{
    NSMutableArray  *colorArr = [NSMutableArray arrayWithCapacity:0];
    for (ColorModel *model in self.fabView.colorTitleArr) {
        if (model.IsSelected) {
            [colorArr addObject:model];
        }
    }
    if (self.dataModel.editType == 2||self.dataModel.editType == 3) {
        self.dataModel.editType = 3;
    }else{
        self.dataModel.editType = 1;     
    }
    [self setDataWithkindTitleArr:self.fabView.kindTitleArr andstatusTitleArr:self.fabView.statusTitleArr andcolorTitleArr:colorArr];
    
}


- (void)setDataWithkindTitleArr:(NSMutableArray *)kindTitleArr andstatusTitleArr:(NSMutableArray *)statusTitleArr andcolorTitleArr:(NSMutableArray *)colorTitleArr{
    self.dataModel.kindArr = kindTitleArr;      //str
    self.dataModel.statusArr = statusTitleArr;  //str
    self.dataModel.colorArr = colorTitleArr;    //里面是模板
    
    if (kindTitleArr.count<=0||statusTitleArr.count<=0||![kindTitleArr containsObject:@"大货"]||colorTitleArr.count<=0) {
        for (BatchModel *baModel in self.dataModel.dataArr) {
            baModel.isOn = NO;
        }
        self.batchView.dataArr =self.dataModel.dataArr;
        _IsHaVeSBat = NO;
    }else{
        _IsHaVeSBat = YES;
        
    }
    if (![kindTitleArr containsObject:@"样卡"]||colorTitleArr.count<=0) {
        _IsHaVeSampleCard = NO;
    }else{
        _IsHaVeSampleCard = YES;
    }
    if (![kindTitleArr containsObject:@"样布"]||colorTitleArr.count<=0) {
        _IsHaVeSampleCloth = NO;
    }else{
        _IsHaVeSampleCloth = YES ;
    }
    
    if (colorTitleArr.count>0&&statusTitleArr.count>0&&[kindTitleArr containsObject:@"大货"])
    {
        NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:0];
        for (ColorModel *model in colorTitleArr) {
            [colorArr addObject:model.colorName];
        }
        [_needResultArr removeAllObjects];
        NSMutableArray* result = [NSMutableArray array];
        NSMutableArray* array_data = [NSMutableArray arrayWithObjects:
                                      [NSMutableArray arrayWithObject:@"大货"],
                                      statusTitleArr,
                                      colorArr,
                                      nil];
        
        [self combine:result data:array_data curr:0 count:(int)array_data.count];
        NSLog(@"%@",result);
        NSMutableArray *selectedKindArr = [NSMutableArray arrayWithCapacity:0];
        for (BatchModel *model in self.dataModel.dataArr)
        {
            [selectedKindArr addObject:model.kind];
        }
        for (NSArray *kind in _needResultArr)
        {
            if (![selectedKindArr containsObject:[kind componentsJoinedByString:@","]]) {
                BatchModel *model = [[BatchModel alloc]init];
                model.isOn = YES;
                model.type = 0;
                model.pictureArr = self.dataModel.photoArr;
                model.kind = [kind componentsJoinedByString:@","];
                [self.dataModel.dataArr addObject:model];
            }
        }
        
        //设置显示data
        for (BatchModel *model in self.dataModel.dataArr) {
            NSString *kind = [model.kind componentsSeparatedByString:@","][0];
            NSString *status = [model.kind componentsSeparatedByString:@","][1];
            NSString *color = [model.kind componentsSeparatedByString:@","][2];
            
            if (![colorArr containsObject:color]||![kindTitleArr containsObject:kind]||![statusTitleArr containsObject:status]) {
                model.isOn = NO;
            }else{
                model.isOn = YES;
            }
            
        }
        
        self.batchView.dataArr =self.dataModel.dataArr;
        
        
        
    }
    
    
    [self refreshHeight];
}

#pragma mark ===== 设置返回按钮点击效果
- (void)UserHaveChangeData{
    
    
    if (self.dataModel.editType == 2) {
        self.dataModel.editType = 3;
    }
}

-(void)respondToLeftButtonClickEvent{
    if (self.dataModel.editType ==3) {
        return;
    }else if (self.dataModel.editType ==0){
        self.dataModel.editType =1;
    }
    [self.navigationController popViewControllerAnimated:YES];
    
}
#pragma mark ===== 批量设置

- (void)batchBtnClick{
    
    [self.mybatchView showinView:self.view];
    
}

- (void)sureBtnClick{
    
    for (BatchModel *model in self.dataModel.dataArr) {
        if (self.mybatchView.stocktxt.text.length>0) {
            model.stock = self.mybatchView.stocktxt.text;

        }
        if (self.mybatchView.pricetxt.text.length>0) {
            model.price = self.mybatchView.pricetxt.text;
            
        }
        if (self.mybatchView.mintxt.text.length>0) {
            model.mineBuy = self.mybatchView.mintxt.text;
            
        }
    }
    if (self.dataModel.editType == 2) {
        self.dataModel.editType = 3;
    }
    self.batchView.dataArr =self.dataModel.dataArr;

    [self.mybatchView dismiss];
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

@end
