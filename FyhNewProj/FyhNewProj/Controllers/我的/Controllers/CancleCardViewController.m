//
//  CancleCardViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/14.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CancleCardViewController.h"
#import "BankCardMTableViewCell.h"
#import "BankCardPL.h"
#import "BankCardModel.h"
@interface CancleCardViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic , strong) UITableView *CardListTableView;

@end

@implementation CancleCardViewController
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
    [self.CardListTableView reloadData];
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
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"解绑" forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightbuttonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = choiceCityBtn;
    
    
    
}

- (void)rightbuttonClickEvent{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否解除绑定" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [BankCardPL userDeleteHisBankCardWithId:_model.cardId WithReturnBlock:^(id returnValue) {
            [self showTextHud:@"解绑成功"];
            [self.navigationController popViewControllerAnimated:YES];
            
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];


}


#pragma mark ===== tableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 126;

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cardlist";
    BankCardMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[BankCardMTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model = _model;
    return cell;
}



@end
