//
//  PrintQrNewViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/6/5.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "PrintQrNewViewController.h"
#import "BaseViewFactory.h"
#import "ProjectMacro.h"
#import "NSString+ZXingQRImage.h"
#import "ConnectViewController.h"
#import "SubBtn.h"
#import "AppDelegate.h"

#import "TscCommand.h"
#import "BLKWrite.h"
#import "EscCommand.h"
#import "ShopSettingPL.h"

#import "LYConnectViewController.h"
#import "SizeBtn.h"
#import <CoreBluetooth/CoreBluetooth.h>

@interface PrintQrNewViewController ()<UITextViewDelegate,UITextFieldDelegate,CBCentralManagerDelegate>
@property (nonatomic , strong) CBCentralManager *centralManager;

@end

@implementation PrintQrNewViewController{

    UITextView      *_text1;
    UITextField     *_numberTxt;
    NSMutableArray  *_textfieldArr;
    NSArray         *_btnArr;

    SizeBtn  *_btn1;             //60  40
    SizeBtn  *_btn2;             //60  50
    SizeBtn  *_btn3;             //70  40
    SizeBtn  *_btn4;             //70  50
    UILabel *sizelab;
    UILabel *numlab;
    UIView *view8;
    UIView *view9;
    NSDictionary    *_printDic;
    UIImageView *_imageview;
    BOOL         _BoothIsOpen;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(LineColorValue);
    _textfieldArr = [NSMutableArray arrayWithCapacity:0];
    _btnArr = [NSArray array];
    [self setBarBackBtnWithImage:nil];

    self.navigationItem.title = @"二维码打印";
    [self loadTheShopInfo];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)setUp{
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - 64)];
    [self.view addSubview:scrollView];
    scrollView.contentSize = CGSizeMake(10, 570);

    CGFloat  _OriginY1 = 85;
    
    _imageview = [[UIImageView alloc]init];
    _imageview.contentMode = UIViewContentModeScaleToFill;
    [scrollView addSubview:_imageview];
    _imageview.userInteractionEnabled = YES;
    if (iPad) {
        _imageview.image = [UIImage imageNamed:@"QR_Padback"];
        _imageview.frame = CGRectMake(50, 35*TimeScaleY, ScreenWidth -100, (ScreenHeight -64-35*TimeScaleY*2));

    }else{
         _imageview.image = [UIImage imageNamed:@"QR_backIma"];
        _imageview.frame = CGRectMake(25, 35, ScreenWidth - 50, 500);

    }

    
    UIImageView *showImageView = [[UIImageView alloc]init];
    showImageView.frame = CGRectMake(0 , 82, 115, 115);
    showImageView.contentMode = UIViewContentModeScaleToFill;
    if (iPad) {
        showImageView.frame = CGRectMake(0 , 160, 115, 115);
    }
    UIImage *qrImage = [NSString becomeQRCodeWithQRstring:_infoDic[@"url"] withWidth:90 withHight:90];
    showImageView.image = qrImage;
    [_imageview addSubview:showImageView];

    UILabel *fyhLab;
         fyhLab = [BaseViewFactory labelWithFrame:CGRectMake(15, 200, 200, 15) textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"FYH88.COM"];
   
   
    [_imageview   addSubview:fyhLab];
    if (iPad) {
        fyhLab.frame = CGRectMake(15, 280, 200, 15);
    }
    
    CGFloat view1Width = ScreenWidth - 50-125-15;
    if (iPad) {
       view1Width = ScreenWidth - 100-125-15;
        _OriginY1+=40;
    }
    
    
    UIView *view1 = [BaseViewFactory viewWithFrame:CGRectMake(120, _OriginY1, view1Width, 44) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:view1];
    view1.layer.cornerRadius = 5;
    view1.layer.borderColor = UIColorFromRGB(0x434a54).CGColor;
    view1.layer.borderWidth = 1;
    
    UIButton *view1_deleteBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [view1_deleteBtn1 setImage:[UIImage imageNamed:@"xx"] forState:UIControlStateNormal];
    [view1 addSubview:view1_deleteBtn1];
    view1_deleteBtn1.frame = CGRectMake(view1Width -16, 0, 16, 44);
    [view1_deleteBtn1 addTarget:self action:@selector(view1_deleteBtn1Click) forControlEvents:UIControlEventTouchUpInside];
    if (iPad) {
        view1.frame = CGRectMake(120, _OriginY1, view1Width, 60);
        view1_deleteBtn1.frame = CGRectMake(view1Width -16, 0, 16, 60);

        _OriginY1+=60+12;
    }else{
        _OriginY1 +=44+12;

    }
   
    
    
    
    
    CGFloat view2Width =44;
    UIView *view2 = [BaseViewFactory viewWithFrame:CGRectMake(120, _OriginY1, view2Width, 22) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:view2];
    view2.layer.cornerRadius = 5;
    view2.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
    view2.layer.borderWidth = 1;

    
    CGFloat view3Width =view1Width - 44 -8;
    UIView *view3 = [BaseViewFactory viewWithFrame:CGRectMake(172, _OriginY1, view3Width, 22) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:view3];
    view3.layer.cornerRadius = 5;
    view3.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
    view3.layer.borderWidth = 1;

    if (iPad) {
        view2.frame = CGRectMake(120, _OriginY1, view2Width, 40);
        view3.frame = CGRectMake(172, _OriginY1, view3Width, 40);

        _OriginY1+=40+12;
    }else{
        _OriginY1 +=22+12;

    }

    
    CGFloat view4Width =44;
    UIView *view4 = [BaseViewFactory viewWithFrame:CGRectMake(120, _OriginY1, view4Width, 22) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:view4];
    view4.layer.cornerRadius = 5;
    view4.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
    view4.layer.borderWidth = 1;
    
    
    CGFloat view5Width =view1Width - 44 -8;
    UIView *view5 = [BaseViewFactory viewWithFrame:CGRectMake(172, _OriginY1, view5Width, 22) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:view5];
    view5.layer.cornerRadius = 5;
    view5.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
    view5.layer.borderWidth = 1;
    
    if (iPad) {
        view4.frame = CGRectMake(120, _OriginY1, view4Width, 40);
        view5.frame = CGRectMake(172, _OriginY1, view5Width, 40);
        
        _OriginY1+=40+12;
    }else{
        _OriginY1 +=22+12;
        
    }
    
    CGFloat view6Width =44;
    UIView *view6 = [BaseViewFactory viewWithFrame:CGRectMake(120, _OriginY1, view6Width, 22) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:view6];
    view6.layer.cornerRadius = 5;
    view6.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
    view6.layer.borderWidth = 1;
    
    
    CGFloat view7Width =view1Width - 44 -8;
    UIView *view7 = [BaseViewFactory viewWithFrame:CGRectMake(172, _OriginY1, view7Width, 22) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:view7];
    view7.layer.cornerRadius = 5;
    view7.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
    view7.layer.borderWidth = 1;

    if (iPad) {
        view6.frame = CGRectMake(120, _OriginY1, view6Width, 40);
        view7.frame = CGRectMake(172, _OriginY1, view7Width, 40);
        
        _OriginY1+=40+12;
    }else{
        _OriginY1 +=22+12;
        
    }
    
    CGFloat view8Width =44;
    view8 = [BaseViewFactory viewWithFrame:CGRectMake(120, _OriginY1, view6Width, 22) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:view8];
    view8.layer.cornerRadius = 5;
    view8.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
    view8.layer.borderWidth = 1;
    view8.hidden = YES;
    
    CGFloat view9Width =view1Width - 44 -8;
    view9 = [BaseViewFactory viewWithFrame:CGRectMake(172, _OriginY1, view7Width, 22) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:view9];
    view9.layer.cornerRadius = 5;
    view9.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
    view9.layer.borderWidth = 1;
    view9.hidden = YES;
    
    if (iPad) {
        view8.frame = CGRectMake(120, _OriginY1, view8Width, 40);
        view9.frame = CGRectMake(172, _OriginY1, view9Width, 40);
        
        _OriginY1+=40+12;
    }else{
        _OriginY1 +=22+12;
        
    }
    NSArray *viewArr = @[view2,view3,view4,view5,view6,view7,view8,view9];
    
    NSArray *textArr = @[@"货号",_infoDic[@"customBn"],@"克重",[NSString stringWithFormat:@"%@",_infoDic[@"bn"]],@"成分",_infoDic[@"ingredient"],@"门幅",_infoDic[@"Width"]];
    for (int i = 0; i<viewArr.count; i++) {
        UIView *theview = viewArr[i];
        
        UITextField *textField = [BaseViewFactory textFieldWithFrame:CGRectMake(8, 0, theview.width - 20, 22) font:APPFONT(11) placeholder:@"" textColor:UIColorFromRGB(0xaab2bd) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
        [theview addSubview:textField];
        textField.textAlignment = NSTextAlignmentCenter;
        textField.text = textArr[i];
        [self adddeleteButtonWithview:theview andBunTag:1000+i];
        [_textfieldArr addObject:textField];
        if (iPad) {
            textField.frame = CGRectMake(8, 0, theview.width - 20, 40);
        }
        if (_type == 1) {
            textField.userInteractionEnabled = NO;
        }
        
    }
    _text1 = [[UITextView alloc]initWithFrame:CGRectMake(8, 0, view1Width - 24, 44)];
    _text1.textColor = UIColorFromRGB(0x434a54);
    _text1.font = APPFONT(14);
    _text1.delegate = self;
    _text1.keyboardType = UIKeyboardTypeDefault;
    [view1 addSubview:_text1];
    _text1.text = _infoDic[@"title"];
    if (iPad) {
        _text1.frame = CGRectMake(8, 0,view1Width - 24, 60);
    }
    
    
    SubBtn *btn = [SubBtn buttonWithtitle:@"确认打印" titlecolor:UIColorFromRGB(0xffffff) cornerRadius:21 andtarget:self action:@selector(printQrcode) andframe:CGRectMake(35, _imageview.bottom - 60 - 35, _imageview.width - 70, 42)];
    [_imageview  addSubview:btn];
    if (iPad) {
        btn.frame = CGRectMake(35, _imageview.bottom - 60 - 35-80, _imageview.width - 70, 42);
    }
    
    numlab = [BaseViewFactory labelWithFrame:CGRectMake(37, btn.top-60, 50, 30) textColor:UIColorFromRGB(0x434a54) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@"数量:"];
    [_imageview  addSubview:numlab];
    if (iPad) {
        numlab.frame =CGRectMake(37, btn.top-160, 50, 30);
    }
    
   sizelab  = [BaseViewFactory labelWithFrame:CGRectMake(37, numlab.top-91, 50, 30) textColor:UIColorFromRGB(0x434a54) font:APPFONT(14) textAligment:NSTextAlignmentLeft andtext:@"尺寸:"];
    [_imageview  addSubview:sizelab];
    if (iPad) {
        sizelab.frame =CGRectMake(37, numlab.top-91, 50, 30);
    }
//    _btn1 = [SizeBtn buttonWithType:UIButtonTypeCustom];
//    [_btn1 setTitle:@"60*40(mm)" forState:UIControlStateNormal];
//    _btn1.on = YES;
//    
//    _btn2 = [SizeBtn buttonWithType:UIButtonTypeCustom];
//    [_btn2 setTitle:@"60*50(mm)" forState:UIControlStateNormal];
//    
    _btn3 = [SizeBtn buttonWithType:UIButtonTypeCustom];
    [_btn3 setTitle:@"70*40(mm)" forState:UIControlStateNormal];
    
//    _btn4 = [SizeBtn buttonWithType:UIButtonTypeCustom];
//    [_btn4 setTitle:@"70*50(mm)" forState:UIControlStateNormal];
    _btn3.on = YES;
    _btn3.layer.cornerRadius = 5;
    _btn3.titleLabel.font = APPFONT(11);
    _btn3.layer.borderColor = UIColorFromRGB(0x434a54).CGColor;
    _btn3.layer.borderWidth = 1;
    [_imageview addSubview:_btn3];
    [_btn3 addTarget:self action:@selector(sizeBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPhone5) {
        _btn3.frame = CGRectMake(87, sizelab.top , 70, 22);
        
    }else if (iPad){
        _btn3.frame = CGRectMake(87, sizelab.top -100, 80, 22);
        
    }else{
        _btn3.frame = CGRectMake(87, sizelab.top , 80, 22);
        
    }
    
    
    
    _btn4 = [SizeBtn buttonWithType:UIButtonTypeCustom];
    [_btn4 setTitle:@"80*50(mm)" forState:UIControlStateNormal];
    _btn4.on = NO;
    _btn4.layer.cornerRadius = 5;
    _btn4.titleLabel.font = APPFONT(11);
        _btn4.layer.borderColor = UIColorFromRGB(0x434a54).CGColor;
        _btn4.layer.borderWidth = 1;
    [_imageview addSubview:_btn4];
    [_btn4 addTarget:self action:@selector(sizeBtnclick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPhone5) {
        _btn4.frame = CGRectMake(87+107, sizelab.top , 70, 22);
        
    }else if (iPad){
        _btn4.frame = CGRectMake(87+107, sizelab.top -100, 80, 22);
        
    }else{
        _btn4.frame = CGRectMake(87+107, sizelab.top , 80, 22);
        
    }
    _btnArr = @[_btn3,_btn4];
    [self makesureTheColorOfBtn];
//    _btnArr = @[_btn1,_btn2,_btn3,_btn4];
//    for (int i = 0; i<_btnArr.count; i++) {
//        int a = i/2;
//        int b = i%2;
//        SizeBtn *btn = _btnArr[i];
//        btn.layer.cornerRadius = 5;
//        btn.titleLabel.font = APPFONT(11);
//        btn.layer.borderColor = UIColorFromRGB(0x434a54).CGColor;
//        btn.layer.borderWidth = 1;
//        [imageview addSubview:btn];
//        [btn addTarget:self action:@selector(sizeBtnclick:) forControlEvents:UIControlEventTouchUpInside];
//        if (iPhone5) {
//            btn.frame = CGRectMake(87+98*b, sizelab.top+34 *a, 70, 22);
//
//        }else{
//            btn.frame = CGRectMake(87+108*b, sizelab.top+34 *a, 80, 22);
//
//        }
//    }
//    [self makesureTheColorOfBtn];
    
    UIView *bgView = [BaseViewFactory viewWithFrame:CGRectMake(87, numlab.top, 188, 30) color:UIColorFromRGB(0xffffff)];
    [_imageview addSubview:bgView];
    bgView.layer.cornerRadius = 5;
    bgView.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
    bgView.layer.borderWidth = 1;
    if (iPad){
        _btn3.frame = CGRectMake(87, numlab.top-100, 188, 30);
        
    }
    UIView *leftLine = [BaseViewFactory viewWithFrame:CGRectMake(37, 5, 1, 20) color:UIColorFromRGB(0xaab2bd)];
    [bgView addSubview:leftLine];
    UIView *rightLine = [BaseViewFactory viewWithFrame:CGRectMake(bgView.width - 37, 5, 1, 20) color:UIColorFromRGB(0xaab2bd)];
    [bgView addSubview:rightLine];
    
    UIView *decreaseLine = [BaseViewFactory viewWithFrame:CGRectMake(13, 14, 12, 2) color:UIColorFromRGB(0xccd1d9)];
    [bgView addSubview:decreaseLine];
    UIButton *decreaseBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    decreaseBtn.frame = CGRectMake(0, 0, 37, 30);
    [bgView addSubview:decreaseBtn];
    
    UIView *addLine1 = [BaseViewFactory viewWithFrame:CGRectMake(164, 14, 12, 2) color:UIColorFromRGB(0x434a54)];
    [bgView addSubview:addLine1];
    UIView *addLine2 = [BaseViewFactory viewWithFrame:CGRectMake(168.5, 9, 2, 12) color:UIColorFromRGB(0x434a54)];
    [bgView addSubview:addLine2];
    
    UIButton *addBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    addBtn.frame = CGRectMake(bgView.width - 37, 0, 37, 30);
    [bgView addSubview:addBtn];
    
    
    [decreaseBtn addTarget:self action:@selector(decreaseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [addBtn addTarget:self action:@selector(addBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    _numberTxt = [BaseViewFactory  textFieldWithFrame:CGRectMake(37, 0, 114, 30) font:APPFONT(13) placeholder:@"" textColor:UIColorFromRGB(0x434a54) placeholderColor:UIColorFromRGB(0xaab2bd) delegate:self];
    _numberTxt.textAlignment = NSTextAlignmentCenter;
    _numberTxt.keyboardType = UIKeyboardTypeNumberPad;
    [bgView addSubview:_numberTxt];
    _numberTxt.text = @"1";
    if (iPhone5) {
        bgView.frame = CGRectMake(87, numlab.top, 168, 30);
        _numberTxt.frame =CGRectMake(37, 0, 94, 30);
        rightLine.frame = CGRectMake(bgView.width - 37, 5, 1, 20);
        addLine1.frame =CGRectMake(144, 14, 12, 2);
        addLine2.frame =CGRectMake(148.5, 9, 2, 12);
        addBtn.frame = CGRectMake(bgView.width - 37, 0, 37, 30);
    }
    
    if (_type == 1) {
        view1_deleteBtn1.hidden = YES;
        _text1.userInteractionEnabled = NO;

    }
    
//    _number = 1;
    //判断蓝牙是否开启
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil options:@{@"CBCentralManagerOptionShowPowerAlertKey":@NO}];


}








/**
 打印前确认
 */
- (void)printQrcode{
    if (!_BoothIsOpen) {
        [self openBluthSetting];
        return;
    }
        if([[BLKWrite Instance] isConnecting]){
            if (_type ==1) {
                
                if (_dataArr.count > 0) {
                    for (NSDictionary *dic in _dataArr) {
                        int a = [_numberTxt.text intValue];
                        if (a>0) {
                            for (int i = 0 ; i<a; i++) {
                                [self morePrintwithDic:dic];
                            }
                        }
                    }
                    
                    
                }
                

                
                
            }else{
                int a = [_numberTxt.text intValue];
                if (a>0) {
                    for (int i = 0 ; i<a; i++) {
                        [self GprinterPrint];
                    }
                }else{
                    
                    [self GprinterPrint];
                }
                
            }
           
    
    
        }
        else{
            [[BLKWrite Instance] setBWiFiMode:NO];
            AppDelegate *dele = (AppDelegate*)[UIApplication sharedApplication].delegate;
            [self.navigationController pushViewController:dele.LYConnBLE animated:YES];
        }

}


- (void)morePrintwithDic:(NSDictionary*)dic{
    TscCommand *tscCmd = [[TscCommand alloc] init];
    [tscCmd setHasResponse:YES];
    // NSArray *textArr = @[@"货号",_infoDic[@"customBn"],@"克重",[NSString stringWithFormat:@"%@",_infoDic[@"bn"]],@"成分",_infoDic[@"ingredient"],@"门幅",_infoDic[@"Width"]];
    //名称
    NSString *namestr = dic[@"title"];
    //
  
    NSString *proNumberstr = [NSString stringWithFormat:@"货号：%@",dic[@"customBn"]];
    //

    NSString *Numberstr = [NSString stringWithFormat:@"克重：%@",dic[@"bn"]];
    //
    NSString *unitstr = [NSString stringWithFormat:@"成分：%@",dic[@"ingredient"]];
    
    
  
    //一个字符高度24
    if (_btn3.on){
        //70  40
        [tscCmd addSize:70 :40];
        
        //GAP
        [tscCmd addGapWithM:2   withN:0];
        
        //REFERENCE
        [tscCmd addReference:0
                            :24];
        
        //SPEED
        [tscCmd addSpeed:4];
        
        //DENSITY
        
        [tscCmd addDensity:8];
        
        //DIRECTION
        [tscCmd addDirection:0];
        
        //fixed command
        [tscCmd addComonCommand];
        [tscCmd addCls];
        
        
        
        if (_printDic[@"shopName"]) {
            [tscCmd addTextwithX:0
                           withY:12
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:2
                       withYscal:2
                        withText:_printDic[@"shopName"]];
            
        }else{
            [tscCmd addTextwithX:0
                           withY:12
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:2
                       withYscal:2
                        withText:@"FYH88.COM"];
            
        }
        [tscCmd addQRCode:0
                         :80
                         :@"L"
                         :5
                         :@"A"
                         :0
                         :_infoDic[@"url"]];
        
        [tscCmd addTextwithX:0
                       withY:224
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:@"FYH88.COM"];
        
        if ([self isStr:namestr moreThanLenth:13]) {
            //标题两行
            NSMutableArray * strarr = [self subTextString:namestr len:13];
            
            [tscCmd addTextwithX:180
                           withY:80
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:strarr[0]];
            
            [tscCmd addTextwithX:180
                           withY:110
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:strarr[1]];
            
            [tscCmd addTextwithX:180
                           withY:148
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:proNumberstr];
            
            [tscCmd addTextwithX:180
                           withY:186
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:Numberstr];
            
            [tscCmd addTextwithX:180
                           withY:224
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:unitstr];
            
            
        }else{
            
            //字符高度24  空24
            
            [tscCmd addTextwithX:180
                           withY:80
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:namestr];
            
            [tscCmd addTextwithX:180
                           withY:128
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:proNumberstr];
            
            [tscCmd addTextwithX:180
                           withY:176
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:Numberstr];
            
            [tscCmd addTextwithX:180
                           withY:224
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:unitstr];
            
            
        }
        
    }else{
        //80  50
        [tscCmd addSize:80 :50];
        
        //GAP
        [tscCmd addGapWithM:2   withN:0];
        
        //REFERENCE
        [tscCmd addReference:48
                            :24];
        
        //SPEED
        [tscCmd addSpeed:4];
        
        //DENSITY
        
        [tscCmd addDensity:8];
        
        //DIRECTION
        [tscCmd addDirection:0];
        
        //fixed command
        [tscCmd addComonCommand];
        [tscCmd addCls];
        
        if (_printDic[@"shopName"]) {
            [tscCmd addTextwithX:0
                           withY:24
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:2
                       withYscal:2
                        withText:_printDic[@"shopName"]];
            
        }else{
            [tscCmd addTextwithX:0
                           withY:24
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:2
                       withYscal:2
                        withText:@"FYH88.COM"];
        }
        
        [tscCmd addQRCode:0
                         :104
                         :@"L"
                         :5
                         :@"A"
                         :0
                         :_infoDic[@"url"]];
        [tscCmd addTextwithX:0
                       withY:248
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:@"FYH88.COM"];
        
        
        if ([self isStr:namestr moreThanLenth:17]) {
            //标题两行
            NSMutableArray * strarr = [self subTextString:namestr len:17];
            
            [tscCmd addTextwithX:156
                           withY:104
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:strarr[0]];
            
            [tscCmd addTextwithX:156
                           withY:134
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:strarr[1]];
            
            [tscCmd addTextwithX:156
                           withY:184
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:proNumberstr];
            
            [tscCmd addTextwithX:156
                           withY:234
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:[NSString stringWithFormat:@"%@   门幅：%@",Numberstr,dic[@"Width"]]];
            
            if ([self isStr:unitstr moreThanLenth:17]) {
                NSMutableArray * unitstrArr = [self subTextString:unitstr len:17];
                [tscCmd addTextwithX:156
                               withY:284
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstrArr[0]];
                [tscCmd addTextwithX:156
                               withY:314
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstrArr[1]];
                
            }else{
                [tscCmd addTextwithX:156
                               withY:284
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstr];
            }
            
            
            
        }else{
            
            //字符高度24  空24
            
            [tscCmd addTextwithX:156
                           withY:104
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:namestr];
            
            [tscCmd addTextwithX:156
                           withY:160
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:proNumberstr];
            
            [tscCmd addTextwithX:156
                           withY:214
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:[NSString stringWithFormat:@"%@   门幅：%@",Numberstr,dic[@"Width"]]];;
            
            if ([self isStr:unitstr moreThanLenth:17]) {
                NSMutableArray * unitstrArr = [self subTextString:unitstr len:17];
                [tscCmd addTextwithX:156
                               withY:260
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstrArr[0]];
                [tscCmd addTextwithX:156
                               withY:290
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstrArr[1]];
                
            }else{
                [tscCmd addTextwithX:156
                               withY:260
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstr];
            }
            
        }
        
    }
    
    
    
    //print
    [tscCmd addPrint:1 :1];
    
}

/**
 开始打印
 */
- (void)GprinterPrint{
/*
 SizeBtn  *_btn1;             //60  40
 SizeBtn  *_btn2;             //60  50
 SizeBtn  *_btn3;             //70  40
 SizeBtn  *_btn4;             //80  50

 */
    TscCommand *tscCmd = [[TscCommand alloc] init];
    [tscCmd setHasResponse:YES];

    //名称
    NSString *namestr = _text1.text;
    //
    UITextField *txt0_0 = _textfieldArr[0];
    UITextField *txt0_1 = _textfieldArr[1];
    NSString *proNumberstr = [NSString stringWithFormat:@"%@：%@",txt0_0.text,txt0_1.text];
    //
    UITextField *txt1_0 = _textfieldArr[2];
    UITextField *txt1_1 = _textfieldArr[3];
    NSString *Numberstr = [NSString stringWithFormat:@"%@：%@",txt1_0.text,txt1_1.text];
    //
    UITextField *txt2_0 = _textfieldArr[4];
    UITextField *txt2_1 = _textfieldArr[5];
    NSString *unitstr = [NSString stringWithFormat:@"%@：%@",txt2_0.text,txt2_1.text];

    
    UITextField *txt3_0 = _textfieldArr[6];
    UITextField *txt3_1 = _textfieldArr[7];
    //一个字符高度24
     if (_btn3.on){
        //70  40
        [tscCmd addSize:70 :40];
        
        //GAP
        [tscCmd addGapWithM:2   withN:0];
        
        //REFERENCE
        [tscCmd addReference:0
                            :24];
        
        //SPEED
        [tscCmd addSpeed:4];
        
        //DENSITY
        
        [tscCmd addDensity:8];
        
        //DIRECTION
        [tscCmd addDirection:0];
        
        //fixed command
        [tscCmd addComonCommand];
        [tscCmd addCls];
        
        

        if (_printDic[@"shopName"]) {
            [tscCmd addTextwithX:0
                           withY:12
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:2
                       withYscal:2
                        withText:_printDic[@"shopName"]];
            
        }else{
            [tscCmd addTextwithX:0
                           withY:12
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:2
                       withYscal:2
                        withText:@"FYH88.COM"];
            
        }
        [tscCmd addQRCode:0
                         :80
                         :@"L"
                         :5
                         :@"A"
                         :0
                         :_infoDic[@"url"]];
        
        [tscCmd addTextwithX:0
                       withY:224
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:@"FYH88.COM"];

        if ([self isStr:namestr moreThanLenth:13]) {
            //标题两行
           NSMutableArray * strarr = [self subTextString:namestr len:13];
            
            [tscCmd addTextwithX:180
                           withY:80
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:strarr[0]];
            
            [tscCmd addTextwithX:180
                           withY:110
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:strarr[1]];
            
            [tscCmd addTextwithX:180
                           withY:148
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:proNumberstr];
            
            [tscCmd addTextwithX:180
                           withY:186
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:Numberstr];
            
            [tscCmd addTextwithX:180
                           withY:224
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:unitstr];
            

        }else{
        
            //字符高度24  空24
            
            [tscCmd addTextwithX:180
                           withY:80
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:namestr];
            
            [tscCmd addTextwithX:180
                           withY:128
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:proNumberstr];
            
            [tscCmd addTextwithX:180
                           withY:176
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:Numberstr];
            
            [tscCmd addTextwithX:180
                           withY:224
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:unitstr];

            
        }

    }else{
        //80  50
        [tscCmd addSize:80 :50];
        
        //GAP
        [tscCmd addGapWithM:2   withN:0];
        
        //REFERENCE
        [tscCmd addReference:48
                            :24];
        
        //SPEED
        [tscCmd addSpeed:4];
        
        //DENSITY
        
        [tscCmd addDensity:8];
        
        //DIRECTION
        [tscCmd addDirection:0];
        
        //fixed command
        [tscCmd addComonCommand];
        [tscCmd addCls];
       
        if (_printDic[@"shopName"]) {
            [tscCmd addTextwithX:0
                           withY:24
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:2
                       withYscal:2
                        withText:_printDic[@"shopName"]];
            
        }else{
            [tscCmd addTextwithX:0
                           withY:24
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:2
                       withYscal:2
                        withText:@"FYH88.COM"];
        }
        
        [tscCmd addQRCode:0
                         :104
                         :@"L"
                         :5
                         :@"A"
                         :0
                         :_infoDic[@"url"]];
        [tscCmd addTextwithX:0
                       withY:248
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:@"FYH88.COM"];
        
        
        if ([self isStr:namestr moreThanLenth:17]) {
            //标题两行
            NSMutableArray * strarr = [self subTextString:namestr len:17];
            
            [tscCmd addTextwithX:156
                           withY:104
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:strarr[0]];
            
            [tscCmd addTextwithX:156
                           withY:134
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:strarr[1]];
            
            [tscCmd addTextwithX:156
                           withY:184
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:proNumberstr];
            
            [tscCmd addTextwithX:156
                           withY:234
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:[NSString stringWithFormat:@"%@   %@：%@",Numberstr,txt3_0.text,txt3_1.text]];
            
            if ([self isStr:unitstr moreThanLenth:17]) {
                NSMutableArray * unitstrArr = [self subTextString:namestr len:17];
                [tscCmd addTextwithX:156
                               withY:284
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstrArr[0]];
                [tscCmd addTextwithX:156
                               withY:314
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstrArr[1]];

            }else{
                [tscCmd addTextwithX:156
                               withY:284
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstr];
            }
           
            
            
        }else{
            
            //字符高度24  空24
            
            [tscCmd addTextwithX:156
                           withY:104
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:namestr];
            
            [tscCmd addTextwithX:156
                           withY:160
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:proNumberstr];
            
            [tscCmd addTextwithX:156
                           withY:214
                        withFont:@"TSS24.BF2"
                    withRotation:0
                       withXscal:1
                       withYscal:1
                        withText:[NSString stringWithFormat:@"%@   %@：%@",Numberstr,txt3_0.text,txt3_1.text]];
            
            if ([self isStr:unitstr moreThanLenth:17]) {
                NSMutableArray * unitstrArr = [self subTextString:unitstr len:17];
                [tscCmd addTextwithX:156
                               withY:260
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstrArr[0]];
                [tscCmd addTextwithX:156
                               withY:290
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstrArr[1]];
                
            }else{
                [tscCmd addTextwithX:156
                               withY:260
                            withFont:@"TSS24.BF2"
                        withRotation:0
                           withXscal:1
                           withYscal:1
                            withText:unitstr];
            }
           
        }

    }
    
    
    
    //print
    [tscCmd addPrint:1 :1];
    



}

#pragma mark ====== 判断尺寸标签颜色

/**
 选择纸张

 @param button 纸张规格
 */
- (void)sizeBtnclick:(SizeBtn *)button{
    for (SizeBtn *btn  in _btnArr) {
        btn.on = NO;
    }
    button.on = YES;
    [self makesureTheColorOfBtn];
    if (_btn3.on) {
        view8.hidden = YES;
        view9.hidden = YES;
        sizelab.frame  = CGRectMake(37, numlab.top-91, 50, 30);
        if (iPhone5) {
            _btn3.frame = CGRectMake(87, sizelab.top , 70, 22);
            
        }else if (iPad){
            _btn3.frame = CGRectMake(87, sizelab.top -100, 80, 22);
            
        }else{
            _btn3.frame = CGRectMake(87, sizelab.top , 80, 22);
            
        }
        
        if (iPhone5) {
            _btn4.frame = CGRectMake(87+107, sizelab.top , 70, 22);
            
        }else if (iPad){
            _btn4.frame = CGRectMake(87+107, sizelab.top -100, 80, 22);
            
        }else{
            _btn4.frame = CGRectMake(87+107, sizelab.top , 80, 22);
            
        }
        if (iPad) {
            _imageview.image = [UIImage imageNamed:@"QR_Padback"];
            _imageview.frame = CGRectMake(50, 35*TimeScaleY, ScreenWidth -100, (ScreenHeight -64-35*TimeScaleY*2));
            
        }else{
            _imageview.image = [UIImage imageNamed:@"QR_backIma"];
            _imageview.frame = CGRectMake(25, 35, ScreenWidth - 50, 500);
            
        }
        
    }else{
        view8.hidden = NO;
        view9.hidden = NO;
        sizelab.frame  = CGRectMake(37, numlab.top-71, 50, 30);
        if (iPhone5) {
            _btn3.frame = CGRectMake(87, sizelab.top , 70, 22);
            
        }else if (iPad){
            _btn3.frame = CGRectMake(87, sizelab.top -100, 80, 22);
            
        }else{
            _btn3.frame = CGRectMake(87, sizelab.top , 80, 22);
            
        }
        
        if (iPhone5) {
            _btn4.frame = CGRectMake(87+107, sizelab.top , 70, 22);
            
        }else if (iPad){
            _btn4.frame = CGRectMake(87+107, sizelab.top -100, 80, 22);
            
        }else{
            _btn4.frame = CGRectMake(87+107, sizelab.top , 80, 22);
            
        }
        if (iPad) {
            _imageview.image = [UIImage imageNamed:@"QR_backImaLo"];
            _imageview.frame = CGRectMake(50, 35*TimeScaleY, ScreenWidth -100, (ScreenHeight -64-35*TimeScaleY*2));
            
        }else{
            _imageview.image = [UIImage imageNamed:@"QR_backImaLo"];
            _imageview.frame = CGRectMake(25, 35, ScreenWidth - 50, 500);
            
        }
        
    }

}

- (void)makesureTheColorOfBtn{

    for (SizeBtn *btn  in _btnArr) {
        if (btn.on) {
            btn.backgroundColor = UIColorFromRGB(RedColorValue);
            [btn setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        }else{
            btn.backgroundColor = UIColorFromRGB(0xffffff);
            [btn setTitleColor:UIColorFromRGB(0x434a54) forState:UIControlStateNormal];
        }
    }
}



#pragma mark ====== 按钮点击方法

/**
 增加打印数量
 */
- (void)addBtnClick{

    int a = [_numberTxt.text intValue];
    a++;
    _numberTxt.text = [NSString stringWithFormat:@"%d",a];

}

/**
 减少数量
 */
- (void)decreaseBtnClick{
    int a = [_numberTxt.text intValue];
    if (a<=1) {
        return;
    }
    a--;
    _numberTxt.text = [NSString stringWithFormat:@"%d",a];

}

/**
 清空标题
 */
- (void)view1_deleteBtn1Click{

    _text1.text = @"";
}

- (void)view_deleteBtn1Click:(UIButton *)button{
    UITextField *textfield = _textfieldArr[button.tag - 1000];
    textfield.text = @"";
}


- (void)adddeleteButtonWithview:(UIView *)view andBunTag:(NSInteger)tag{

    UIButton *view1_deleteBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [view1_deleteBtn1 setImage:[UIImage imageNamed:@"xx-"] forState:UIControlStateNormal];
    [view addSubview:view1_deleteBtn1];
    view1_deleteBtn1.tag = tag;
    view1_deleteBtn1.frame = CGRectMake(view.width-16, 0, 16, 22);
    [view1_deleteBtn1 addTarget:self action:@selector(view_deleteBtn1Click:) forControlEvents:UIControlEventTouchUpInside];
    
    if (iPad) {
        view1_deleteBtn1.frame = CGRectMake(view.width-16, 0, 16, 40);
    }
    if (_type == 1) {
        view1_deleteBtn1.hidden = YES;
    }
}

- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
  //  [self contentSizeToFit];
    return YES;
}


#pragma mark ---------- 判断蓝牙设备
- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *message = nil;
    switch (central.state) {
        case 1:{
            _BoothIsOpen = NO;
            message = @"该设备不支持蓝牙功能,请检查系统设置";
            break;
        }
        case 2:{
            _BoothIsOpen = NO;
            message = @"该设备蓝牙未授权,请检查系统设置";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
                        [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];

            break;
        }
        case 3:{
            _BoothIsOpen = NO;
            message = @"该设备蓝牙未授权,请检查系统设置";
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
            [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];

            break;
        }
        case 4:{
            _BoothIsOpen = NO;

            message = @"该设备尚未打开蓝牙,请在设置中打开";
            
            break;
        }
        case 5:{
            message = @"蓝牙已经成功开启,请稍后再试";
            _BoothIsOpen = YES;

            break;
        }
        default:
            break;
    }
    if(message!=nil&&message.length!=0)
    {
        NSLog(@"message == %@",message);
    }
}

- (void)openBluthSetting{
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"蓝牙未开启，是否开启？" preferredStyle:UIAlertControllerStyleAlert];
    [alert  addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSLog(@"%f",[[UIDevice currentDevice] systemVersion].floatValue);
      //  if ([[UIDevice currentDevice] systemVersion].floatValue >=10 ) {
            //蓝牙设置界面 ios10
            NSString * urlString = @"App-Prefs:root=Bluetooth";
            if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:urlString]]) {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
            }else {
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[urlString stringByReplacingOccurrencesOfString:@"App-P" withString:@"p"]]];
            }
            
