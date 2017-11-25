//
//  MemberFgPwdViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/6.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MemberFgPwdViewController.h"
#import "SubBtn.h"
#import "YzmPL.h"
@interface MemberFgPwdViewController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *UserPhoneTxt;  //手机号

@property (nonatomic,strong)UITextField *YZMTxt;        //验证码

@property (nonatomic,strong)UITextField *NewPwd;        //新密码

@property (nonatomic,strong)UITextField *SurePwd;  //确认密码
@end

@implementation MemberFgPwdViewController{
    SubBtn *_yzmBtn;   //获取验证码按钮
    YzmPL *_yzmPL;     //验证码加注册
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    UILabel *titlelab;
    if (_Type == 1) {
        titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(17) textAligment:NSTextAlignmentCenter andtext:@"修改登录密码"];

    }else{
        titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(17) textAligment:NSTextAlignmentCenter andtext:@"忘记密码"];

    }
    self.navigationItem.titleView = titlelab;
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    _yzmPL = [[YzmPL alloc]init];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [self setUP];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.navigationController.navigationBar.hidden = NO;
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    myView.layer.sublayers[0].hidden = YES;
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = YES;
    }
    NSLog(@"%@",myView.layer.sublayers);
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(WhiteColorValue);

}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }

}

- (void)setUP{
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(35, 30, ScreenWidth-70, 260)];
    bgview.layer.borderWidth = 1;
    bgview.clipsToBounds = YES;
    bgview.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    [self.view addSubview:bgview];
    bgview.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i<3; i++) {
        [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 65*(i+1)-0.5, ScreenWidth-70, 1) Super:bgview];
    }
    
    _UserPhoneTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(15) placeholder:@"请输入您的手机号" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    _UserPhoneTxt.keyboardType = UIKeyboardTypePhonePad;
    if (_Type == 1) {
        _UserPhoneTxt.text = [[NSUserDefaults standardUserDefaults] objectForKey:FYH_USER_ACCOUNT];
        _UserPhoneTxt.userInteractionEnabled = NO;
    }
    _YZMTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(15) placeholder:@"请输入您的验证码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    _YZMTxt.keyboardType = UIKeyboardTypePhonePad;
    _NewPwd = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(15) placeholder:@"请输入您的密码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    _NewPwd.keyboardType = UIKeyboardTypeDefault;
    _SurePwd = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(15) placeholder:@"6-20个字符，不能纯数字、纯字母" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    _SurePwd.keyboardType = UIKeyboardTypeDefault;
    
    NSArray *txtArr = @[_UserPhoneTxt,_YZMTxt,_NewPwd,_SurePwd];
    NSArray *titleArr = @[@"手机号",@"验证码",@"设置新密码",@"确认新密码"];
    for (int i = 0; i<4; i++) {
        UILabel *numLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:titleArr[i]];
        [bgview addSubview:numLab];
        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
        CGSize textSize = [titleArr[i] boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;;
        numLab.frame = CGRectMake(20, 65*i, textSize.width, 65);
        
        UITextField *txt = txtArr[i];
        [bgview addSubview:txt];
        
        if (i==1) {
            txt.frame = CGRectMake(CGRectGetMaxX(numLab.frame)+10, 65*i, 120, 65);
            _yzmBtn = [SubBtn buttonWithtitle:@"获取验证码" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:14.5 andtarget:self action:@selector(getYzm) andframe:CGRectMake(CGRectGetMaxX(txt.frame)+20, 65*i+18, 80, 29)];
            // CGRectMake(CGRectGetMaxX(txt.frame)+20, 65*i+18, 80, 29)
            _yzmBtn.titleLabel.font = APPFONT(13);
            [bgview addSubview:_yzmBtn];
            
            if (iPhone5) {
                [_yzmBtn setTitle:@"获取" forState:UIControlStateNormal];
                _yzmBtn.frame = CGRectMake(CGRectGetMaxX(txt.frame), 65*i+18, 50, 29);
            }else{
                _yzmBtn.sd_layout.rightSpaceToView(bgview, 20).topSpaceToView(bgview, 65*i+18).widthIs(80).heightIs(29);
                
            }
            
        }else{
            txt.frame = CGRectMake(CGRectGetMaxX(numLab.frame)+10, 65*i, ScreenWidth-80-CGRectGetMaxX(numLab.frame), 65);
            
        }
    }
    
    SubBtn *loginBtn = [SubBtn buttonWithtitle:@"完成" titlecolor:UIColorFromRGB(0xffffff) cornerRadius:2 andtarget:self action:@selector(completeBtnClick) andframe:CGRectMake(35, CGRectGetMaxY(bgview.frame)+30, ScreenWidth-70, 50)];
    loginBtn.titleLabel.font = APPFONT(18);
    loginBtn.layer.cornerRadius = 5;
    [self.view addSubview:loginBtn];
    
  }






