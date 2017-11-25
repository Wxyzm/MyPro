//
//  SubBtn.h
//  Pindai
//
//  Created by apple on 16/4/7.
//  Copyright © 2016年 jytec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubBtn : UIButton

+ (id)buttonWithtitle:(NSString *)title backgroundColor:(UIColor *)backgroundcolor titlecolor:(UIColor *)titlcolor cornerRadius:(CGFloat)cornerflot andtarget:(id)target action:(SEL)action;

+ (id)buttonWithtitle:(NSString *)title titlecolor:(UIColor *)titlcolor  cornerRadius:(CGFloat)cornerflot andtarget:(id)target action:(SEL)action andframe:(CGRect)frame;


@end
