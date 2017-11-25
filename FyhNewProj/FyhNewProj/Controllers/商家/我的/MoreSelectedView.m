//
//  MoreSelectedView.m
//  FyhNewProj
//
//  Created by yh f on 2017/7/15.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "MoreSelectedView.h"

@interface MoreSelectedView()

@property (nonatomic, strong) UIButton      *backButton;

@property (nonatomic , strong) UIView       *selectedView;

@end

@implementation MoreSelectedView{
    
    BOOL        _isShow;
    NSMutableArray  *_btnArr;
    
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:self.bounds];
        _backButton.backgroundColor = [UIColor clearColor];
        [_backButton addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}
#pragma mark ========= init
-(instancetype)init{
    if (self = [super init]) {
        self.frame = CGRectMake(0, 40, ScreenWidth, ScreenHeight);
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        _btnArr = [NSMutableArray arrayWithCapacity:0];
        [self setUp];
    }
    return self;
    
}
- (void)setUp{
    [self addSubview:self.backButton];

    _selectedView = [BaseViewFactory viewWithFrame:CGRectMake(ScreenWidth/5*4, -200, ScreenWidth/5, 120) color:UIColorFromRGB(WhiteColorValue)];
    _selectedView.layer.borderWidth = 1;
    _selectedView.layer.borderColor = UIColorFromRGB(PlaColorValue).CGColor;
    [self addSubview:_selectedView];

    UIView *line1 = [BaseViewFactory viewWithFrame:CGRectMake(0, 39.5, ScreenWidth/5, 1) color:UIColorFromRGB(PlaColorValue)];
    [_selectedView addSubview:line1];
    UIView *line2 = [BaseViewFactory viewWithFrame:CGRectMake(0, 79.5, ScreenWidth/5, 1) color:UIColorFromRGB(PlaColorValue)];
    [_selectedView addSubview:line2];

    
    _sentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _sentBtn.frame = CGRectMake(0, 0, ScreenWidth/5, 40);
    [_sentBtn setTitle:@"已发货" forState:UIControlStateNormal];
    [_sentBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_selectedView addSubview:_sentBtn];
    _sentBtn.titleLabel.font = APPFONT(13);

    _comBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _comBtn.frame = CGRectMake(0, 40, ScreenWidth/5, 40);
    [_comBtn setTitle:@"已完成" forState:UIControlStateNormal];
    [_comBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_selectedView addSubview:_comBtn];
    _comBtn.titleLabel.font = APPFONT(13);

    _closeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _closeBtn.frame = CGRectMake(0, 80, ScreenWidth/5, 40);
    [_closeBtn setTitle:@"已关闭" forState:UIControlStateNormal];
    [_closeBtn setTitleColor:UIColorFromRGB(BlackColorValue) forState:UIControlStateNormal];
    [_selectedView addSubview:_closeBtn];
    _closeBtn.titleLabel.font = APPFONT(13);

}
- (void)showinView:(UIView *)view
{
    if (_isShow) return;
    
    _isShow = YES;
    
    [view addSubview:self];
    _selectedView.frame = CGRectMake(ScreenWidth/5*4, -150, ScreenWidth/5, 120);
    
    
    [UIView animateWithDuration:0.2 animations:^{
        _selectedView.frame = CGRectMake(ScreenWidth/5*4, 0, ScreenWidth/5, 120);
        
    }];
}

- (void)dismiss
{
    if (!_isShow) return;
    
    _isShow = NO;
    
    //CGFloat duration = 0.4 * (ScreenWidth - _sideView.frame.origin.x)/_sideView.frame.size.width;
    
    [UIView animateWithDuration:0.2 animations:^{
        _selectedView.frame = CGRectMake(ScreenWidth/5*4, -150, ScreenWidth/5, 120);
        //_backButton.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        //_backButton.alpha = 0.3;
    }];
}


@end
