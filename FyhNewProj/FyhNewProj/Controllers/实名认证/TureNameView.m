//
//  TureNameView.m
//  FyhNewProj
//
//  Created by yh f on 2017/8/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "TureNameView.h"

@interface TureNameView()

@property (nonatomic, strong) UIButton      *backButton;

@property (nonatomic, strong) UIView      *bgView;

@end

@implementation TureNameView{
    
    BOOL        _isShow;
    
}
- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backButton.backgroundColor = [UIColor blackColor];
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        _backButton.alpha = 0.3;
    }
    return _backButton;
}

#pragma mark ========= init
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = [UIColor clearColor];
        [self setUp];
    }
    return self;
    
}

- (void)setUp{
    [self addSubview:self.backButton];
    
    _bgView = [[UIView alloc]init];
    [self addSubview:_bgView];
    _personBtn = [SubBtn buttonWithtitle:@"" backgroundColor:[UIColor clearColor] titlecolor:UIColorFromRGB(0xffffff) cornerRadius:15 andtarget:nil action:nil];
    _BussBtn = [SubBtn buttonWithtitle:@"" backgroundColor:[UIColor clearColor] titlecolor:UIColorFromRGB(0xffffff) cornerRadius:15 andtarget:nil action:nil];
    
    UIImageView *showImage;
    if (iPhone5) {
        _bgView.center = CGPointMake(ScreenWidth/2, 220);
        _bgView.bounds = CGRectMake(0, 0, 284, 396);
        showImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iphone5"]];
        [_bgView addSubview:showImage];
        showImage.sd_layout.centerXEqualToView(_bgView).centerYEqualToView(_bgView).widthIs(284).heightIs(396);
        
        [showImage addSubview:_personBtn];
        _personBtn.sd_layout.centerXEqualToView(showImage).topSpaceToView(showImage,85).widthIs(200).heightIs(31);
        [self createLabelWith:UIColorFromRGB(0xffffff) Font:FSYSTEMFONT(13) WithSuper:_personBtn Frame:CGRectMake(74, 9, 110, 14) Alignment:NSTextAlignmentLeft Text:@"个人实名认证"];
        UIImageView *perImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"verify_name"]];
        [_personBtn addSubview:perImage];
        perImage.frame = CGRectMake(50, 6, 20, 20);
        perImage.layer.cornerRadius = 10;
        perImage.clipsToBounds = YES;
        
        [showImage addSubview:_BussBtn];
        _BussBtn.sd_layout.centerXEqualToView(showImage).bottomSpaceToView(showImage,128).widthIs(200).heightIs(31);
        [self createLabelWith:UIColorFromRGB(0xffffff) Font:FSYSTEMFONT(13) WithSuper:_BussBtn Frame:CGRectMake(74, 9, 110, 14) Alignment:NSTextAlignmentLeft Text:@"企业实名认证"];
        UIImageView *bussImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"verify_frim"]];
        [_BussBtn addSubview:bussImage];
        bussImage.frame = CGRectMake(50, 6, 20, 20);
        bussImage.layer.cornerRadius = 10;
        bussImage.clipsToBounds = YES;
        
        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [_bgView  addSubview:closeBtn];
        closeBtn.sd_layout.rightSpaceToView(_bgView,10).topSpaceToView(_bgView,10).widthIs(20).heightIs(20);
        [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
        
    }else{
        _bgView.center = CGPointMake(ScreenWidth/2, 245);
        _bgView.bounds = CGRectMake(0, 0, 339, 450);
        showImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"iv_label"]];
        [_bgView addSubview:showImage];
        showImage.userInteractionEnabled = YES; showImage.sd_layout.centerXEqualToView(_bgView).centerYEqualToView(_bgView).widthIs(305).heightIs(470);
        
        [showImage addSubview:_personBtn];
        _personBtn.sd_layout.centerXEqualToView(showImage).topSpaceToView(showImage,120).widthIs(200).heightIs(60);
       

        
        [showImage addSubview:_BussBtn];
        _BussBtn.sd_layout.centerXEqualToView(showImage).bottomSpaceToView(showImage,115).widthIs(200).heightIs(60);


        UIButton *closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closeBtn setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
        [showImage  addSubview:closeBtn];
        closeBtn.sd_layout.rightSpaceToView(showImage,10).topSpaceToView(showImage,60).widthIs(20).heightIs(20);
        [closeBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];

    }
    showImage.userInteractionEnabled = YES;


}



-(void)createLabelWith:(UIColor *)color Font:(UIFont *)font WithSuper:(UIView *)superView Frame:(CGRect)frame Alignment:(NSTextAlignment)alignment Text:(NSString *)text{
    UILabel *myLabel = [[UILabel alloc] initWithFrame:frame];
    myLabel.textColor = color;
    myLabel.textAlignment = alignment;
    myLabel.text = text;
    myLabel.font = font;
    myLabel.numberOfLines = 0;
    myLabel.backgroundColor = [UIColor clearColor];
    [superView addSubview: myLabel];
    
}


#pragma - mark public method
- (void)showinView:(UIView *)view
{
    if (_isShow) return;
    
    _isShow = YES;
    
    [view addSubview:self];
    
    
    _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, 200);
    
    
    [UIView animateWithDuration:0.2 animations:^{
    
        if (iPhone5) {
            _bgView.center = CGPointMake(ScreenWidth/2, (ScreenHeight-64)/2);
            _bgView.bounds = CGRectMake(0, 0, 284, 396);

        }else{
            _bgView.center = CGPointMake(ScreenWidth/2, (ScreenHeight-64)/2);
            _bgView.bounds = CGRectMake(0, 0, 339, 450);
        }
        
    }];
}

- (void)dismiss
{
    
    if (!_isShow) return;
    
    _isShow = NO;
    
    
    [UIView animateWithDuration:0.2 animations:^{
        if (iPhone5) {
            _bgView.frame = CGRectMake(0, ScreenHeight, 284, 396);
            
        }else{
            _bgView.frame = CGRectMake(0, ScreenHeight, 339, 450);

        }

        _backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        _backButton.alpha = 0.3;
    }];
}

@end
