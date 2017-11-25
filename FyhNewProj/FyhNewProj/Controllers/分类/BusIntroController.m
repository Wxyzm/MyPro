//
//  BusIntroController.m
//  FyhNewProj
//
//  Created by yh f on 2017/10/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "BusIntroController.h"
#import "BussQRCodeController.h"
#import "BussShowPL.h"
@interface BusIntroController ()

@property (nonatomic,strong)UIScrollView    *mainScrollView;

@property (nonatomic, strong) UIView *topView;

@property (nonatomic, strong) UIView *middleView;



@end

@implementation BusIntroController{
    
    UIImageView       *_faceImageView;      //头像
        UILabel       *_nameLab;            //名称
        UILabel       *_saleKindLab;        //销售
    //
        UILabel       *_middNameLab;        //名称
        UILabel       *_middConnLab;        //联系方式
        UILabel       *_middAdreLab;        //地址
        UILabel       *_middSaleLab;        //销售范围
        UILabel       *_middQrLab;          //二维码
    //
}


-(UIView *)topView{
    if (!_topView) {
        _topView  = [[UIView alloc]initWithFrame:CGRectMake(0, 12, ScreenWidth, 70)];
        _topView.backgroundColor  = UIColorFromRGB(WhiteColorValue);
        
       
        _faceImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        [_faceImageView setContentMode:UIViewContentModeScaleAspectFill];
        _faceImageView.clipsToBounds = YES;
        [_topView addSubview:_faceImageView];
        
        _nameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
        [_topView addSubview:_nameLab];
        
        _saleKindLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(13) textAligment:NSTextAlignmentLeft andtext:@""];
        [_topView addSubview:_saleKindLab];
        
        
        _faceImageView.sd_layout.
        leftSpaceToView(_topView, 16).
        centerYEqualToView(_topView).
        widthIs(50).
        heightIs(50);
        //
        _nameLab.sd_layout.
        leftSpaceToView(_faceImageView, 12).
        topSpaceToView(_topView, 16.5).
        rightSpaceToView(_topView, 16).
        heightIs(16);
        //
        _saleKindLab.sd_layout.
        leftSpaceToView(_faceImageView, 12).
        topSpaceToView(_nameLab, 9).
        rightSpaceToView(_topView, 16).
        heightIs(14);
    }
    
    return _topView;
}


