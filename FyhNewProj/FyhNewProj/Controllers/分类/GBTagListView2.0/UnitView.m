//
//  UnitView.m
//  FyhNewProj
//
//  Created by yh f on 2017/5/24.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "UnitView.h"
#import "GBTagListView.h"
#import "GProductItemModel.h"
#import "UnitModel.h"
#import "GItemModel.h"



#define HORIZONTAL_PADDING 7.0f
#define VERTICAL_PADDING   3.0f
#define LABEL_MARGIN       15.0f
#define BOTTOM_MARGIN      10.0f

#define TOPVIEW_HEIGHT     100.0f
#define DOWNVIEW_HEIGHT    140.0f


@interface UnitView()<UITextFieldDelegate>

@property (nonatomic, strong) UIButton      *backButton;

@property (nonatomic , strong)  UILabel     *priceLab;     //价格

@property (nonatomic , strong)  UILabel     *stocklab;     //库存

@property (nonatomic , strong)  UILabel     *unitlab;      //选择的规格

@property (nonatomic , strong)  UILabel     *minlab;      //选择的规格


@property (nonatomic , strong)  UITextField *numberTxt;    //选择的数量

@property (nonatomic , strong)     UnitModel *unmodel0;

@property (nonatomic , strong)     UnitModel *unmodel1;

@property (nonatomic , strong)     UnitModel *unmodel2;

@property (nonatomic , copy)     NSString      *specificationValueIds;

@property (nonatomic , strong) UIView *topView;

@property (nonatomic , strong) GBTagListView *view1;

@property (nonatomic , strong) GBTagListView *view2;

@property (nonatomic , strong) GBTagListView *view3;

@property (nonatomic , strong)  UILabel     *view1tLab;     //view1titlelab

@property (nonatomic , strong)  UILabel     *view2tLab;     //view2titlelab

@property (nonatomic , strong)  UILabel     *view3tLab;     //view3titlelab

@property (nonatomic , strong) UIView *downView;

@property (nonatomic , strong) UIView *danView;

@end

@implementation UnitView{

    
  
//    UIView  *_View5;
//    UIView  *_View6;
    UIScrollView *_bgscrollView;

    CGFloat _originY;
    
         UIView *_bgView;           //背景View
    UIImageView *_shopLogo;         //店铺logo
          NSString *_idStr;         //根据id查看库存
    NSMutableArray *_btnDataArr1;   //按钮数据1
    NSMutableArray *_btnDataArr2;   //按钮数据2
    NSMutableArray *_btnDataArr3;   //按钮数据3
               int _number;         //购买数量
               int _stok;           //库存数量
               int _minBuy;         //起订量
               int _limBuy;         //限购
               int _buyerHasBoughtQuantityInLimitTotalBuy;         //限购已购买数量
              BOOL _isShow;         //是否展示
    NSString    *_title;
    NSString    *_oldunit;

    NSMutableArray *_selectedUnitArr;

    GProductItemModel *_selectedmodel;
}


-(UIView *)topView{

    if (!_topView) {
        _topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 100) color:UIColorFromRGB(WhiteColorValue)];
            _shopLogo = [[UIImageView alloc]init];
            _shopLogo.backgroundColor = UIColorFromRGB(0xccd1d9);
            [_topView addSubview:_shopLogo];
            _shopLogo.frame = CGRectMake(15, 10, 80, 80);
        
            _priceLab = [BaseViewFactory labelWithFrame:CGRectMake(120, 15, ScreenWidth-160, 18) textColor:UIColorFromRGB(RedColorValue) font:APPFONT(17) textAligment:NSTextAlignmentLeft andtext:@""];
            [_topView addSubview:_priceLab];
        
            _stocklab = [BaseViewFactory labelWithFrame:CGRectMake(120, 42, ScreenWidth-160, 14) textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
            [_topView addSubview:_stocklab];
        
            _unitlab = [BaseViewFactory labelWithFrame:CGRectMake(120, 60, ScreenWidth-160, 14) textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"请选择  尺码"];
            [_topView addSubview:_unitlab];
        
        
            UIButton *closeBtn = [BaseViewFactory  buttonWithWidth:16 imagePath:@"close"];
            [_topView addSubview:closeBtn];
            closeBtn.frame = CGRectMake(ScreenWidth-36, 10, 16, 16);
            [closeBtn addTarget:self action:@selector(closeBtnclick) forControlEvents:UIControlEventTouchUpInside];
        
            UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(10, 99,  ScreenWidth-20, 1) color:UIColorFromRGB(LineColorValue)];
            [_topView addSubview:line1];
    }


    return _topView;
}