//        }else{
//            //ios9
//            NSURL *url = [NSURL URLWithString:@"prefs:root=Bluetooth"];
//            if ([[UIApplication sharedApplication]canOpenURL:url]) {
//                [[UIApplication sharedApplication]openURL:url];
//            }
//        }
        
        
     
        
    }]];
    [alert  addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
    }]];
    [self presentViewController:alert animated:YES completion:nil];

    
}


- (BOOL)isStr:(NSString*)str moreThanLenth:(NSInteger)len{
    if (!str) {
        return NO;
    }
    if(str.length<=len)return NO;
    NSMutableString *sb = [NSMutableString string];
    int count=0;

    for (int i=0; i<str.length; i++) {
        NSRange range = NSMakeRange(i, 1) ;
        NSString *aStr = [str substringWithRange:range];
        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
        [sb appendString:aStr];
        if(count > len*2) {
           return YES;
        }
    }
    return NO;
}

-(NSMutableArray*)subTextString:(NSString*)str len:(NSInteger)len{
  //  if(str.length<=len)return str;
    NSMutableString *sb = [NSMutableString string];
    NSMutableArray *strArr = [NSMutableArray arrayWithCapacity:0];
    
    int count=0;
    for (int i=0; i<str.length; i++) {
        NSRange range = NSMakeRange(i, 1) ;
        NSString *aStr = [str substringWithRange:range];
        count += [aStr lengthOfBytesUsingEncoding:NSUTF8StringEncoding]>1?2:1;
        [sb appendString:aStr];
        if(count >= len*2) {
            [strArr addObject:[sb copy]];
            NSString *str1 = [str substringFromIndex:i+1];
            [strArr addObject:str1];
          //  return (i==str.length-1)?[sb copy]:[NSString stringWithFormat:@"%@",[sb copy]];
        }
    }
    return strArr;
}


#pragma mark ======== 加载店铺信息
- (void)loadTheShopInfo{
    
    [ShopSettingPL getTheShopSettingInfoWithReturnBlock:^(id returnValue) {
        _printDic = returnValue;
        NSLog(@"%@",returnValue);
         [self setUp];
    } andErrorBlock:^(NSString *msg) {
        [self showTextHud:msg];
         [self setUp];
    }];
}



@end
