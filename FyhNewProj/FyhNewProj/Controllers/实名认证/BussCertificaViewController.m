//
//  BussCertificaViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BussCertificaViewController.h"
#import "JYAreaPickerView.h"
#import "JYDataPickerWindow.h"
#import "YLButton.h"
#import "MBProgressHUD.h"
@interface BussCertificaViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JYAreaPickerDelegate,JYDataPickerDelegate>

@property (nonatomic , strong) UITextField *ComNameTF;         //公司名称
@property (nonatomic , strong) UITextField *ComManNameTF;      //法人姓名
@property (nonatomic , strong) UITextField *IdNumberTF;        //身份证号
@property (nonatomic , strong) UITextField *BusLicenseTF;      //营业执照号
@property (nonatomic , strong) UITextField *BusRangeTF;        //经营范围
@property (nonatomic , strong) UITextField *RegistMoneyTF;     //注册资本
@property (nonatomic , strong) UITextField *OpenComNameTF;     //开户公司名称
@property (nonatomic , strong) UITextField *BankNumberTF;      //银行开户账户
@property (nonatomic , strong) UITextField *BankNameTF;         //银行名称
@property (nonatomic , strong) UIScrollView *myscrollview;

@property (nonatomic , strong) YLButton *ResidentBtn;        //法人身份
@property (nonatomic , strong) YLButton *EstablishBtn;       //成立日期
@property (nonatomic , strong) YLButton *BusinBtn;           //营业期限

@property (nonatomic , strong) YLButton *IDCardUpBtn;       //身份证正面
@property (nonatomic , strong) YLButton *IDCardDownBtn;     //身份证反面
@property (nonatomic , strong) YLButton *IicenseBtn;        //营业执照
@property (nonatomic , strong) YLButton *BankLocaBtn;       //银行所在地

@end

@implementation BussCertificaViewController{
    
        UIView                  *_nameview;         //显示view
        BOOL                    _keyBoardIsShow;
        UITextField             *_tempTxt;          //根据位置控制键盘弹起
        NSString                *_IdcardOnUrlStr;   //正面身份证照片网址
        NSString                *_IdcarddownUrlStr; //反面身份证照片网址
        NSString                *_BussUrlStr;       //营业执照网址
        UIImagePickerController *_imagePicker;      //图片选择器

        JYAreaPickerView        *_areaPicker;       //地址选择器
        JYDataPickerWindow      *_datePicker;       //时间选择器
        NSString                *_openDateStr;      //成立日期
        NSString                *_bussDateStr;      //营业期限

        NSString                *_bankAdressStr;    //银行地址
        NSInteger               _choseType;         //上传正面还是反面 1：正面 2：反面 3:执照
        NSInteger               _timeype;           //1成立日期 2营业期限
        BOOL                    _IdcardOnIsUp;      //身份证正面是否上传
        BOOL                    _IdcardDownIsUp;    //身份证反面是否上传
        BOOL                    _BussIsUp;          //身份证反面是否上传
        BOOL                    _areaPickIsShow;

}