-(UIView *)danView{
    if (!_danView) {
        _danView = [[UIView alloc]initWithFrame:CGRectMake(0, 100, ScreenWidth, ScreenHeight - 150 - 140 - 100)];
        _downView.backgroundColor = [UIColor whiteColor];
    
    }
    return _danView;
}
-(UIView *)downView{
    
    if (!_downView) {
            _downView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 150 - 140, ScreenWidth, 140)];
            _downView.backgroundColor = [UIColor whiteColor];
        
            UILabel *buyNumLab = [BaseViewFactory labelWithFrame:CGRectMake(15, 0, 80, 60) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@"购买数量"];
            [_downView addSubview:buyNumLab ];
        
            _minlab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth -250, 15, 100, 30) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
            [_downView addSubview:_minlab];

        
            UIView *bgView = [BaseViewFactory viewWithFrame:CGRectMake(ScreenWidth -140, 15, 125, 30) color:UIColorFromRGB(WhiteColorValue)];
            [_downView addSubview:bgView];
            bgView.layer.cornerRadius = 5;
            bgView.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
            bgView.layer.borderWidth = 1;
        
            UIView *leftLine = [BaseViewFactory viewWithFrame:CGRectMake(37, 5, 1, 20) color:UIColorFromRGB(LineColorValue)];
            [bgView addSubview:leftLine];
            UIView *rightLine = [BaseViewFactory viewWithFrame:CGRectMake(88, 5, 1, 20) color:UIColorFromRGB(LineColorValue)];
            [bgView addSubview:rightLine];
        
            UIView *decreaseLine = [BaseViewFactory viewWithFrame:CGRectMake(13, 14, 12, 2) color:UIColorFromRGB(0xccd1d9)];
            [bgView addSubview:decreaseLine];
            UIButton *decreaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            decreaseBtn.frame = CGRectMake(0, 0, 37, 30);
            [bgView addSubview:decreaseBtn];
        
            UIView *addLine1 = [BaseViewFactory viewWithFrame:CGRectMake(101, 14, 12, 2) color:UIColorFromRGB(0x434a54)];
            [bgView addSubview:addLine1];
            UIView *addLine2 = [BaseViewFactory viewWithFrame:CGRectMake(105.5, 9, 2, 12) color:UIColorFromRGB(0x434a54)];
            [bgView addSubview:addLine2];
        
            UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            addBtn.frame = CGRectMake(88, 0, 37, 30);
            [bgView addSubview:addBtn];
        
        
            [decreaseBtn addTarget:self action:@selector(decreaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
        
        
            _numberTxt = [BaseViewFactory  textFieldWithFrame:CGRectMake(37, 0, 51, 30) font:APPFONT(13) placeholder:@"" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
            _numberTxt.textAlignment = NSTextAlignmentCenter;
            _numberTxt.keyboardType = UIKeyboardTypeNumberPad;
            [bgView addSubview:_numberTxt];
            _numberTxt.text = @"1";
            _number = 1;
        
//            _View6 = [[UIView alloc]init];
//            [_bgscrollView addSubview:_View6];
//            _View6.backgroundColor = [UIColor whiteColor];
            SubBtn *submitBtn = [SubBtn buttonWithtitle:@"确定" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(submitBtnClick) andframe:CGRectMake(0, 90, ScreenWidth, 50)];
            [_downView addSubview:submitBtn];
        
            UIView *line6 = [BaseViewFactory viewWithFrame:CGRectMake(10, 60, ScreenWidth-20, 1) color:UIColorFromRGB(LineColorValue)];
            [_downView addSubview:line6];
    
        UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(10, 0,  ScreenWidth-20, 1) color:UIColorFromRGB(LineColorValue)];
        [_downView addSubview:line1];
    }

    
    return _downView;
}

