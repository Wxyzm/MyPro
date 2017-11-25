//
//  NewPhoneNumViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/8/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "NewPhoneNumViewController.h"

@interface NewPhoneNumViewController ()<UITextFieldDelegate>

@end

@implementation NewPhoneNumViewController{

    UITextField *_phoneTxt;
    UITextField *_yzmTxt;
    SubBtn *_yzmBtn;
//    NSString *_newsubSession;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe6e9ed);
    [self setBarBackBtnWithImage:nil];
    self.title = @"手机验证";
    [self initUI];

}

- (void)initUI{
    
    
    UIView *view = [BaseViewFactory viewWithFrame:CGRectMake(0, 12, ScreenWidth, 100) color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:view];
    [self createLineWithColor:UIColorFromRGB(0xe6e9ed) frame:CGRectMake(0, 49.5, ScreenWidth, 1) Super:view];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view Frame:CGRectMake(20, 0, 115, 50) Alignment:NSTextAlignmentLeft Text:@"新手机号"];
    
    _phoneTxt= [BaseViewFactory textFieldWithFrame:CGRectMake(115, 0, ScreenWidth - 115 -20, 50) font:APPFONT(15) placeholder:@"请输入手机号" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    [view addSubview:_phoneTxt];
    _phoneTxt.keyboardType = UIKeyboardTypeNumberPad;
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view Frame:CGRectMake(20, 50, 180, 50) Alignment:NSTextAlignmentLeft Text:@"短信验证码"];
    
    _yzmTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(115, 50, ScreenWidth - 115 - 103, 50) font:APPFONT(15) placeholder:@"短信验证码" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    [view addSubview:_yzmTxt];
    _yzmTxt.keyboardType = UIKeyboardTypeNumberPad;
    
    _yzmBtn = [SubBtn buttonWithtitle:@"获取验证码" backgroundColor:UIColorFromRGB(RedColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(yzmBtnClick)];
    _yzmBtn.titleLabel.font = APPFONT(13);
    [view addSubview:_yzmBtn];
    _yzmBtn.frame = CGRectMake(ScreenWidth - 103, 60, 83, 30);
    
    
    
    SubBtn *setBtn = [SubBtn buttonWithtitle:@"下一步" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(setBtnClick) andframe:CGRectMake(20, 212, ScreenWidth - 40, 50)];
    [self.view addSubview:setBtn];
    
    
}

- (void)yzmBtnClick{
    if (![self isMobileNumber:_phoneTxt.text]) {
        [self showTextHud:@"请输入正确的手机号码"];
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
                _yzmBtn.backgroundColor = UIColorFromRGB(RedColorValue);
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
                _yzmBtn.backgroundColor = UIColorFromRGB(0xaab2bd);
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client POST:@"/user/change-mobile/send-new-mobile-sms" dict:@{@"subSession":_subSession,@"mobileCountry":@"CN",@"mobileNumber":_phoneTxt.text} success:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]!=-1) {
            [self showTextHud:resultDic[@"message"]];
            return;
        }
        [self showTextHud:@"短信已发出，请注意查收"];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTextHud:@"网络错误"];
    }];



}

- (void)setBtnClick{
    if (_yzmTxt.text.length <=0) {
        [self showTextHud:@"请输入验证码"];
        return;
    }
    if (![self isMobileNumber:_phoneTxt.text]) {
        [self showTextHud:@"请输入正确的手机号码"];
        return;
    }
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client POST:@"/user/change-mobile/do-change-mobile" dict:@{@"subSession":_subSession,@"mobileCountry":@"CN",@"mobileNumber":_phoneTxt.text,@"smsCode":_yzmTxt.text} success:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]!=-1) {
            [self showTextHud:resultDic[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [[NSUserDefaults standardUserDefaults]setObject:_phoneTxt.text forKey:FYH_USER_ACCOUNT];

        [self showTextHud:@"手机号修改成功"];
        [self.navigationController popToRootViewControllerAnimated:YES];
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTextHud:@"网络错误"];
    }];


}
@end
