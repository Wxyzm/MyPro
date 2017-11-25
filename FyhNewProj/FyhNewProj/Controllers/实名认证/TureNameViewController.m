//
//  TureNameViewController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "TureNameViewController.h"
#import "CertificationViewController.h"
#import "BussCertificaViewController.h"
#import "SubBtn.h"

@interface TureNameViewController ()



@end

@implementation TureNameViewController{

    UIView *_bgView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(0xf1f1f1);
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = NO;
    [self setUpUI];

}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [_bgView removeFromSuperview];
}

- (void)setUpUI{
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _bgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self.view addSubview:_bgView];
    SubBtn *personBtn = [SubBtn buttonWithtitle:@"" backgroundColor:UIColorFromRGB(0xc61616) titlecolor:UIColorFromRGB(0xffffff) cornerRadius:15 andtarget:self action:@selector(personBtnClick)];
    SubBtn *BussBtn = [SubBtn buttonWithtitle:@"" backgroundColor:UIColorFromRGB(0x1975cf) titlecolor:UIColorFromRGB(0xffffff) cornerRadius:15 andtarget:self action:@selector(BussBtnClick)];

    UIImageView *showImage;
    if (iPhone5) {
        showImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iphone5"]];
        [_bgView addSubview:showImage];
        showImage.sd_layout.centerXEqualToView(_bgView).centerYIs((ScreenHeight-64)/2).widthIs(284).heightIs(396);
       
        [showImage addSubview:personBtn];
        personBtn.sd_layout.centerXEqualToView(showImage).topSpaceToView(showImage,85).widthIs(200).heightIs(31);
        [self createLabelWith:UIColorFromRGB(0xffffff) Font:FSYSTEMFONT(13) WithSuper:personBtn Frame:CGRectMake(74, 9, 110, 14) Alignment:NSTextAlignmentLeft Text:@"个人实名认证"];
        UIImageView *perImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"verify_name"]];
        [personBtn addSubview:perImage];
        perImage.frame = CGRectMake(50, 6, 20, 20);
        perImage.layer.cornerRadius = 10;
        perImage.clipsToBounds = YES;
        
        [showImage addSubview:BussBtn];
        BussBtn.sd_layout.centerXEqualToView(showImage).bottomSpaceToView(showImage,128).widthIs(200).heightIs(31);
        [self createLabelWith:UIColorFromRGB(0xffffff) Font:FSYSTEMFONT(13) WithSuper:BussBtn Frame:CGRectMake(74, 9, 110, 14) Alignment:NSTextAlignmentLeft Text:@"企业实名认证"];
        UIImageView *bussImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"verify_frim"]];
        [BussBtn addSubview:bussImage];
        bussImage.frame = CGRectMake(50, 6, 20, 20);
        bussImage.layer.cornerRadius = 10;
        bussImage.clipsToBounds = YES;

    }else{
        showImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iphone6"]];
        [_bgView addSubview:showImage];
        showImage.sd_layout.centerXEqualToView(_bgView).centerYIs((ScreenHeight-64)/2).widthIs(339).heightIs(450);
       
        [showImage addSubview:personBtn];
        personBtn.sd_layout.centerXEqualToView(showImage).topSpaceToView(showImage,100).widthIs(200).heightIs(31);
        [self createLabelWith:UIColorFromRGB(0xffffff) Font:FSYSTEMFONT(13) WithSuper:personBtn Frame:CGRectMake(74, 9, 110, 14) Alignment:NSTextAlignmentLeft Text:@"个人实名认证"];
        UIImageView *perImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"verify_name"]];
        [personBtn addSubview:perImage];
        perImage.frame = CGRectMake(50, 6, 20, 20);
        perImage.layer.cornerRadius = 10;
        perImage.clipsToBounds = YES;
        
        [showImage addSubview:BussBtn];
        BussBtn.sd_layout.centerXEqualToView(showImage).bottomSpaceToView(showImage,145).widthIs(200).heightIs(31);
        [self createLabelWith:UIColorFromRGB(0xffffff) Font:FSYSTEMFONT(13) WithSuper:BussBtn Frame:CGRectMake(74, 9, 110, 14) Alignment:NSTextAlignmentLeft Text:@"企业实名认证"];
        UIImageView *bussImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"verify_frim"]];
        [BussBtn addSubview:bussImage];
        bussImage.frame = CGRectMake(50, 6, 20, 20);
        bussImage.layer.cornerRadius = 10;
        bussImage.clipsToBounds = YES;
    }
    showImage.userInteractionEnabled = YES;

    
}

//个人实名认证
- (void)personBtnClick{
    CertificationViewController *PersoncerVc = [[CertificationViewController alloc]init];
    [self.navigationController pushViewController:PersoncerVc animated:YES];

}

//商家
- (void)BussBtnClick{
    BussCertificaViewController *bussVC = [[BussCertificaViewController alloc]init];
    [self.navigationController pushViewController:bussVC animated:YES];

}

@end