-(GBTagListView *)view1{
    if (!_view1) {
        _view1 = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 0)];
        _view1.canTouch=YES;
        _view1.signalTagColor=[UIColor whiteColor];

        _view1tLab = [BaseViewFactory labelWithFrame:CGRectMake(15, 0, 100, 38) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
        [_view1 addSubview:_view1tLab];
        
    }
    return _view1;
}
-(GBTagListView *)view2{
    if (!_view2) {
        _view2 = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 0)];
        _view2.canTouch=YES;
        _view2.signalTagColor=[UIColor whiteColor];
        
        _view2tLab = [BaseViewFactory labelWithFrame:CGRectMake(15, 0, 100, 38) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
        [_view2 addSubview:_view2tLab];
        
        UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(10, 0,  ScreenWidth-20, 1) color:UIColorFromRGB(LineColorValue)];
        [_view2 addSubview:line1];

    }
    return _view2;
}
-(GBTagListView *)view3{
    if (!_view3) {
        _view3 = [[GBTagListView alloc]initWithFrame:CGRectMake(0, 80, ScreenWidth, 0)];
        _view3.canTouch=YES;
        _view3.signalTagColor=[UIColor whiteColor];
        
        _view3tLab = [BaseViewFactory labelWithFrame:CGRectMake(15, 0, 100, 38) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@""];
        [_view3 addSubview:_view3tLab];
        
        
        UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(10, 0,  ScreenWidth-20, 1) color:UIColorFromRGB(LineColorValue)];
        [_view3 addSubview:line1];

    }
    return _view3;
}


-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];

        _title = @"";
        _dataArr = [NSMutableArray array];
        _btnDataArr1 = [NSMutableArray array];
        _btnDataArr2 = [NSMutableArray array];
        _btnDataArr3= [NSMutableArray array];
        _selectedUnitArr = [NSMutableArray array];
        [self setUp];
    }
    return self;
    
}
#pragma mark ========= 控件
- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backButton.backgroundColor = [UIColor blackColor];
        _backButton.alpha = 0.3;
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
#pragma mark ========= UI

- (void)setUp{
    [self addSubview:self.backButton];
    
    
    _bgView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 150) color:UIColorFromRGB(WhiteColorValue)];
    [self addSubview:_bgView];
    [_bgView addSubview:self.topView];
    

    _bgscrollView = [[UIScrollView alloc]init];
    _bgscrollView.backgroundColor= UIColorFromRGB(WhiteColorValue);
    [_bgView addSubview:_bgscrollView];
    
    [_bgscrollView addSubview:self.view1];
    [_bgscrollView addSubview:self.view2];
    [_bgscrollView addSubview:self.view3];

    [_bgView addSubview:self.downView];

}


-(void)setType:(NSInteger)type{

    _type = type;
}