/**
 发送验证码
 */
- (void)getYzm{
    if (_UserPhoneTxt.text.length < 8) {
        [self showTextHud:@"请输入正确的手机号"];
        return;
    }
    __block int timeout=119; // Time block.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); // Excute every second.
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0) // Time up.
        {
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                // Recover the UI of the button.
                [_yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                // You can tap now if necessary.
                _yzmBtn.userInteractionEnabled = YES;
                _yzmBtn.titleLabel.alpha = 1.0f;
            });
        }
        else
        {
            int seconds = timeout % 120;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                // Show seconds left.
                [_yzmBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                _yzmBtn.userInteractionEnabled = NO;
                _yzmBtn.titleLabel.alpha = 0.5;
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client getUserRetrievePasswordSubSessionwithReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
        if ([dic[@"code"] intValue]==-1) {
            NSDictionary *dataDic = dic[@"data"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            dict[@"mobileCountry"] = @"CN";
            dict[@"mobileNumber"] = _UserPhoneTxt.text;
            dict[@"subSession"] = dataDic[@"subSession"];
            [[NSUserDefaults  standardUserDefaults] setObject:dict[@"subSession"] forKey:FYHSubSession];
            if (_Type != 1) {
                [[NSUserDefaults  standardUserDefaults] setObject:dict[@"sessionId"] forKey:FYHSessionId];

            }
            
            [client sendRetrievePasswordSMSWuthInfoDic:dict withReturnBlock:^(id returnValue) {
                NSDictionary *smsdic = [HTTPClient valueWithJsonString:returnValue];
                
                if ([smsdic[@"code"] intValue]==-1){
                    [self showTextHud:@"短信已发出，请注意查收"];
                }else{
                    [self showTextHud:smsdic[@"message"]];
                }
            } andErrorBlock:^(NSString *msg) {
                [self showTextHud:msg];
            }];
        }else{
            
            [self showTextHud:dic[@"message"]];
            
        }

    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];

}

/**
 完成修改密码
 */
- (void)completeBtnClick{
    if (![_NewPwd.text isEqualToString:_SurePwd.text]) {
        [self showTextHud:@"两次密码输入不一致"];
        return;
    }
    if (_YZMTxt.text.length<=0) {
        [self showTextHud:@"请输入验证码"];
        return;
    }
    if (_YZMTxt.text.length <= 0) {
        [self showTextHud:@"请输入验证码"];
        return;
    }
    if (_UserPhoneTxt.text.length < 8) {
        [self showTextHud:@"请输入正确的手机号"];
        return;
    }
    if (![[NSUserDefaults standardUserDefaults]objectForKey:FYHSubSession]) {
        [self showTextHud:@"请获取验证码"];
        return;
    }

    HTTPClient *client = [HTTPClient sharedHttpClient];
    NSDictionary *infoDic = @{@"mobileCountry":@"CN",
                              @"mobileNumber":_UserPhoneTxt.text,
                              @"subSession":[[NSUserDefaults standardUserDefaults]objectForKey:FYHSubSession],
                              @"password":_NewPwd.text,
                              @"smsCode":_YZMTxt.text,
                              };
    
    [client userRetrievePasswordWuthInfoDic:infoDic withReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
        if ([dic[@"code"] intValue]==-1) {
            [self showTextHud:@"修改成功"];
            [[NSUserDefaults  standardUserDefaults] setObject:_NewPwd.text forKey:FYH_USER_PASSWORD];

            [self performSelector:@selector(Goback) withObject:nil afterDelay:0.5];
        }else {
            [self showTextHud:dic[@"message"]];
        }

        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];



}

- (void)Goback{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