-(UIScrollView *)myscrollview{
    if (!_myscrollview) {
        _myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
        _myscrollview.backgroundColor = UIColorFromRGB(0xf1f1f1);
    }
    return _myscrollview;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
    self.navigationItem.title = @"企业实名认证";
    [self setBarBackBtnWithImage:nil];


    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initUI{
    NSArray *strArr = @[@"*公司名称",@"*法人姓名",@"*法人身份",@"*身份证号",@"*营业执照号",@"*法人身份证正面照片",@"*法人身份证反面照片",@"*营业执照照片",@"*开户公司名",@"*银行开户账号",@"*开户银行所在地",@"*开户银行",];
    [self.view addSubview:self.myscrollview ];
    self.myscrollview.contentSize = CGSizeMake(10, strArr.count*42+130);

    _nameview = [[UIView alloc]initWithFrame:CGRectMake(0, 12, ScreenWidth, strArr.count*42)];
    _nameview.backgroundColor = [UIColor whiteColor];
    [self.myscrollview addSubview:_nameview];
    for (int i = 0; i<strArr.count; i++) {
        [self createLabelWith:UIColorFromRGB(0x333333) Font:FSYSTEMFONT(13) WithSuper:_nameview Frame:CGRectMake(15, 14+42*i, 150, 14) Alignment:NSTextAlignmentLeft Text:strArr[i]];
        [self createLineWithColor:UIColorFromRGB(0xb3b3b3) frame:CGRectMake(0, 41.5+42*i, ScreenWidth, 0.5) Super:_nameview];
    }

     _ComNameTF = [self txtFieldWithframe:CGRectMake(ScreenWidth-165,0,150, 42) andplaceholder:@"请输入公司名称"];
    _ComManNameTF = [self txtFieldWithframe:CGRectMake(ScreenWidth-165,42,150, 42) andplaceholder:@"请输入法人姓名"];
    _IdNumberTF = [self txtFieldWithframe:CGRectMake(ScreenWidth-165,42*3,150, 42) andplaceholder:@"请输入身份证号"];
    _BusLicenseTF = [self txtFieldWithframe:CGRectMake(ScreenWidth-165,42*4,150, 42) andplaceholder:@"请输入营业执照号"];
   // _BusRangeTF = [self txtFieldWithframe:CGRectMake(ScreenWidth-165,14+42*7,150, 14) andplaceholder:@"请输入经营范围"];
   // _RegistMoneyTF = [self txtFieldWithframe:CGRectMake(ScreenWidth-165,14+42*8,110, 14) andplaceholder:@"请输入"];
    _OpenComNameTF = [self txtFieldWithframe:CGRectMake(ScreenWidth-165,42*8,150, 42) andplaceholder:@"请输入开户公司名"];
    _BankNumberTF = [self txtFieldWithframe:CGRectMake(ScreenWidth-165,42*9,150, 42) andplaceholder:@"请输入账户"];
    _BankNameTF = [self txtFieldWithframe:CGRectMake(ScreenWidth-165,42*11,150, 42) andplaceholder:@"请输入支行名称"];
    // 法人身份
    _ResidentBtn = [self buttonwihtitle:@"身份证" frame:CGRectMake(ScreenWidth-105, 42*2, 90, 42) andtitleRect:CGRectMake(0, 12.5, 80, 15) imageRect:CGRectZero andtag:1001];
    [_nameview  addSubview:_ResidentBtn];
    
    //成立日期
//    _EstablishBtn = [self buttonwihtitle:@"请选择" frame:CGRectMake(ScreenWidth-105, 224, 90, 40) andtitleRect:CGRectMake(0, 12.5, 80, 15) imageRect:CGRectMake(80, 12.5, 9, 15) andtag:1002];
  //  [_myscrollview  addSubview:_EstablishBtn];
    
    //营业期限
//    _BusinBtn = [self buttonwihtitle:@"请选择" frame:CGRectMake(ScreenWidth-105, 266, 90, 40) andtitleRect:CGRectMake(0, 12.5, 80, 15) imageRect:CGRectMake(80, 12.5, 9, 15) andtag:1003];
//    [_myscrollview  addSubview:_BusinBtn];

    //身份证正面
    _IDCardUpBtn = [self buttonwihtitle:@"请上传照片" frame:CGRectMake(ScreenWidth-105, 42*5, 90, 42) andtitleRect:CGRectMake(0, 12.5, 80, 15) imageRect:CGRectMake(80, 12.5, 9, 15) andtag:1004];
    [_nameview  addSubview:_IDCardUpBtn];
    
    //身份证反面
    _IDCardDownBtn = [self buttonwihtitle:@"请上传照片" frame:CGRectMake(ScreenWidth-105, 42*6, 90, 42) andtitleRect:CGRectMake(0, 12.5, 80, 15) imageRect:CGRectMake(80, 12.5, 9, 15) andtag:1005];
    [_nameview  addSubview:_IDCardDownBtn];

    //营业执照照片
    _IicenseBtn = [self buttonwihtitle:@"请上传照片" frame:CGRectMake(ScreenWidth-105, 42*7, 90, 42) andtitleRect:CGRectMake(0, 12.5, 80, 15) imageRect:CGRectMake(80, 12.5, 9, 15) andtag:1006];
    [_nameview  addSubview:_IicenseBtn];
    
    //开户银行所在地
    _BankLocaBtn = [self buttonwihtitle:@"请选择" frame:CGRectMake(ScreenWidth-105, 42*10, 90, 42) andtitleRect:CGRectMake(0, 12.5, 80, 15) imageRect:CGRectMake(80, 12.5, 9, 15) andtag:1007];
    [_nameview  addSubview:_BankLocaBtn];
    SubBtn *setBtn = [SubBtn buttonWithtitle:@"提交" backgroundColor:UIColorFromRGB(0xc61616) titlecolor:UIColorFromRGB(0xffffff) cornerRadius:5 andtarget:self action:@selector(setUPUserAllInfo)];
    [_myscrollview addSubview:setBtn];
    setBtn.frame = CGRectMake(15, strArr.count*42+21, ScreenWidth - 30, 42);

}

#pragma mark ======= 提交

- (void)setUPUserAllInfo{
    if (![self IsIdentityCard:_IdNumberTF.text]) {
        [self showTextHud:@"请填写正确的身份证号码"];
        
        return;
    }
    if (_ComNameTF.text.length<=0||_ComManNameTF.text.length<=0||_IdNumberTF.text.length<=0||_BusLicenseTF.text.length<=0||_IdcardOnUrlStr.length<=0||_IdcarddownUrlStr.length<=0||_BussUrlStr.length<=0||_OpenComNameTF.text.length<=0||_BankNumberTF.text.length<=0||_bankAdressStr.length<=0||_BankNameTF.text.length<=0) {
        [self showTextHud:@"请将信息填写完整"];
        return;
    }
    
    
    NSDictionary *dic =
            @{
            @"corporateName":_ComNameTF.text,                   //公司名
            @"legalPersonName":_ComManNameTF.text,              //法人名字
            @"legalPersonIdentificationType":@"idCard",         //法人证件类型 idCard/passport
            @"legalPersonIdentificationNumber":_IdNumberTF.text, //法人证件号
            @"businessLicenseNumber":_BusLicenseTF.text,         //营业执照号
            @"businessLicensePicUrl":_BussUrlStr,                       //营业执照照片图片地址
            @"legalPersonIdentificationHeadPicUrl":_IdcardOnUrlStr,         //法人证件正面图片地址
            @"legalPersonIdentificationBackPicUrl":_IdcarddownUrlStr,         //法人证件反面图片地址
            @"bankAccountName":_OpenComNameTF.text,                             //银行开户公司名
            @"bankAccountNumber":_BankNumberTF.text,                           //银行开户帐号
            @"bankName":_BankNameTF.text,                      //开户银行名
            @"bankAddress":_bankAdressStr,                   //开户银行所在地

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
    
    
    NSLog(@"%@",dic);
    
    
}


#pragma mark ======= YLButtonClick

- (void)YLButtonClick:(YLButton *)button{
    
    switch (button.tag) {
        case 1001:
        {
            // 法人身份
            break;
        }
        case 1002:
        {
            //成立日期
            if (!_datePicker) {
                _datePicker = [[JYDataPickerWindow alloc] init];
                _datePicker.delegate = self;

            }
            _timeype = 1;
            [_datePicker show];
            break;
        }
        case 1003:
        {
            //营业期限
            if (!_datePicker) {
                _datePicker = [[JYDataPickerWindow alloc] init];
                _datePicker.delegate = self;
                
            }
            _timeype = 2;
            [_datePicker show];

            
            break;
        }
        case 1004:
        {
            //身份证正面
            if (_IdcardOnIsUp) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"身份证正面照片已提交，确定替换？" preferredStyle:UIAlertControllerStyleAlert];
                [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _choseType = 1;
                    [self chosePhoto];
                    
                }]];
                [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                _choseType = 1;
                [self chosePhoto];
                
            }
            break;
        }
        case 1005:
        {
            //身份证反面
            if (_IdcarddownUrlStr) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"身份证反面照片已提交，确定替换？" preferredStyle:UIAlertControllerStyleAlert];
                [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _choseType = 2;
                    [self chosePhoto];
                    
                }]];
                [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                _choseType = 2;
                [self chosePhoto];
                
            }

            break;
        }
        case 1006:
        {
            //营业执照照片
            if (_BussUrlStr) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"营业执照照片件已提交，确定替换？"preferredStyle:UIAlertControllerStyleAlert];
                [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    _choseType = 3;
                    [self chosePhoto];
                    
                }]];
                [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                }]];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                _choseType = 3;
                [self chosePhoto];
                
            }

            break;
        }
        case 1007:
        {
            //开户银行所在地
            [self presentAreaPicker];
            break;
        }
        default:
            break;
    }
    
    
}
#pragma mark ======== 时间选择

