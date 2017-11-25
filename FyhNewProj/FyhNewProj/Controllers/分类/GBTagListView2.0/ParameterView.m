//
//  ParameterView.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ParameterView.h"
#import "ParameterCell.h"

@interface ParameterView()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UIButton      *backButton;

@property (nonatomic , strong) UIView *topView;

@property (nonatomic , strong) UITableView *tableView;


@end

@implementation ParameterView{

    UIView *_bgView;           //背景View
    BOOL        _isShow;

    
}

-(UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 50, ScreenWidth, ScreenHeight - 250) style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }

    return _tableView;
}

-(UIView *)topView{
    
    if (!_topView) {
        _topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 50) color:UIColorFromRGB(WhiteColorValue)];
        UILabel *canshuLab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, ScreenWidth, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext:@"产品参数"];
        [_topView addSubview:canshuLab];
        
        UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 49,  ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [_topView addSubview:line1];
        
        
        
    }
    
    
    return _topView;
}

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
#pragma mark ========= init
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
    
}
- (void)setUp{
    [self addSubview:self.backButton];
    _bgView = [BaseViewFactory viewWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight - 150) color:UIColorFromRGB(WhiteColorValue)];
    [self addSubview:_bgView];
    [_bgView addSubview:self.topView];
    [_bgView addSubview:self.tableView];
    SubBtn *comBtn = [SubBtn buttonWithtitle:@"完成" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(comBtnClick) andframe:CGRectMake(0, ScreenHeight - 200, ScreenWidth, 50)];
    [_bgView addSubview:comBtn];
}

- (void)comBtnClick{

    [self dismiss];
}

-(void)setDataArr:(NSArray *)dataArr{
    _dataArr = dataArr;
    [self.tableView reloadData];

}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    return 50;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    ParameterCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[ParameterCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.nameLab.text = dic[@"attributeName"];
    cell.paraLab.text = dic[@"attributeValue"];

    return cell;
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
    hud.label.text = msg;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    // [hud hide:YES afterDelay:1.5];
    [hud hideAnimated:YES afterDelay:1.5];
}


@end
