//
//  EnterprisecertificationViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "EnterprisecertificationViewController.h"
#import "CardTypeViewController.h"
#import "NextViewController.h"
#import "BussModel.h"
#import "UpImagePL.h"

@interface EnterprisecertificationViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>


@property (nonatomic , strong) UITextField *Enterprisename; //企业名称

@property (nonatomic , strong) UITextField *nameTF;         //姓名

@property (nonatomic , strong) UITextField *IdcardTF;       //身份证号

@property (nonatomic , strong) UITextField *YYZZTF;       //身份证号

@property (nonatomic , strong) UIButton *PositiveBtn;       //身份证正面

@property (nonatomic , strong) UIButton *BackBtn;       //身份证正面

@property (nonatomic , strong) UIButton *yyzzphBtn;       //营业执照照片

@property (nonatomic , strong) UILabel *cardKindLab;       //证件类型


@end

@implementation EnterprisecertificationViewController{
    
    BussModel *_bussModel;
    NSInteger  _choseType;
    UpImagePL *_upImagePL;                     //上传图片
    UIImagePickerController *_imagePicker;


}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setBarBackBtnWithImage:nil];
    self.title = @"企业实名认证";
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    _bussModel = [[BussModel alloc]init];
    _upImagePL = [[UpImagePL alloc]init];
    [self createNavagationItem];
    [self steupUI];
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    if (_bussModel.legalPersonIdentificationType) {
        if ([_bussModel.legalPersonIdentificationType isEqualToString:@"idCard"]) {
             _cardKindLab.text = @"身份证";
        }else{
             _cardKindLab.text = @"护照";
        }
        _cardKindLab.textColor = UIColorFromRGB(BlackColorValue);

    }else{
        _cardKindLab.text = @"请选择";
        _cardKindLab.textColor = UIColorFromRGB(PlaColorValue);
    }
    
}


- (void)createNavagationItem
{
   UIButton *  btn = [YLButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"1/2" forState:UIControlStateNormal];
    btn.titleLabel.font = APPFONT(15);
    [btn setTitleColor:UIColorFromRGB(WhiteColorValue) forState:UIControlStateNormal];
    btn.frame = CGRectMake(0, 0, 40, 40);
    UIBarButtonItem * choiceCityBtn = [[UIBarButtonItem alloc] initWithCustomView:btn];
    
    self.navigationItem.rightBarButtonItem = choiceCityBtn;
}

