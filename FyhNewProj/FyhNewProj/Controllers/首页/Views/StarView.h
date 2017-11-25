//
//  StarView.h
//  FyhNewProj
//
//  Created by yh f on 2017/9/25.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StarView : UIView<UIScrollViewDelegate>
{
    UIPageControl *pageControl;
}


- (id)init;

- (void)showWinView;

- (void)dismissCurrentWindow;


@end
