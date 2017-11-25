//
//  SettingupinventoryViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/31.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "SettingupinventoryViewController.h"
#import "ShopSettingPL.h"
@interface SettingupinventoryViewController ()

@property (nonatomic , strong) UITextField  *numberTF;

@end

@implementation SettingupinventoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(0xe6e9ed);
    [self setBarBackBtnWithImage:nil];
    self.title = @"设置库存警告";
    [self initUI];
    
    UIButton* rightbutton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 13)];
    [rightbutton setTitle:@"确定" forState:UIControlStateNormal];
    rightbutton.titleLabel.font = APPFONT(14);
    [rightbutton addTarget:self action:@selector(respondToRightButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    
    self.navigationItem.rightBarButtonItem = right;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI
{
    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 12, ScreenWidth, 40)];
    v1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v1];
    
    _numberTF = [[UITextField alloc]initWithFrame:CGRectMake(17, 0, ScreenWidth-17, 40)];
    _numberTF.textColor = UIColorFromRGB(0x434a54);
    _numberTF.textAlignment = NSTextAlignmentLeft;
    _numberTF.text = _numStr;
    _numberTF.font = APPFONT(15);
    _numberTF.keyboardType = UIKeyboardTypeNumberPad;
    
    [v1 addSubview:_numberTF];
}

-(void)respondToRightButtonClickEvent
{
    if (_numberTF.text.length<=0) {
        return;
    }
    WeakSelf(self);
    NSDictionary *dic = @{@"key":@"stockLessThanNumber",@"value":_numberTF.text};
    [ShopSettingPL SettingCustomShopInfoWithDic:dic andReturnBlock:^(id returnValue) {
        weakself.didSetNumberBlock(_numberTF.text);
        [weakself showTextHud:@"设置成功"];
        [weakself.navigationController popViewControllerAnimated:YES];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    
    
}



@end
