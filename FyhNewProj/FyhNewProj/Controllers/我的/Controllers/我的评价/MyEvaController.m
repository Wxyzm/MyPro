//
//  MyEvaController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyEvaController.h"
#import "EvaModel.h"
#import "MyEvaluateCell.h"
#import "UITableView+SDAutoTableViewCellHeight.h"
@interface MyEvaController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *AllTabView;           //全部

@end

@implementation MyEvaController{

    NSMutableArray *_dataArr;
}

-(UITableView *)AllTabView{
    
    if (!_AllTabView) {
        _AllTabView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth,ScreenHeight-64-39) style:UITableViewStylePlain];
        _AllTabView.bounces = NO;
        _AllTabView.delegate = self;
        _AllTabView.dataSource = self;
        _AllTabView.backgroundColor = UIColorFromRGB(WhiteColorValue);
        _AllTabView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    return _AllTabView;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.navigationItem.title = @"我的评价";
    _dataArr = [NSMutableArray  array];
    NSArray *titleArr = @[@"的撒大大撒所",@"多大事大所大所",@"的撒大所大所大所大所大所多撒大所大所大所多撒多撒奥所多撒",@"广东省国防生的国防生的功夫大使馆发生的股份大概多少个省份官方的说法都是官方十多个梵蒂冈梵蒂冈身高多少发给",@"的撒奥",@"大叔大婶大所大所多多撒撒撒所",@"的撒大撒大多撒撒撒奥",@"的撒大所大撒所大",@"的撒大所大大撒",@"aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa"];
    for (int i = 0; i<titleArr.count; i++) {
        EvaModel *model = [[EvaModel alloc]init];
        model.evaStr = titleArr[i];
        [_dataArr addObject:model];
    }

    [self.view addSubview:self.AllTabView];
    

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.hidden = NO;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
   
    return _dataArr.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    

    return [self.AllTabView cellHeightForIndexPath:indexPath model:_dataArr[indexPath.row] keyPath:@"model" cellClass:[MyEvaluateCell class] contentViewWidth:ScreenWidth];

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    static NSString *cellid = @"ordercell";
    MyEvaluateCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[MyEvaluateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    cell.model = _dataArr[indexPath.row];
    
    [cell useCellFrameCacheWithIndexPath:indexPath tableView:self.AllTabView];

    return cell;
    
}

@end
