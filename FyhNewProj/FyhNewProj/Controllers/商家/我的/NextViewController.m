//
//  NextViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "NextViewController.h"
#import "JYAreaPickerView.h"
#import "BussModel.h"

@interface NextViewController ()<UITextFieldDelegate,JYAreaPickerDelegate>

@end

@implementation NextViewController{
    UITextField *_nametxt;
    UITextField *_numbertxt;
    UILabel     *_locolLab;
    UITextField *_banknametxt;
    JYAreaPickerView        *_areaPicker;       //地址选择器
    BOOL                    _areaPickIsShow;

    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBarBackBtnWithImage:nil];
    self.title = @"企业实名认证";
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    [self createNavagationItem];
    [self setupUI];

}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    
    
}

- (void)createNavagationItem
{
    UIButton *  btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"2/2" forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = choiceCityBtn;
}

-(void)setupUI
{
    // 开户公司名
    UIView *v1 = [[UIView alloc]initWithFrame:CGRectMake(0, 12,ScreenWidth, 48)];
    v1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v1];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:v1 Frame:CGRectMake(16, 16.5, 120, 15) Alignment:NSTextAlignmentLeft Text:@"开户公司名"];
    _nametxt = [BaseViewFactory textFieldWithFrame:CGRectMake(ScreenWidth -200, 0, 184, 48) font:APPFONT(15) placeholder:@"请输入开户公司名" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    [v1 addSubview:_nametxt ];
    _nametxt.textAlignment = NSTextAlignmentRight;
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:v1];
    //银行开户账号
    UIView *v2 = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48,ScreenWidth, 48)];
    v2.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v2];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:v2 Frame:CGRectMake(16, 16.5, 120, 15) Alignment:NSTextAlignmentLeft Text:@"银行开户账号"];
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:v2];
    
    _numbertxt = [BaseViewFactory textFieldWithFrame:CGRectMake(ScreenWidth -200, 0, 184, 48) font:APPFONT(15) placeholder:@"请输入银行账户" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    [v2 addSubview:_numbertxt ];
    _numbertxt.textAlignment = NSTextAlignmentRight;

    
    
    //开户银行所在地
    UIView *v3 = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48+48,ScreenWidth, 48)];
    v3.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v3];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:v3 Frame:CGRectMake(16, 16.5, 120, 15) Alignment:NSTextAlignmentLeft Text:@"开户银行所在地"];
    
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:v3];
    
    _locolLab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth - 200, 0, 168, 48) textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"请选择"];
    [v3 addSubview:_locolLab];
    
    UIImageView *right = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 24, 16, 10, 16)];
    right.image = [UIImage imageNamed:@"right"];
    [v3 addSubview:right];
    UIButton *kindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kindBtn.frame = CGRectMake(ScreenWidth - 200, 0, 200, 48);
    [v3 addSubview:kindBtn];
    [kindBtn addTarget:self action:@selector(bankLocalBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //开户银行
    UIView *v4 = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48+48+48,ScreenWidth, 48)];
    v4.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:v4];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:v4 Frame:CGRectMake(16, 16.5, 120, 15) Alignment:NSTextAlignmentLeft Text:@"开户银行"];
    
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:v4];
    
    _banknametxt = [BaseViewFactory textFieldWithFrame:CGRectMake(ScreenWidth -200, 0, 184, 48) font:APPFONT(15) placeholder:@"请输入开户银行" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    [v4 addSubview:_banknametxt ];
    _banknametxt.textAlignment = NSTextAlignmentRight;

    
    SubBtn *SubmitBtn = [SubBtn buttonWithtitle:@"提交" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(SubmitBtnClick) andframe:CGRectMake(16, CGRectGetMaxY(v4.frame)+24, ScreenWidth-32, 50)];
    SubmitBtn.titleLabel.font = APPFONT(17);
    [self.view addSubview:SubmitBtn];
    
}


- (void)bankLocalBtnClick{
    [self.view endEditing:YES];
    
    if (!_areaPicker) {
        _areaPicker = [[JYAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 168) type:AreaNoBuXian
                                               includeContory:NO];
        _areaPicker.delegate = self;
    }
        [_areaPicker showInView:self.view];
    
    
    
}


- (void)hideKeyBoard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    [_areaPicker cancelPicker];
    
    
}


- (void)SubmitBtnClick{
    if (_nametxt.text.length<=0) {
        [self showTextHud:@"请输入开户公司名称"];
        return;
    }
    if (_numbertxt.text.length<=0) {
        [self showTextHud:@"请输入银行开户账户"];
        return;
    }
    if (_banknametxt.text.length<=0) {
        [self showTextHud:@"请输入开户银行名称"];
        return;
    }
    if ( [_locolLab.text isEqualToString:@"请选择"]) {
        [self showTextHud:@"请输入开户银行所在地"];
        return;
    }
    
    NSDictionary *dic = @{@"corporateName":_model.corporateName,
                          @"legalPersonName":_model.legalPersonName,
                          @"legalPersonIdentificationType":_model.legalPersonIdentificationType,
                          @"legalPersonIdentificationNumber":_model.legalPersonIdentificationNumber,
                          @"businessLicenseNumber":_model.businessLicenseNumber,
                          @"businessLicensePicUrl":_model.businessLicensePicUrl,
                          @"legalPersonIdentificationHeadPicUrl":_model.legalPersonIdentificationHeadPicUrl,
                          @"legalPersonIdentificationBackPicUrl":_model.legalPersonIdentificationBackPicUrl,
                          @"bankAccountName":_nametxt.text,
                          @"bankAccountNumber":_numbertxt.text,
                          @"bankName":_banknametxt.text,
                          @"bankAddress":_model.bankAddress
                          };
    
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client POST:@"/user/certification/enterprise" dict:dic success:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]==-1) {
            [self showTextHud:@"提交成功，请等待"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self showTextHud:@"出错了，请稍后再试"];
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTextHud:@"出错了，请稍后再试"];
    }];
    
    
    
}




#pragma mark--------------------------------JYAreaPickerDelegate--------------------------------
- (void)pickerDidChaneStatus:(JYAreaPickerView *)picker
{
    if (picker == _areaPicker) {
        NSString *areaString = [NSString stringWithFormat:@"%@%@%@", _areaPicker.locate.state, _areaPicker.locate.city,
                                _areaPicker.locate.district];
        _locolLab.text = areaString;
        _locolLab.textColor = UIColorFromRGB(BlackColorValue);
        _model.bankAddress   = areaString;
    }
}










@end
