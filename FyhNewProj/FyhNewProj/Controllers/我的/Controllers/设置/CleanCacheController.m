//
//  CleanCacheController.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/12.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "CleanCacheController.h"
#import "CacheClearManager.h"
#include <sys/param.h>
#include <sys/mount.h>

@interface CleanCacheController ()

@end

@implementation CleanCacheController{

    UILabel *_cacheLab;         //内存M
    UILabel *_percentageLab;    //内存百分比
    CacheClearManager   *_cacheManager;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17]
       ,NSForegroundColorAttributeName:UIColorFromRGB(BlackColorValue)
       }];

    self.navigationItem.title = @"清除缓存";
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);
    _cacheManager = [[CacheClearManager alloc]init];
    [self initUI];
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
    self.navigationController.navigationBar.backgroundColor = UIColorFromRGB(WhiteColorValue);
    self.navigationController.navigationBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    UIView *myView = [[self.navigationController valueForKey:@"_navigationBar"] valueForKey:@"_backgroundView"];
    for (CALayer *layers in myView.layer.sublayers) {
        layers.hidden = NO;
    }
    [self.navigationController.navigationBar setTitleTextAttributes:
     
     @{NSFontAttributeName:[UIFont systemFontOfSize:17]
       ,NSForegroundColorAttributeName:UIColorFromRGB(WhiteColorValue)
       }];
    

}

- (void)initUI{

    UIImageView  *imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"cache"]];
    [self.view addSubview:imageview];
    imageview.sd_layout.centerXEqualToView(self.view).centerYIs((ScreenHeight - 64)/2-100).widthIs(180).heightIs(180);
    
    
    SubBtn *cleanBtn = [SubBtn buttonWithtitle:@"清除缓存" backgroundColor:UIColorFromRGB(GaryBtnColorValue) titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:self action:@selector(cleanBtnClick)];
    [self.view addSubview:cleanBtn];
    cleanBtn.frame = CGRectMake(20, (ScreenHeight - 64)/2+80, ScreenWidth-40, 50);
    
    
    
    
    _cacheLab = [BaseViewFactory labelWithFrame:CGRectMake(30, 65, 120, 16) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(16) textAligment:NSTextAlignmentCenter andtext:[NSString stringWithFormat:@"%.2fMB",[_cacheManager filePath]]];
    NSString *str3 = @"MB";
    NSRange range3 = [_cacheLab.text rangeOfString:str3];
    NSMutableAttributedString *str3_1 = [[NSMutableAttributedString alloc]initWithString:_cacheLab.text];
    [str3_1 addAttribute:NSFontAttributeName value:APPFONT(13) range:range3];
    _cacheLab.attributedText = str3_1;
    [imageview addSubview:_cacheLab];

   CGFloat aa =  [self getTotalMemorySize];
  
    if (aa<0.01 && aa>0) {
        aa = 0.01;
    }
    _percentageLab = [BaseViewFactory labelWithFrame:CGRectMake(10, 90, 160, 16) textColor:UIColorFromRGB(WhiteColorValue) font:APPFONT(13) textAligment:NSTextAlignmentCenter andtext:[NSString stringWithFormat:@"约占手机%.2f存储空间",aa]];
    [imageview addSubview:_percentageLab];

}

- (void)cleanBtnClick{

    [_cacheManager clearFile];
    _cacheLab.text = [NSString stringWithFormat:@"%.2fMB",[_cacheManager filePath]];
    CGFloat aa =  [self getTotalMemorySize];
    
    if (aa<0.01 && aa>0) {
        aa = 0.01;
    }
    _percentageLab.text = @"约占手机0.00%存储空间";

}
- (CGFloat)getTotalMemorySize
{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSDictionary *fat = [fm attributesOfFileSystemForPath:NSHomeDirectory() error:nil];
    CGFloat all = [[fat objectForKey:NSFileSystemSize]longLongValue]/1000000000 *1024;
    if ([_cacheManager filePath]==0) {
        return 0;
    }
    
    CGFloat pa = [_cacheManager filePath]/all;
    return pa;
    

}

@end
