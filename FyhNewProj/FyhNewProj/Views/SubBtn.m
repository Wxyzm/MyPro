//
//  SubBtn.m
//  Pindai
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 jytec. All rights reserved.
//  虎豹之驹虽未成纹，已有食牛之气

#import "SubBtn.h"
#import "ProjectMacro.h"
@implementation SubBtn

+ (id)buttonWithtitle:(NSString *)title backgroundColor:(UIColor *)backgroundcolor titlecolor:(UIColor *)titlcolor  cornerRadius:(CGFloat)cornerflot andtarget:(id)target action:(SEL)action{

    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titlcolor forState:UIControlStateNormal];
    button.backgroundColor = backgroundcolor;
    button.layer.cornerRadius = cornerflot;
    if (target) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    return button;
}

+ (id)buttonWithtitle:(NSString *)title  titlecolor:(UIColor *)titlcolor  cornerRadius:(CGFloat)cornerflot andtarget:(id)target action:(SEL)action andframe:(CGRect)frame{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.layer.cornerRadius = cornerflot;
    if (target) {
        [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    button.frame = frame;
    button.clipsToBounds = YES;
    //  创建 CAGradientLayer 对象
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    //  设置 gradientLayer 的 Frame
    gradientLayer.frame = button.bounds;
    //  gradientLayer.cornerRadius = 10;
    //  创建渐变色数组，需要转换为CGColor颜色
    gradientLayer.colors = @[(id)UIColorFromRGB(0xff2d66).CGColor,
                             (id)UIColorFromRGB(0xff4452).CGColor,
                             (id)UIColorFromRGB(0xff5d3b).CGColor];
    //  设置三种颜色变化点，取值范围 0.0~1.0
    gradientLayer.locations = @[@(0.1f) ,@(0.5f),@(1.0f)];
    
    //  设置渐变颜色方向，左上点为(0,0), 右下点为(1,1)
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1, 0);
    
    //  添加渐变色到创建的 UIView 上去
    [button.layer addSublayer:gradientLayer];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:titlcolor forState:UIControlStateNormal];

    return button;
}
@end
