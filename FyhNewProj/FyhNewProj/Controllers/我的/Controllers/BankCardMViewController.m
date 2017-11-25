//
//  BankCardMViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BankCardMViewController.h"
#import "AddBankCardViewController.h"
#import "BankCardPL.h"
#import "BankCardModel.h"
#import "BankCardMTableViewCell.h"
#import "CancleCardViewController.h"

@interface BankCardMViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) NSMutableArray *dataArr;

@property (nonatomic , strong) UITableView *CardListTableView;

@end

@implementation BankCardMViewController

-(NSMutableArray *)dataArr{

    if (!_dataArr) {
        _dataArr = [[NSMutableArray alloc]initWithCapacity:0];
    }
    return _dataArr;
}


-(UITableView *)CardListTableView{

    if (!_CardListTableView) {
        _CardListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _CardListTableView.delegate = self;
        _CardListTableView.dataSource = self;
        _CardListTableView.backgroundColor = UIColorFromRGB(0x393d42);
        _CardListTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_CardListTableView];
    }

    return _CardListTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
     //顶部导航栏
    [self setNavTitle];
    self.view.backgroundColor = UIColorFromRGB(0x393d42);
    
  
    
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    myView.backgroundColor =  UIColorFromRGB(0x282c32);
    myView.layer.sublayers[0].hidden = YES;
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = YES;
    }
    NSLog(@"%@",myView.layer.sublayers);
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(0x282c32)];

    self.navigationController.navigationBar.hidden = NO;
    
    if (_dataArr.count >0) {
        [self loadBankCard];
    }
  [self loadBankCard];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(WhiteColorValue)];
    
    
}


- (void)setNavTitle{
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(17) textAligment:NSTextAlignmentCenter andtext:@"银行卡管理"];
    self.navigationItem.titleView = titlelab;
    
    UIImage *image = [UIImage imageNamed:@"Ass-add"];
    if (!image) return ;
    CGFloat imgHeight = 24;
    YLButton *button = [[YLButton alloc] initWithFrame:CGRectMake(0, 0, 40, imgHeight)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightbuttonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [button setImageRect:CGRectMake(15, 4, 15, 15)];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = item;

    
    
}
- (void)rightbuttonClickEvent{
    AddBankCardViewController  *addVc = [[AddBankCardViewController  alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];


}

#pragma mark ====  加载银行卡数据

- (void)loadBankCard{
[BankCardPL userGetBankCardWithReturnBlock:^(id returnValue) {
    NSLog(@"银行卡信息%@",returnValue);
    NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in returnValue[@"bankCardList"]) {
        if (![dic[@"isFromCertification"] boolValue]) {
            [arr addObject:dic];
        }
    }
    _dataArr = [BankCardModel mj_objectArrayWithKeyValuesArray:arr];
    
   // NSLog(@"银行卡信息%@",_dataArr);
    [self.CardListTableView reloadData];
    
} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];
}];


}

#pragma mark ===== tableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (indexPath.row == 0) {
        return 126;
    }else{
        return 122;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

static NSString *cellid = @"cardlist";
    BankCardMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[BankCardMTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model = _dataArr[indexPath.row];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{


    BankCardModel *model = _dataArr[indexPath.row];
    CancleCardViewController *canVc = [[CancleCardViewController alloc]init];
    canVc.model = model;
    [self.navigationController  pushViewController:canVc animated:YES];

}





@end
