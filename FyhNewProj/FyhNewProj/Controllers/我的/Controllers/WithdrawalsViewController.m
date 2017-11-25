//
//  WithdrawalsViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/16.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "WithdrawalsViewController.h"
#import "WithdrawalsViewController.h"
#import "BankCardSeleteViewController.h"
#import "AddBankCardViewController.h"
#import "DrawDetailViewController.h"
#import "BankCardModel.h"
#import "BankCardPL.h"

@interface WithdrawalsViewController ()<UITextFieldDelegate>

@property (nonatomic , strong) UIView *BankCardView;

@property (nonatomic , strong) UIView *addCardView;

@property (nonatomic , strong) UIImageView *bankImageView;

@property (nonatomic , strong) UILabel *bankNameLab;

@property (nonatomic , strong) UILabel *endNumBerLab;

@property (nonatomic , strong) SubBtn *setGaryBtn;

@property (nonatomic , strong) SubBtn *setColorBtn;


@end

@implementation WithdrawalsViewController{

    UITextField *_moneyTxt;
    NSMutableArray *_dataArr;
    BankCardModel *_model;
    BOOL isHaveDian;
    

}
#pragma ------ get
-(UIView *)BankCardView{
    if (!_BankCardView) {
        _BankCardView = [BaseViewFactory viewWithFrame:CGRectMake(0, 148, ScreenWidth, 64) color:UIColorFromRGB(WhiteColorValue)];
        [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 0, ScreenWidth, 1) Super:_BankCardView];
        [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 63, ScreenWidth, 1) Super:_BankCardView];
        [self.view addSubview:_BankCardView];
        _bankImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_BankCardView addSubview:_bankImageView];
        
        _bankNameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
        [_BankCardView addSubview:_bankNameLab];
        
        _endNumBerLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
        [_BankCardView addSubview:_endNumBerLab];
        
        _bankImageView.sd_layout
        .leftSpaceToView(_BankCardView, 16)
        .topSpaceToView(_BankCardView, 12)
        .widthIs(40)
        .heightIs(40);
        
        _bankNameLab.sd_layout
        .leftSpaceToView(_bankImageView, 12)
        .topSpaceToView(_BankCardView, 12)
        .widthIs(ScreenWidth - 108)
        .heightIs(16);
        
        _endNumBerLab.sd_layout
        .leftSpaceToView(_bankImageView, 12)
        .bottomEqualToView(_bankImageView)
        .widthIs(ScreenWidth - 108)
        .heightIs(16);
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, ScreenWidth, 64);
        [_BankCardView addSubview:btn];
        [btn addTarget:self action:@selector(addBankCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
        UIImageView *right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
        [_BankCardView addSubview:right];
        right.frame = CGRectMake(ScreenWidth - 26, 24, 10, 16);

        
    }
    
    
    return _BankCardView;
}

-(UIView *)addCardView{

    if (!_addCardView) {
        _addCardView = [BaseViewFactory viewWithFrame:CGRectMake(0, 148, ScreenWidth, 39) color:UIColorFromRGB(WhiteColorValue)];
        [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 0, ScreenWidth, 1) Super:_addCardView];
        [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 38, ScreenWidth-16, 1) Super:_addCardView];
        [self.view addSubview:_addCardView];
        
        [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:_addCardView Frame:CGRectMake(16, 0, 200, 39) Alignment:NSTextAlignmentLeft Text:@"添加银行卡"];
        UIImageView *right = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"right"]];
        [_addCardView addSubview:right];
        right.frame = CGRectMake(ScreenWidth - 26, 11.5, 10, 16);
 
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(0, 0, ScreenWidth, 39);
        [_addCardView addSubview:btn];
        [btn addTarget:self action:@selector(addBankCardBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }

    return _addCardView;
}

#pragma ------ viewdidload

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    //顶部导航栏
    [self setNavTitle];
    [self loadUserBankCard];

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
- (void)setNavTitle{
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(17) textAligment:NSTextAlignmentCenter andtext:@"提现"];
    self.navigationItem.titleView = titlelab;
    
    UIButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"记录" forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(gotoDetailViewController) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = choiceCityBtn;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    
}

