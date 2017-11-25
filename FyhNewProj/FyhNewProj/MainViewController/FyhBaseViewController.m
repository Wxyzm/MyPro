//
//  FyhBaseViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/2.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "FyhBaseViewController.h"
#import "MBProgressHUD.h"
#import "User.h"
@interface FyhBaseViewController ()
//@property(strong, nonatomic)MBProgressHUD *HUD;
@end

@implementation FyhBaseViewController

- (void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGr.cancelsTouchesInView = NO;
    self.automaticallyAdjustsScrollViewInsets = NO;

    [self.view addGestureRecognizer:tapGr];

//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}



- (void)setBarBackBtnWithImage:(UIImage *)image
{
    UIImage *backImg;
    if (image == nil) {
        backImg = [UIImage imageNamed:@"back-white"];
    } else {
        backImg = image;
    }
   // CGFloat height = 17;
  //  CGFloat width = height * backImg.size.width / backImg.size.height;
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 20, 34)];
   // [button setBackgroundImage:backImg forState:UIControlStateNormal];
    [button setImage:backImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(respondToLeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.leftBarButtonItem = left;
}
- (void)hideBarbackBtn
{
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [backBtn addTarget:self action:@selector(hideBackBtnPress) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    left.title = @"";
    self.navigationItem.leftBarButtonItem = left;
}

- (void)hideBackBtnPress {
}

-(void)createLabelWith:(UIColor *)color Font:(UIFont *)font WithSuper:(UIView *)superView Frame:(CGRect)frame Alignment:(NSTextAlignment)alignment Text:(NSString *)text{
    UILabel *myLabel = [[UILabel alloc] initWithFrame:frame];
    myLabel.textColor = color;
    myLabel.textAlignment = alignment;
    myLabel.text = text;
    myLabel.font = font;
    myLabel.numberOfLines = 0;
    myLabel.backgroundColor = [UIColor clearColor];
    [superView addSubview: myLabel];

}

- (void)createLineWithColor:(UIColor *)color frame:(CGRect)frame Super: (UIView *)superView{
    UIView *line = [[UIView alloc] initWithFrame:frame];
    line.backgroundColor = color;
    [superView addSubview:line];
}
- (void)respondToLeftButtonClickEvent
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)showTextHud:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.hidden = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hideAnimated:YES afterDelay:1.5];
    [self performSelector:@selector(hideHUD:) withObject:hud afterDelay:1.5];
}
- (void)showTextHudInSelfView:(NSString*)msg {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.hidden = NO;
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.margin = 10.0f;
    hud.removeFromSuperViewOnHide = YES;
     [hud hideAnimated:YES afterDelay:1.5];
    [self performSelector:@selector(hideHUD:) withObject:hud afterDelay:1.5];
}
-(void) hideHUD:(MBProgressHUD*) progress {
    __block MBProgressHUD* progressC = progress;
    dispatch_async(dispatch_get_main_queue(), ^{
        [progressC hideAnimated:YES afterDelay:0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       ];

        [progressC hideAnimated:YES];
        progressC = nil;
    });
}
/**
 判断字符串是否包含空格

 @param str 字符串
 @return yes代表包含空格
 */
-(BOOL)isEmpty:(NSString *) str {
    NSRange range = [str rangeOfString:@" "];
    if (range.location != NSNotFound) {
        return YES; //yes代表包含空格
    }else {
        return NO; //反之
    }
}

/**
 判断手机号的正则表达式

 @param mobileNum mobileNum description
 @return return value description
 */
- (BOOL)isMobileNumber:(NSString *)mobileNum
{
    /**
     * 手机号码
     * 移动：134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     * 联通：130,131,132,152,155,156,185,186
     * 电信：133,1349,153,180,189
     */
    NSString * MOBILE = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    /**
     10         * 中国移动：China Mobile
     11         * 134[0-8],135,136,137,138,139,150,151,157,158,159,182,187,188
     12         */
    NSString * CM = @"^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$";
    /**
     15         * 中国联通：China Unicom
     16         * 130,131,132,152,155,156,185,186
     17         */
    NSString * CU = @"^1(3[0-2]|5[256]|8[56])\\d{8}$";
    /**
     20         * 中国电信：China Telecom
     21         * 133,1349,153,180,189,77
     22         */
    NSString * CT = @"^1((33|53|8[09]|77)[0-9]|349)\\d{7}$";
    /**
     25         * 大陆地区固话及小灵通
     26         * 区号：010,020,021,022,023,024,025,027,028,029
     27         * 号码：七位或八位
     28         */
    // NSString * PHS = @"^0(10|2[0-5789]|\\d{3})\\d{7,8}$";
    
    NSPredicate *regextestmobile = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", MOBILE];
    NSPredicate *regextestcm = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM];
    NSPredicate *regextestcu = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU];
    NSPredicate *regextestct = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT];
    
    if (([regextestmobile evaluateWithObject:mobileNum] == YES)
        || ([regextestcm evaluateWithObject:mobileNum] == YES)
        || ([regextestct evaluateWithObject:mobileNum] == YES)
        || ([regextestcu evaluateWithObject:mobileNum] == YES))
    {
        return YES;
    }
    else
    {
        return NO;
    }
}