- (void)setItemModel:(GItemModel *)ItemModel{//0

    
    
    _ItemModel = ItemModel;
    self.view1.hidden = YES;
    self.view2.hidden = YES;
    self.view3.hidden = YES;
    
    if (_type == 0) {
        
        [self setUIWithItemModel:ItemModel];
        
        return;
    }
    
    self.view1.hidden = NO;
    self.view2.hidden = NO;
    self.view3.hidden = NO;
    self.danView.hidden = YES;
    NSArray *specificationList = ItemModel.specificationList;
    
    for (int i = 0 ; i<specificationList.count; i++) {//1
        NSDictionary *itemDic = specificationList[i];
        
        if (i==0) {
            self.view1.hidden = NO;
            
            _view1tLab.text = itemDic[@"name"];
            NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:0];
            if (_btnDataArr1.count>0) {
                [self.view1 setTagWithTagArray:_btnDataArr1];
                
            }else{
                NSArray * specificationValues = itemDic[@"specificationValues"];
                for (int i = 0; i <specificationValues.count; i++) {
                    
                    NSDictionary *unmodelDic = specificationValues[i];
                    UnitModel  *unmodel0 = [[UnitModel alloc]init];
                    unmodel0.unitId  = unmodelDic[@"id"];
                    unmodel0.accountId = unmodelDic[@"accountId"];
                    unmodel0.specificationId = unmodelDic[@"specificationId"];
                    unmodel0.name = unmodelDic[@"name"];
                    if (i==0) {
                        unmodel0.on = YES;
                        _unmodel0 = unmodel0;
                    }
                    
                    if (![colorArr containsObject:unmodel0.name]) {
                        [colorArr addObject:unmodel0.name];
                        [_btnDataArr1 addObject:unmodel0];
                    }
                }
                [self.view1 setTagWithTagArray:_btnDataArr1];            }
            
        }else if (i== 1){
            self.view2.hidden = NO;

            _view2tLab.text = itemDic[@"name"];
            NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:0];
            if (_btnDataArr2.count>0) {
                [self.view2 setTagWithTagArray:_btnDataArr2];
                
            }else{
                NSArray * specificationValues = itemDic[@"specificationValues"];
                for (int i = 0; i <specificationValues.count; i++) {
                    
                    NSDictionary *unmodelDic = specificationValues[i];
                    UnitModel  *unmodel0 = [[UnitModel alloc]init];
                    unmodel0.unitId  = unmodelDic[@"id"];
                    unmodel0.accountId = unmodelDic[@"accountId"];
                    unmodel0.specificationId = unmodelDic[@"specificationId"];
                    unmodel0.name = unmodelDic[@"name"];
                    if (i==0) {
                        unmodel0.on = YES;
                        _unmodel1 = unmodel0;

                    }

                    if (![colorArr containsObject:unmodel0.name]) {
                        [colorArr addObject:unmodel0.name];
                        [_btnDataArr2 addObject:unmodel0];
                    }
                }
                [self.view2 setTagWithTagArray:_btnDataArr2];            }
            

        
        }else if (i==2){
            self.view3.hidden = NO;
            _view3tLab.text = itemDic[@"name"];
            NSMutableArray *colorArr = [NSMutableArray arrayWithCapacity:0];

            if (_btnDataArr3.count>0) {
                [self.view3 setTagWithTagArray:_btnDataArr3];

            }else{
                NSArray * specificationValues = itemDic[@"specificationValues"];
                for (int i = 0; i <specificationValues.count; i++) {
                    
                    NSDictionary *unmodelDic = specificationValues[i];
                    UnitModel  *unmodel0 = [[UnitModel alloc]init];
                    unmodel0.unitId  = unmodelDic[@"id"];
                    unmodel0.accountId = unmodelDic[@"accountId"];
                    unmodel0.specificationId = unmodelDic[@"specificationId"];
                    unmodel0.name = unmodelDic[@"name"];

                    if (i==0) {
                        unmodel0.on = YES;
                        _unmodel2 = unmodel0;
 
                    }

                    if (![colorArr containsObject:unmodel0.name]) {
                        [colorArr addObject:unmodel0.name];
                        [_btnDataArr3 addObject:unmodel0];
                    }
                }
                [self.view3 setTagWithTagArray:_btnDataArr3];
            }
            
        }
        
    }//1
    self.view1.frame = CGRectMake(0, 0, ScreenWidth, self.view1.height);
    self.view2.frame = CGRectMake(0, self.view1.bottom, ScreenWidth, self.view2.height);
    self.view3.frame = CGRectMake(0, self.view2.bottom, ScreenWidth, self.view3.height);
    _bgscrollView.frame = CGRectMake(0, 100, ScreenWidth, ScreenHeight - 150 - 140 - 100);
    _bgscrollView.contentSize = CGSizeMake(10, self.view1.height+self.view2.height+self.view3.height);
    [self refreshstockAndImageView];
    
    WeakSelf(self);
    [self.view1 setDidselectItemBlock:^(UnitModel *model) {
        if (model.on) {
            _unmodel0 = model;
        }
        [weakself refreshstockAndImageView];
    }];
    [self.view2 setDidselectItemBlock:^(UnitModel *model) {
        if (model.on) {
            _unmodel1 = model;
        }
        [weakself refreshstockAndImageView];

    }];
    [self.view3 setDidselectItemBlock:^(UnitModel *model) {
        if (model.on) {
            _unmodel2 = model;
        }
        [weakself refreshstockAndImageView];

    }];
    
    
}//0


