//
//  BaseScrollView.h
//  freeride
//
//  Created by apple on 16/2/24.
//  Copyright © 2016年 nixinyue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseScrollView : UIScrollView

@property (nonatomic, assign) BOOL  isSideScroll;  //防止scroll滑动影响侧滑返回 默认NO

@end
