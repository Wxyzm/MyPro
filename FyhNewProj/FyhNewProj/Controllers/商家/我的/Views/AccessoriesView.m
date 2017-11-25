//
//  AccessoriesView.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AccessoriesView.h"
#import "UnitModel.h"
#import "TagLIstButtonView.h"
#import "UnitCell.h"

@interface AccessoriesView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSMutableArray *typeArr;

@property (nonatomic , strong) NSMutableArray *statusArr;


@end

@implementation AccessoriesView{
    
    UIView   *_goodsUnitView;           //商品规格
    UIView    *_line1;
    UIView    *_line2;
    UITableView  *_unitTableview;
    NSMutableArray *_kindnameArr;
    //    NSMutableArray *_unitrr;
    UILabel  *lab2;                 //类型
}


#pragma - mark setter
-(void)setKindArr:(NSMutableArray *)kindArr{
    
    _kindArr = kindArr;
    
    [_kindView setTagWithTagArray:kindArr];
    [self refreshViewFrame];
}

- (void)setUnitArr:(NSMutableArray *)unitArr{
    
    _unitArr = unitArr;
    [_unitTableview reloadData];
    [self refreshViewFrame];
}

-(void)setItemIsEditComplete:(BOOL)itemIsEditComplete{
    _itemIsEditComplete = itemIsEditComplete;
    _kindView.canTouch = NO;
    _quanView.canTouch = NO;
    _leixinView.canTouch = NO;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = UIColorFromRGB(LineColorValue);
        _outPutArr = [NSMutableArray arrayWithCapacity:0];
        _outPutArr1 = [NSMutableArray arrayWithCapacity:0];
        _outPutArr2 = [NSMutableArray arrayWithCapacity:0];
        [self setUp];
    }
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        self.backgroundColor = UIColorFromRGB(LineColorValue);
        _outPutArr = [NSMutableArray arrayWithCapacity:0];
        _outPutArr1 = [NSMutableArray arrayWithCapacity:0];
        _outPutArr2 = [NSMutableArray arrayWithCapacity:0];
        [self setUp];
    }
    return self;
}