#pragma mark ======= viewDidLoad
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(LineColorValue);
    [self setBarBackBtnWithImage:[UIImage imageNamed:@"back-d"]];
    [self createNavigationItem];

    //获取简介
    [self loadShopInfo];
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
[[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
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
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;

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
 rightBarButtonItem
 */
- (void)createNavigationItem
{
//    self.navigationController.navigationBar.barStyle = UIStatusBarStyleDefault;
    UILabel *titlelab;
    titlelab = [BaseViewFactory labelWithFrame:CGRectMake(0, 0, 200, 44) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(18) textAligment:NSTextAlignmentCenter andtext:@"店铺简介"];
    self.navigationItem.titleView = titlelab;
    UIBarButtonItem *item = [BaseViewFactory barItemWithImagePath:@"share" height:20 target:self action:@selector(shareBtnclick)];
    self.navigationItem.rightBarButtonItem = item;
    
}

/**
 initUI
 */
- (void)initUIWithreturnValue:(NSDictionary *)returnDic{
    
    if (!_mainScrollView) {
        _mainScrollView = [[BaseScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
        [self.view addSubview:_mainScrollView];
        _mainScrollView.backgroundColor = UIColorFromRGB(LineColorValue);
    }
    //
    [_mainScrollView addSubview:self.topView];
    if (NULL_TO_NIL( returnDic[@"shopLogoImageUrl"])) {
        [_faceImageView  sd_setImageWithURL:[NSURL URLWithString:NULL_TO_NIL(returnDic[@"shopLogoImageUrl"])] placeholderImage:[UIImage imageNamed:@"loding"]];
    }else{
        _faceImageView.image = [UIImage imageNamed:@"loding"];
    }
    if (NULL_TO_NIL(returnDic[@"shopName"])) {
        _nameLab.text =  NULL_TO_NIL(returnDic[@"shopName"]);
    }else{
        _nameLab.text =  NULL_TO_NIL(returnDic[@"sellerInfo"]);
    }
    _saleKindLab.text = NULL_TO_NIL(returnDic[@"shopDescription"]) ;
    
    
    //
    [self setThemiddleViewWithDic:returnDic];
    //
    
    UIView *boomView = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(WhiteColorValue)];
    [_mainScrollView addSubview:boomView];
    
    [self createLabelWith:UIColorFromRGB(0xaab2bd) Font:APPFONT(15) WithSuper:boomView Frame:CGRectMake(16, 15, 200, 16) Alignment:NSTextAlignmentLeft Text:@"公司简介"];
    UILabel *introLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:NULL_TO_NIL(returnDic[@"shopDescription"])];
    [boomView addSubview:introLab];
    NSMutableParagraphStyle*paragraphStyle = [NSMutableParagraphStyle new];
    //调整行间距
    paragraphStyle.lineSpacing= 1.5;
    NSDictionary*attriDict =@{NSParagraphStyleAttributeName:paragraphStyle};
    NSMutableAttributedString*attributedString = [[NSMutableAttributedString alloc]initWithString:introLab.text?introLab.text:@"" attributes:attriDict];
    introLab.attributedText = attributedString;
   
   //
    CGFloat labHeight = [self theheightForString:NULL_TO_NIL(returnDic[@"shopDescription"]) andWidth:ScreenWidth - 32 andFont:APPFONT(15)];
    introLab.sd_layout.
    leftSpaceToView(boomView, 16).
    rightSpaceToView(boomView, 16).
    topSpaceToView(boomView, 45).
    autoHeightRatio(0);
    
    boomView.sd_layout.
    leftSpaceToView(_mainScrollView, 0).
    rightSpaceToView(_mainScrollView, 0).
    topSpaceToView(self.middleView, 12).
    heightIs(45 + labHeight+15);
    _mainScrollView.contentSize = CGSizeMake(10, 346+ 45 + labHeight + 15 + 18);
}


-(void)setThemiddleViewWithDic:(NSDictionary *)returnDic{
    
        _middleView  = [[UIView alloc]initWithFrame:CGRectZero];
        _middleView.backgroundColor  = UIColorFromRGB(WhiteColorValue);
        
        //
//        NSArray *titleArr = @[@"公司名称",@"联系方式",@"详细地址",@"主营范围",@"二维码"];
//        for (int i = 0; i<titleArr.count; i++) {
//            UILabel *lab = [BaseViewFactory labelWithFrame:CGRectMake(16, 48*i, 65, 48) textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:titleArr[i]];
//            [_middleView addSubview:lab];
//            if (i!=0) {
//                [self createLineWithColor:UIColorFromRGB(0xe6e9ed) frame:CGRectMake(16, 48*i, ScreenWidth - 16, 1) Super:_middleView];
//            }
//        }
        //
         UILabel *lab1 = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"公司名称"];
        [_middleView addSubview:lab1];
        
        UILabel *lab2 = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"联系方式"];
        [_middleView addSubview:lab2];
        
        UILabel *lab3 = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"详细地址"];
        [_middleView addSubview:lab3];
        
        UILabel *lab4 = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"主营范围"];
        [_middleView addSubview:lab4];
        
        UILabel *lab5 = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0xaab2bd) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@"二维码"];
        [_middleView addSubview:lab5];
        //
        UIView *line1 = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xe6e9ed)];
        [_middleView addSubview:line1];
        UIView *line2 = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xe6e9ed)];
        [_middleView addSubview:line2];
        UIView *line3 = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xe6e9ed)];
        [_middleView addSubview:line3];
        UIView *line4 = [BaseViewFactory viewWithFrame:CGRectZero color:UIColorFromRGB(0xe6e9ed)];
        [_middleView addSubview:line4];

        //
        _middNameLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
        _middNameLab.numberOfLines = 0;
        [_middleView addSubview:_middNameLab];
        
        _middConnLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
        _middConnLab.numberOfLines = 0;
        [_middleView addSubview:_middConnLab];
        
        _middAdreLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
        _middAdreLab.numberOfLines = 0;
        [_middleView addSubview:_middAdreLab];
        
        _middSaleLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
        _middSaleLab.numberOfLines = 0;
        [_middleView addSubview:_middSaleLab];
        
        _middQrLab = [BaseViewFactory labelWithFrame:CGRectZero textColor:UIColorFromRGB(0x434a54) font:APPFONT(15) textAligment:NSTextAlignmentLeft andtext:@""];
        _middQrLab.text = @"店铺二维码";
        [_middleView addSubview:_middQrLab];
        //
        UIImageView * QrImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        QrImageView.image = [UIImage imageNamed:@"QR_intro"];
        [QrImageView setContentMode:UIViewContentModeScaleAspectFill];
        QrImageView.clipsToBounds = YES;
        [_middleView addSubview:QrImageView];
        UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        rightImageView.image = [UIImage imageNamed:@"right"];
        [rightImageView setContentMode:UIViewContentModeScaleAspectFill];
        rightImageView.clipsToBounds = YES;
        [_middleView addSubview:rightImageView];
        //
        UIButton *qrBtn = [UIButton buttonWithType:UIButtonTypeSystem];
        [_middleView addSubview:qrBtn];
        [qrBtn addTarget:self action:@selector(qrBtnClick) forControlEvents:UIControlEventTouchUpInside];
        //
        if (NULL_TO_NIL(returnDic[@"shopName"])) {
            _middNameLab.text =  NULL_TO_NIL(returnDic[@"shopName"]);
        }else{
            _middNameLab.text =  NULL_TO_NIL(returnDic[@"sellerInfo"]);
        }
        _middConnLab.text = NULL_TO_NIL(returnDic[@"shopContact"]);
        if (NULL_TO_NIL(returnDic[@"shopArea"])&&NULL_TO_NIL(returnDic[@"shopAddress"])) {
            _middAdreLab.text = [NSString stringWithFormat:@"%@%@",NULL_TO_NIL(returnDic[@"shopArea"]),NULL_TO_NIL(returnDic[@"shopAddress"])];
        }
        _middSaleLab.text = NULL_TO_NIL(returnDic[@"shopMainBusiness"]);
        //
        CGFloat height1 = [GlobalMethod heightForString:_middNameLab.text andWidth:ScreenWidth -96 -16 andFont:APPFONT(15)];
        if (height1 <48) {
            height1 = 48;
        }
        _middNameLab.sd_layout.
        leftSpaceToView(_middleView, 96).
        topSpaceToView(_middleView, 0).
        rightSpaceToView(_middleView, 16).
        heightIs(height1);
        lab1.sd_layout.
        leftSpaceToView(_middleView, 16).
        topSpaceToView(_middleView, 0).
        widthIs(65).
        heightIs(height1);
        line1.sd_layout.
        leftSpaceToView(_middleView, 16).
        topSpaceToView(_middNameLab, 0).
        widthIs(ScreenWidth - 16).
        heightIs(1);
        //
        CGFloat height2 = [GlobalMethod heightForString:_middNameLab.text andWidth:ScreenWidth -96 -16 andFont:APPFONT(15)];
        if (height2 <48) {
            height2 = 48;
        }
        _middConnLab.sd_layout.
        leftSpaceToView(_middleView, 96).
        topSpaceToView(_middNameLab, 0).
        rightSpaceToView(_middleView, 16).
        heightIs(height2);
        lab2.sd_layout.
        leftSpaceToView(_middleView, 16).
        topSpaceToView(lab1, 0).
        widthIs(65).
        heightIs(height2);
    line2.sd_layout.
    leftSpaceToView(_middleView, 16).
    topSpaceToView(_middConnLab, 0).
    widthIs(ScreenWidth - 16).
    heightIs(1);
        //
        CGFloat height3 = [GlobalMethod heightForString:_middAdreLab.text andWidth:ScreenWidth -96 -16 andFont:APPFONT(15)];
        if (height3 <48) {
            height3 = 48;
        }
        _middAdreLab.sd_layout.
        leftSpaceToView(_middleView, 96).
        topSpaceToView(_middConnLab, 0).
        rightSpaceToView(_middleView, 16).
        heightIs(height3);
        lab3.sd_layout.
        leftSpaceToView(_middleView, 16).
        topSpaceToView(lab2, 0).
        widthIs(65).
        heightIs(height3);
    line3.sd_layout.
    leftSpaceToView(_middleView, 16).
    topSpaceToView(_middAdreLab, 0).
    widthIs(ScreenWidth - 16).
    heightIs(1);
        //
        CGFloat height4 = [GlobalMethod heightForString:_middSaleLab.text andWidth:ScreenWidth -96 -16 andFont:APPFONT(15)];
        if (height4 <48) {
            height4 = 48;
        }
        _middSaleLab.sd_layout.
        leftSpaceToView(_middleView, 96).
        topSpaceToView(_middAdreLab, 0).
        rightSpaceToView(_middleView, 16).
        heightIs(height4);
        lab4.sd_layout.
        leftSpaceToView(_middleView, 16).
        topSpaceToView(lab3, 0).
        widthIs(65).
        heightIs(height4);
    line4.sd_layout.
    leftSpaceToView(_middleView, 16).
    topSpaceToView(_middSaleLab, 0).
    widthIs(ScreenWidth - 16).
    heightIs(1);
        //
        _middQrLab.sd_layout.
        leftSpaceToView(_middleView, 96).
        topSpaceToView(_middSaleLab, 0).
        rightSpaceToView(_middleView, 16).
        heightIs(48);
        lab5.sd_layout.
        leftSpaceToView(_middleView, 16).
        topSpaceToView(lab4, 0).
        widthIs(65).
        heightIs(48);
        //
        rightImageView.sd_layout.
        rightSpaceToView(_middleView, 16).
        bottomSpaceToView(_middleView, 12).
        widthIs(10).
        heightIs(20);
        QrImageView.sd_layout.
        rightSpaceToView(rightImageView, 12).
        bottomSpaceToView(_middleView, 12).
        widthIs(20).
        heightIs(20);
        qrBtn.sd_layout.
        leftSpaceToView(_middleView, 0).
        rightSpaceToView(_middleView, 0).
        bottomSpaceToView(_middleView, 0).
        heightIs(48);

        _middleView.frame = CGRectMake(0, 94, ScreenWidth, height1+height2+height3+height4+48);
        [_mainScrollView addSubview:_middleView];

    
}
#pragma mark =========  按钮点击

/**
 分享
 */
- (void)shareBtnclick{
    
    
    
}

/**
 二维码页面
 */
- (void)qrBtnClick{
    
    BussQRCodeController *qrVc = [[BussQRCodeController alloc]init];
    qrVc.shopId = _shopId;
    [self.navigationController pushViewController:qrVc animated:YES];
    
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
        [self showTextHud:@"商家简介获取失败"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    
}



- (CGFloat)theheightForString:(NSString *)value andWidth:(float)width andFont:(UIFont *)font{
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = 1.5; //行距
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle
                          };
    
    CGSize size = [value boundingRectWithSize:CGSizeMake(width, 0) options:\
                   NSStringDrawingTruncatesLastVisibleLine |
                   NSStringDrawingUsesLineFragmentOrigin |
                   NSStringDrawingUsesFontLeading attributes:dic context:nil].size;
    return size.height;
}
@end
