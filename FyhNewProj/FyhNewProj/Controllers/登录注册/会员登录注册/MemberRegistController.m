//
//  MemberRegistController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MemberRegistController.h"
#import "XieYiController.h"
#import "YLButton.h"
#import "YzmPL.h"
#import "UserPL.h"
@interface MemberRegistController ()<UITextFieldDelegate>
@property (nonatomic,strong)UITextField *UserPhoneTxt;  //手机号

@property (nonatomic,strong)UITextField *YZMTxt;        //验证码

@property (nonatomic,strong)UITextField *NewPwd;        //新密码

@property (nonatomic,strong)UITextField *SurePwd;       //确认密码

@end

@implementation MemberRegistController{
    SubBtn    *_yzmBtn;            //获取验证码按钮
    SelectBtn *_protoBtn;          //协议按钮
      YLButton  *_selectBtn;         //协议
    BOOL    _isSuccess;
    dispatch_source_t _timer ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
//    self.navigationItem.title = @"快速注册";
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext:@"快速注册"];
    self.navigationItem.titleView = titlelab;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];

    [self setUP];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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
    
    _UserPhoneTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(13) placeholder:@"请输入您的手机号" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    _UserPhoneTxt.keyboardType = UIKeyboardTypePhonePad;
    _YZMTxt = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(13) placeholder:@"请输入您的验证码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    _YZMTxt.keyboardType = UIKeyboardTypePhonePad;
    _NewPwd = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(13) placeholder:@"请输入您的密码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    _NewPwd.secureTextEntry = YES;
    _NewPwd.keyboardType = UIKeyboardTypeASCIICapable;
    _SurePwd = [BaseViewFactory textFieldWithFrame:CGRectZero font:APPFONT(13) placeholder:@"6-20位字母与数字的组合" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(PlaColorValue) delegate:self];
    _SurePwd.keyboardType = UIKeyboardTypeASCIICapable;
    _SurePwd.secureTextEntry = YES;

    NSArray *txtArr = @[_UserPhoneTxt,_YZMTxt,_NewPwd,_SurePwd];
    NSArray *titleArr = @[@"账号",@"验证码",@"密码",@"确认密码"];
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
            _yzmBtn = [SubBtn buttonWithtitle:@"获取验证码" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:14.5 andtarget:self action:@selector(getYzm) andframe: CGRectMake(CGRectGetMaxX(txt.frame)+20, 65*i+18, 80, 29)];
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
    
    _selectBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    _selectBtn.titleLabel.font =APPFONT(13);
    _selectBtn.on = YES;
    [_selectBtn setTitle:@"我已阅读并同意遵守" forState:UIControlStateNormal];
    [_selectBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_selectBtn setImage:[UIImage imageNamed:@"select-s"] forState:UIControlStateNormal];
    [self.view addSubview:_selectBtn];
    [_selectBtn addTarget:self action:@selector(selectedBtnClick) forControlEvents:UIControlEventTouchUpInside];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:13],};
    CGSize textSize = [@"我已阅读并同意遵守" boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    _selectBtn.frame = CGRectMake(35,  CGRectGetMaxY(bgview.frame)+40, textSize.width+24, 18);
    [_selectBtn setImageRect:CGRectMake(0, 1, 17, 16)];
    [_selectBtn setTitleRect:CGRectMake(24, 0, textSize.width, 18)];
    
    
    YLButton *messageBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    messageBtn.titleLabel.font =APPFONT(13);
    [messageBtn setTitle:@"《商城入驻协议》" forState:UIControlStateNormal];
    messageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [messageBtn setTitleColor:UIColorFromRGB(RedColorValue) forState:UIControlStateNormal];
    [self.view addSubview:messageBtn];
    messageBtn.frame = CGRectMake(CGRectGetMaxX(_selectBtn.frame)+5, CGRectGetMaxY(bgview.frame)+40 , 120, 18);
    [messageBtn addTarget:self action:@selector(messagrBtnClick) forControlEvents:UIControlEventTouchUpInside];

//    SubBtn *setBtn = [SubBtn buttonWithtitle:@"立即注册" backgroundColor:UIColorFromRGB(GaryBtnColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(completeBtnClick)];
//  
    SubBtn *setBtn = [SubBtn buttonWithtitle:@"立即注册" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(completeBtnClick) andframe:CGRectMake(35, CGRectGetMaxY(bgview.frame)+80, ScreenWidth - 70, 50)];
    setBtn.titleLabel.font = APPFONT(18);
    [self.view addSubview:setBtn];
    
    
    setBtn.frame =CGRectMake(35, CGRectGetMaxY(bgview.frame)+80, ScreenWidth - 70, 50);
}






