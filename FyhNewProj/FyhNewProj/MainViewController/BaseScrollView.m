//
//  BaseScrollView.m
//  freeride
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 nixinyue. All rights reserved.
//

#import "BaseScrollView.h"

@implementation BaseScrollView



-(instancetype)init{
    
    self = [super init];
    if (self) {
        if (@available(iOS 11.0, *)) {
            self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    
    return self;
}

//防止影响侧滑
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (!_isSideScroll) return YES;
    
    CGFloat mainWidth = [UIScreen mainScreen].bounds.size.width;
    
    CGPoint velocity = [(UIPanGestureRecognizer *)gestureRecognizer velocityInView:self];
    CGPoint location = [gestureRecognizer locationInView:self];
    
    if (velocity.x > 0.0f&&(int)location.x%(int)mainWidth < 60 && self.contentOffset.x < mainWidth) {
        return NO;
    }
    
    return YES;
}

//-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
//{
//    if (gestureRecognizer.state != 0) {
//        return YES;
//    } else {
//        return NO;
//    }
//}

// 即使触摸到的是一个 UIControl (如子类：UIButton), 我们也希望拖动时能取消掉动作以便响应滚动动作
- (BOOL)touchesShouldCancelInContentView:(UIView *)view
{
    return YES;
}

@end