-(void)steupUI
{
    UIScrollView *myscrollview = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-64)];
    myscrollview.contentSize = CGSizeMake(ScreenWidth, ScreenHeight-64);
    myscrollview.backgroundColor = UIColorFromRGB(0xf5f7fa);
    [self.view addSubview:myscrollview];
    
    
    
    //   企业名称
    UIView *Enterprisenameview = [[UIView alloc]initWithFrame:CGRectMake(0, 12, ScreenWidth, 48)];
    Enterprisenameview.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:Enterprisenameview];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:Enterprisenameview Frame:CGRectMake(16, 16.5, 66, 15) Alignment:NSTextAlignmentLeft Text:@"企业名称"];
    
    _Enterprisename = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-16-250, 0, 250, 48)];
    _Enterprisename.placeholder = @"请输入公司名称";
    _Enterprisename.font = APPFONT(15);
    _Enterprisename.textColor = UIColorFromRGB(BlackColorValue);
    _Enterprisename.textAlignment = NSTextAlignmentRight;
    [Enterprisenameview addSubview:_Enterprisename];
    
     [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:Enterprisenameview];
    
    //   法人姓名
    UIView *nameview = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48, ScreenWidth, 48)];
    nameview.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:nameview];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:nameview Frame:CGRectMake(16, 16.5,66, 15) Alignment:NSTextAlignmentLeft Text:@"法人姓名"];
    
    _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-16-250, 0, 250, 48)];
    _nameTF.placeholder = @"请输入名称";
    _nameTF.font = APPFONT(15);
    _nameTF.textColor = UIColorFromRGB(BlackColorValue);
    _nameTF.textAlignment = NSTextAlignmentRight;
    [nameview addSubview:_nameTF];
    
     [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:nameview];
    
    //   法人身份
    UIView *typeview = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48+48, ScreenWidth, 48)];
    typeview.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:typeview];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:typeview Frame:CGRectMake(16, 16.5, 99, 15) Alignment:NSTextAlignmentLeft Text:@"法人证件类型"];
    
    _cardKindLab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth - 200, 0, 168, 48) textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"请选择"];
    [typeview addSubview:_cardKindLab];
    
    UIImageView *right = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 24, 16, 10, 16)];
    right.image = [UIImage imageNamed:@"right"];
    [typeview addSubview:right];
    UIButton *kindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kindBtn.frame = CGRectMake(ScreenWidth - 200, 0, 200, 48);
    [typeview addSubview:kindBtn];
    [kindBtn addTarget:self action:@selector(kindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
     [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:typeview];
    
    //    证件号
    
    UIView *Certificatesnumberview = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48+48+48, ScreenWidth, 48)];
    Certificatesnumberview.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:Certificatesnumberview];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:Certificatesnumberview Frame:CGRectMake(16, 16.5, 99, 15) Alignment:NSTextAlignmentLeft Text:@"法人证件号"];
    
    _IdcardTF = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-16-250, 0, 250, 48)];
    _IdcardTF.placeholder = @"请输入证件号";
    _IdcardTF.keyboardType = UIKeyboardTypeASCIICapable;
    _IdcardTF.font = APPFONT(15);
    _IdcardTF.textColor = UIColorFromRGB(BlackColorValue);
    _IdcardTF.textAlignment = NSTextAlignmentRight;
    [Certificatesnumberview addSubview:_IdcardTF];
    
     [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:Certificatesnumberview];
    
    
    //    证件照片
    UIView *Certificatesphotoview = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48+48+48+48, ScreenWidth, 136)];
    Certificatesphotoview.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:Certificatesphotoview];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:Certificatesphotoview Frame:CGRectMake(16, 60.5, 66, 15) Alignment:NSTextAlignmentLeft Text:@"证件照片"];
    
    _PositiveBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-16-104-16-104, 16, 104, 104)];
    [_PositiveBtn setImage:[UIImage imageNamed:@"True_IDCardOn"] forState:0];
    [_PositiveBtn addTarget:self action:@selector(PositiveBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [Certificatesphotoview addSubview:_PositiveBtn];
    
    _BackBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-16-104, 16, 104, 104)];
    [_BackBtn setImage:[UIImage imageNamed:@"True_IDCardDown"] forState:0];
    [_BackBtn addTarget:self action:@selector(BackBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [Certificatesphotoview addSubview:_BackBtn];
    
     [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 135, ScreenWidth, 1) Super:Certificatesphotoview];
    
    //营业执照号码
    UIView *Businesslicensenumuberview = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48+48+48+48+136, ScreenWidth, 48)];
    Businesslicensenumuberview.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:Businesslicensenumuberview];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:Businesslicensenumuberview Frame:CGRectMake(16, 16.5, 99, 15) Alignment:NSTextAlignmentLeft Text:@"营业执照号码"];
    
    _YYZZTF = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-16-250, 0, 250, 48)];
    _YYZZTF.placeholder = @"请输入营业执照号";
    _YYZZTF.font = APPFONT(15);
    _YYZZTF.textColor = UIColorFromRGB(BlackColorValue);
    _YYZZTF.textAlignment = NSTextAlignmentRight;
    [Businesslicensenumuberview addSubview:_YYZZTF];
    
     [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:Businesslicensenumuberview];
    
    //营业执照照片
    UIView *zzyyph = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48+48+48+48+136+48, ScreenWidth, 136)];
    zzyyph.backgroundColor = [UIColor whiteColor];
    [myscrollview addSubview:zzyyph];
    
     [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:zzyyph Frame:CGRectMake(16, 60.5, 100, 15) Alignment:NSTextAlignmentLeft Text:@"营业执照照片"];
    
    _yyzzphBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-16-104, 16, 104, 104)];
    [_yyzzphBtn setImage:[UIImage imageNamed:@"True_Bussness"] forState:0];
    [_yyzzphBtn addTarget:self action:@selector(BussBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [zzyyph addSubview:_yyzzphBtn];
    
     [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 135, ScreenWidth, 1) Super:zzyyph];
    
    SubBtn *nextBtn = [SubBtn buttonWithtitle:@"下一步" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(nextBtnClick) andframe:CGRectMake(16, 12+48+48+48+48+136+48+136+24, ScreenWidth-32, 50)];
    
    nextBtn.titleLabel.font = APPFONT(17);
    [myscrollview addSubview:nextBtn];
    
    myscrollview.contentSize = CGSizeMake(ScreenWidth, 667);

}

