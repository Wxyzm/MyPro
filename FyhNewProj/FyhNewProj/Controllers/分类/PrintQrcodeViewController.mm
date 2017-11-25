//
//  PrintQrcodeViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/7.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "PrintQrcodeViewController.h"
#import "NSString+ZXingQRImage.h"
#import "ConnectViewController.h"
#import "SubBtn.h"
#import "AppDelegate.h"

#import "TscCommand.h"
#import "BLKWrite.h"
#import "EscCommand.h"
@interface PrintQrcodeViewController (){

    SubBtn *_connectBtn;

}

@end

@implementation PrintQrcodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
   
    self.navigationItem.title = @"产品二维码";
    [self setUp];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
}
- (void)setUp{
    UIScrollView *scrView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-108)];
    [self.view addSubview:scrView];
    UIView *bgview = [[UIView alloc]initWithFrame:CGRectMake(30, 10, ScreenWidth - 60, ScreenHeight)];
    [scrView addSubview:bgview];
    bgview.backgroundColor = UIColorFromRGB(0xffffff);
    UIImageView *showImageView = [[UIImageView alloc]init];
    showImageView.frame = CGRectMake((ScreenWidth - 60)/2 - 125, 20, 250, 250);
    UIImage *qrImage = [NSString becomeQRCodeWithQRstring:_infoDic[@"url"] withWidth:250 withHight:250];
    showImageView.image = qrImage;
    [bgview addSubview:showImageView];
    
    UILabel *namelab = [[UILabel alloc]initWithFrame:CGRectMake(15, 280, ScreenWidth-90, 30)];
    namelab.textAlignment = NSTextAlignmentLeft;
    namelab.textColor = UIColorFromRGB(0x333333);
    namelab.numberOfLines = 2;
    namelab.font = FSYSTEMFONT(12);
    [bgview addSubview:namelab];
    namelab.text = [NSString stringWithFormat:@"名称:%@",_infoDic[@"title"]];

    [self createLabelWith:UIColorFromRGB(0x333333) Font:FSYSTEMFONT(12) WithSuper:bgview Frame:CGRectMake(15, 320, ScreenWidth-90, 13) Alignment:NSTextAlignmentLeft Text:[NSString stringWithFormat:@"成分:%@",_infoDic[@"ingredient"]]];
     [self createLabelWith:UIColorFromRGB(0x333333) Font:FSYSTEMFONT(12) WithSuper:bgview Frame:CGRectMake(15, 347, ScreenWidth-90, 13) Alignment:NSTextAlignmentLeft Text:[NSString stringWithFormat:@"货号:%@",_infoDic[@"customBn"]]];
    [self createLabelWith:UIColorFromRGB(0x333333) Font:FSYSTEMFONT(12) WithSuper:bgview Frame:CGRectMake(15, 374, ScreenWidth-90, 13) Alignment:NSTextAlignmentLeft Text:[NSString stringWithFormat:@"平台代号:%@",_infoDic[@"bn"]]];
    
    SubBtn *btn1 = [SubBtn buttonWithtitle:@"选择打印机" backgroundColor:UIColorFromRGB(0xc61616) titlecolor:UIColorFromRGB(0xffffff) cornerRadius:5 andtarget:self action:@selector(openPrinter)];
    [self.view addSubview:btn1];
    btn1.frame  = CGRectMake(15, ScreenHeight - 220, ScreenWidth - 30, 42);

    SubBtn *btn = [SubBtn buttonWithtitle:@"打印二维码" backgroundColor:UIColorFromRGB(0xc61616) titlecolor:UIColorFromRGB(0xffffff) cornerRadius:5 andtarget:self action:@selector(printQrcode)];
    [self.view addSubview:btn];
    btn.frame  = CGRectMake(15, ScreenHeight - 160, ScreenWidth - 30, 42);
    
   
}

