//
//  MyShopViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/5.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MyShopViewController.h"
#import "ShopSettingPL.h"
#import "UpImagePL.h"
#import "AdressPickerView.h"
#import "BusinessesShopViewController.h"

@interface MyShopViewController ()<UITextFieldDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UIAlertViewDelegate,UINavigationControllerDelegate,AdressPickerDelegate>

@property (nonatomic , strong) UIScrollView *bgScrollView;


@end

@implementation MyShopViewController{
    
    UIImagePickerController *_imagePicker;
    UIImageView       *_faceImageView;
    UILabel           *_adressLab;
    UIView            *_shopView;
    UpImagePL         *_upImagePL;                     //上传图片
    NSString          *_imageStr;
    AdressPickerView        *_areaPicker;       //地址选择器
    BOOL                    _areaPickIsShow;
    UIButton *_adressBtn;
}

-(UIScrollView *)bgScrollView{

    if (!_bgScrollView) {
        _bgScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight )];
        _bgScrollView.backgroundColor = UIColorFromRGB(PlaColorValue);
        _bgScrollView.contentSize = CGSizeMake(10, 500);
    }

    return _bgScrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.title = @"我的店铺";
    
    _upImagePL = [[UpImagePL alloc]init];
    [self initUI];
    [self loadTheShopInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}

- (void)initUI{
    [self.view addSubview:self.bgScrollView];
    UIImageView *colorImageView = [BaseViewFactory icomWithWidth:ScreenWidth imagePath:@"shop_topImage"];
    [self.bgScrollView addSubview:colorImageView];
    colorImageView.frame = CGRectMake(0, 0, ScreenWidth, 100);

    _faceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 40, 50, 50)];
    [_faceImageView setContentMode:UIViewContentModeScaleAspectFill];
    _faceImageView.image = [UIImage imageNamed:@"loding"];
    _faceImageView.clipsToBounds = YES;
    [self.bgScrollView addSubview:_faceImageView];
    
    UIView *downView = [BaseViewFactory viewWithFrame:CGRectMake(0, 100, ScreenWidth, 40) color:UIColorFromRGB(0x444a55)];
    [self.bgScrollView addSubview:downView];
    
    UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(20, 0, ScreenWidth - 120, 40) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@"设置店铺LOGO图，提高多买家的吸引力"];
    [downView addSubview:lab];
    
    SubBtn *setBtn = [SubBtn buttonWithtitle:@"设置" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:15 andtarget:self action:@selector(setBtnClick) andframe:CGRectMake(ScreenWidth - 80, 5, 60, 30)];
    [downView addSubview:setBtn];
    
    
   _shopView = [BaseViewFactory viewWithFrame:CGRectMake(0, 140, ScreenWidth, 300) color:UIColorFromRGB(WhiteColorValue)];
    [self.bgScrollView addSubview:_shopView];
    
    NSArray *titleArr = @[@"店铺名称",@"所在地区",@"详细地址",@"联系方式",@"主营范围",@"简介"];
    NSArray *placeholderArr = @[@"请输入店铺名称",@"请选择",@"请输入详细地址",@"请输入联系方式",@"请输入主营范围",@"请输入简介"];

    for (int i = 0; i<6; i++) {
        UIView *lineView = [BaseViewFactory viewWithFrame:CGRectMake(0, 50*i, ScreenWidth, 1) color:UIColorFromRGB(LineColorValue)];
        [_shopView addSubview:lineView];
        UILabel *namelab = [BaseViewFactory labelWithFrame:CGRectMake(20, 50*i, 80, 50) textColor:NSTextAlignmentLeft font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:titleArr[i]];
        namelab.textColor = UIColorFromRGB(BlackColorValue);
        [_shopView addSubview:namelab];
        
        if (i==1) {
            UIImageView *right = [BaseViewFactory icomWithWidth:10 imagePath:@"right"];
            [_shopView   addSubview:right];
            right.frame = CGRectMake(ScreenWidth - 30, 67, 10, 16);
            _adressLab =  [BaseViewFactory  labelWithFrame:CGRectMake(120, 50, ScreenWidth - 150, 50) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(13) textAligment:NSTextAlignmentRight andtext:@"请选择"];
            [_shopView addSubview:_adressLab];
            
            _adressBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            _adressBtn.frame = CGRectMake(120, 50, ScreenWidth - 120, 50);
            [_adressBtn addTarget:self action:@selector(adressBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [_shopView addSubview:_adressBtn];

            
        }else{
            UITextField *txt = [BaseViewFactory textFieldWithFrame:CGRectMake(120, 50*i, ScreenWidth - 140, 50) font:APPFONT(13) placeholder:placeholderArr[i] textColor:UIColorFromRGB(BlackColorValue) placeholderColor:UIColorFromRGB(0xdbdfe2) delegate:self];
            txt.textAlignment = NSTextAlignmentRight;
            txt.tag = 1000+i;
            if (i==3) {
                txt.keyboardType = UIKeyboardTypePhonePad;
            }
            [txt addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
            [_shopView   addSubview:txt];
        }
    }
    
    SubBtn  *makeSureBtn = [SubBtn buttonWithtitle:@"确认修改" backgroundColor:UIColorFromRGB(0xfbd30d) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(makeSureBtnCLick)];
    [self.view addSubview:makeSureBtn];
    makeSureBtn.frame = CGRectMake(0, ScreenHeight - 50-NaviHeight64-iPhoneX_DOWNHEIGHT, ScreenWidth/2, 50);
    
    
    SubBtn  *lookBtn = [SubBtn buttonWithtitle:@"查看店铺" backgroundColor:UIColorFromRGB(0xff4354) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:0 andtarget:self action:@selector(lookCLick)];
    [self.view addSubview:lookBtn];
    lookBtn.frame = CGRectMake(ScreenWidth/2, ScreenHeight - 50-NaviHeight64-iPhoneX_DOWNHEIGHT, ScreenWidth/2, 50);
    

}
#pragma mark ======== 加载店铺信息
- (void)loadTheShopInfo{

[ShopSettingPL getTheShopSettingInfoWithReturnBlock:^(id returnValue) {
    NSLog(@"%@",returnValue);
    [self refreshUIWithDic:returnValue];
} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];
}];
}



