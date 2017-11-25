//
//  CardTypeViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/21.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CardTypeViewController.h"
#import "ColorSelectedCell.h"
#import "BussModel.h"
#import "ColorModel.h"

@interface CardTypeViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation CardTypeViewController{
    
    UITableView *_colorTableView;
    NSMutableArray  *_dataArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    self.view.backgroundColor = UIColorFromRGB(BGColorValue);
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext:@"证件类型"];
    self.navigationItem.titleView = titlelab;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:0];
    }
    
    
    NSArray *arr = @[@"身份证",@"护照"];
    for ( int i = 0; i<2; i++) {
        ColorModel *model = [[ColorModel alloc]init];
        model.colorName = arr[i];
        [_dataArr addObject:model];
    }
    if (_model.legalPersonIdentificationType) {
        if ([_model.legalPersonIdentificationType isEqualToString:@"idCard"]) {
            ColorModel *model = _dataArr[0];
            model.IsSelected = YES;
        }else if ([_model.legalPersonIdentificationType isEqualToString:@"passport"]){
            ColorModel *model = _dataArr[1];
            model.IsSelected = YES;
        }
    }else{
        _model.legalPersonIdentificationType = @"idCard";
        ColorModel *model = _dataArr[0];
        model.IsSelected = YES;
    }
  
    [self initUI];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    myView.backgroundColor = [UIColor whiteColor];
    myView.layer.sublayers[0].hidden = YES;
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = YES;
    }
    NSLog(@"%@",myView.layer.sublayers);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.navigationController.navigationBar.hidden = NO;
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
    

    _colorTableView = [[UITableView alloc]initWithFrame:CGRectMake(0,12, ScreenWidth, ScreenHeight-NaviHeight64-12) style:UITableViewStylePlain];
    _colorTableView.delegate = self;
    _colorTableView.dataSource = self;
    _colorTableView.backgroundColor = UIColorFromRGB(BGColorValue);
    _colorTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_colorTableView];
    
    
    
}

#pragma mark ========= tableviewdelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count ;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 48;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *colorCeillid = @"colorCeillid";
    ColorSelectedCell *cell = [tableView dequeueReusableCellWithIdentifier:colorCeillid ];
    if (!cell) {
        cell = [[ColorSelectedCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:colorCeillid];
    }
    cell.Model = _dataArr[indexPath.row];
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    for ( ColorModel *model in _dataArr) {
        model.IsSelected  = NO;
    }
    ColorModel *model = _dataArr[indexPath.row];
    model.IsSelected =YES;
    if (indexPath.row == 0) {
        _model.legalPersonIdentificationType = @"idCard";

    }else{
        _model.legalPersonIdentificationType = @"passport";

    }
    [_colorTableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
