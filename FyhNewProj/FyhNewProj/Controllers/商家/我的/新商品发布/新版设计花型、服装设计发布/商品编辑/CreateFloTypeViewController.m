//
//  CreateFloTypeViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/9.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CreateFloTypeViewController.h"
#import "CreateFloTypeView.h"

#import "PublishGoodsPL.h"

#import "ColorModel.h"
#import "BatchModel.h"
#import "SampleColthModel.h"
#import "CreateFlowerModel.h"
#import "CompleteSpecificationModel.h"
#import "SpecificationModel.h"

#import "SampleColth.h"
#import "BatchSetView.h"
#import "BatchView.h"

@interface CreateFloTypeViewController ()<CreateFloTypeViewDelegate>


@property (nonatomic , strong) BaseScrollView      *myscrollView;          //底部scrollView

@property (nonatomic,strong) CreateFloTypeView   *FloTypeView;             //顶部View

@property (nonatomic,strong) SampleColth         *colthView;               //买断

@property (nonatomic,strong) BatchSetView        *batchView;             //批量设置

@property (nonatomic , strong) BatchView          *mybatchView;          //底部scrollView

@end

@implementation CreateFloTypeViewController{
    
    
    CGFloat _originY;
    BOOL _IsHaVeSampleCloth;    //是否有买断
    BOOL _IsHaVeSBat;           //是否有批量设置
    NSMutableArray *_needResultArr;


}