- (void)setUp{
    
    CGFloat _OrginY = 0;
    //商品规格
    UILabel  *lab1 = [BaseViewFactory labelWithFrame:CGRectMake(15, _OrginY, 200, 39) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"商品规格"];
    [self addSubview:lab1];
    _OrginY +=39;
    
    UILabel  *leixinlab = [BaseViewFactory labelWithFrame:CGRectMake(0, 40, 67, 50) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"类型"];
    leixinlab.backgroundColor = UIColorFromRGB(WhiteColorValue);

    [self addSubview:leixinlab];
    
   _leixinView = [[TagLIstButtonView alloc]initWithFrame:CGRectMake(68, 40, ScreenWidth - 68, 0)];
    _leixinView.canTouch=YES;
    _leixinView.type = 3;
    _leixinView.signalTagColor=[UIColor whiteColor];
    [self addSubview:_leixinView];
    
    NSMutableArray *leixinViewArr = [NSMutableArray arrayWithObjects:@"零售",@"批发", nil];
    _typeArr= [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<leixinViewArr.count; i++) {
        UnitModel  *model = [[UnitModel alloc]init];
        model.name = leixinViewArr[i];
        model.originId = 1000+i;
        [_typeArr addObject:model];
    }
    
    [_leixinView setTagWithTagArray:_typeArr];
    
    _kindnameArr = [NSMutableArray arrayWithObjects:@"多色/定制",@"自定义", nil];
    NSMutableArray *kindArr = [[NSMutableArray alloc]initWithCapacity:0];
    for (int i = 0; i<_kindnameArr.count; i++) {
        UnitModel  *model = [[UnitModel alloc]init];
        model.name = _kindnameArr[i];
        model.originId = 1000+i;
        [kindArr addObject:model];
    }
    //创意设计
    
    _kindView = [[TagLIstButtonView alloc]initWithFrame:CGRectMake(68, 90, ScreenWidth - 68, 0)];
    _kindView.canTouch=YES;
    _kindView.type = 0;
    _kindView.signalTagColor=[UIColor whiteColor];
    [self addSubview:_kindView];
    [_kindView setTagWithTagArray:kindArr];
    
   UIView * line1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [_kindView addSubview:line1];
    
    lab2 = [BaseViewFactory labelWithFrame:CGRectMake(0, 91, 67, 49) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"颜色"];
    lab2.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [self addSubview:lab2];
    
    
    
    
    _goodsUnitView = [BaseViewFactory viewWithFrame:CGRectMake(0, _OrginY, ScreenWidth, 0) color:UIColorFromRGB(WhiteColorValue)];
    [self addSubview:_goodsUnitView];
    
    
    UILabel  *lab3 = [BaseViewFactory labelWithFrame:CGRectMake(0, 0.5, 68, 50) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"状态"];
    lab3.backgroundColor = UIColorFromRGB(WhiteColorValue);
    [_goodsUnitView addSubview:lab3];
    
    _line2 = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [_goodsUnitView addSubview:_line2];
    
   _quanView  = [[TagLIstButtonView alloc]initWithFrame:CGRectMake(68, 0, ScreenWidth - 68, 0)];
    _quanView.canTouch=YES;
    _quanView.type = 3;
    _quanView.signalTagColor=[UIColor whiteColor];
    [_goodsUnitView addSubview:_quanView];
    
    NSMutableArray *aaaArr = [NSMutableArray arrayWithObjects:@"现货",@"订制", nil];
    _statusArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<aaaArr.count; i++) {
        UnitModel  *model = [[UnitModel alloc]init];
        model.name = aaaArr[i];
        model.originId = 1000+i;
        [_statusArr addObject:model];
    }
    
    [_quanView setTagWithTagArray:_statusArr];
    
    _line1 = [BaseViewFactory viewWithFrame:CGRectMake(67, 0, 1, 50) color:UIColorFromRGB(LineColorValue)];
    [_goodsUnitView addSubview:_line1];
    _line2 = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
    [_goodsUnitView addSubview:_line2];
    
    
    
    
    UIView *goodlistView = [BaseViewFactory viewWithFrame:CGRectMake(0, 50, ScreenWidth, 12) color:UIColorFromRGB(LineColorValue)];
    [_goodsUnitView addSubview:goodlistView];
    UILabel *goodlistlab = [BaseViewFactory labelWithFrame:CGRectMake(15, 62, 200, 50) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"商品列表"];
    [_goodsUnitView addSubview:goodlistlab];
    
    UIImageView *rightimage = [BaseViewFactory icomWithWidth:9.5 imagePath:@"right"];
    [_goodsUnitView addSubview:rightimage];
    rightimage.frame = CGRectMake(ScreenWidth - 25, 79, 9.5, 16);
    
    _rightLab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth - 125, 62, 100, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@""];
    [_goodsUnitView addSubview:_rightLab];

    
    UIButton *goodslistBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    goodslistBtn.frame =CGRectMake(0, 62, ScreenWidth, 50);
    [_goodsUnitView addSubview:goodslistBtn];
    [goodslistBtn addTarget:self action:@selector(goodslistBtnclick) forControlEvents:UIControlEventTouchUpInside];

    
    UIView *unitView = [BaseViewFactory viewWithFrame:CGRectMake(0, 112, ScreenWidth, 40) color:UIColorFromRGB(LineColorValue)];
    [_goodsUnitView addSubview:unitView];
    UILabel *unitlab = [BaseViewFactory labelWithFrame:CGRectMake(15, 0, 200, 40) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"产品参数"];
    [unitView addSubview:unitlab];
    
    
    [self refreshViewFrame];
    
    
    _unitTableview = [[UITableView alloc]initWithFrame:CGRectMake(0, _goodsUnitView.bottom, ScreenWidth, _unitArr.count * 50-10)];
    _unitTableview.bounces = NO;
    _unitTableview.delegate = self;
    _unitTableview.dataSource = self;
    _unitTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self addSubview:_unitTableview];
    
    WeakSelf(self);
    [_leixinView setDidselectStatusItemBlock:^(UnitModel *model) {
        [weakself refreshViewFrame];
        if (weakself.itemIsEditComplete) {
            
            UIViewController  *CurrentVC = [weakself getCurrentVC];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"编辑商品规格后需要重新编辑商品列表,点击确认后可继续编辑" preferredStyle:UIAlertControllerStyleAlert];
            [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakself.itemIsEditComplete = NO;
                weakself.kindView.canTouch = YES;
                weakself.quanView.canTouch = YES;
                weakself.leixinView.canTouch = YES;

                if ([weakself.delegate respondsToSelector:@selector(didSelectedAccessoriesViewRemoveListArrBtn)]) {
                    [weakself.delegate didSelectedAccessoriesViewRemoveListArrBtn];
                }

                [weakself refreshViewFrame];
                model.on= !model.on;
                [weakself.kindView setTagWithTagArray:weakself.kindArr];
                [weakself.leixinView setTagWithTagArray:weakself.typeArr];
                [weakself refreshViewFrame];
                if (model.on) {
                    if (![weakself.outPutArr containsObject:model]) {
                        [weakself.outPutArr addObject:model];
                    }
                }else{
                    if ([weakself.outPutArr containsObject:model]) {
                        [weakself.outPutArr removeObject:model];
                    }
                }
                
            }]];
            [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself.kindView setTagWithTagArray:weakself.kindArr];
                [weakself refreshViewFrame];
                
            }]];
            [CurrentVC presentViewController:alert animated:YES completion:nil];
            
        }else{
            if (model.on) {
                if (![weakself.outPutArr containsObject:model]) {
                    [weakself.outPutArr addObject:model];
                }
            }else{
                if ([weakself.outPutArr containsObject:model]) {
                    [weakself.outPutArr removeObject:model];
                }
            }
            
        }

    }];
    //点击了按钮
    [_kindView setDidselectStatusItemBlock:^(UnitModel *model) {
        [weakself refreshViewFrame];
        if (weakself.itemIsEditComplete) {
            
            UIViewController  *CurrentVC = [weakself getCurrentVC];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"编辑商品规格后需要重新编辑商品列表,点击确认后可继续编辑" preferredStyle:UIAlertControllerStyleAlert];
            [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakself.itemIsEditComplete = NO;
                weakself.kindView.canTouch = YES;
                weakself.quanView.canTouch = YES;
                weakself.leixinView.canTouch = YES;

                if ([weakself.delegate respondsToSelector:@selector(didSelectedAccessoriesViewRemoveListArrBtn)]) {
                    [weakself.delegate didSelectedAccessoriesViewRemoveListArrBtn];
                }
                
                [weakself refreshViewFrame];
                if (model.originId !=1002) {
                    model.on= !model.on;
                    [weakself.kindView setTagWithTagArray:weakself.kindArr];
                    [weakself refreshViewFrame];
                    if (model.on) {
                        if (![weakself.outPutArr1 containsObject:model]) {
                            [weakself.outPutArr1 addObject:model];
                        }
                    }else{
                        if ([weakself.outPutArr1 containsObject:model]) {
                            [weakself.outPutArr1 removeObject:model];
                        }
                    }
                    
                }else{
                    if ([weakself.delegate respondsToSelector:@selector(didSelectedAccessoriesViewAddBtnwithType:)]) {
                        [weakself.delegate didSelectedAccessoriesViewAddBtnwithType:1];
                    }
                }
            }]];
            [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself.kindView setTagWithTagArray:weakself.kindArr];
                [weakself refreshViewFrame];
                
            }]];
            [CurrentVC presentViewController:alert animated:YES completion:nil];
            
        }else{
            [weakself refreshViewFrame];
            if (model.on) {
                if (![weakself.outPutArr1 containsObject:model]) {
                    [weakself.outPutArr1 addObject:model];
                }
            }else{
                if ([weakself.outPutArr1 containsObject:model]) {
                    [weakself.outPutArr1 removeObject:model];
                }
            }
            if (model.originId == 1002) {
                if ([weakself.delegate respondsToSelector:@selector(didSelectedAccessoriesViewAddBtnwithType:)]) {
                    [weakself.delegate didSelectedAccessoriesViewAddBtnwithType:1];
                }
            }
        }

    }];
    //删除了按钮
    [_kindView setDidDeleteItemBlock:^(UnitModel *model) {
        [weakself refreshViewFrame];
        if (weakself.itemIsEditComplete) {
            
            UIViewController  *CurrentVC = [weakself getCurrentVC];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"编辑商品规格后需要重新编辑商品列表,点击确认后可继续编辑" preferredStyle:UIAlertControllerStyleAlert];
            [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakself.itemIsEditComplete = NO;
                weakself.kindView.canTouch = YES;
                weakself.quanView.canTouch = YES;
                weakself.leixinView.canTouch = YES;

                [weakself.kindArr removeObject:model];
                [weakself.kindView setTagWithTagArray:weakself.kindArr];
                [weakself refreshViewFrame];
                if ([weakself.outPutArr1 containsObject:model]) {
                    [weakself.outPutArr1 removeObject:model];
                }
                if ([weakself.delegate respondsToSelector:@selector(didSelectedAccessoriesViewdeleteBtn)]) {
                    [weakself.delegate didSelectedAccessoriesViewdeleteBtn];
                }
                if ([weakself.delegate respondsToSelector:@selector(didSelectedAccessoriesViewRemoveListArrBtn)]) {
                    [weakself.delegate didSelectedAccessoriesViewRemoveListArrBtn];
                }
            }]];
            [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself.kindView setTagWithTagArray:weakself.kindArr];
                [weakself refreshViewFrame];
                
            }]];
            [CurrentVC presentViewController:alert animated:YES completion:nil];
            
        }else{
            [weakself.kindArr removeObject:model];
            if ([weakself.outPutArr1 containsObject:model]) {
                [weakself.outPutArr1 removeObject:model];
            }
            if ([weakself.delegate respondsToSelector:@selector(didSelectedAccessoriesViewdeleteBtn)]) {
                [weakself.delegate didSelectedAccessoriesViewdeleteBtn];
            }
        }
