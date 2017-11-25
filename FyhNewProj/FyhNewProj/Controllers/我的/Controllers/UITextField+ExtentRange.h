//
//  UITextField+ExtentRange.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (ExtentRange)

- (NSRange)selectedRange;

- (void)setSelectedRange:(NSRange)range;

@end