- (void)DataPickerWindowbaocunBtnCilck{
    [_datePicker cancelPicker];
    if (_timeype == 1) {
        NSLog(@"成立时间 ====== %@-%@-%@",_datePicker.selectedYear,_datePicker.selectedMonth,_datePicker.selectedDay);
        NSString *timeStr = [NSString stringWithFormat:@"%@-%@-%@",_datePicker.selectedYear,_datePicker.selectedMonth,_datePicker.selectedDay];
        _openDateStr = timeStr;
        [_EstablishBtn setTitle:timeStr forState:UIControlStateNormal];

    }else if (_timeype == 2){
        NSLog(@"营业期限 ====== %@-%@-%@",_datePicker.selectedYear,_datePicker.selectedMonth,_datePicker.selectedDay);
        NSString *timeStr = [NSString stringWithFormat:@"%@-%@-%@",_datePicker.selectedYear,_datePicker.selectedMonth,_datePicker.selectedDay];
        _bussDateStr = timeStr;
        [_BusinBtn setTitle:timeStr forState:UIControlStateNormal];
    
    }

}

#pragma mark ======== 地址选择

- (void)presentAreaPicker
{
    [self.myscrollview endEditing:YES];
    if (!_areaPicker) {
        _areaPicker = [[JYAreaPickerView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 168) type:AreaNoBuXian
                                               includeContory:NO];
        _areaPicker.delegate = self;
    }
    if (!_areaPickIsShow) {
        [_areaPicker showInView:self.view];
        _areaPickIsShow = YES;
        _BankLocaBtn.userInteractionEnabled = NO;
        
    }}
