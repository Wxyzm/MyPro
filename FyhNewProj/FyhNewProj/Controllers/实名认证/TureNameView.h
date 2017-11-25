//
//  TureNameView.h
//  FyhNewProj
//
//  Created by yh f on 2017/8/3.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TureNameView : UIView

@property (nonatomic , strong) SubBtn *personBtn;

@property (nonatomic , strong) SubBtn *BussBtn;

- (void)showinView:(UIView *)view;
- (void)dismiss;
@end