- (void)selectedBtnClick{
    _selectBtn.on = !_selectBtn.on;
    if (_selectBtn.on) {
        [_selectBtn setImage:[UIImage imageNamed:@"select-s"] forState:UIControlStateNormal];

    }else{
        [_selectBtn setImage:[UIImage imageNamed:@"select-u"] forState:UIControlStateNormal];

    }
}

- (void)messagrBtnClick{

    XieYiController *xyVc = [[XieYiController alloc]init];
    xyVc.Type = 1;
    [self.navigationController pushViewController:xyVc animated:YES];
    
    

}

/**
 发送验证码
 */
- (void)getYzm{
    
    if (_UserPhoneTxt.text.length <=0) {
        [self showTextHud:@"请输入手机号码"];
        return;
    }
    if (![self isMobileNumber:_UserPhoneTxt.text]) {
        [self showTextHud:@"请输入正确的手机号码"];
        return;
    }
    __block int timeout=119; // Time block.
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _timer  = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
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
            //    _yzmBtn.titleLabel.alpha = 1.0f;
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
                  //  _yzmBtn.titleLabel.alpha = 0.5;
                });
                timeout--;
            
           
        }
    });
    dispatch_resume(_timer);
    
    
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client getUserSubSessionwithReturnBlock:^(id returnValue) {
        NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
        if ([dic[@"code"] intValue]==-1) {
            NSDictionary *dataDic = dic[@"data"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithCapacity:0];
            dict[@"mobileCountry"] = @"CN";
            dict[@"mobileNumber"] = _UserPhoneTxt.text;
            dict[@"subSession"] = dataDic[@"subSession"];
            [[NSUserDefaults  standardUserDefaults] setObject:dict[@"subSession"] forKey:FYHSubSession];
            [[NSUserDefaults  standardUserDefaults] setObject:dict[@"sessionId"] forKey:FYHSessionId];

            [client sendRegisterSMSWuthInfoDic:dict withReturnBlock:^(id returnValue) {
                NSDictionary *smsdic = [HTTPClient valueWithJsonString:returnValue];

                if ([smsdic[@"code"] intValue]==-1){
                    [self showTextHud:@"短信已发出，请注意查收"];
                }else{
                    [self showTextHud:smsdic[@"message"]];
                    [_yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                    // You can tap now if necessary.
                    _yzmBtn.userInteractionEnabled = YES;
                    _yzmBtn.titleLabel.alpha = 1.0f;
//                    if(_timer){
//                        dispatch_source_cancel(_timer);
//                        _timer = nil;
//                    }
                }
            } andErrorBlock:^(NSString *msg) {
                [_yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
                // You can tap now if necessary.
                _yzmBtn.userInteractionEnabled = YES;
                _yzmBtn.titleLabel.alpha = 1.0f;
//                if(_timer){
//                    dispatch_source_cancel(_timer);
//                    _timer = nil;
//                }
                [self showTextHud:msg];
            }];
        }else{
            [_yzmBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            // You can tap now if necessary.
            _yzmBtn.userInteractionEnabled = YES;
            _yzmBtn.titleLabel.alpha = 1.0f;
//            if(_timer){
//                dispatch_source_cancel(_timer);
//                _timer = nil;
//            }
            [self showTextHud:dic[@"message"]];
            
        }
        
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    

    }

/**
 立即注册
 */
- (void)completeBtnClick{
    if (_UserPhoneTxt.text.length <=0) {
        [self showTextHud:@"请输入手机号码"];
        return;
    }
    if (_YZMTxt.text.length <=0) {
        [self showTextHud:@"请输入验证码"];
        return;
    }
    if (_NewPwd.text.length <6||_NewPwd.text.length >=20) {
        [self showTextHud:@"密码需要6-20位字母数字组合"];
        return;
    }
    if (![self isMobileNumber:_UserPhoneTxt.text]) {
        [self showTextHud:@"请输入正确的手机号码"];
        return;
    }
    int a = [self checkIsHaveNumAndLetter:_NewPwd.text];
    if (a != 3) {
        [self showTextHud:@"密码需要6-20位字母数字组合"];
        return;
    }
    if ( !_selectBtn.on) {
        [self showTextHud:@"请同意商城入驻协议"];
        return;
    }
    if (![[NSUserDefaults standardUserDefaults]objectForKey:FYHSubSession]) {
        [self showTextHud:@"请获取验证码"];

        return;
    }
    NSDictionary *infoDic = @{@"mobileCountry":@"CN",
                              @"mobileNumber":_UserPhoneTxt.text,
                              @"subSession":[[NSUserDefaults standardUserDefaults]objectForKey:FYHSubSession],
                              @"password":_NewPwd.text,
                              @"smsCode":_YZMTxt.text,
                              };
    
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client UserRegisterWithInfoDic:infoDic withReturnBlock:^(id returnValue) {
        NSDictionary *returnDic = [HTTPClient valueWithJsonString:returnValue];
        if ([returnDic[@"code"] intValue]== -1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"userLoginIn" object:nil userInfo:nil];
            [self showTextHud:@"注册成功"];
            [self.navigationController popToRootViewControllerAnimated:YES];
        }else{
            [self showTextHud:returnDic[@"message"]];
        }
        
    } andErrorBlock:^(NSString *msg) {
         [self showTextHud:msg];
    }];
    
}

/**
 选则协议
 */
- (void)protoSelect{
    _protoBtn.on  = !_protoBtn.on;
    if ( _protoBtn.on) {
        [_protoBtn setBackgroundImage:[UIImage imageNamed:@"勾选x2626"] forState:UIControlStateNormal];

    }else{
        [_protoBtn setBackgroundImage:[UIImage imageNamed:@"勾选未x2626"] forState:UIControlStateNormal];
    }

}

/**
 查看协议详情
 */
- (void)gotoProtodetail{

    XieYiController *xieYiVc = [[XieYiController alloc]init];
    xieYiVc.Type = 1;
    [self.navigationController pushViewController:xieYiVc animated:YES];

  
}


/**
 判断密码数字和字母

 @param password 密码
 @return 1全部符合数字 2全部符合英文 3符合英文和符合数字条件的相加等于密码长度 4可能包含标点符号的情況，或是包含非英文的文字
 */
-(int)checkIsHaveNumAndLetter:(NSString*)password{
    //数字条件
    NSRegularExpression *tNumRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[0-9]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合数字条件的有几个字节
    NSUInteger tNumMatchCount = [tNumRegularExpression numberOfMatchesInString:password
                                                                       options:NSMatchingReportProgress
                                                                         range:NSMakeRange(0, password.length)];
    
    //英文字条件
    NSRegularExpression *tLetterRegularExpression = [NSRegularExpression regularExpressionWithPattern:@"[A-Za-z]" options:NSRegularExpressionCaseInsensitive error:nil];
    
    //符合英文字条件的有几个字节
    NSUInteger tLetterMatchCount = [tLetterRegularExpression numberOfMatchesInString:password options:NSMatchingReportProgress range:NSMakeRange(0, password.length)];
    
    if (tNumMatchCount == password.length) {
        //全部符合数字，表示沒有英文
        return 1;
    } else if (tLetterMatchCount == password.length) {
        //全部符合英文，表示沒有数字
        return 2;
    } else if (tNumMatchCount + tLetterMatchCount == password.length) {
        //符合英文和符合数字条件的相加等于密码长度
        return 3;
    } else {
        return 4;
        //可能包含标点符号的情況，或是包含非英文的文字，这里再依照需求详细判断想呈现的错误
    }
    
}
@end
