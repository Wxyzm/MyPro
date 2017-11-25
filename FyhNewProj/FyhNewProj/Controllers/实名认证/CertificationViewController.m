//
//  CertificationViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CertificationViewController.h"
#import "JYAreaPickerView.h"
#import "MBProgressHUD.h"
#import "YLButton.h"


@interface CertificationViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,JYAreaPickerDelegate>

@property (nonatomic , strong) UIScrollView *myscrollview;

@property (nonatomic , strong) UITextField *nameTF;         //姓名
@property (nonatomic , strong) UITextField *addTF;          //地址
@property (nonatomic , strong) UITextField *IdcardTF;       //身份证号
@property (nonatomic , strong) UITextField *openNameTF;     //开户人姓名
@property (nonatomic , strong) UITextField *openAccountTF;  //开户账号
@property (nonatomic , strong) UITextField *openBankTF;     //开户银行名

@property (nonatomic , strong) YLButton *IDCardUpBtn;       //身份证正面
@property (nonatomic , strong) YLButton *IDCardDownBtn;     //身份证反面
@property (nonatomic , strong) YLButton *BankLocaBtn;       //银行所在地




@end

@implementation CertificationViewController{
    BOOL                    _IdcardOnIsUp;      //身份证正面是否上传
    BOOL                    _IdcardDownIsUp;    //身份证反面是否上传
    UIImagePickerController *_imagePicker;      //图片选择器
    NSInteger               _choseType;         //上传正面还是反面 1：正面 2：反面
    NSString                *_IdcardOnUrlStr;   //正面身份证照片网址
    NSString                *_IdcarddownUrlStr; //反面身份证照片网址
    JYAreaPickerView        *_areaPicker;       //地址选择器
    NSString                *_bankAdressStr;    //银行地址
    UITextField             *_tempTxt;          //根据位置控制键盘弹起
    UIView                  *_nameview;         //显示view
    BOOL                    _keyBoardIsShow;
    BOOL                    _areaPickIsShow;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人实名认证";

    [self setBarBackBtnWithImage:nil];
    _myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64-50)];
    _myscrollview.backgroundColor = UIColorFromRGB(0xf1f1f1);
    _myscrollview.contentSize = CGSizeMake(ScreenWidth, 600);
    [self.view addSubview:_myscrollview];
    _IdcardOnIsUp = NO;
    _IdcardDownIsUp = NO;
    _keyBoardIsShow = NO;
    _areaPickIsShow = NO;
    [self setupUI];
    
 
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

