//
//  BussChoseViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/11.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BussChoseViewController.h"
#import "BussLeiMuCell.h"

@interface BussChoseViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableview;


@end

@implementation BussChoseViewController{

    NSMutableArray *_dataArr;
    NSMutableArray *_selectArr;

}
-(UITableView *)tableview
{
    if (!_tableview) {
        self.tableview = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
        self.tableview.delegate = self;
        self.tableview.backgroundColor = UIColorFromRGB(0xf1f1f1);
        self.tableview.dataSource = self;
        self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:self.tableview];
    }
    return _tableview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"类目选择";
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    _dataArr = [[NSMutableArray alloc]init];
    _selectArr = [[NSMutableArray alloc]init];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40  , 40)];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromRGB(0xc61616) forState:UIControlStateNormal];
    [button addTarget:self action:@selector(quedin) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = rightBarButton;

    [self getCategory];
}

- (void)quedin{
    NSMutableArray * shopCadIdArr = [[NSMutableArray alloc]init];
    for (int i = 0; i<_selectArr.count; i++) {
        NSString *selected = _selectArr[i];
        if ([selected boolValue]) {
            NSDictionary *iddic = _dataArr[i];
            [shopCadIdArr addObject:iddic[@"catId"]];
        }

    }
    if (shopCadIdArr.count<=0) {
        [self showTextHud:@"您未选择任何类目"];
        return;
    }
    NSDictionary *userInfo = @{@"catIdArr": shopCadIdArr};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"BussLeiMuSelected" object:nil userInfo:userInfo];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getCategory{

    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/gateway?api=lv1Category",kbaseUrl]];
    // 2、 创建请求对象，绑定URL
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setHTTPMethod:@"POST"];
    NSData *bodyData = [@"" dataUsingEncoding:NSUTF8StringEncoding];
    [request setHTTPBody:bodyData];
    // 3、 发送请求
    NSData * dataRE = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    //    NSLog(@"%@",data);
    // json 解析
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:dataRE options:NSJSONReadingAllowFragments error:nil];
    NSDictionary *categoriesDic = dic[@"data"];
    _dataArr = categoriesDic[@"categories"];
    for (int i = 0; i <_dataArr.count; i ++) {
        [_selectArr addObject:@"NO"];
    }
    [self.tableview reloadData];
     NSLog(@"%@",dic);
}


#pragma mark ======= tableview data delegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return _dataArr.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 42;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid = @"cellid";
    BussLeiMuCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[BussLeiMuCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        cell.textLabel.font = FSYSTEMFONT(13);
        cell.backgroundColor = UIColorFromRGB(0xffffff);
        cell.textLabel.textColor = UIColorFromRGB(0x333333);
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        [self createLineWithColor:UIColorFromRGB(0xf1f1f1) frame:CGRectMake(0, 0, ScreenWidth, 0.5) Super:cell.contentView];
        
    }
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.textLabel.text = dic[@"catName"];
    NSString *str = _selectArr[indexPath.row];
    if ([str boolValue]) {
        cell.rightLab.text = @"已选择";
        cell.rightLab.textColor = UIColorFromRGB(0xc61616);

    }else{
        cell.rightLab.text = @"请选择";
        cell.rightLab.textColor = UIColorFromRGB(0x808A87);
    }

    return cell;

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = _selectArr[indexPath.row];
    if ([str boolValue]) {
        [_selectArr  replaceObjectAtIndex:indexPath.row withObject:@"NO"];
    }else{
        [_selectArr  replaceObjectAtIndex:indexPath.row withObject:@"YES"];

    }
    [self.tableview  reloadData];
}


@end
