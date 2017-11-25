//
//  ParameterView.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/22.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParameterView : UIView

@property (nonatomic , strong) NSArray  *dataArr;

- (void)showinView:(UIView *)view;
- (void)dismiss;

@end