- (void)hideKeyBoard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (_areaPickIsShow) {
        [_areaPicker cancelPicker];
        _BankLocaBtn.userInteractionEnabled = YES;
        _areaPickIsShow = NO;
    }
    
}
#pragma mark--------------------------------JYAreaPickerDelegate--------------------------------
- (void)pickerDidChaneStatus:(JYAreaPickerView *)picker
{
    if (picker == _areaPicker) {
        NSString *areaString = [NSString stringWithFormat:@"%@%@%@", _areaPicker.locate.state, _areaPicker.locate.city,
                                _areaPicker.locate.district];
        
        _bankAdressStr =  areaString;
        NSLog(@"银行开户地址=====%@",_bankAdressStr);
        [_BankLocaBtn setTitle:@"已选择" forState:UIControlStateNormal];
    }
}


#pragma mark--------------------------------UIActionDelegate--------------------------------


#pragma mark  ======= 相片选择
/**
 选择照片
 */
- (void)chosePhoto{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
        _imagePicker.delegate = self;
    }
    UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0:
            // Take a photo directly!
            [self pickImageFromCamera];
            break;
        case 1:
            // Pick one from library.
            [self pickImageFromAlbum];
            break;
        default:
            break;
    }
}

#pragma mark 从摄像头获取活动图片
- (void)pickImageFromCamera
{
    _imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (iPad) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }else{
        
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}
#pragma mark 从用户相册获取活动图片
- (void)pickImageFromAlbum
{
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    _imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    _imagePicker.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    if (iPad) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self presentViewController:_imagePicker animated:YES completion:nil];
        }];
    }else{
        
        [self presentViewController:_imagePicker animated:YES completion:nil];
    }
}

