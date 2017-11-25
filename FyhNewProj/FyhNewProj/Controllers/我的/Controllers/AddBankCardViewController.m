//
//  AddBankCardViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/9/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "AddBankCardViewController.h"
#import "UITextField+ExtentRange.h"
#import "WLCardNoFormatter.h"
#import "BankCardModel.h"
#import "BankCardPL.h"



@interface AddBankCardViewController ()<UITextFieldDelegate>

@property (nonatomic , strong) UIView *BankCardView;

@property (nonatomic , strong) UIImageView *bankImageView;

@property (nonatomic , strong) UILabel *bankNameLab;

@property (nonatomic , strong) UILabel *endNumBerLab;

@property (nonatomic , strong) UITextField *nameTxt;

@property (nonatomic , strong) UITextField *cardNumberTxt;

@property (nonatomic , strong) UITextField *bankSelectedTxt;

@property (nonatomic , strong) SubBtn *setGaryBtn;

@property (nonatomic , strong) SubBtn *setColorBtn;

@property (strong, nonatomic) WLCardNoFormatter *cardNoFormatter;

@end

@implementation AddBankCardViewController{
    
    BOOL  _card_ture;
    BOOL  _isAddNumber;
    NSRange _range;

}
#pragma ------ get
-(UIView *)BankCardView{
    if (!_BankCardView) {
        _BankCardView = [BaseViewFactory viewWithFrame:CGRectMake(0, 118, ScreenWidth, 64) color:UIColorFromRGB(WhiteColorValue)];
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
        
    }


    return _BankCardView;
}

#pragma ------ viewdidload
- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    //顶部导航栏
    [self setNavTitle];
    self.view.backgroundColor = UIColorFromRGB(BGColorValue);
    _card_ture = NO;
    [self initUI];
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
    //    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(0x282c32);
    [self.navigationController.navigationBar setBarTintColor:UIColorFromRGB(WhiteColorValue)];
    
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }
    
}


/**
 设置导航栏
 */
- (void)setNavTitle{
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(17) textAligment:NSTextAlignmentCenter andtext:@"添加银行卡"];
    self.navigationItem.titleView = titlelab;
    
}
#pragma ------ UI

- (void)initUI{

    UIView *nameView = [BaseViewFactory viewWithFrame:CGRectMake(0, 16, ScreenWidth, 39)
                                                color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:nameView];
    [self createLineWithColor:UIColorFromRGB(LineColorValue)
                        frame:CGRectMake(0, 0, ScreenWidth, 1)
                        Super:nameView];
    [self createLineWithColor:UIColorFromRGB(LineColorValue)
                        frame:CGRectMake(0, 38, ScreenWidth, 1)
                        Super:nameView];
    [self createLabelWith:UIColorFromRGB(BlackColorValue)
                     Font:APPFONT(15)
                WithSuper:nameView
                    Frame:CGRectMake(16, 0, 76, 39)
                Alignment:NSTextAlignmentLeft
                     Text:@"开户名称"];
    _nameTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(92, 0, ScreenWidth -108, 39)
                                              font:APPFONT(15)
                                       placeholder:@"请输入开户人或开户名"
                                         textColor:UIColorFromRGB(BlackColorValue)
                                  placeholderColor:UIColorFromRGB(LineColorValue)
                                          delegate:self];
    [nameView  addSubview:_nameTxt];
   [_nameTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
    
    
    
    
    UIView *cardView = [BaseViewFactory viewWithFrame:CGRectMake(0, 67, ScreenWidth, 39)
                                                color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:cardView];
    [self createLineWithColor:UIColorFromRGB(LineColorValue)
                        frame:CGRectMake(0, 0, ScreenWidth, 1)
                        Super:cardView];
    [self createLineWithColor:UIColorFromRGB(LineColorValue)
                        frame:CGRectMake(0, 38, ScreenWidth, 1)
                        Super:cardView];
    [self createLabelWith:UIColorFromRGB(BlackColorValue)
                     Font:APPFONT(15)
                WithSuper:cardView
                    Frame:CGRectMake(16, 0, 76, 39)
                Alignment:NSTextAlignmentLeft
                     Text:@"银行卡号"];
    _cardNumberTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(92, 0, ScreenWidth -108, 39)
                                              font:APPFONT(15)
                                       placeholder:@"请输入银行卡号"
                                         textColor:UIColorFromRGB(BlackColorValue)
                                  placeholderColor:UIColorFromRGB(LineColorValue)
                                          delegate:self];
    [cardView  addSubview:_cardNumberTxt];
    _cardNumberTxt.keyboardType = UIKeyboardTypeNumberPad;
    [_cardNumberTxt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];

    