- (void)openPrinter{
    [[BLKWrite Instance] setBWiFiMode:NO];
    AppDelegate *dele = [UIApplication sharedApplication].delegate;
    [self.navigationController pushViewController:dele.mConnBLE animated:YES];
}

- (void)printQrcode{
    if([[BLKWrite Instance] isConnecting]){
        [self GprinterPrint];
    }
    else{
        [[BLKWrite Instance] setBWiFiMode:NO];
        AppDelegate *dele = [UIApplication sharedApplication].delegate;
        [self.navigationController pushViewController:dele.mConnBLE animated:YES];
    }

}


- (void)GprinterPrint{
    TscCommand *tscCmd = [[TscCommand alloc] init];
    [tscCmd setHasResponse:YES];
    /*
     一定会发送的设置项
     */
    //Size
    
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
    
    [tscCmd addTextwithX:20
                   withY:24
                withFont:@"TSS24.BF2"
            withRotation:0
               withXscal:2
               withYscal:2
                withText:@"FYH88.com"];
//    [tscCmd addTextwithX:310
//                   withY:12
//                withFont:@"TSS24.BF2"
//            withRotation:0
//               withXscal:1
//               withYscal:2
//                withText:@"丰云汇有限公司"];
    //品名
    NSString * string =[NSString stringWithFormat:@"品名:%@",_infoDic[@"title"]];
    //成分
    NSString * chenfen =[NSString stringWithFormat:@"成分:%@",_infoDic[@"ingredient"]];
    if ([_infoDic[@"ingredient"] isEqualToString:@""]) {
        chenfen =@"成分:";
    }
    //货号
    NSString * huohao =[NSString stringWithFormat:@"货号:%@",_infoDic[@"customBn"]];
    if ([_infoDic[@"customBn"] isEqualToString:@""]) {
        huohao =@"货号:";
    }
    //平台编号
    NSString * baihao =[NSString stringWithFormat:@"平台代号:%@",_infoDic[@"bn"]];
    if ([_infoDic[@"bn"] isEqualToString:@""]) {
        baihao =@"平台代号:无";
    }
    if (string.length >14) {
        NSLog(@"%lu",(unsigned long)string.length);
        NSString * string1 = [string substringToIndex:14];//截取掉下标18之前的字符串
        NSString * string2 =  [string  substringFromIndex:14];;//截取掉下标18之后的字符串
        //
        [tscCmd addTextwithX:210
                       withY:90
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:string1];
        [tscCmd addTextwithX:254
                       withY:120
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:string2];
        
        [tscCmd addTextwithX:210
                       withY:170
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:chenfen];
        [tscCmd addTextwithX:210
                       withY:210
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:huohao];
        [tscCmd addTextwithX:210
                       withY:250
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:baihao];


        [tscCmd addQRCode:20
                         :104
                         :@"L"
                         :5
                         :@"A"
                         :0
                         :_infoDic[@"url"]];
    }else{
        [tscCmd addTextwithX:210
                       withY:90
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:string];
        [tscCmd addTextwithX:210
                       withY:150
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:chenfen];
        [tscCmd addTextwithX:210
                       withY:200
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:huohao];
        [tscCmd addTextwithX:210
                       withY:250
                    withFont:@"TSS24.BF2"
                withRotation:0
                   withXscal:1
                   withYscal:1
                    withText:baihao];

        [tscCmd addQRCode:20
                         :100
                         :@"L"
                         :5
                         :@"A"
                         :0
                         :_infoDic[@"url"]];

    
    }
    

    
    //print
    [tscCmd addPrint:1 :1];

}
- (int)convertToInt:(NSString*)strtemp
{
    int strlength = 0;
    char* p = (char*)[strtemp cStringUsingEncoding:NSUnicodeStringEncoding];
    for (int i=0 ; i<[strtemp lengthOfBytesUsingEncoding:NSUnicodeStringEncoding] ;i++) {
        if (*p) {
            p++;
            strlength++;
        }
        else {
            p++;
        }
        
    }
    return strlength;
}
@end
