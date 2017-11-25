//
//  TureNameResultController.m
//  FyhNewProj
//
//  Created by yh f on 2017/3/20.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "TureNameResultController.h"

#import "YLButton.h"

@interface TureNameResultController ()

@end

@implementation TureNameResultController{

    YLButton *_showBtn;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setBarBackBtnWithImage:nil];
    self.view.backgroundColor = UIColorFromRGB(WhiteColorValue);

    [self setUP];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];


}

- (void)setUP{

    UIImageView *imageView = [[UIImageView alloc]init];
    if (_type == 1) {
        imageView.image = [UIImage imageNamed:@"wave_blue"];
        [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:self.view Frame:CGRectMake(0, imageView.image.size.height*TimeScaleX, ScreenWidth, 20) Alignment:NSTextAlignmentCenter Text:@"提交成功，请等待管理员审核"];
        
        [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(13) WithSuper:self.view Frame:CGRectMake(35, imageView.image.size.height*TimeScaleX+40, ScreenWidth - 70, 40) Alignment:NSTextAlignmentCenter Text:@"预计一个工作日内审核完毕，审核结果会短信通知到您的注册手机上"];

    }else if (_type == 3){
        imageView.image = [UIImage imageNamed:@"wave_red"];
        [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:self.view Frame:CGRectMake(0, imageView.image.size.height*TimeScaleX, ScreenWidth, 20) Alignment:NSTextAlignmentCenter Text:@"抱歉，您的店铺审核未通过！"];
        
        [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(13) WithSuper:self.view Frame:CGRectMake(35, imageView.image.size.height*TimeScaleX+40, ScreenWidth - 70, 40) Alignment:NSTextAlignmentCenter Text:@"审核未通过，如有疑问请咨询：400—878—0966"];
        
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        [self.view addSubview:btn];
        btn.frame = CGRectMake(35, imageView.image.size.height*TimeScaleX+140, ScreenWidth - 70, 42);
        btn.layer.cornerRadius = 5;
        btn.layer.borderWidth = 1;
        btn.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
        [btn setTitle:@"修改信息" forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0xaab2bd) forState:UIControlStateNormal];
        btn.titleLabel.font = APPFONT(15);
        [btn addTarget:self action:@selector(falseBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    }else{
        imageView.image = [UIImage imageNamed:@"wave_green"];
        [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(15) WithSuper:self.view Frame:CGRectMake(0, imageView.image.size.height*TimeScaleX, ScreenWidth, 20) Alignment:NSTextAlignmentCenter Text:@"恭喜，您的店铺创建成功"];
    
        [self createLabelWith:UIColorFromRGB(0x434a54) Font:APPFONT(13) WithSuper:self.view Frame:CGRectMake(35, imageView.image.size.height*TimeScaleX+40, ScreenWidth - 70, 40) Alignment:NSTextAlignmentCenter Text:@"独立电商平台，个人价值店铺彰显，资产财富稳固增长，马上去管理店铺吧"];
        
        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
//        [self.view addSubview:btn];
//        btn.frame = CGRectMake(35, imageView.image.size.height*TimeScaleX+140, ScreenWidth - 70, 42);
//        btn.layer.cornerRadius = 5;
//        btn.layer.borderWidth = 1;
//        btn.layer.borderColor = UIColorFromRGB(0xaab2bd).CGColor;
//        [btn setTitle:@"查看店铺" forState:UIControlStateNormal];
//        [btn setTitleColor:UIColorFromRGB(0xaab2bd) forState:UIControlStateNormal];
//        btn.titleLabel.font = APPFONT(15);
//        [btn addTarget:self action:@selector(successBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }

    [self.view addSubview:imageView];
    imageView.frame = CGRectMake(0, 0, ScreenWidth, imageView.image.size.height *TimeScaleX );
    imageView.userInteractionEnabled = YES;
    UIImage *backImg= [UIImage imageNamed:@"back-white"];
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 30, 40, 40)];
    [button setImage:backImg forState:UIControlStateNormal];
    [button addTarget:self action:@selector(LeftButtonClickEvent) forControlEvents:UIControlEventTouchUpInside];
    [imageView addSubview:button];

    
}



- (void)successBtnClick{

    [self showTextHud:@"即将上线"];
}

- (void)falseBtnClick{



}

- (void)LeftButtonClickEvent{
    [self.navigationController popViewControllerAnimated:YES];

}
@end