//    UIView *bankNameView = [BaseViewFactory viewWithFrame:CGRectMake(0, 118, ScreenWidth, 39)
//                                                color:UIColorFromRGB(WhiteColorValue)];
//    [self.view addSubview:bankNameView];
//    [self createLineWithColor:UIColorFromRGB(LineColorValue)
//                        frame:CGRectMake(0, 0, ScreenWidth, 1)
//                        Super:bankNameView];
//    [self createLineWithColor:UIColorFromRGB(LineColorValue)
//                        frame:CGRectMake(0, 38, ScreenWidth, 1)
//                        Super:bankNameView];
//    [self createLabelWith:UIColorFromRGB(BlackColorValue)
//                     Font:APPFONT(15)
//                WithSuper:bankNameView
//                    Frame:CGRectMake(16, 0, 76, 39)
//                Alignment:NSTextAlignmentLeft
//                     Text:@"银行"];
//    _bankSelectedTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(92, 0, ScreenWidth -108, 39)
//                                                    font:APPFONT(15)
//                                             placeholder:@"请选择开户银行"
//                                               textColor:UIColorFromRGB(BlackColorValue)
//                                        placeholderColor:UIColorFromRGB(LineColorValue)
//                                                delegate:self];
//    _bankSelectedTxt.userInteractionEnabled = NO;
//    [bankNameView  addSubview:_bankSelectedTxt];
    
    _setGaryBtn =   [SubBtn buttonWithtitle:@"确认" backgroundColor:UIColorFromRGB(LineColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(setBtnCLick)];
    [self.view addSubview:_setGaryBtn];
    _setGaryBtn.frame = CGRectMake(16, 150, ScreenWidth - 32, 44);

    _setColorBtn = [SubBtn buttonWithtitle:@"确认" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(setBtnCLick) andframe:CGRectMake(16, 214, ScreenWidth- 32, 44)];
    [self.view addSubview:_setColorBtn];
    _setColorBtn.hidden = YES;

    UILabel *downLab = [BaseViewFactory labelWithFrame:CGRectMake(16, ScreenHeight -NaviHeight64-iPhoneX_DOWNHEIGHT -80, ScreenWidth - 32, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"目前支持银行：中国农业银行，中国工商银行，交通银行，中国建设银行，中国银行，招商银行。"];
    downLab.numberOfLines = 0;
    [self.view addSubview:downLab];
}








#pragma ------ 确认按钮
/**
 确认
 */
- (void)setBtnCLick{

    if (_nameTxt.text.length <=0) {
        [self showTextHud:@"请输入开户人或开户名"];
        return;
    }
    if (_cardNumberTxt.text.length <=0) {
        [self showTextHud:@"请输入银行卡号"];
        return;
    }
    
    if (!_card_ture) {
        [self showTextHud:@"请输入正确的银行卡号"];
        return;
    }
    NSDictionary *dic = @{@"bankAccountName":_nameTxt.text,
                          @"bankAccountNumber":[_cardNumberTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""],
                          @"bankAddress":@"",
                          @"bankName":_bankNameLab.text};
    WeakSelf(self);
    [BankCardPL userAddBankCardWithinfoDic:dic WithReturnBlock:^(id returnValue) {
        [ weakself showTextHud:@"添加成功"];
        BankCardModel *model = [BankCardModel mj_objectWithKeyValues:returnValue[@"bankCard"]];
        if (weakself.AddBankCardBlock) {
            //两个页面使用，一个页面没调用会崩溃所以if判断一下
            weakself.AddBankCardBlock(model);
        }
        [weakself performSelector:@selector(backVc) withObject:nil afterDelay:1.5];
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    
    
}
- (void)backVc{
    [self.navigationController popViewControllerAnimated:YES];

}



#pragma ------ textfielddelegate

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (textField == self.cardNumberTxt) {
        [self.cardNoFormatter bankNoField:textField shouldChangeCharactersInRange:range replacementString:string];
        [self makeSureInfoInputeComplete];
        return NO;
    }
    return YES;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    if (theTextField == self.nameTxt) {
        [self makeSureInfoInputeComplete];
    }

  
}


- (WLCardNoFormatter *)cardNoFormatter {
    if(_cardNoFormatter == nil) {
        _cardNoFormatter = [[WLCardNoFormatter alloc] init];
    }
    return _cardNoFormatter;
}

#pragma ------ 判断

- (BOOL)makeSureInfoInputeComplete{
    NSString *nameStr = [GlobalMethod getBankName:[_cardNumberTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""]];
    if (_nameTxt.text.length >0
        &&(_cardNumberTxt.text.length == 19||_cardNumberTxt.text.length == 23)
        &&nameStr.length>0
        &&[GlobalMethod isValidCardNumber:[_cardNumberTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""]])

    {
        
        [self setBankCardViewWithNameStr:nameStr];
        return YES;
    }
    self.BankCardView.hidden = YES;
    _setColorBtn.hidden = YES;
    _setGaryBtn.hidden = NO;
        return NO;
}



- (void)setBankCardViewWithNameStr:(NSString *)nameStr{
    if (nameStr.length<=0) {
        return;
    }
    NSString *bankName;
    UIImage *bankImage;
    if ([nameStr containsString:@"农业银行"]) {
        bankName = @"中国农业银行";
        bankImage = [UIImage imageNamed:@"Ass-ABC"];
        
    }else if ([nameStr containsString:@"工商银行"]){
        bankName = @"中国工商银行";
        bankImage = [UIImage imageNamed:@"Ass-ICBC"];

    }else if ([nameStr containsString:@"招商银行"]){
        bankName = @"中国招商银行";
        bankImage = [UIImage imageNamed:@"Ass-CMB"];
 
    }else if ([nameStr containsString:@"中国银行"]){
        bankName = @"中国银行";
        bankImage = [UIImage imageNamed:@"Ass-BOC"];
 
    }else if ([nameStr containsString:@"交通银行"]){
        bankName = @"中国交通银行";
        bankImage = [UIImage imageNamed:@"Ass-BCM"];

    }else if ([nameStr containsString:@"建设银行"]){
        bankName = @"中国建设银行";
        bankImage = [UIImage imageNamed:@"Ass-CBC"];

    }else{
        self.BankCardView.hidden = YES;
        _setColorBtn.hidden = YES;
        _setGaryBtn.hidden = NO;
        _card_ture = NO;
        return;
    }
    
    self.BankCardView.hidden = NO;
    _setColorBtn.hidden = NO;
    _setGaryBtn.hidden = YES;
    _card_ture = YES;
    _bankNameLab.text = bankName;
    _bankImageView.image = bankImage;
    
    NSString *numberStr = [_cardNumberTxt.text stringByReplacingOccurrencesOfString:@" " withString:@""];

    numberStr = [numberStr substringFromIndex:numberStr.length - 4];
    _endNumBerLab.text = [NSString stringWithFormat:@"尾号%@",numberStr];



}

@end
