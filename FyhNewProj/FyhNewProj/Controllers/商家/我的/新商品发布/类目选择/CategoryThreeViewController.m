//
//  CategoryThreeViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CategoryThreeViewController.h"

#import "KindCell.h"
#import "GoodsLVOneModel.h"
#import "GoodsLvTwoModel.h"
#import "GoodsLvThreeModel.h"
#import "ShopReleaseGoodsController.h"
#import "NewProCreateController.h"

@interface CategoryThreeViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)UITableView *kindTabView;           //分类

@end

@implementation CategoryThreeViewController

#pragma - mark getter
-(UITableView *)kindTabView{
    
    if (!_kindTabView) {
        _kindTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
        //        _kindTabView.bounces = NO;
        _kindTabView.delegate = self;
        _kindTabView.dataSource = self;
        _kindTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _kindTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_kindTabView];
        
    }
    return _kindTabView;
    
}
-(NSMutableArray *)selectArr{
    
    if (!_selectArr) {
        _selectArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _selectArr;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"类目";
    [self setBarBackBtnWithImage:nil];
    [self.kindTabView reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellid = @"kindcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *lineview = [BaseViewFactory viewWithFrame:CGRectMake(0, 49, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [cell.contentView addSubview:lineview];
        
    }
    GoodsLvThreeModel *twomodel = _dataArr[indexPath.row];
    cell.textLabel.text = twomodel.name;
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    GoodsLvThreeModel *twomodel = _dataArr[indexPath.row];
    
       
    UIViewController *target = nil;
    NSDictionary *selecDic = @{
                               @"name":twomodel.name,
                               @"modelid":twomodel.categoryId
                               };
    [self.selectArr addObject:selecDic];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"newUserHaveSelectedCategory" object:self.selectArr];
    
    for (UIViewController * controller in self.navigationController.viewControllers) { //遍历
        if ([controller isKindOfClass:[NewProCreateController class]]) { //这里判断是否为你想要跳转的页面
            target = controller;
        }
    }
    if (target) {
        [self.navigationController popToViewController:target animated:YES]; //跳转
    }
}

@end