- (void)refreshUIWithDic:(NSDictionary *)dic{

    UITextField *nameTxt = [_shopView viewWithTag:1000];
    UITextField *adressTxt = [_shopView viewWithTag:1002];
    UITextField *phoneTxt = [_shopView viewWithTag:1003];
    UITextField *saleTxt = [_shopView viewWithTag:1004];
    UITextField *introTxt = [_shopView viewWithTag:1005];

        nameTxt.text =  NULL_TO_NIL(dic[@"shopName"]);

        _adressLab.text = NULL_TO_NIL(dic[@"shopArea"]) ;
        
        adressTxt.text =  NULL_TO_NIL(dic[@"shopAddress"]) ;
        
        phoneTxt.text =  NULL_TO_NIL(dic[@"shopContact"]) ;
        
        saleTxt.text = NULL_TO_NIL(dic[@"shopMainBusiness"]) ;
        
        introTxt.text =  NULL_TO_NIL( dic[@"shopDescription"]);
        
    if (dic[@"shopLogoImageUrl"]) {
        NSArray *arr =[dic[@"shopLogoImageUrl"]componentsSeparatedByString:@"om6h1w22l.qnssl.com/"];
        if (arr.count>1) {
            _imageStr = arr[1];
        }
    }
    [_faceImageView sd_setImageWithURL:[NSURL URLWithString:dic[@"shopLogoImageUrl"]] placeholderImage:[UIImage imageNamed:@"loding"]];

}


#pragma mark ======== 按钮点击
/**
 设置图片
 */
- (void)setBtnClick{
    [self chosePhoto];

}

/**
 选择地址
 */
- (void)adressBtnClick{
    [self presentAreaPicker];


}

/**
 确认修改
 */
- (void)makeSureBtnCLick{
    UITextField *nameTxt = [_shopView viewWithTag:1000];
    UITextField *adressTxt = [_shopView viewWithTag:1002];
    UITextField *phoneTxt = [_shopView viewWithTag:1003];
    UITextField *saleTxt = [_shopView viewWithTag:1004];
    UITextField *introTxt = [_shopView viewWithTag:1005];
    int a  = [GlobalMethod textLength:nameTxt.text];
    if (a>20) {
        [self showTextHud:@"店铺名称不能超过20个字符"];
        return;
    }
    NSDictionary *dic1 = @{@"setting":@"shopName",
                           @"value":nameTxt.text.length>0?nameTxt.text:@""
                           };
    NSDictionary *dic2 = @{@"setting":@"shopLogoImageUrl",
                           @"value":_imageStr.length>0?_imageStr:@""
                           };
    NSDictionary *dic3 = @{@"setting":@"shopFacadeImageUrl",
                           @"value":@""
                           };
    NSDictionary *dic4 = @{@"setting":@"shopAddress",
                           @"value":adressTxt.text.length>0?adressTxt.text:@""
                           };
    NSDictionary *dic5 = @{@"setting":@"shopArea",
                           @"value":_adressLab.text.length>0?_adressLab.text:@""
                           };
    NSDictionary *dic6 = @{@"setting":@"shopDescription",
                           @"value":introTxt.text.length>0?introTxt.text:@""
                           };
    NSDictionary *dic7 = @{@"setting":@"shopContact",
                           @"value":phoneTxt.text.length>0?phoneTxt.text:@""
                           };
    NSDictionary *dic8 = @{@"setting":@"shopMainBusiness",
                           @"value":saleTxt.text.length>0?saleTxt.text:@""
                           };
    NSArray *settingArr = @[[self thedictionaryToJson:dic1],[self thedictionaryToJson:dic2],[self thedictionaryToJson:dic3],[self thedictionaryToJson:dic4],[self thedictionaryToJson:dic5],[self thedictionaryToJson:dic6],[self thedictionaryToJson:dic7],[self thedictionaryToJson:dic8],];
    
    NSDictionary *setDic = @{@"settings":[NSString stringWithFormat:@"[%@]",[settingArr componentsJoinedByString:@","]]};
    [ShopSettingPL SettingTheShopInfoWithDic:setDic andReturnBlock:^(id returnValue) {
        [self showTextHud:@"设置保存成功"];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
    }];
    
    NSLog(@"ffff");
    

}

