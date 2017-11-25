//
//  ComponentViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ComponentViewController.h"
#import "TwoUnitSelectedController.h"
#import "ComponentModel.h"
#import "ParaMeterModel.h"
#import "ComponentCell.h"
@interface ComponentViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation ComponentViewController{
    
      BaseTableView *_tableView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    self.view.backgroundColor = UIColorFromRGB(BGColorValue);
 
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext:@"成分"];
    self.navigationItem.titleView = titlelab;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self initUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    // self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    myView.backgroundColor = [UIColor whiteColor];
    myView.layer.sublayers[0].hidden = YES;
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = YES;
    }
    NSLog(@"%@",myView.layer.sublayers);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.navigationController.navigationBar.hidden = NO;
    [_tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }
    
}

//具体成分选项为 ：棉、亚麻、真丝、尼龙、羊绒、蚕丝、涤纶、兔毛、羊毛、其它。
- (void)initUI{
    UIButton* rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 20)];
    [rightbutton setTitle:@"新增" forState:UIControlStateNormal];
    [rightbutton  setTitleColor:UIColorFromRGB(PLAHColorValue) forState:UIControlStateNormal];
    rightbutton.titleLabel.font = APPFONT(14);
    [rightbutton addTarget:self action:@selector(respondToRightButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    
    self.navigationItem.rightBarButtonItem = right;
    
    _tableView = [[BaseTableView alloc]initWithFrame:CGRectMake(0, 12, ScreenWidth, ScreenHeight - 64-12) style:UITableViewStylePlain];
    _tableView.bounces = NO;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
}


- (void)respondToRightButtonClickEvent{
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@"" forKey:COMPENTVALUE];
    [dic setValue:@"棉" forKey:COMPENTUNIT];
    [_model.componentModel.chenfenArr addObject:dic];
    [_tableView reloadData];
    
}

-(void)setModel:(ParaMeterModel *)model {
    
    _model = model;
    if (model.componentModel.chenfenArr.count<=0) {
        for (int i = 0; i<2; i++) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObject:@"" forKey:COMPENTVALUE];
            [dic setValue:@"棉" forKey:COMPENTUNIT];
            [model.componentModel.chenfenArr addObject:dic];

        }
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _model.componentModel.chenfenArr.count;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *unitCellid = @"unitCellid";
    ComponentCell *cell = [tableView dequeueReusableCellWithIdentifier:unitCellid];
    if (!cell) {
        cell = [[ComponentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:unitCellid];
    }
    [cell setModel:_model andIndex:indexPath.row];
    return cell;
}



@end