//        [weakself.kindArr removeObject:model];
//        if ([weakself.outPutArr1 containsObject:model]) {
//            [weakself.outPutArr1 removeObject:model];
//        }
//        if ([weakself.delegate respondsToSelector:@selector(didSelectedAccessoriesViewdeleteBtn)]) {
//            [weakself.delegate didSelectedAccessoriesViewdeleteBtn];
//        }
    }];
    [_quanView setDidselectStatusItemBlock:^(UnitModel *model) {
        [weakself refreshViewFrame];
        if (weakself.itemIsEditComplete) {
            
            UIViewController  *CurrentVC = [weakself getCurrentVC];
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"编辑商品规格后需要重新编辑商品列表,点击确认后可继续编辑" preferredStyle:UIAlertControllerStyleAlert];
            [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                weakself.itemIsEditComplete = NO;
                weakself.kindView.canTouch = YES;
                weakself.quanView.canTouch = YES;
                weakself.leixinView.canTouch = YES;
                if ([weakself.delegate respondsToSelector:@selector(didSelectedAccessoriesViewRemoveListArrBtn)]) {
                    [weakself.delegate didSelectedAccessoriesViewRemoveListArrBtn];
                }
                [weakself refreshViewFrame];
                model.on= !model.on;
                [weakself.kindView setTagWithTagArray:weakself.kindArr];
                [weakself.quanView setTagWithTagArray:weakself.statusArr];

                [weakself refreshViewFrame];
                if (model.on) {
                    if (![weakself.outPutArr2 containsObject:model]) {
                        [weakself.outPutArr2 addObject:model];
                    }
//                    [weakself.outPutArr1 addObject:model];
                }else{
                    if ([weakself.outPutArr2 containsObject:model]) {
                        [weakself.outPutArr2 removeObject:model];
                    }
                }
                
            }]];
            [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [weakself.kindView setTagWithTagArray:weakself.kindArr];
                [weakself refreshViewFrame];
                
            }]];
            [CurrentVC presentViewController:alert animated:YES completion:nil];
            
        }else{
            if (model.on) {
                if (![weakself.outPutArr2 containsObject:model]) {
                    [weakself.outPutArr2 addObject:model];
                }
            }else{
                if ([weakself.outPutArr2 containsObject:model]) {
                    [weakself.outPutArr2 removeObject:model];
                }
            }
            
        }