/**
 查看店铺
 */
- (void)lookCLick{
[ShopSettingPL getTheShopIdWithReturnBlock:^(id returnValue) {
    BusinessesShopViewController  *bussvc = [[BusinessesShopViewController alloc]init];
    bussvc.shopId = returnValue[@"id"];
    [self.navigationController pushViewController:bussvc animated:YES];
    
} andErrorBlock:^(NSString *msg) {
    [self showTextHud:msg];

}];


}



#pragma mark ======== 地址选择
- (void)presentAreaPicker
{
    [self.view endEditing:YES];
    if (!_areaPicker) {
        _areaPicker = [[AdressPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 168)];
        _areaPicker.delegate = self;
    }
    if (!_areaPickIsShow) {
        [_areaPicker showInView:self.view];
        _areaPickIsShow = YES;
        _adressBtn.userInteractionEnabled = NO;
        
        
    }}
- (void)hideKeyBoard{
    [[UIApplication sharedApplication] sendAction:@selector(resignFirstResponder) to:nil from:nil forEvent:nil];
    if (_areaPickIsShow) {
        [_areaPicker cancelPicker];
        _areaPickIsShow = NO;
        _adressBtn.userInteractionEnabled = YES;
        
    }
    
}

#pragma mark--------------------------------JYAreaPickerDelegate--------------------------------
- (void)pickerDidChaneStatus:(AdressPickerView *)picker
{
    if (picker == _areaPicker) {
        NSString *areaString = [NSString stringWithFormat:@"%@%@%@", _areaPicker.provinceDic, _areaPicker.cityDic,_areaPicker.areaDic];
        NSLog(@"选择地址===========%@",areaString);
//        _code1 =  _areaPicker.provinceDic[@"code"];
//        _code2 =  _areaPicker.cityDic[@"code"];
//        _code3 =  _areaPicker.areaDic[@"code"];
        
        [_adressLab setText:[NSString stringWithFormat:@"%@%@%@", _areaPicker.provinceDic[@"name"], _areaPicker.cityDic[@"name"],_areaPicker.areaDic[@"name"]]];
        
    }
}


#pragma mark  ================  选取照片

- (void)chosePhoto{
    if (!_imagePicker) {
        _imagePicker = [[UIImagePickerController alloc] init];
      //  _imagePicker.allowsEditing = YES;
        
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
//    _isChoiceCamera = YES;
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
//    _isChoiceCamera= NO;
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
    _faceImageView.image  = image;
    __weak __typeof(self)weakSelf = self;
    
    [_upImagePL updateImg:image WithReturnBlock:^(id returnValue) {
        NSDictionary *imageDic = returnValue;
        NSArray *arr = imageDic[@"imageUrls"];
//        _imageStr = [NSString stringWithFormat:@"https://om6h1w22l.qnssl.com/%@",arr[0]];
        _imageStr = arr[0];
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
    
    kb*=1024;
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

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
//    if ([string isEqualToString:@""]) {
//        return YES;
//    }
//    if (textField.tag == 1000) {
//        int a = [GlobalMethod textLength:textField.text];
//        if (a>20) {
//
//            return NO;
//        }
//    }
//
    return YES;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
//    if (theTextField.tag == 1000) {
//
//        int a = [GlobalMethod textLength:theTextField.text];
//        theTextField.text = [GlobalMethod subTextString:theTextField.text len:10];
//
//
//    }
    
    
}
@end
