//
//  ChangePhoneViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/8/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "ChangePhoneViewController.h"
#import "NewPhoneNumViewController.h"


@interface ChangePhoneViewController ()<UITextFieldDelegate>

@end

@implementation ChangePhoneViewController{

    NSString *_subSession;
    NSString *_phoneNumber;
    UITextField *_yzmTxt;
    SubBtn *_yzmBtn;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xe6e9ed);
    [self setBarBackBtnWithImage:nil];
    self.title = @"修改手机号";
    [self loadPhone];
}

- (void)initUI{


    UIView *view = [BaseViewFactory viewWithFrame:CGRectMake(0, 12, ScreenWidth, 100) color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:view];
    [self createLineWithColor:UIColorFromRGB(0xe6e9ed) frame:CGRectMake(0, 49.5, ScreenWidth, 1) Super:view];
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view Frame:CGRectMake(20, 0, 180, 50) Alignment:NSTextAlignmentLeft Text:@"验证码将发送至手机号"];
    
    NSMutableString *numberStr = [[NSMutableString alloc]initWithString:_phoneNumber];
    if (_phoneNumber.length >7) {
        [numberStr replaceCharactersInRange:NSMakeRange(3, 4) withString:@"****"];

    }
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:view Frame:CGRectMake(ScreenWidth - 200, 0, 180, 50) Alignment:NSTextAlignmentRight Text:numberStr];
    
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

- (void)loadPhone{

[[HTTPClient sharedHttpClient] GET:@"/user/change-mobile" dict:nil success:^(NSDictionary *resultDic) {
    NSLog(@"%@",resultDic);
    if ([resultDic[@"code"] intValue]!=-1) {
        [self showTextHud:resultDic[@"message"]];
        [self.navigationController popViewControllerAnimated:YES];
        return;
    }
    _phoneNumber = resultDic[@"data"][@"oldMobileNumber"];
    _subSession =resultDic[@"data"][@"subSession"];
    [self initUI];

} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    [self showTextHud:@"网络错误"];
    [self.navigationController popViewControllerAnimated:YES];
}];


}


/**
 提交
 */
- (void)setBtnClick{
    if (_yzmTxt.text.length <=0) {
        [self showTextHud:@"请输入验证码"];
        return;
    }
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client POST:@"/user/change-mobile/do-check-old-mobile-sms" dict:@{@"subSession":_subSession,@"smsCode":_yzmTxt.text} success:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]!=-1) {
            [self showTextHud:resultDic[@"message"]];
            return;
        }
        NewPhoneNumViewController *phoVc = [[NewPhoneNumViewController alloc]init];
        phoVc.subSession = resultDic[@"data"][@"subSession"];
        [self.navigationController pushViewController:phoVc animated:YES];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTextHud:@"网络错误"];

    }];





}

/**
 获取验证码
 */
- (void)yzmBtnClick{
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
                _yzmBtn.backgroundColor = UIColorFromRGB(RedColorValue);

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
    [client POST:@"/user/change-mobile/send-old-mobile-sms" dict:@{@"subSession":_subSession} success:^(NSDictionary *resultDic) {
        if ([resultDic[@"code"] intValue]!=-1) {
            [self showTextHud:resultDic[@"message"]];
            [self.navigationController popViewControllerAnimated:YES];
            return;
        }
        [self showTextHud:@"短信已发出，请注意查收"];

        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showTextHud:@"网络错误"];
    }];


}

@end
