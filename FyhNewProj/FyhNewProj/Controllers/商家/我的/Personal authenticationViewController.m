//
//  Personal authenticationViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/11/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "Personal authenticationViewController.h"
#import "CardTypeViewController.h"

#import "BussModel.h"
#import "UpImagePL.h"

@interface Personal_authenticationViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate>

@property (nonatomic , strong) UITextField *nameTF;         //姓名

@property (nonatomic , strong) UITextField *IdcardTF;       //身份证号

@property (nonatomic , strong) UIButton *PositiveBtn;       //身份证正面

@property (nonatomic , strong) UIButton *BackBtn;       //身份证正面

@property (nonatomic , strong) UILabel *cardKindLab;       //营业执照照片


@end

@implementation Personal_authenticationViewController{
    
    BussModel *_bussModel;
    NSInteger  _choseType;
    UpImagePL *_upImagePL;                     //上传图片
    UIImagePickerController *_imagePicker;
    
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self setBarBackBtnWithImage:nil];
    [self setBarBackBtnWithImage:nil];
    self.title = @"个人实名认证";
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    _bussModel = [[BussModel alloc]init];
    _upImagePL = [[UpImagePL alloc]init];
    [self steupUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)steupUI
{
    
//   姓名
    UIView *nameview = [[UIView alloc]initWithFrame:CGRectMake(0, 12, ScreenWidth, 48)];
    nameview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:nameview];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:nameview Frame:CGRectMake(16, 16.5, 33, 15) Alignment:NSTextAlignmentLeft Text:@"姓名"];
    
    _nameTF = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-16-250, 0, 250, 48)];
    _nameTF.placeholder = @"请输入姓名";
    _nameTF.font = APPFONT(15);
    _nameTF.textColor = UIColorFromRGB(BlackColorValue);
    _nameTF.textAlignment = NSTextAlignmentRight;
    [nameview addSubview:_nameTF];
    
    [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:nameview];
    
    
    
//    证件类型
    UIView *typeview = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48, ScreenWidth, 48)];
    typeview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:typeview];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:typeview Frame:CGRectMake(16, 16.5, 66, 15) Alignment:NSTextAlignmentLeft Text:@"证件类型"];
    
     [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:typeview];
    _cardKindLab = [BaseViewFactory labelWithFrame:CGRectMake(ScreenWidth - 200, 0, 168, 48) textColor:UIColorFromRGB(PlaColorValue) font:APPFONT(15) textAligment:NSTextAlignmentRight andtext:@"请选择"];
    [typeview addSubview:_cardKindLab];
    
    UIImageView *right = [[UIImageView alloc]initWithFrame:CGRectMake(ScreenWidth - 24, 16, 10, 16)];
    right.image = [UIImage imageNamed:@"right"];
    [typeview addSubview:right];
    UIButton *kindBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    kindBtn.frame = CGRectMake(ScreenWidth - 200, 0, 200, 48);
    [typeview addSubview:kindBtn];
    [kindBtn addTarget:self action:@selector(kindBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
//    证件号
    
    UIView *Certificatesnumberview = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48+48, ScreenWidth, 48)];
    Certificatesnumberview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:Certificatesnumberview];
    
    [self createLabelWith:UIColorFromRGB(BlackColorValue) Font:APPFONT(15) WithSuper:Certificatesnumberview Frame:CGRectMake(16, 16.5, 50, 15) Alignment:NSTextAlignmentLeft Text:@"证件号"];
    
    _IdcardTF = [[UITextField alloc]initWithFrame:CGRectMake(ScreenWidth-16-250, 0, 250, 48)];
    _IdcardTF.placeholder = @"请输入证件号";
    _IdcardTF.font = APPFONT(15);
    _IdcardTF.textColor = UIColorFromRGB(BlackColorValue);
    _IdcardTF.textAlignment = NSTextAlignmentRight;
    _IdcardTF.keyboardType = UIKeyboardTypeASCIICapable;
    [Certificatesnumberview addSubview:_IdcardTF];
    
     [self createLineWithColor:UIColorFromRGB(LineColorValue) frame:CGRectMake(0, 47, ScreenWidth, 1) Super:Certificatesnumberview];
    