#pragma imagePicekr
//点击相册中的图片or照相机照完后点击use  后触发的方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (!image) {
        return;
    }
    NSData * imageData = [self scaleImage:image toKb:1024];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyyMMddHHmmss";
    NSString *str = [formatter stringFromDate:[NSDate date]];
    NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
    NSDictionary *dataDict = @{@"image":imageData};
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self showLoadHUDMsg:@"正在上传图片"];
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval a=[dat timeIntervalSince1970];
    NSString *timeString = [NSString stringWithFormat:@"%.0f", a];
    [manager.requestSerializer setValue:@"FYHIOS" forHTTPHeaderField:@"FYH-App-Key"];
    [manager.requestSerializer setValue:timeString forHTTPHeaderField:@"FYH-App-Timestamp"];
    [manager.requestSerializer setValue:@"multipart/form-data" forHTTPHeaderField:@"Content-Type"];
    //用的是测试的
    [manager.requestSerializer setValue:@"oIkBLWG4OUHTgYmN" forHTTPHeaderField:@"FYH-App-Signature"];
    //需要在登录后获取 存于本地  注意在用户登出时清掉
    if ([HTTPClient getUserSessiond]) {
        [manager.requestSerializer setValue:[HTTPClient getUserSessiond] forHTTPHeaderField:@"FYH-Session-Id"];
    }
    
    __weak BussCertificaViewController * weakself = self;
    
    [manager POST:[NSString stringWithFormat:@"%@/user/upload-images?imageType=",kbaseUrl] parameters:dataDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [weakself hideLoadHUD];
        NSDictionary  *jsonDic = [NSJSONSerialization  JSONObjectWithData:responseObject options:0 error:nil];
        NSArray *returnArr = jsonDic[@"data"][@"imageUrls"];
        if (_choseType == 1) {
            //身份证正面
            _IdcardOnUrlStr = returnArr[0];
            _IdcardOnIsUp = YES;
            [_IDCardUpBtn setTitle:@"照片已上传" forState:UIControlStateNormal];
            [_IDCardUpBtn setTitleColor:UIColorFromRGB(0xc61616) forState:UIControlStateNormal];
        }else if (_choseType == 2){
            //身份证反面
            _IdcarddownUrlStr = returnArr[0];
            _IdcardDownIsUp = YES;
            [_IDCardDownBtn setTitle:@"照片已上传" forState:UIControlStateNormal];
            [_IDCardDownBtn setTitleColor:UIColorFromRGB(0xc61616) forState:UIControlStateNormal];
            
        }else if (_choseType == 3){
            //身份证反面
            _BussUrlStr = returnArr[0];
            _BussIsUp = YES;
            [_IicenseBtn setTitle:@"照片已上传" forState:UIControlStateNormal];
            [_IicenseBtn setTitleColor:UIColorFromRGB(0xc61616) forState:UIControlStateNormal];
            
        }
        
        NSLog(@"%@=======%@=======%@",_IdcardOnUrlStr,_IdcarddownUrlStr,_BussUrlStr);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [weakself hideLoadHUD];
        NSLog(@"%@",error);
    }];
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark  ======= 压缩图片至1m以内用于上传
/**
 压缩图片返回data
 @param image 传入图片
 @param kb 压缩至1M（1024kb）
 @return 压缩后的图片转化的base64编码
 */
- (NSData *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    kb*=300;
    CGFloat compression = 0.9f;
    CGFloat maxCompression = 0.1f;
    NSData *imageData = UIImageJPEGRepresentation(image, compression);
    NSLog(@"原始大小:%fkb",(float)[imageData length]/1024.0f);
    while ([imageData length] > kb && compression > maxCompression) {
        compression -= 0.1;
        imageData = UIImageJPEGRepresentation(image, compression);
    }
    NSLog(@"当前大小:%fkb",(float)[imageData length]/1024.0f);
    //    UIImage *compressedImage = [UIImage imageWithData:imageData];
    return imageData;
}

#pragma mark ========= webview使用MBProgressHUD

//正在加载提示
- (void)showLoadHUDMsg:(NSString *)msg{
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.label.text = msg;
    
}

//隐藏加载提示
- (void)hideLoadHUD{
    
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
}



- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _tempTxt = textField;
    return YES;
}



#pragma mark ======== YLbtn
- (YLButton *)buttonwihtitle:(NSString *)title frame:(CGRect)frame andtitleRect:(CGRect)frame1  imageRect:(CGRect)frame2 andtag:(NSInteger)btnTag{

    YLButton *  btn = [YLButton buttonWithType:UIButtonTypeCustom];
    if (btnTag == 1001) {
        
    }else{
        [btn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];

    }
//    [btn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [btn setTitle:title forState:UIControlStateNormal];
    [btn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    btn.titleLabel.font = [UIFont systemFontOfSize:13];
    btn.titleRect = frame1;//CGRectMake(0, 12.5, 80, 15);
    btn.imageRect = frame2;//CGRectMake(80, 12.5, 9, 15);
    btn.frame = frame;//CGRectMake(ScreenWidth-105, 212, 90, 40);
    btn.tag = btnTag;
    [btn addTarget:self action:@selector(YLButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    return btn;
}



- (UITextField *)txtFieldWithframe:(CGRect)frame andplaceholder:(NSString *)str{

  UITextField*  txtField=[[UITextField alloc] initWithFrame:frame];
    txtField.placeholder=str;
    UILabel * placeholderLabel = [txtField valueForKey:@"_placeholderLabel"];
    placeholderLabel.textAlignment = NSTextAlignmentRight;

    txtField.textAlignment = NSTextAlignmentRight;
    txtField.textColor=[UIColor blackColor];
    txtField.font=FSYSTEMFONT(13);
    txtField.autocorrectionType=UITextAutocorrectionTypeNo;
    txtField.autocapitalizationType=UITextAutocapitalizationTypeNone;
    txtField.delegate=self;
    [_nameview addSubview:txtField];
    return txtField;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==_IdNumberTF) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (_IdNumberTF.text.length>=18) {
            return NO;
        }
    }
    
    return YES;
}
@end