-(void)setupUI
{
    NSArray *strArr = @[@"*申请人姓名",@"*联系地址",@"*身份",@"*身份证号",@"*身份证正面复印件",@"*身份证反面复印件",@"*开户人姓名",@"*银行开户账号",@"*开户银行所在地",@"*开户银行",];
    
    _nameview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 500)];
    _nameview.backgroundColor = [UIColor whiteColor];
    [_myscrollview addSubview:_nameview];
    for (int i = 0; i<strArr.count; i++) {
        [self createLabelWith:UIColorFromRGB(0x333333) Font:FSYSTEMFONT(15) WithSuper:_nameview Frame:CGRectMake(15,50*i, 150, 50) Alignment:NSTextAlignmentLeft Text:strArr[i]];
        [self createLineWithColor:UIColorFromRGB(0xb3b3b3) frame:CGRectMake(0, 49.5+50*i, ScreenWidth, 0.5) Super:_nameview];
    }
    [self createLabelWith:UIColorFromRGB(0x333333) Font:FSYSTEMFONT(15) WithSuper:_nameview Frame:CGRectMake(ScreenWidth-85, 100, 70, 50) Alignment:NSTextAlignmentRight Text:@"身份证"];
    
    _nameTF=[[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth-165,0,150, 50)];
    _nameTF.placeholder=@"请输入申请人姓名";
    UILabel * placeholderLabel = [_nameTF valueForKey:@"_placeholderLabel"];
    placeholderLabel.textAlignment = NSTextAlignmentRight;
    _nameTF.textAlignment = NSTextAlignmentRight;
    _nameTF.textColor=[UIColor blackColor];
    _nameTF.font=FSYSTEMFONT(15);
    _nameTF.autocorrectionType=UITextAutocorrectionTypeNo;
    _nameTF.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _nameTF.delegate=self;
    [_nameview addSubview:_nameTF];

    _addTF=[[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth-165,50,150, 50)];
    _addTF.placeholder=@"请输入联系地址";
    UILabel * placeholderLabel1 = [_addTF valueForKey:@"_placeholderLabel"];
    placeholderLabel1.textAlignment = NSTextAlignmentRight;
    _addTF.textAlignment = NSTextAlignmentRight;
    _addTF.textColor=[UIColor blackColor];
    _addTF.font=FSYSTEMFONT(15);
    _addTF.autocorrectionType=UITextAutocorrectionTypeNo;
    _addTF.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _addTF.delegate=self;
    [_nameview addSubview:_addTF];
    
    _IdcardTF=[[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth-185,150,170, 50)];
    _IdcardTF.placeholder=@"请输入身份证号";
    UILabel * placeholderLabel2 = [_IdcardTF valueForKey:@"_placeholderLabel"];
    placeholderLabel2.textAlignment = NSTextAlignmentRight;
    _IdcardTF.textAlignment = NSTextAlignmentRight;
    _IdcardTF.textColor=[UIColor blackColor];
    _IdcardTF.font=FSYSTEMFONT(15);
    _IdcardTF.autocorrectionType=UITextAutocorrectionTypeNo;
    _IdcardTF.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _IdcardTF.delegate=self;
    [_nameview addSubview:_IdcardTF];
    
    _openNameTF=[[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth-165,300,150, 50)];
    _openNameTF.placeholder=@"请输入开户人姓名";
    UILabel * placeholderLabel3 = [_openNameTF valueForKey:@"_placeholderLabel"];
    placeholderLabel3.textAlignment = NSTextAlignmentRight;
    _openNameTF.textAlignment = NSTextAlignmentRight;
    _openNameTF.textColor=[UIColor blackColor];
    _openNameTF.font=FSYSTEMFONT(15);
    _openNameTF.autocorrectionType=UITextAutocorrectionTypeNo;
    _openNameTF.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _openNameTF.delegate=self;
    [_nameview addSubview:_openNameTF];

    _openAccountTF=[[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth-165,350,150, 50)];
    _openAccountTF.placeholder=@"请输入银行开户账户";
    UILabel * placeholderLabel4 = [_openAccountTF valueForKey:@"_placeholderLabel"];
    placeholderLabel4.textAlignment = NSTextAlignmentRight;
    _openAccountTF.textAlignment = NSTextAlignmentRight;
    _openAccountTF.textColor=[UIColor blackColor];
    _openAccountTF.font=FSYSTEMFONT(15);
    _openAccountTF.autocorrectionType=UITextAutocorrectionTypeNo;
    _openAccountTF.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _openAccountTF.delegate=self;
    [_nameview addSubview:_openAccountTF];

    _openBankTF=[[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth-165,450,150, 50)];
    _openBankTF.placeholder=@"请输入开户银行";
    UILabel * placeholderLabel5 = [_openBankTF valueForKey:@"_placeholderLabel"];
    placeholderLabel5.textAlignment = NSTextAlignmentRight;
    _openBankTF.textAlignment = NSTextAlignmentRight;
    _openBankTF.textColor=[UIColor blackColor];
    _openBankTF.font=FSYSTEMFONT(15);
    _openBankTF.autocorrectionType=UITextAutocorrectionTypeNo;
    _openBankTF.autocapitalizationType=UITextAutocapitalizationTypeNone;
    _openBankTF.delegate=self;
    [_nameview addSubview:_openBankTF];
    
    _IDCardUpBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_IDCardUpBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [_IDCardUpBtn setTitle:@"请上传照片" forState:UIControlStateNormal];
    [_IDCardUpBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
   _IDCardUpBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _IDCardUpBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _IDCardUpBtn.titleRect = CGRectMake(0, 17.5, 80, 15);
    _IDCardUpBtn.imageRect = CGRectMake(80, 17.5, 9, 15);
    [_nameview addSubview:_IDCardUpBtn];
    _IDCardUpBtn.frame = CGRectMake(ScreenWidth-105, 200, 90, 50);
    [_IDCardUpBtn addTarget:self action:@selector(IDCardUpBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _IDCardDownBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_IDCardDownBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [_IDCardDownBtn setTitle:@"请上传照片" forState:UIControlStateNormal];
    [_IDCardDownBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _IDCardDownBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _IDCardDownBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _IDCardDownBtn.titleRect = CGRectMake(0, 17.5, 80, 15);
    _IDCardDownBtn.imageRect = CGRectMake(80, 17.5, 9, 15);
    [_nameview addSubview:_IDCardDownBtn];
    _IDCardDownBtn.frame = CGRectMake(ScreenWidth-105, 250, 90, 50);
    [_IDCardDownBtn addTarget:self action:@selector(IDCardDownBtnBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    _BankLocaBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_BankLocaBtn setImage:[UIImage imageNamed:@"right"] forState:UIControlStateNormal];
    [_BankLocaBtn setTitle:@"请选择" forState:UIControlStateNormal];
    [_BankLocaBtn setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
    _BankLocaBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    _BankLocaBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    _BankLocaBtn.titleRect = CGRectMake(0, 17.5, 80, 15);
    _BankLocaBtn.imageRect = CGRectMake(80, 17.5, 9, 15);
    [_nameview addSubview:_BankLocaBtn];
    _BankLocaBtn.frame = CGRectMake(ScreenWidth-105, 400, 90, 50);
    [_BankLocaBtn addTarget:self action:@selector(BankLocaBtnClick) forControlEvents:UIControlEventTouchUpInside];

//    SubBtn *setBtn = [SubBtn buttonWithtitle:@"提交" backgroundColor:UIColorFromRGB(0xc61616) titlecolor:UIColorFromRGB(0xffffff) cornerRadius:0 andtarget:self action:@selector(setUPUserAllInfo)];
    SubBtn * setBtn = [SubBtn buttonWithtitle:@"提交" titlecolor:UIColorFromRGB(0xffffff) cornerRadius:0 andtarget:self action:@selector(setUPUserAllInfo) andframe:CGRectMake(0, ScreenHeight -64-50, ScreenWidth , 50)];
    [self.view addSubview:setBtn];
//    setBtn.frame = CGRectMake(0, ScreenHeight -64-50, ScreenWidth , 50);
    
    _myscrollview  .contentSize = CGSizeMake(10, 600);
}


#pragma mark ===== 按钮点击方法

/**
 身份证正面上传
 */
- (void)IDCardUpBtnClick{

    if (_IdcardOnIsUp) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"身份证正面面复印件已提交，确定替换？" preferredStyle:UIAlertControllerStyleAlert];
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
   
}



/**
 身份证反面上传
 */
- (void)IDCardDownBtnBtnClick{

    if (_IdcardDownIsUp) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"身份证反面复印件已提交，确定替换？" preferredStyle:UIAlertControllerStyleAlert];
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

}



/**
 开户银行所在地
 */
- (void)BankLocaBtnClick{
    [self presentAreaPicker];

}


/**
 提交
 */
- (void)setUPUserAllInfo{

    
    if (![self IsIdentityCard:_IdcardTF.text ]) {
        [self showTextHud:@"请填写正确的身份证号码"];
        
        return;
    }
    
    
    if (_nameTF.text.length == 0||_addTF.text.length == 0||_IdcardTF.text.length == 0||_openNameTF.text.length == 0||_openAccountTF.text.length == 0||_openBankTF.text.length == 0||_IdcardOnUrlStr.length == 0||_IdcarddownUrlStr.length == 0||_bankAdressStr.length == 0) {
        [self showTextHud:@"请将信息填写完整"];
        return;
    }

 
    HTTPClient  *client = [HTTPClient sharedHttpClient];
    [client POST:@"/user/certification/individual"
            dict:@{@"applicantName":_nameTF.text,
                   @"address":_addTF.text,
                   @"identificationType":@"idCard",
                   @"identificationNumber":_IdcardTF.text,
                   @"identificationHeadPicUrl":_IdcardOnUrlStr,
                   @"identificationBackPicUrl":_IdcarddownUrlStr,
                   @"bankAccountNumber":_openAccountTF.text,
                   @"bankAccountName":_openNameTF.text,
                   @"bankAddress":_bankAdressStr,
                   @"bankName":_openBankTF.text
                   } success:^(NSDictionary *resultDic) {
                       
                       dispatch_async(dispatch_get_main_queue(), ^{
                           if ([resultDic[@"code"] intValue]==-1) {
                               [self showTextHud:@"资料上传成功"];
                               [self performSelector:@selector(back) withObject:nil afterDelay:1.5];
                           }else{
                                [self showTextHud:resultDic[@"message"]];

                           }

                          
                       });
                       
                   } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                       [self showTextHud:@"资料上传失败"];
                       
                   }];

}

- (void)back{
    [self.navigationController popToRootViewControllerAnimated:YES];

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
      //  _BankLocaBtn.userInteractionEnabled = NO;

    }
}


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
#pragma mark--------------------------------UIActionDelegate--------------------------------
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
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    progressHUD.label.text = @"正在上传图片";
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

    __weak CertificationViewController * weakself = self;
    
    [manager POST:[NSString stringWithFormat:@"%@/user/upload-images?imageType=/user/upload-images?imageType=",kbaseUrl] parameters:dataDict constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:imageData name:@"image" fileName:fileName mimeType:@"image/png"];
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
        [weakself showTextHudInSelfView:@"上传成功"];
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

        }
        NSLog(@"%@=======%@",_IdcardOnUrlStr,_IdcarddownUrlStr);
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow  animated:YES];
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
    
    kb*=400;
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
    
    MBProgressHUD *progressHUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    progressHUD.label.text = msg;

}

//隐藏加载提示
- (void)hideLoadHUD{
    
    [MBProgressHUD hideHUDForView:self.view   animated:YES];
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





#pragma mark--------------------------------UITextFieldDelegate--------------------------------

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    _tempTxt = textField;
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (textField==_IdcardTF) {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        if (_IdcardTF.text.length>=18) {
            return NO;
        }
    }
    
    return YES;
}


@end