- (void)refreshstockAndImageView{
    NSMutableString *str = [NSMutableString string];
    NSMutableString *str1 = [NSMutableString string];

    if (_unmodel0.unitId) {
        [str appendString:[NSString stringWithFormat:@"%@",_unmodel0.unitId]];
        [str1 appendString:[NSString stringWithFormat:@"%@",_unmodel0.name]];

    }
    if (_unmodel1.unitId ) {
        if (str.length >0) {
            [str appendString:[NSString stringWithFormat:@",%@",_unmodel1.unitId]];
            [str1 appendString:[NSString stringWithFormat:@",%@",_unmodel1.name]];

        }else{
            [str appendString:[NSString stringWithFormat:@"%@",_unmodel1.unitId]];
            [str1 appendString:[NSString stringWithFormat:@"%@",_unmodel1.name]];

        }
    }
    if (_unmodel2.unitId ) {
        if (str.length >0) {
            [str appendString:[NSString stringWithFormat:@",%@",_unmodel2.unitId]];
            [str1 appendString:[NSString stringWithFormat:@",%@",_unmodel2.name]];

        }else{
            [str appendString:[NSString stringWithFormat:@"%@",_unmodel2.unitId]];
            [str1 appendString:[NSString stringWithFormat:@"%@",_unmodel2.name]];

        }
    }
    
    NSString *proStr = str;
    GProductItemModel *promodel;
    for (GProductItemModel *model in _dataArr) {
        if ([model.specificationValueIds isEqualToString:proStr]) {
            if (model) {
                promodel = model;
                _selectedmodel = model;
            }
        }
    }
    _title = promodel.title;
    [_selectedUnitArr removeAllObjects];
    for (UnitModel *unitModel in promodel.specificationValues ) {
        NSDictionary *dic = @{@"name":unitModel.name,
                              };
        [_selectedUnitArr addObject:dic];
    }
    
    
//    _selectedUnitArr = [promodel.specificationValues mutableCopy];
    if (promodel.stock) {
        _stocklab.text = [NSString stringWithFormat:@"库存:%@件",promodel.stock];
        _priceLab.text = [NSString stringWithFormat:@"￥%@元",promodel.price];
        _unitlab.text =str1;
        
        [_shopLogo sd_setImageWithURL:[NSURL URLWithString:promodel.imageUrlList[0]] placeholderImage:[UIImage imageNamed:@"loding"]];
                _stok = [promodel.stock intValue];
    }else{
        _unitlab.text = @"无该规格商品";
        _stocklab.text = @"库存:0件";
        _priceLab.text = @"";
        _shopLogo.image = [UIImage imageNamed:@"loding"];
        _stok = 0;
    }
    
    if (promodel.minBuyQuantity&&![promodel.minBuyQuantity isEqualToString:@"0"]) {
        _minlab.text = [NSString stringWithFormat:@"起订量:%@",promodel.minBuyQuantity];
        _minBuy = [promodel.minBuyQuantity intValue];
        
    }else{
        _minBuy = 0;
       // _minlab.text = @"";
        
    }
    if (promodel.limitUserTotalBuyQuantity&&![promodel.limitUserTotalBuyQuantity isEqualToString:@"0"]) {
        _limBuy = [promodel.limitUserTotalBuyQuantity intValue];
        _minlab.text = [NSString stringWithFormat:@"限购量:%@",promodel.limitUserTotalBuyQuantity];

    }else{
        _limBuy = 1000000000;
     //   _minlab.text = @"";
        
    }
    
    if ([promodel.limitUserTotalBuyQuantity isEqualToString:@"0"]&&[promodel.minBuyQuantity isEqualToString:@"0"]) {
         _minlab.text = @"";
    }
    
    if (promodel.buyerHasBoughtQuantityInLimitTotalBuy) {
        _buyerHasBoughtQuantityInLimitTotalBuy = [promodel.buyerHasBoughtQuantityInLimitTotalBuy intValue];
    }
    
    

}



