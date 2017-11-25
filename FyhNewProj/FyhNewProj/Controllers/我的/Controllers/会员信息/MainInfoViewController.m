//
//  MainInfoViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/24.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MainInfoViewController.h"
#import "UserInfoModel.h"

//#import <objc/message.h>
//#import "LBXScanResult.h"
#import <AVFoundation/AVFoundation.h>
#import "UpImagePL.h"
#import "UserInfoChangePL.h"
#import "JYDataPickerWindow.h"



@interface MainInfoViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,JYDataPickerDelegate>


@end

@implementation MainInfoViewController{

    UIImageView             *_faceImageView;
    UITextField             *_nameTxt;
    UITextField             *_genderTxt;
    UITextField             *_birthdayTxt;
    UIImagePickerController *_imagePicker;
    BOOL                     _isChoiceCamera;
    UpImagePL               *_upImagePL;                     //上传图片
    UserInfoChangePL        *_userInfoChangePL;
    UserInfoModel           *_infomodel;
    JYDataPickerWindow      *_datePicker;       //时间选择器
    NSString                *_timeStr;
    
    YLButton *_manBtn;
    YLButton *_womanBtn;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    _infomodel = [[UserInfoModel alloc]init];
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(0xe6e9ed);
    self.navigationItem.title = @"会员信息";
    _upImagePL = [[UpImagePL alloc]init];
    _userInfoChangePL = [[UserInfoChangePL alloc]init];
    [self createNavagationItem];
    [self initUI];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}



- (void)createNavagationItem
{
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithTitle:@"保存  " style:UIBarButtonItemStylePlain target:self action:@selector(changeuserinfo)];
    [choiceCityBtn setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                           [UIFont systemFontOfSize:15.0],NSFontAttributeName,
                                           UIColorFromRGB(WhiteColorValue),NSForegroundColorAttributeName,
                                           nil] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = choiceCityBtn;
}


- (void)initUI{
    UIView *topView = [BaseViewFactory viewWithFrame:CGRectMake(0, 0, ScreenWidth, 250) color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:topView];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:topView Frame:CGRectMake(20, 0, 100, 100) Alignment:NSTextAlignmentLeft Text:@"会员头像"];

    NSArray *titleArr = @[@"昵称:",@"性别:",@"生日:"];
    for (int i = 0; i<3 ; i++) {
        [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 100+50*i, ScreenWidth, 0.5) Super:topView];
        [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:topView Frame:CGRectMake(20, 100+50*i, 40, 50) Alignment:NSTextAlignmentLeft Text:titleArr[i]];
    }
    
    
    _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 100, 10, 80, 80)];
    _faceImageView.layer.cornerRadius = 40;
    _faceImageView.layer.borderColor = UIColorFromRGB(LineColorValue).CGColor;
    _faceImageView.layer.borderWidth = 1;
    _faceImageView.clipsToBounds = YES;
    _faceImageView.image = [UIImage imageNamed:@"member-big"];
    [topView addSubview:_faceImageView];
    

    
    _nameTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(60, 100, ScreenWidth - 80, 50) font:APPFONT(15) placeholder:@"" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _nameTxt.text = [[NSUserDefaults standardUserDefaults] objectForKey:FYH_USER_ACCOUNT];
    [topView addSubview:_nameTxt];
    
    
