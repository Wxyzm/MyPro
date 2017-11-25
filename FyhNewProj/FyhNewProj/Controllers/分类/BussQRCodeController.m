//
//  BussQRCodeController.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BussQRCodeController.h"
#import "BussShowPL.h"
#import "NSString+ZXingQRImage.h"

@interface BussQRCodeController ()<UIActionSheetDelegate>

@end

@implementation BussQRCodeController{
    UIImageView *_showImageView;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    [self createNavigationItem];
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    [self loadShopInfo];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    myView.backgroundColor = [UIColor whiteColor];
    myView.layer.sublayers[0].hidden = YES;
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = YES;
    }
    NSLog(@"%@",myView.layer.sublayers);
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }

}
#pragma mark =========  UI

/**
 navigationBar
 */
- (void)createNavigationItem
{
    self.view.backgroundColor = UIColorFromRGB(0xf5f7fa);
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext:@"店铺二维码"];
    self.navigationItem.titleView = titlelab;
    
}

#pragma mark =========  网络请求

/**
 店铺简介
 */
- (void)loadShopInfo{
    
    NSDictionary *dic = @{@"itemPageNum":@"1",
                          @"itemTitle":@"",
                          @"itemCategoryId":@""
                          };
    
    [BussShowPL GetShopInfoWithShopID:_shopId andDic:dic andReturnBlock:^(id returnValue) {
        NSLog(@"商家简介===%@",returnValue);
        [self initUIWithreturnValue:(NSDictionary *)returnValue[@"shopInfo"]];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:@"商家信息获取失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}
#pragma mark =========  initUI

- (void)initUIWithreturnValue:(NSDictionary *)dic{
    
    UIView *view = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    [self.view addSubview:view];
    
    view.sd_layout.
    widthIs(280).
    heightIs(360).
    topSpaceToView(self.view, 80).
    centerXEqualToView(self.view);
    
    //
    UIImageView * faceImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    [faceImageView setContentMode:UIViewContentModeScaleAspectFill];
    faceImageView.clipsToBounds = YES;
    [view addSubview:faceImageView];
    
    UILabel *nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
    [view addSubview:nameLab];
    
    UILabel *saleKindLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
    [view addSubview:saleKindLab];
    
    //
    faceImageView.sd_layout.
    leftSpaceToView(view, 16).
    topSpaceToView(view, 20).
    widthIs(50).
    heightIs(50);
    //
    nameLab.sd_layout.
    leftSpaceToView(faceImageView, 12).
    topSpaceToView(view, 26.5).
    rightSpaceToView(view, 16).
    heightIs(16);
    //
    saleKindLab.sd_layout.
    leftSpaceToView(faceImageView, 12).
    topSpaceToView(nameLab, 9).
    rightSpaceToView(view, 16).
    heightIs(14);
    //
    if (NULL_TO_NIL( dic[@"shopLogoImageUrl"])) {
        [faceImageView  sd_setImageWithURL:[NSURL URLWithString:NULL_TO_NIL(dic[@"shopLogoImageUrl"])] placeholderImage:[UIImage imageNamed:@"loding"]];
    }else{
        faceImageView.image = [UIImage imageNamed:@"loding"];
    }
    if (NULL_TO_NIL(dic[@"shopName"])) {
        nameLab.text =  NULL_TO_NIL(dic[@"shopName"]);
    }else{
        nameLab.text =  NULL_TO_NIL(dic[@"sellerInfo"]);
    }
        saleKindLab.text = NULL_TO_NIL(dic[@"shopDescription"]) ;
    //
    UIView *view1 = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0x656d78)];
    [view addSubview:view1];
    view1.sd_layout.
    widthIs(240).
    heightIs(240).
    topSpaceToView(view, 80).
    centerXEqualToView(view);
    //
    _showImageView = [[UIImageView alloc]init];
    _showImageView.frame = CGRectMake(20 , 20, 200, 200);
    _showImageView.contentMode = UIViewContentModeScaleAspectFill;
    _showImageView.userInteractionEnabled = YES;
    
    UILongPressGestureRecognizer * longPressGr = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
    [_showImageView addGestureRecognizer:longPressGr];
    
    UIImage *qrImage = [self encodeQRImageWithContent:[NSString stringWithFormat:@"%@/shop/%@",kbaseUrl,_shopId] size:CGSizeMake(200, 200)];
    _showImageView.image = qrImage;
    [view1 addSubview:_showImageView];

    //
    UILabel *scanlab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentCenter andtext:@"扫描我的二维码，快来选购吧"];
    [view addSubview:scanlab];
    scanlab.sd_layout.
    leftSpaceToView(view, 0).
    rightSpaceToView(view, 0).
    topSpaceToView(view1, 12).
    heightIs(14);
    //
    UILabel *touchlab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"长按保存二维码"];
    [self.view addSubview:touchlab];
    touchlab.sd_layout.
    leftSpaceToView(self.view, 0).
    rightSpaceToView(self.view, 0).
    topSpaceToView(view, 12).
    heightIs(16);
    
}

- (UIImage *)encodeQRImageWithContent:(NSString *)content size:(CGSize)size {
    UIImage *codeImage = nil;
        NSData *stringData = [content dataUsingEncoding: NSUTF8StringEncoding];
        
        //生成
        CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
        [qrFilter setValue:stringData forKey:@"inputMessage"];
        [qrFilter setValue:@"M" forKey:@"inputCorrectionLevel"];
        
        UIColor *onColor = [UIColor blackColor];
        UIColor *offColor = [UIColor whiteColor];
        
        //上色
        CIFilter *colorFilter = [CIFilter filterWithName:@"CIFalseColor"
                                           keysAndValues:
                                 @"inputImage",qrFilter.outputImage,
                                 @"inputColor0",[CIColor colorWithCGColor:onColor.CGColor],
                                 @"inputColor1",[CIColor colorWithCGColor:offColor.CGColor],
                                 nil];
        
        CIImage *qrImage = colorFilter.outputImage;
        CGImageRef cgImage = [[CIContext contextWithOptions:nil] createCGImage:qrImage fromRect:qrImage.extent];
        UIGraphicsBeginImageContext(size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetInterpolationQuality(context, kCGInterpolationNone);
        CGContextScaleCTM(context, 1.0, -1.0);
        CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
        codeImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        CGImageRelease(cgImage);
    
    return codeImage;
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    
    if(gesture.state==UIGestureRecognizerStateBegan){
        if (!_showImageView.image) {
            return;
        }
        UIActionSheet *actionSheet = [[UIActionSheet alloc]
                                      initWithTitle:nil
                                      delegate:self
                                      cancelButtonTitle:@"取消"
                                      destructiveButtonTitle:nil
                                      otherButtonTitles:@"保存到相册", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleBlackOpaque;
        [actionSheet showInView:self.view];
    }
   
   
    
   

}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if(!error) {
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"成功保存到相册" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
        
        
    }else{
        
        UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:@"提示" message:@"图片保存失败" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertControl addAction:action];
        
        [self presentViewController:alertControl animated:YES completion:nil];
        
    }
    
}





#pragma mark--------------------------------UIActionDelegate--------------------------------
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == actionSheet.cancelButtonIndex) {
        return;
    }
    switch (buttonIndex) {
        case 0:
            UIImageWriteToSavedPhotosAlbum(_showImageView.image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);            break;
        
        default:
            break;
    }
}


@end
