//
//  AdministrationaddViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AdministrationaddViewController.h"
#import "AddaddressViewController.h"
#import "YLButton.h"
#import "AcceptAdressPL.h"
#import "AdressCell.h"
#import "AdressModel.h"

@interface AdministrationaddViewController ()<UITableViewDelegate,UITableViewDataSource,AdressCellDelegate>

@property (nonatomic , strong) UITableView *addTbv;

@property(retain, nonatomic) NSMutableArray *addList;

@end

@implementation AdministrationaddViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.title = @"管理收货地址";
    [self setBarBackBtnWithImage:nil];
    _addList = [NSMutableArray  arrayWithCapacity:0];
    
    self.addTbv = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50)];
    self.addTbv.delegate = self;
    self.addTbv.dataSource = self;
    self.addTbv.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview: self.addTbv];

    SubBtn *AddaddressBtn =[SubBtn buttonWithtitle:@"添加新地址" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(Addaddress) andframe:CGRectMake(0, ScreenHeight-50-NaviHeight64-iPhoneX_DOWNHEIGHT, ScreenWidth, 50)];
    AddaddressBtn.titleLabel.font = APPFONT(18);
    [self.view addSubview:AddaddressBtn];
    [self loadAllAdrsss];
    //用户信息变化通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeUserDefaultAdress:)
                                                 name:@"deautifultAdressChanged"  object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshAdress)
                                                 name:@"refreshAdress"  object:nil];
}



- (void)loadAllAdrsss{

[AcceptAdressPL getUserAllAdresswithReturnBlock:^(id returnValue) {

    _addList = [AdressModel mj_objectArrayWithKeyValuesArray:returnValue[@"data"][@"addresses"]];
    if (_addList.count >0) {
         AdressModel *model = _addList[0];
        model.isDefaultAdress = YES;
    }
   
    [self.addTbv reloadData];
} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];
}];
}

- (void)refreshAdress{

    [self loadAllAdrsss];
}

/**
 添加地址时设置默认地址
 
 @param noti 返回字典
 */
- (void)changeUserDefaultAdress:(NSNotification *)noti{
    
    NSString *idStr = noti.object;
    [AcceptAdressPL defaultAcceptAdressWithAdressid:idStr withReturnBlock:^(id returnValue) {
        [self loadAllAdrsss];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    
}





- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _addList.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 112;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"Cell111";
    AdressCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell == nil) {
        cell  = [[AdressCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell.selectionStyle = UITableViewCellAccessoryNone;
    }
    cell.model = _addList[indexPath.row];
    cell.delegate = self;
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if (_selectedType==1) {
        self.didselectAdressBlock(_addList[indexPath.row]);
        [self.navigationController popViewControllerAnimated:YES];
    }

}


//添加新地址
-(void)Addaddress
{
    AddaddressViewController *addVc = [[AddaddressViewController alloc]init];
    [self.navigationController pushViewController:addVc animated:YES];
}

#pragma mark =========== AdressCellDelegate

/**
 默认   不作处理

 @param cell cell
 */
-(void)AdressCellMorenBtnClick:(AdressCell *)cell{


}

/**
 设为默认

 @param cell cell
 */
-(void)AdressCellLeftBtnClick:(AdressCell *)cell{

    [self setDefaultAdressWithID:cell.model.addressid];
   
}

/**
 编辑

 @param cell 编辑
 */
-(void)AdressCellEditBtnClick:(AdressCell *)cell{

    AddaddressViewController *addVc = [[AddaddressViewController alloc]init];
    addVc.model = cell.model;
    [self.navigationController pushViewController:addVc animated:YES];
}

/**
 删除

 @param cell cell
 */
-(void)AdressCellDeleteBtnClick:(AdressCell *)cell{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"确定删除地址么？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [AcceptAdressPL deleteAcceptAdressWithAdressid:cell.model.addressid withReturnBlock:^(id returnValue) {
            [self showTextHud:@"删除成功"];
            [self loadAllAdrsss];
        } andErrorBlock:^(NSString *msg) {
            [self showTextHud:msg];
        }];
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
    



}

- (void)setDefaultAdressWithID:(NSString *)adressId{
    [AcceptAdressPL defaultAcceptAdressWithAdressid:adressId withReturnBlock:^(id returnValue) {
        [self showTextHud:@"设置成功"];
        [self loadAllAdrsss];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];

}

@end