-(void)setDataArr:(NSMutableArray *)dataArr{
    _dataArr = dataArr;

}



#pragma - mark 按钮点击方法
- (void)closeBtnclick{
    [self dismiss];
}



/**
 减少数量
 */
- (void)decreaseBtnClick{

    _number = [_numberTxt.text intValue];
    if (_number <=1) {
        return;
    }
    _number --;
    _numberTxt.text = [NSString stringWithFormat:@"%d",_number];
}

/**
 增加数量
 */
- (void)addBtnClick{

    _number = [_numberTxt.text intValue];
    _number ++;
    _numberTxt.text = [NSString stringWithFormat:@"%d",_number];


}

/**
 提交
 */
- (void)submitBtnClick{
    if (_stok<=0) {
        [self showTextHud:@"该商品已没有库存"];
        return ;
    }
    
    if (_number > _stok) {
            [self showTextHud:@"数量超出库存"];
            return ;
    }
    if (_number < _minBuy) {
        [self showTextHud:@"购买数量小于起订量"];
        return ;
    }
    if (_number >_limBuy) {
        [self showTextHud:@"购买数量超过限购量"];
        return ;
    }
    
    if (_number > _limBuy - _buyerHasBoughtQuantityInLimitTotalBuy) {
        [self showTextHud:[NSString stringWithFormat:@"该商品限购数量为%d您已经购买了%d件，还能购买%d件",_limBuy,_buyerHasBoughtQuantityInLimitTotalBuy,_limBuy - _buyerHasBoughtQuantityInLimitTotalBuy]];
         return ;
    }
    

    NSDictionary *dic;
    //_unitlab.text = @"无该规格商品";
    if (_type == 0) {
        dic = @{@"goodId":_ItemModel.itemID,
                @"price":_ItemModel.price,
                @"imageUrl":_ItemModel.imageUrlList[0],
                @"unit":_oldunit,
                @"title":_title,
                @"unitArr":@[],
                @"quantity":@(_number)
                };
    }else{
        dic = @{@"goodId":_selectedmodel.ProductItemid,
                @"price":_selectedmodel.price,
                @"imageUrl":_selectedmodel.imageUrlList[0],
                @"unit":_unitlab.text,
                @"title":_title,
                @"unitArr":_selectedUnitArr,
                @"quantity":@(_number)
                };

    }
       _didselectGoodsItemBlock(dic);
    [self dismiss];

}

#pragma - mark textfielddelegate
-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([_numberTxt.text intValue]<=0) {
        _numberTxt.text = @"1";
    }
    _number = [_numberTxt.text intValue];
    return YES;
}



#pragma - mark public method
- (void)showinView:(UIView *)view
{
    if (_isShow) return;
    
    _isShow = YES;
    
    [view addSubview:self];
    _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 150);
   
    
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.frame = CGRectMake(0, ScreenHeight-_bgView.height, ScreenWidth, _bgView.height);

    }];
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
    
    //CGFloat duration = 0.4 * (ScreenWidth - _sideView.frame.origin.x)/_sideView.frame.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, _bgView.height);
        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _backButton.alpha = 0.3;
    }];
}
- (void)showTextHud:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabel.text = msg;
    hud.detailsLabel.font = APPFONT(15);
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    // [hud hide:YES afterDelay:1.5];
    [hud hideAnimated:YES afterDelay:2];
}


