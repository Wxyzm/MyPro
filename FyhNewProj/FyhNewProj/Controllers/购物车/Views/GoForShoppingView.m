//
//  GoForShoppingView.m
//  FyhNewProj
//
//  Created by yh f on 2017/4/17.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import "GoForShoppingView.h"

@implementation GoForShoppingView

-(instancetype)initWithFrame:(CGRect)frame{

    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = UIColorFromRGB(PlaColorValue);
        [self setup];
    }

    return self;
}

- (void)setup{
    UIImageView *cartView = [BaseViewFactory icomWithWidth:111 imagePath:@"cart-empty"];
    cartView.frame = CGRectMake(ScreenWidth/2-55.5, ScreenHeight/2-88-64-60, 111, 88);
    [self addSubview:cartView];
    
    UILabel *emptyLab = [BaseViewFactory labelWithFrame:CGRectMake(0, ScreenHeight/2+10-64-60, ScreenWidth, 16) textColor:UIColorFromRGB(BlackColorValue) font:APPFONT(15) textAligment:NSTextAlignmentCenter andtext:@"您的购物车是空的"];
    [self addSubview:emptyLab];
    
    _goBtn = [SubBtn buttonWithtitle:@"去逛逛" titlecolor:UIColorFromRGB(WhiteColorValue) cornerRadius:5 andtarget:nil action:nil andframe:CGRectMake(20, ScreenHeight/2+60-64-60, ScreenWidth - 40, 50)];
    [self addSubview:_goBtn];
    
    
}


@end