-(void)nextBtnClick
{
    if (_Enterprisename.text.length<=0) {
        [self showTextHud:@"请输入企业名称"];
        return;
    }
    if (_nameTF.text.length<=0) {
        [self showTextHud:@"请输入法人姓名"];
        return;
    }
    if ([_cardKindLab.text isEqualToString:@"请选择"]) {
        [self showTextHud:@"请选择证件类型"];
        return;
    }else if ([_cardKindLab.text isEqualToString:@"身份证"]){
        if (![self IsIdentityCard:_IdcardTF.text]) {
            [self showTextHud:@"请输入正确的身份证号码"];
            return;
        }
    }
    if (_IdcardTF.text.length<=0) {
        [self showTextHud:@"请输入法人证件号"];
        return;
    }
    if (_YYZZTF.text.length<=0) {
        [self showTextHud:@"请输入营业执照号"];
        return;
    }
    if (!_bussModel.legalPersonIdentificationHeadPicUrl) {
        [self showTextHud:@"请上传身份证正面照片"];
        return;
    }
    if (!_bussModel.legalPersonIdentificationBackPicUrl) {
        [self showTextHud:@"请上传身份证反面照片"];
        return;
    }
    if (!_bussModel.businessLicensePicUrl) {
        [self showTextHud:@"请上传营业执照正面照片"];
        return;
    }
    _bussModel.corporateName = _Enterprisename.text;
    _bussModel.legalPersonName = _nameTF.text;
    _bussModel.legalPersonIdentificationNumber = _IdcardTF.text;
    _bussModel.businessLicenseNumber = _YYZZTF.text;
    NextViewController *vc = [[NextViewController alloc]init];
    vc.model = _bussModel;
    [self.navigationController pushViewController:vc animated:YES];
}


/**
 身份证正面
 */
- (void)PositiveBtnClick{
    
    _choseType = 0;
    [self chosePhoto];
    
}


/**
反面
*/
- (void)BackBtnClick{
     _choseType = 1;
      [self chosePhoto];
    
}

/**
 营业执照
 */
- (void)BussBtnClick{
     _choseType = 2;
      [self chosePhoto];
}

- (void)kindBtnClick{
    
    CardTypeViewController *cardVc = [[CardTypeViewController alloc]init];
    cardVc.model = _bussModel;
    [self.navigationController pushViewController:cardVc animated:YES];
    
    
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
    __weak __typeof(self)weakSelf = self;
    [_upImagePL updateImg:image WithReturnBlock:^(id returnValue) {
        NSDictionary *imageDic = returnValue;
        if (_choseType == 0) {
            _bussModel.legalPersonIdentificationHeadPicUrl =imageDic[@"imageUrls"][0];
            [_PositiveBtn setImage:image forState:UIControlStateNormal];
        }else if (_choseType == 1){
            _bussModel.legalPersonIdentificationBackPicUrl =imageDic[@"imageUrls"][0];
            [_BackBtn setImage:image forState:UIControlStateNormal];

        }else if (_choseType == 2){
            _bussModel.businessLicensePicUrl =imageDic[@"imageUrls"];
            [_yyzzphBtn setImage:image forState:UIControlStateNormal];

        }
        
        
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