-(BatchView *)mybatchView{
    
    if (!_mybatchView) {
        _mybatchView = [[BatchView alloc]init];
        [_mybatchView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
        _mybatchView.type = 0;
    }
    return _mybatchView;
}

//样布
-(SampleColth *)colthView{
    if (!_colthView) {
        _colthView = [[SampleColth alloc] initWithFrame:CGRectMake(0, 135, ScreenWidth, 104)];
        _colthView.nameLab.text = @"买断";
    }
    return _colthView;
}

//批量设置
-(BatchSetView *)batchView{
    if (!_batchView) {
        _batchView = [[BatchSetView alloc] initWithFrame:CGRectMake(0, 240, ScreenWidth, self.dataModel.dataArr.count *112 +51)];
      [_batchView.batchBtn addTarget:self action:@selector(batchBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _batchView;
}


//scrollView
-(BaseScrollView *)myscrollView{
    
    if (!_myscrollView) {
        _myscrollView = [[BaseScrollView alloc] init];
        _myscrollView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight-64);
        self.myscrollView.backgroundColor = UIColorFromRGB(0xf5f7fa);
    }
    return _myscrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商品列表";
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    [self setBarBackBtnWithImage:nil];
    
    _needResultArr = [NSMutableArray arrayWithCapacity:0];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHaveSelectedColor:)
                                                 name:@"UserHaveSelectedColor"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UserHaveChangeData)
                                                 name:@"UserHaveChangeData"  object:nil];
    id traget = self.navigationController.interactivePopGestureRecognizer.delegate;
    UIPanGestureRecognizer * pan = [[UIPanGestureRecognizer alloc]initWithTarget:traget action:nil];
    [self.view addGestureRecognizer:pan];
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
    _FloTypeView = [[CreateFloTypeView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 105 )];

    _FloTypeView.statusTitleArr = self.dataModel.statusArr;
    _FloTypeView.delegate = self;
    if (self.dataModel.isFirstEdit) {
        if (_TYPE == 2) {
            //服装设计
            NSArray *color =@[@"JPG",@"AI",@"样衣"];
            for (NSString *colorstr in color) {
                ColorModel *model   = [[ColorModel alloc]init];
                model.colorName = colorstr;
                model.IsSelected = YES;
                [self.dataModel.kindArr addObject:model];
            }
        }else{
            //花型设计
            NSArray *color =@[@"JPG",@"AI",@"PSD"];
            for (NSString *colorstr in color) {
                ColorModel *model   = [[ColorModel alloc]init];
                model.colorName = colorstr;
                model.IsSelected = YES;
                [self.dataModel.kindArr addObject:model];
            }
            
        }
        
    }
    _FloTypeView.kindTitleArr = self.dataModel.kindArr;
    [self.myscrollView addSubview:_FloTypeView];
    self.dataModel.isFirstEdit = NO;
    
    //样布
    [self.myscrollView addSubview:self.colthView];
    self.colthView.clothModel = self.dataModel.colthModel;
    if ([self.dataModel.statusArr containsObject:@"买断"]) {
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
    [_FloTypeView refreshKindBtnView];
    _originY +=  _FloTypeView.height_sd;
    
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

- (void)respondToRightButtonClickEvent{
    [self.view endEditing:YES];
    if (![self makesureAllDatas]) {
        return;
    }
    NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:0];
    for (ColorModel *model in self.dataModel.kindArr) {
        if (model.IsSelected) {
            [colorArr addObject:model.colorName];
        }
    }
    
    NSString *colorStr = [colorArr componentsJoinedByString:@","];
    NSString *stateStr = [self.dataModel.statusArr  componentsJoinedByString:@","];
    
    NSDictionary *infoDic1 = @{@"specificationName":@"类型",
                               @"specificationValues":colorStr,
                               @"memo":@"",
                               };
    NSDictionary *infoDic2 = @{@"specificationName":@"状态",
                               @"specificationValues":stateStr,
                               @"memo":@"",
                               };
     NSArray *infoArr = @[[GlobalMethod dictionaryToJson:infoDic1],[GlobalMethod dictionaryToJson:infoDic2]];
    
    NSDictionary *setDic;
    if (_ProIdStr) {
        setDic  = @{@"completeSpecificationList":[NSString stringWithFormat:@"[%@,%@]",infoArr[0],infoArr[1]],@"productId":_ProIdStr};
        
    }else{
        setDic = @{@"completeSpecificationList":[NSString stringWithFormat:@"[%@,%@]",infoArr[0],infoArr[1]]};

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

        for (int i = 0; i<self.dataModel.dataArr.count; i++)
        {
            BatchModel *model = self.dataModel.dataArr[i];
            NSArray *unitArr = [model.kind componentsSeparatedByString:@","];
            NSString *kindId = @"";
            NSString *stateId = @"";
            for (SpecificationModel *specificatioModel in model0.specificationValueList) {
                if ([unitArr[0] isEqualToString:specificatioModel.name]) {
                    kindId = specificatioModel.kindId;
                }
               
            }
            for (SpecificationModel *specificatioModel in model1.specificationValueList) {
                
                if ([unitArr[1]  isEqualToString:specificatioModel.name]) {
                    stateId = specificatioModel.kindId;
                }
            }
            
            NSDictionary *goodDic = @{@"specificationValueIds":[NSString stringWithFormat:@"%@,%@",kindId,stateId],
                                      @"price":model.price,
                                      @"stock":model.stock,
                                      @"minBuyQuantity":model.limitBuy,
                                      @"limitUserTotalBuyQuantity":model.mineBuy,
                                      @"mainImageUrl":model.minePictureStr
                                      };
            [specificationValueIds addObject:[GlobalMethod dictionaryToJson:goodDic]];
            
        }
        
        //加入买断属性
        
        NSMutableArray *outArr = [self.dataModel.statusArr mutableCopy];
        NSMutableArray* resultArr = [NSMutableArray array];
        
        if ([outArr containsObject:@"授权"]) {
            [outArr removeObject:@"授权"];
        }
        [_needResultArr removeAllObjects];
        NSMutableArray* result = [NSMutableArray array];
        NSMutableArray* array_data = [NSMutableArray arrayWithObjects:
                                      colorArr,
                                      outArr,
                                      
                                      nil];
        
        [self combine:result data:array_data curr:0 count:(int)array_data.count];
        
        for (NSArray *kind in _needResultArr)
        {
            if ([kind[1] isEqualToString:@"买断"]){
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
            for (SpecificationModel *specificatioModel in model0.specificationValueList) {
                if ([unitArr[0] isEqualToString:specificatioModel.name]) {
                    kindId = specificatioModel.kindId;
                }
            }
            for (SpecificationModel *specificatioModel in model1.specificationValueList) {
                if ([unitArr[1]  isEqualToString:specificatioModel.name]) {
                    stateId = specificatioModel.kindId;
                }
            }
            
            NSDictionary *goodDic = @{@"specificationValueIds":[NSString stringWithFormat:@"%@,%@",kindId,stateId],
                                      @"price":model.price,
                                      @"stock":model.stock,
                                      @"minBuyQuantity":model.limitBuy,
                                      @"limitUserTotalBuyQuantity":model.mineBuy,
                                      @"mainImageUrl":model.minePictureStr
                                      };
            [specificationValueIds addObject:[GlobalMethod dictionaryToJson:goodDic]];
            
        }
        
        
        
        NSString *goodStr = [specificationValueIds componentsJoinedByString:@","];
        NSString *specificationIds = [NSString stringWithFormat:@"%@,%@",model0.specification.kindId,model1.specification.kindId];
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
    
    if (_IsHaVeSampleCloth) {
        //样布
        if (!self.dataModel.colthModel.price||!self.dataModel.colthModel.stock) {
            [self showTextHud:@"请将买断数据填写完整"];
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
        if (!model.stock||!model.price||model.stock.length<=0||model.price.length<=0) {
            [self showTextHud:[NSString stringWithFormat:@"请将%@数据填写完整",model.kind]];
            return NO;
        }
    }
    if (self.FloTypeView.kindTitleArr<=0||self.FloTypeView.statusTitleArr<=0) {
        [self showTextHud:@"每样规格至少选择一种"];
        return NO;
    }
    return YES;
    
}
#pragma mark ==========  View的代理


-(void)DidSelectedCreateFloTypeProUnitViewOutPutBtn:(NSMutableArray *)kindTitleArr andstatusTitleArr:(NSMutableArray *)statusTitleArr andType:(NSInteger)type{
    
    [self setDataWithkindTitleArr:kindTitleArr andstatusTitleArr:statusTitleArr];
    
}
- (void)UserHaveSelectedColor:(NSNotification *)noti{
    NSMutableArray  *colorArr = [NSMutableArray arrayWithCapacity:0];
    for (ColorModel *model in _FloTypeView.kindTitleArr) {
        if (model.IsSelected) {
            [colorArr addObject:model];
            
        }
    }
    if (self.dataModel.editType == 2||self.dataModel.editType == 3) {
        self.dataModel.editType = 3;
    }else{
        self.dataModel.editType = 1;
    }
    [self setDataWithkindTitleArr:colorArr andstatusTitleArr:_FloTypeView.statusTitleArr];

}


- (void)setDataWithkindTitleArr:(NSMutableArray *)kindTitleArr andstatusTitleArr:(NSMutableArray *)statusTitleArr{
    self.dataModel.kindArr = kindTitleArr;      //str
    self.dataModel.statusArr = statusTitleArr;  //str
    
    if (kindTitleArr.count<=0||![statusTitleArr containsObject:@"授权"]) {
        for (BatchModel *baModel in self.dataModel.dataArr) {
            baModel.isOn = NO;
        }
        self.batchView.dataArr =self.dataModel.dataArr;
        _IsHaVeSBat = NO;
    }else{
        _IsHaVeSBat = YES;
        
    }
    
    if (![statusTitleArr containsObject:@"买断"]||kindTitleArr.count<=0) {
        _IsHaVeSampleCloth = NO;
    }else{
        _IsHaVeSampleCloth = YES ;
    }
    
    if (kindTitleArr.count>0&&statusTitleArr.count>0&&[statusTitleArr containsObject:@"授权"])
    {
        NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:0];
        for (ColorModel *model in kindTitleArr) {
            [colorArr addObject:model.colorName];
        }
        [_needResultArr removeAllObjects];
        NSMutableArray* result = [NSMutableArray array];
        NSMutableArray* array_data = [NSMutableArray arrayWithObjects:
                                      colorArr,
                                      [NSMutableArray arrayWithObject:@"授权"],
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
                model.type = 1;
                model.pictureArr = self.dataModel.photoArr;
                model.kind = [kind componentsJoinedByString:@","];
                [self.dataModel.dataArr addObject:model];
            }
        }
        
        //设置显示data
        for (BatchModel *model in self.dataModel.dataArr) {
            NSString *kind = [model.kind componentsSeparatedByString:@","][0];
            NSString *status = [model.kind componentsSeparatedByString:@","][1];
//            NSString *color = [model.kind componentsSeparatedByString:@","][2];
            
            if (![colorArr containsObject:kind]||![statusTitleArr containsObject:status]) {
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