- (int)convertToByte:(NSString*)str {
    int strlength = 0;
    char* p = (char*)[str cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[str lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
    }
    return (strlength+1)/2;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}
- (void)hideKeyBoard {
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
}
//用scrollView 替换 self.view
- (void)createBackScrollView
{
    _backView = [[BaseScrollView alloc] initWithFrame:self.view.bounds];
    _backView.backgroundColor = UIColorFromRGB(0xf1f1f1);
//    _backView.scrollEnabled = NO;
    self.view = _backView;
    self.edgesForExtendedLayout = UIRectEdgeAll;
    UITapGestureRecognizer *tapGr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideKeyBoard)];
    tapGr.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGr];
}



- (void)gotoLoginViewController{
            MemberLoginController *vc = [[MemberLoginController alloc] init];
            vc.type = 2;
            DOHNavigationController *navigationController = [[DOHNavigationController alloc] initWithRootViewController:vc];
            [self presentViewController:navigationController animated:YES completion:^{}];
    
        
}



- (YLButton *)buttonWithtitle:(NSString *)title imagename:(NSString *)imageName andtextColor:(UIColor*)color font:(UIFont*)font textAli:(NSTextAlignment)Alignment titleFrame:(CGRect)titleFrame andImageFrame:(CGRect)imageFrame{
    
    YLButton *btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleRect:titleFrame];
    [btn setImageRect:imageFrame];
    btn.titleLabel.font = font;
    btn.titleLabel.textAlignment = Alignment;

    return btn;
}

//词典转换为字符串
- (NSString*)thedictionaryToJson:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (BOOL)ChatManiSHisSelfwithHisId:(NSString *)idStr{
    
  
    if ( [[[NSUserDefaults standardUserDefaults] objectForKey:FYH_USER_ID] isEqualToString:idStr]   ) {
        return YES;
    }
    return NO;
}
  
/**
 身份证

 @param IDCardNumber IDCardNumber description
 @return return value description
 */
- (BOOL) IsIdentityCard:(NSString *)IDCardNumber
{
    
    if (IDCardNumber.length <= 0) {
        return NO;
    }
    //长度不为18的都排除掉
//    if (IDCardNumber.length!=18) {
//        return NO;
//    }
    
    //校验格式
    NSString *regex2 = @"^(^[1-9]\\d{7}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])\\d{3}$)|(^[1-9]\\d{5}[1-9]\\d{3}((0\\d)|(1[0-2]))(([0|1|2]\\d)|3[0-1])((\\d{4})|\\d{3}[Xx])$)$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    BOOL flag = [identityCardPredicate evaluateWithObject:IDCardNumber];
    
    if (!flag) {
        return flag;    //格式错误
    }else {
        //格式正确在判断是否合法
        
        //将前17位加权因子保存在数组里
        NSArray * idCardWiArray = @[@"7", @"9", @"10", @"5", @"8", @"4", @"2", @"1", @"6", @"3", @"7", @"9", @"10", @"5", @"8", @"4", @"2"];
        
        //这是除以11后，可能产生的11位余数、验证码，也保存成数组
        NSArray * idCardYArray = @[@"1", @"0", @"10", @"9", @"8", @"7", @"6", @"5", @"4", @"3", @"2"];
        
        //用来保存前17位各自乖以加权因子后的总和
        NSInteger idCardWiSum = 0;
        for(int i = 0;i < 17;i++)
        {
            NSInteger subStrIndex = [[IDCardNumber substringWithRange:NSMakeRange(i, 1)] integerValue];
            NSInteger idCardWiIndex = [[idCardWiArray objectAtIndex:i] integerValue];
            
            idCardWiSum+= subStrIndex * idCardWiIndex;
            
        }
        
        //计算出校验码所在数组的位置
        NSInteger idCardMod=idCardWiSum%11;
        
        //得到最后一位身份证号码
        NSString * idCardLast= [IDCardNumber substringWithRange:NSMakeRange(17, 1)];
        
        //如果等于2，则说明校验码是10，身份证号码最后一位应该是X
        if(idCardMod==2)
        {
            if([idCardLast isEqualToString:@"X"]||[idCardLast isEqualToString:@"x"])
            {
                return YES;
            }else
            {
                return NO;
            }
        }else{
            //用计算出的验证码与最后一位身份证号码匹配，如果一致，说明通过，否则是无效的身份证号码
            if([idCardLast isEqualToString: [idCardYArray objectAtIndex:idCardMod]])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    
  
}

@end
