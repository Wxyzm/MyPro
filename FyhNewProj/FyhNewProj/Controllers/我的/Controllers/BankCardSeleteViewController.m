//
//  BankCardSeleteViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BankCardSeleteViewController.h"
#import "BankCardSelectCell.h"
#import "BankCardModel.h"

@interface BankCardSeleteViewController ()<UITableViewDelegate,UITableViewDataSource>


@property (nonatomic , strong) UITableView *CardListTableView;


@end

@implementation BankCardSeleteViewController

-(UITableView *)CardListTableView{
    
    if (!_CardListTableView) {
        _CardListTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 16, ScreenWidth, ScreenHeight - 64) style:UITableViewStylePlain];
        _CardListTableView.delegate = self;
        _CardListTableView.dataSource = self;
        _CardListTableView.backgroundColor = UIColorFromRGB(0xf5f7fa);
        _CardListTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
        [self.view addSubview:_CardListTableView];
    }
    
    return _CardListTableView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    //顶部导航栏
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(17) textAligment:NSTextAlignmentCenter andtext:@"选择银行卡"];
    self.navigationItem.titleView = titlelab;
    [self.CardListTableView reloadData];

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
}

#pragma mark ===== tableviewdelegate

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _dataArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellid = @"cardlist";
    BankCardSelectCell *cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    if (!cell) {
        cell = [[BankCardSelectCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
    }
    cell.model = _dataArr[indexPath.row];
    return cell;
}
/* _model.accountId =NULL_TO_NIL(bankCard[@"accountId"]);
 _model.bankAccountName = NULL_TO_NIL( bankCard[@"bankAccountName"]);
 _model.bankAccountNumber = NULL_TO_NIL(bankCard[@"bankAccountNumber"]) ;
 _model.bankAddress = NULL_TO_NIL(bankCard[@"bankAddress"]) ;
 _model.bankName = NULL_TO_NIL(bankCard[@"bankName"]) ;
 _model.cardId = NULL_TO_NIL(bankCard[@"cardId"]) ;
 _model.isFromCertification = [NULL_TO_NIL(bankCard[@"accountId"] ) boolValue];
 _model.type = [ NULL_TO_NIL(bankCard[@"accountId"]) integerValue];
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    BankCardModel *model = _dataArr[indexPath.row];
   
    NSDictionary *dic = @{@"accountId":model.accountId,
                          @"bankAccountName":model.bankAccountName,
                          @"bankAccountNumber":model.bankAccountNumber,
                          @"bankAddress":model.bankAddress,
                          @"bankName":model.bankName,
                          @"cardId":model.cardId,
                          @"isFromCertification":model.isFromCertification?@"1":@"0",
                          @"type":[NSString stringWithFormat:@"%ld",model.type]
                          };
    [[NSUserDefaults standardUserDefaults] setObject:dic forKey:User_bankCard];
    _didselectStatusItemBlock(model);
    [self.navigationController popViewControllerAnimated:YES];
}


@end