//        if (model.on) {
//            if (![weakself.outPutArr2 containsObject:model]) {
//                [weakself.outPutArr2 addObject:model];
//            }
//        }else{
//                if ([weakself.outPutArr2 containsObject:model]) {
//                    [weakself.outPutArr2 removeObject:model];
//                }
//        }

    }];
    
    
    
}

/**
点击商品列表
*/
- (void)goodslistBtnclick{
    
    if ([self.delegate respondsToSelector:@selector(didSelectedAccessoriesViewGoodsList)]) {
        [self.delegate didSelectedAccessoriesViewGoodsList];
    }
    
}

- (void)refreshViewFrame{
    
    _kindView.frame = CGRectMake(68, _kindView.top, ScreenWidth - 68, _kindView.height);
    lab2. frame = CGRectMake(0, 91, 67,  _kindView.height-1);
    _goodsUnitView.frame = CGRectMake(0, _kindView.bottom, ScreenWidth, 152);
    _unitTableview.frame = CGRectMake(0, _goodsUnitView.bottom, ScreenWidth, (_unitArr.count+1) * 50-10);
    self.frame = CGRectMake(self.origin.x, 300, ScreenWidth, _unitTableview.bottom);
}

#pragma mark ============= tableviewdelegate  tableviewdatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _unitArr.count+1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _unitArr.count ) {
        return 40;
    }
    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _unitArr.count ) {
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
        cell.attModel = _unitArr[indexPath.row];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == _unitArr.count ) {
        if ([self.delegate respondsToSelector:@selector(didSelectedAccessoriesViewAddBtnwithType:)]) {
            [self.delegate didSelectedAccessoriesViewAddBtnwithType:0];
        }
        
    }
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        // 删除数据源的数据,self.cellData是你自己的数据
        [self.unitArr removeObjectAtIndex:indexPath.row];
        // 删除列表中数据
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self refreshViewFrame];
        if ([self.delegate respondsToSelector:@selector(didSelectedAccessoriesViewdeleteBtn)]) {
            [self.delegate didSelectedAccessoriesViewdeleteBtn];
        }
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";//默认文字为 Delete
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == _unitArr.count) {
        return NO;
    }
    return YES;
}


- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]])
        result = nextResponder;
    else
        result = window.rootViewController;
    
    return result;
}


@end