-(void)dealloc{
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

}
- (void)gotoDetailViewController{

    DrawDetailViewController *drVc = [[DrawDetailViewController  alloc]init];
    [self.navigationController pushViewController:drVc animated:YES];


}
#pragma mark ====== initUI
- (void)initUI{

  NSDictionary *bankCard = (NSDictionary *)[[NSUserDefaults standardUserDefaults]objectForKey:User_bankCard];
    if (!bankCard) {
        if (_dataArr.count <=0) {
            _model = [[BankCardModel alloc]init];

        }else{
            _model = _dataArr[0];

        }
    }else{
        //逻辑有问题
        _model = [[BankCardModel alloc]init];
        NSMutableArray *idArr = [NSMutableArray arrayWithCapacity:0];
        [idArr removeAllObjects];
        for (BankCardModel *model  in _dataArr) {
            [idArr addObject:model.cardId];
        }
        if ([idArr containsObject:NULL_TO_NIL(bankCard[@"cardId"])]) {
            for (BankCardModel *model in _dataArr) {
                if ([model.cardId isEqualToString:NULL_TO_NIL(bankCard[@"cardId"])]) {
                    
                    _model = model;
                    
                }
            }

        }else{
            _model = _dataArr[0];
        
        }
        
        
    }
    
    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 16, ScreenWidth, 120) color:UIColorFromRGB(WhiteColorValue)];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 0, ScreenWidth, 1) Super:topView];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(16, 89, ScreenWidth-16, 1) Super:topView];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 119, ScreenWidth, 1) Super:topView];
    [self.view addSubview:topView];
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(15) WithSuper:topView Frame:CGRectMake(16, 13, 200, 16) Alignment:NSTextAlignmentLeft Text:@"请输入提现金额"];
     [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(28) WithSuper:topView Frame:CGRectMake(16, 29, 30, 63) Alignment:NSTextAlignmentLeft Text:@"￥"];
    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(12) WithSuper:topView Frame:CGRectMake(16, 90, ScreenWidth-32, 30) Alignment:NSTextAlignmentLeft Text:[NSString stringWithFormat:@"可用余额%@元",_money]];

    _moneyTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(54, 29, ScreenWidth -70, 63) font:APPFONT(36) placeholder:@"0.00" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _moneyTxt.keyboardType = UIKeyboardTypeDecimalPad;
    [topView addSubview:_moneyTxt];
    [_moneyTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    _setGaryBtn =   [SubBtn buttonWithtitle:@"确认" backgroundColor:UIColorFromRGB(LineColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(setBtnCLick)];
    [self.view addSubview:_setGaryBtn];
    _setGaryBtn.frame = CGRectMake(16, 236, ScreenWidth - 32, 44);
    
    _setColorBtn = [SubBtn buttonWithtitle:@"确认" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(setBtnCLick) andframe:CGRectMake(16, 236, ScreenWidth- 32, 44)];
    [self.view addSubview:_setColorBtn];
    _setColorBtn.hidden = YES;

    
    if (_model.cardId.length > 0) {
        self.addCardView.hidden = YES;
        self.BankCardView.hidden = NO;
        [self setBankCardView];
        
    }else{
        self.addCardView.hidden = NO;
        self.BankCardView.hidden = YES;

    }
    
    
    UILabel *downLab = [BaseViewFactory labelWithFrame:CGRectMake(16, ScreenHeight -NaviHeight64-iPhoneX_DOWNHEIGHT -80, ScreenWidth - 32, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"未进行实名认证的用户不能进行提现的，资金会被冻结在账户中，只能进行实名认证后才能取出。"];
    downLab.numberOfLines = 0;
    [self.view addSubview:downLab];
   
}

#pragma mark ====== NetWork

- (void)loadUserBankCard{

    [BankCardPL userGetBankCardWithReturnBlock:^(id returnValue) {
        NSLog(@"银行卡信息%@",returnValue);
        NSMutableArray *arr = [NSMutableArray arrayWithCapacity:0];
        for (NSDictionary *dic in returnValue[@"bankCardList"]) {
            if (![dic[@"isFromCertification"] boolValue]) {
                [arr addObject:dic];
            }
        }
        _dataArr = [BankCardModel mj_objectArrayWithKeyValuesArray:arr];
        [self initUI];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
        [self.navigationController popViewControllerAnimated:YES];
    }];



}

#pragma mark ====== 添加银行卡

- (void)addBankCardBtnClick{

    if (_dataArr.count <=0) {
        
        AddBankCardViewController  *addVc = [[AddBankCardViewController  alloc]init];
        addVc.AddBankCardBlock = ^(BankCardModel *addModel) {
            _model = addModel;
            [self setBankCardView];
        };
       
        [self.navigationController pushViewController:addVc animated:YES];
        
        
        
    }else{
        BankCardSeleteViewController  *seleVc = [[BankCardSeleteViewController alloc]init];
        seleVc.dataArr = _dataArr;
        for (BankCardModel *model in _dataArr) {
            if ([model.cardId isEqualToString:_model.cardId]) {
                model.selected = YES;
            }else{
                model.selected = NO;
            }
        }
        seleVc.didselectStatusItemBlock = ^(BankCardModel *selectedModel) {
            _model = selectedModel;
            [self setBankCardView];
        };
        [self.navigationController pushViewController:seleVc animated:YES];
        
    }

}


- (void)setBtnCLick{

    if ([_moneyTxt.text floatValue] <=0) {
        [self showTextHud:@"请输入正确的金额"];
        return;
    }
    if (_model.accountId.length <=0) {
        [self showTextHud:@"请选择提现的银行卡"];
        return;
    }
    NSDictionary *dic = @{@"amount":_moneyTxt.text,
                          @"bankCardId":_model.cardId};
    [BankCardPL userDrawalRequestWithDic:dic withReturnBlock:^(id returnValue) {
        [self showTextHud:@"提现请求发起成功"];
        [self.navigationController popViewControllerAnimated:YES];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];

}


- (void)setBankCardView{
    if (_model.bankName.length<=0) {
        return;
    }
    
    if (_model.cardId.length > 0) {
        self.addCardView.hidden = YES;
        self.BankCardView.hidden = NO;
        if (_moneyTxt.text.length >0&&_model.accountId.length >0&&[_moneyTxt.text floatValue]>0){
            _setColorBtn.hidden = NO;
            _setGaryBtn.hidden = YES;
        }
       
        
    }else{
        self.addCardView.hidden = NO;
        self.BankCardView.hidden = YES;
        _setColorBtn.hidden = YES;
        _setGaryBtn.hidden = NO;
    }

    NSString *bankName;
    UIImage *bankImage;
    if ([_model.bankName containsString:@"农业银行"]) {
        bankName = @"中国农业银行";
        bankImage = [UIImage imageNamed:@"Ass-ABC"];
        
    }else if ([_model.bankName containsString:@"工商银行"]){
        bankName = @"中国工商银行";
        bankImage = [UIImage imageNamed:@"Ass-ICBC"];
        
    }else if ([_model.bankName containsString:@"招商银行"]){
        bankName = @"中国招商银行";
        bankImage = [UIImage imageNamed:@"Ass-CMB"];
        
    }else if ([_model.bankName containsString:@"中国银行"]){
        bankName = @"中国银行";
        bankImage = [UIImage imageNamed:@"Ass-BOC"];
        
    }else if ([_model.bankName containsString:@"交通银行"]){
        bankName = @"中国交通银行";
        bankImage = [UIImage imageNamed:@"Ass-BCM"];
        
    }else if ([_model.bankName containsString:@"建设银行"]){
        bankName = @"中国建设银行";
        bankImage = [UIImage imageNamed:@"Ass-CBC"];
        
    }
    _bankNameLab.text = bankName;
    _bankImageView.image = bankImage;
    
    NSString *numberStr = [_model.bankAccountNumber stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    numberStr = [numberStr substringFromIndex:numberStr.length - 4];
    _endNumBerLab.text = [NSString stringWithFormat:@"尾号%@",numberStr];
    
    
    
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([textField.text rangeOfString:@"."].location == NSNotFound)
    {
        isHaveDian = NO;
    }
    if ([string length] > 0)
    {
        unichar single = [string characterAtIndex:0];//当前输入的字符
        if ((single >= '0' && single <= '9') || single == '.')//数据格式正确
        {
            //首字母不能为0和小数点
            if([textField.text length] == 0)
            {
                
                if(single == '.')
                {
                    
                  //  [self showMyMessage:@"亲，第一个数字不能为小数点!"];
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
//                if (single == '0')
//                {
//                    
//                 //   [self showMyMessage:@"亲，第一个数字不能为0!"];
//                    
//                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
//                    
//                    return NO;
//                    
//                }
                
            }
            
            //输入的字符是否是小数点
            
            if (single == '.')
            {
                
                if(!isHaveDian)//text中还没有小数点
                {
                    
                    isHaveDian = YES;
                    
                    return YES;
                    
                }else{
                    
                 //   [self showMyMessage:@"亲，您已经输入过小数点了!"];
                    
                    [textField.text stringByReplacingCharactersInRange:range withString:@""];
                    
                    return NO;
                    
                }
                
            }else{
                
                if (isHaveDian) {//存在小数点
                    
                    //判断小数点的位数
                    
                    NSRange ran = [textField.text rangeOfString:@"."];
                    
                    if (range.location - ran.location <= 2) {
                        
                        return YES;
                        
                    }else{
                        
                    //    [self showMyMessage:@"亲，您最多输入两位小数!"];
                        
                        return NO;
                        
                    }
                    
                }else{
                    
                    return YES;
                    
                }
                
            }
            
        }else{//输入的数据格式不正确
            
         //   [self showMyMessage:@"亲，您输入的格式不正确!"];
            
            [textField.text stringByReplacingCharactersInRange:range withString:@""];
            
            return NO;
            
        }
        
    }
    
    else
        
    {
        
        return YES;
        
    }
    
   
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if ([_moneyTxt.text floatValue]>[_money floatValue]) {
        _moneyTxt.text = _money;
        if ([_moneyTxt.text rangeOfString:@"."].location == NSNotFound)
        {
            isHaveDian = NO;
        }else{
            isHaveDian = YES;
        }
    }
    
    if (_moneyTxt.text.length >0&&_model.accountId.length >0&&[_moneyTxt.text floatValue]>0) {
        _setColorBtn.hidden = NO;
        _setGaryBtn.hidden = YES;

    }else{
    
        _setColorBtn.hidden = YES;
        _setGaryBtn.hidden = NO;
    }


}


@end