//    _genderTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(60, 150, ScreenWidth - 80, 50) font:APPFONT(15) placeholder:@"" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
//    [topView addSubview:_genderTxt];

    _manBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_manBtn setImageRect:CGRectMake(20, 15, 20, 20)];
    [_manBtn setTitleRect:CGRectMake(50, 15, 16, 20)];
    [_manBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
    [_manBtn setTitle:@"男" forState:UIControlStateNormal];
    [_manBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [topView addSubview:_manBtn];
    _manBtn.on = YES;
    _manBtn.frame = CGRectMake(60, 150, 80, 50);
    [_manBtn addTarget:self action:@selector(manbtnClick) forControlEvents:UIControlEventTouchUpInside];
    _manBtn.titleLabel.font = APPFONT(15);
    
    _womanBtn = [YLButton buttonWithType:UIButtonTypeCustom];
    [_womanBtn setImageRect:CGRectMake(20, 15, 20, 20)];
    [_womanBtn setTitleRect:CGRectMake(50, 15, 16, 20)];
    [_womanBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
    [_womanBtn setTitle:@"女" forState:UIControlStateNormal];
    [_womanBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [topView addSubview:_womanBtn];
    _womanBtn.on = NO;
    [_womanBtn addTarget:self action:@selector(womanbtnClick) forControlEvents:UIControlEventTouchUpInside];
    _womanBtn.titleLabel.font = APPFONT(15);
    _womanBtn.frame = CGRectMake(160, 150, 80, 50);

    
    
    _birthdayTxt = [BaseViewFactory textFieldWithFrame:CGRectMake(60, 200, ScreenWidth - 80, 50) font:APPFONT(15) placeholder:@"请选择" textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(LineColorValue) delegate:self];
    _birthdayTxt.text = @"1994-01-23";
    _birthdayTxt.userInteractionEnabled = NO;
    [topView addSubview:_birthdayTxt];
    UIButton *birbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:birbtn];
    birbtn.frame = CGRectMake(60, 200, ScreenWidth - 60, 50);
    [birbtn addTarget:self action:@selector(birbtnClick) forControlEvents:UIControlEventTouchUpInside];

    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [topView addSubview:btn];
    btn.frame = CGRectMake(ScreenWidth - 100, 10, 80, 80);
    [btn addTarget:self action:@selector(chosePhoto) forControlEvents:UIControlEventTouchUpInside];
    
    [self loadUserInfo];
}


#pragma mark =========== 按钮点击
- (void)manbtnClick{
    _manBtn.on = YES;
    _womanBtn.on = NO;
    [_manBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
    [_womanBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];

}
- (void)womanbtnClick{
    _manBtn.on = NO;
    _womanBtn.on = YES;
    [_manBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
    [_womanBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
}

- (void)birbtnClick{
    if (!_datePicker) {
        _datePicker = [[JYDataPickerWindow alloc] init];
        _datePicker.delegate = self;
        
    }
    [_datePicker show];



}

#pragma mark ======== 时间选择

- (void)DataPickerWindowbaocunBtnCilck{
    [_datePicker cancelPicker];
        NSLog(@"成立时间 ====== %@-%@-%@",_datePicker.selectedYear,_datePicker.selectedMonth,_datePicker.selectedDay);
    
    _timeStr = [NSString stringWithFormat:@"%@-%@-%@",_datePicker.selectedYear,_datePicker.selectedMonth,_datePicker.selectedDay];
    _birthdayTxt.text = _timeStr;

}

#pragma mark =========== NetWork

/**
 保存信息
 */
- (void)changeuserinfo{

    
    if (_manBtn.on) {
         _infomodel.gender = @"男";
    }else{
        _infomodel.gender = @"女";
    }
    _infomodel.nickname = _nameTxt.text;
    _infomodel.birthday =_birthdayTxt.text;

    if (_infomodel.avatarUrl.length<=0) {
      _infomodel .avatarUrl = @"";
    }
    if (_infomodel.nickname<=0) {
        _infomodel .nickname = @"";

    }
    if (_infomodel.gender<=0) {
        _infomodel .gender = @"";

    }
    if (_infomodel.birthday<=0) {
        _infomodel .birthday = @"";

    }
    
    __weak __typeof(self)weakSelf = self;
    _userInfoChangePL.infoModel = _infomodel;
    [_userInfoChangePL upuserInfoWithReturnBlock:^(id returnValue) {
        [weakSelf freshUserInfoWithModel:_infomodel];
        [self.navigationController popViewControllerAnimated:YES];
    } andErrorBlock:^(NSString *msg) {
        [weakSelf showTextHud:msg];
    }];


}

- (void)loadUserInfo{

    __weak __typeof(self)weakSelf = self;
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client getUserInfowithReturnBlock:^(id returnValue) {
    NSDictionary *dic = [HTTPClient valueWithJsonString:returnValue];
        NSDictionary *redic = dic[@"data"];
        _infomodel = [UserInfoModel mj_objectWithKeyValues:redic[@"userProfile"]];
        [weakSelf freshUserInfoWithModel:_infomodel];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:@"出错啦，请稍后再试"];

    }];


}


- (void)freshUserInfoWithModel:(UserInfoModel *)infoModel{

    if (_infomodel.avatarUrl) {
        [_faceImageView  sd_setImageWithURL:[NSURL URLWithString:_infomodel.avatarUrl] placeholderImage: [UIImage imageNamed:@"member-big"]];
    }
    if (_infomodel.nickname) {
        _nameTxt.text = _infomodel.nickname;
    }
    if ([_infomodel.gender isEqualToString:@"1"]) {
        [_manBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
        [_womanBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
        _manBtn.on = YES;
        _womanBtn.on = NO;

    }else if ([_infomodel.gender isEqualToString:@"2"]){
        [_manBtn setImage:[UIImage imageNamed:@"circle-40"] forState:UIControlStateNormal];
        [_womanBtn setImage:[UIImage imageNamed:@"iv_cart_chose"] forState:UIControlStateNormal];
        _womanBtn.on = YES;
        _manBtn.on = NO;

    }

    if (_infomodel.birthday) {
        _birthdayTxt.text = _infomodel.birthday;
    }
    RCUserInfo *user = [[RCUserInfo alloc]init];
    user.userId = infoModel.accountId;
    user.name = infoModel.nickname;
    user.portraitUri = infoModel.avatarUrl ;

    [[RCIM sharedRCIM] refreshUserInfoCache:user withUserId:infoModel.accountId];
    
    

}


#pragma mark ================= 选择头像

/**
 判断照相机权限
 
 @return 是否
 */
- (BOOL)cameraPemission
{
    
    BOOL isHavePemission = NO;
    if ([AVCaptureDevice respondsToSelector:@selector(authorizationStatusForMediaType:)])
    {
        AVAuthorizationStatus permission =
        [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
        
        switch (permission) {
            case AVAuthorizationStatusAuthorized:
                isHavePemission = YES;
                break;
            case AVAuthorizationStatusDenied:
            case AVAuthorizationStatusRestricted:
                break;
            case AVAuthorizationStatusNotDetermined:
                isHavePemission = YES;
                break;
        }
    }
    
    return isHavePemission;
}


#pragma mark  ================  webview Delegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    NSURL *url = [request URL];
    NSString *urlstr = [NSString stringWithFormat:@"%@",url];
    NSLog(@"URL===========%@",urlstr);
    return YES;
}


#pragma mark  ================  选取照片

- (void)chosePhoto{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
//        _imagePicker.allowsEditing = YES;

        _imagePicker.delegate = self;
    }
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                  initWithTitle:nil
                                  delegate:self
                                  cancelButtonTitle:@"取消"
                                  destructiveButtonTitle:nil
                                  otherButtonTitles:@"拍照", @"从相册选取",nil];
    actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
    [actionSheet showInView:self.view];
    
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
    _isChoiceCamera = YES;
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
    _isChoiceCamera= NO;
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
    __weak __typeof(self)weakSelf = self;

    [_upImagePL updateImg:image WithReturnBlock:^(id returnValue) {
        NSDictionary *imageDic = returnValue;
        NSArray *arr = imageDic[@"imageUrlList"];
        NSArray *upArr = [arr[0] componentsSeparatedByString:imageDic[@"cdnUrl"]];
        _infomodel.upUrl = upArr[1];
        _infomodel.avatarUrl = arr[0];
        _userInfoChangePL.infoModel = _infomodel;
        [_userInfoChangePL upuserInfoWithReturnBlock:^(id returnValue) {
            [weakSelf freshUserInfoWithModel:_infomodel ];

        } andErrorBlock:^(NSString *msg) {
            [weakSelf showTextHud:msg];
        }];
    } withErrorBlock:^(NSString *msg) {
        [weakSelf showTextHud:msg];
    }];

    
    
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

#pragma mark ===== 图片压缩至1m


/**
 压缩图片返回data
 @param image 传入图片
 @param kb 压缩至1M（1024kb）
 @return 压缩后的图片转化的base64编码
 */
- (NSData *)scaleImage:(UIImage *)image toKb:(NSInteger)kb{
    
    kb*=500;
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




@end
