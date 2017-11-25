//
//  CategoryOneViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CategoryOneViewController.h"
#import "KindCell.h"
#import "GoodsLVOneModel.h"
#import "GoodsLvTwoModel.h"
#import "GoodsLvThreeModel.h"
#import "GoodsPL.h"
#import "CategoryTwoViewController.h"

@interface CategoryOneViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong)UITableView *kindTabView;           //分类


@end

@implementation CategoryOneViewController{

    NSMutableArray  *_lvOneArr;
    NSMutableArray  *_lvTwoArr;
    NSMutableArray  *_lvThreeArr;

}

#pragma - mark getter
-(UITableView *)kindTabView{
    
    if (!_kindTabView) {
        _kindTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64) style:UITableViewStylePlain];
//        _kindTabView.bounces = NO;
        _kindTabView.delegate = self;
        _kindTabView.dataSource = self;
        _kindTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _kindTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        
    }
    return _kindTabView;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"类目";
    [self.view addSubview:self.kindTabView];
    [self loadDatas]; 

}

- (void)dealloc{
    
    
    
}

- (void )loadDatas{
    [GoodsPL getFabuGoodsCategorywithReturnBlock:^(id returnValue) {
        NSDictionary *dic = returnValue;
        NSLog(@"%@",dic);
        NSDictionary *lvDic = dic[@"data"];
        NSArray *lvArr = lvDic[@"leveledCategoryList"];
        //        return ;
        _lvOneArr = [GoodsLVOneModel mj_objectArrayWithKeyValuesArray:lvArr[0]];
        _lvTwoArr = [GoodsLvTwoModel mj_objectArrayWithKeyValuesArray:lvArr[1]];
        for (GoodsLvTwoModel *model in _lvTwoArr) {
            model.threeModelArr = [[NSMutableArray alloc]initWithCapacity:0];
        }
        _lvThreeArr  = [GoodsLvThreeModel mj_objectArrayWithKeyValuesArray:lvArr[2]];
        [self.kindTabView reloadData];
        
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
}

#pragma mark ========= tableviewdelegate and datasource


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return _lvOneArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellid = @"kindcell";
    KindCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[KindCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    GoodsLVOneModel*model = _lvOneArr[indexPath.row];
    cell.model = model;
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    GoodsLVOneModel*model = _lvOneArr[indexPath.row];
//    if ([model.name isEqualToString:@"服装服饰"]||[model.name isEqualToString:@"窗帘家纺"]) {
//        [self showTextHud:@"很抱歉该模块暂时不能选择"];
//        return;
//    }

    NSMutableArray *dataArr = [NSMutableArray arrayWithCapacity:0];
    for (GoodsLvTwoModel *twoModel in _lvTwoArr) {
        if ([twoModel.parentId isEqualToString:model.categoryId]) {
            [twoModel.threeModelArr removeAllObjects];
            [dataArr addObject:twoModel];
        }
    }
    
    for (GoodsLvTwoModel *twoModel in dataArr) {
        for (GoodsLvThreeModel *threeModel in _lvThreeArr) {
            if ([threeModel.parentId isEqualToString:twoModel.categoryId]) {
                [twoModel.threeModelArr addObject:threeModel];
            }
        }
    }

    CategoryTwoViewController  *twoVC = [[CategoryTwoViewController alloc]init];
    twoVC.title = model.name;
    twoVC.dataArr = dataArr;
    NSDictionary *selecDic = @{
                               @"name":model.name,
                               @"modelid":model.categoryId
                               };
    [twoVC.selectArr addObject:selecDic];
    [self.navigationController pushViewController:twoVC animated:YES];
}


@end