- (void)setUIWithItemModel:(GItemModel *)model{
    _unitlab.text = @"已选择";
    _title = model.title;
    if (model.stock) {
        _stocklab.text = [NSString stringWithFormat:@"库存:%@件",model.stock];
        _priceLab.text = [NSString stringWithFormat:@"￥%@元",model.price];
        
        [_shopLogo sd_setImageWithURL:[NSURL URLWithString:model.imageUrlList[0]] placeholderImage:[UIImage imageNamed:@"loding"]];
        _stok = [model.stock intValue];
    }else{
        _unitlab.text = @"无该规格商品";
        _stocklab.text = @"库存:0件";
        _priceLab.text = @"";
        _shopLogo.image = [UIImage imageNamed:@"loding"];
        _stok = 0;
    }
    if ([model.minBuyQuantity intValue]>0) {
        _minlab.text = [NSString stringWithFormat:@"起订量:%@",model.minBuyQuantity];
        _minBuy = [model.minBuyQuantity intValue];
        
    }else{
        _minBuy = 0;
        
    }
    if ([model.limitUserTotalBuyQuantity intValue]>0) {
        _limBuy = [model.limitUserTotalBuyQuantity intValue];
        _minlab.text = [NSString stringWithFormat:@"限购量:%@",model.limitUserTotalBuyQuantity];
        
    }else{
        _limBuy = 1000000000;
        
    }
    if (model.buyerHasBoughtQuantityInLimitTotalBuy) {
        _buyerHasBoughtQuantityInLimitTotalBuy = [model.buyerHasBoughtQuantityInLimitTotalBuy intValue];
    }

    
    [_bgView addSubview:self.danView];
    
    
    
    UIButton*tagBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    tagBtn.frame=CGRectZero;
    tagBtn.userInteractionEnabled=NO;
    [tagBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    tagBtn.backgroundColor=UIColorFromRGB(RedColorValue);
    tagBtn.titleLabel.font=[UIFont boldSystemFontOfSize:12];
    //  [tagBtn addTarget:self action:@selector(tagBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *proDic = model.product;
    NSArray *arr;
    if (proDic) {
       arr  = [model.title componentsSeparatedByString:proDic[@"name"]];

    }
    
    if (arr.count >0) {
        [tagBtn setTitle:[NSString stringWithFormat:@"状态：%@",arr[1]] forState:UIControlStateNormal];
        _oldunit  = arr[1];
       
    }

    tagBtn.layer.cornerRadius = 10;
    tagBtn.clipsToBounds=YES;
    NSDictionary *attrs = @{NSFontAttributeName : [UIFont boldSystemFontOfSize:12]};
    CGSize Size_str=[[NSString stringWithFormat:@"状态：%@",_oldunit] sizeWithAttributes:attrs];
    
    Size_str.width += HORIZONTAL_PADDING*3;
    Size_str.height = 30;
    
    CGRect newRect = CGRectZero;
    CGRect previousFrame = CGRectZero;
    previousFrame.origin.y = 34;
    if (previousFrame.origin.x + previousFrame.size.width + Size_str.width + LABEL_MARGIN > self.bounds.size.width) {
        
        newRect.origin = CGPointMake(15, previousFrame.origin.y + Size_str.height + BOTTOM_MARGIN);
    }
    else {
        newRect.origin = CGPointMake(previousFrame.origin.x + previousFrame.size.width + LABEL_MARGIN, previousFrame.origin.y);
        
    }
    newRect.size = Size_str;
    [tagBtn setFrame:newRect];
    previousFrame=tagBtn.frame;
    [self.danView addSubview:tagBtn];
    

}


@end
