//
//  TwoUnitSelectedController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "TwoUnitSelectedController.h"
#import "ParaMeterModel.h"
#import "ParaUnitModel.h"
#import "UnitModelPL.h"
#import "ParaUnitSelectedCell.h"
#import "ComponentModel.h"
#import "ComponentCell.h"
@interface TwoUnitSelectedController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation TwoUnitSelectedController{
    
    NSMutableArray  *_dataArr;
    UITableView *_tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    self.view.backgroundColor = UIColorFromRGB(BGColorValue);
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext: _model.ParaKind];
    self.navigationItem.titleView = titlelab;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self initUI];

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    myView.backgroundColor = [UIColor whiteColor];
    myView.layer.sublayers[0].hidden = YES;
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = YES;
    }
    NSLog(@"%@",myView.layer.sublayers);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(WhiteColorValue);
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
}
- (void)initUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,12, ScreenWidth, ScreenHeight - 64-12) style:UITableViewStylePlain];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}
/**
传入已选择数值

@param model model description
*/
-(void)setModel:(ParaMeterModel *)model
{
    _dataArr = [NSMutableArray arrayWithCapacity:0];
    _model = model;
    NSArray *nameArr = [UnitModelPL returnArrWithUnitName:model.ParaKind];
    for (NSString *nameStr  in nameArr)
    {
        ParaUnitModel *unitModel = [[ParaUnitModel alloc]init];
        unitModel.isSelected  = NO;
        unitModel.unitName = nameStr;
        [_dataArr addObject:unitModel];
    }
    if ([model.ParaKind isEqualToString:@"成分"]) {
        for (ParaUnitModel *unitModel in _dataArr)
        {
            if ([unitModel.unitName isEqualToString:model.componentModel.chenfenArr[_Index][COMPENTUNIT]])
            {
                unitModel.isSelected  = YES;
            }else{
                unitModel.isSelected  = NO;
            }
        }
    }
    else
    {
       
        for (ParaUnitModel *unitModel in _dataArr)
        {
            if ([unitModel.unitName isEqualToString:model.twoUnit])
            {
                unitModel.isSelected  = YES;
            }else{
                unitModel.isSelected  = NO;
            }
        }
    }
    
    [_tableView reloadData];
}
#pragma mark ============ tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *unitCellid = @"unitCellid";
    ParaUnitSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:unitCellid];
    if (!cell) {
        cell = [[ParaUnitSelectedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unitCellid];
    }
    cell.Model = _dataArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    ParaUnitModel *unitModel = _dataArr[indexPath.row];
    unitModel.isSelected  = YES;
    if ([_model.ParaKind isEqualToString:@"成分"]){
        NSMutableDictionary *dic = _model.componentModel.chenfenArr[_Index];
        [dic setValue:unitModel.unitName forKey:COMPENTUNIT];
        
    }else{
      
        _model.twoUnit = unitModel.unitName;
      
        
    }
    [_tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
    
}


@end