//    8097+161+5699+2599+2599+2599+2599+2599+2899+798+2649+4699
    
//    证件照片
    UIView *Certificatesphotoview = [[UIView alloc]initWithFrame:CGRectMake(0, 12+48+48+48, ScreenWidth, 136)];
    Certificatesphotoview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:Certificatesphotoview];
    
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
    
    
//    提交按钮
    
    SubBtn *SubmitBtn = [SubBtn buttonWithtitle:@"提交" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(SubmitBtnClick) andframe:CGRectMake(16, 12+48+48+48+136+24, ScreenWidth-32, 50)];
//    SubmitBtn.layer.contentsRect = 5;
    SubmitBtn.titleLabel.font = APPFONT(17);
    [self.view addSubview:SubmitBtn];
    
   
    
//提示文案
    CGFloat height2 = [self getSpaceLabelHeight:@"1.证件上的所有信息清晰可见，证件号、证件照片等信息无遮挡、无涂改。" withFont:APPFONT(12) withWidth:ScreenWidth-32];
    UILabel *labe21 = [[UILabel alloc]initWithFrame:CGRectMake( 16, CGRectGetMaxY(SubmitBtn.frame)+24,ScreenWidth-32, height2+4)];
    labe21.text = @"1.证件上的所有信息清晰可见，证件号、证件照片等信息无遮挡、无涂改。";
    labe21.font = APPFONT(12);
    labe21.numberOfLines = 0;
    labe21.textAlignment = NSTextAlignmentLeft;
    labe21.textColor = UIColorFromRGB(0x656d78);
    [self.view addSubview:labe21];
    
    [self createLabelWith:UIColorFromRGB(0x656d78) Font:APPFONT(12) WithSuper:self.view Frame:CGRectMake(16, CGRectGetMaxY(labe21.frame)+10, ScreenWidth-32, 12) Alignment:NSTextAlignmentLeft Text:@"2.照片内容真实有效，不得做任何修改。"];
    
    [self createLabelWith:UIColorFromRGB(0x656d78) Font:APPFONT(12) WithSuper:self.view Frame:CGRectMake(16, CGRectGetMaxY(labe21.frame)+10+12+10, ScreenWidth-32, 12) Alignment:NSTextAlignmentLeft Text:@"3.支持ipg/jpeg/png格式，最大不超过5M。"];
    
    
}



- (void)kindBtnClick{
    CardTypeViewController *cardVc = [[CardTypeViewController alloc]init];
    cardVc.model = _bussModel;
    [self.navigationController pushViewController:cardVc animated:YES];
    
    
}

- (void)PositiveBtnClick{
     _choseType = 0;
    [self chosePhoto];
    
}

- (void)BackBtnClick{
     _choseType = 1;
    [self chosePhoto];
    
}


- (void)SubmitBtnClick{
    
    
   
    if (_nameTF.text.length<=0) {
        [self showTextHud:@"请输入姓名"];
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
    if (!_bussModel.legalPersonIdentificationHeadPicUrl) {
        [self showTextHud:@"请上传身份证正面照片"];
        return;
    }
    if (!_bussModel.legalPersonIdentificationBackPicUrl) {
        [self showTextHud:@"请上传身份证反面照片"];
        return;
        
    }
    NSDictionary *dic = @{@"applicantName":_nameTF.text,
                          @"identificationType":_bussModel.legalPersonIdentificationType,
                          @"identificationNumber":_IdcardTF.text,
                          @"identificationHeadPicUrl":_bussModel.legalPersonIdentificationHeadPicUrl,
                          @"identificationBackPicUrl":_bussModel.legalPersonIdentificationBackPicUrl
                          };
    HTTPClient *client = [HTTPClient sharedHttpClient];
    [client POST:@"/user/certification/individual" dict:dic success:^(NSDictionary *resultDic) {
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
//计算UILabel的高度(带有行间距的情况)

-(CGFloat)getSpaceLabelHeight:(NSString*)str withFont:(UIFont*)font withWidth:(CGFloat)width {
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    // paraStyle.lineSpacing = 8; 行距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, 0) options:\
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.height;
}


@end
