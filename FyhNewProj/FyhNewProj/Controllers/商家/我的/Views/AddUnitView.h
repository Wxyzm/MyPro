//
//  AddUnitView.h
//  FyhNewProj
//
//  Created by yh f on 2017/6/13.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol AddUnitViewDelegate <NSObject>


- (void)didSelectedaddkindBtnwithtext:(NSString *)text;

- (void)didSelectedaddunitBtnwithtext:(NSString *)text;


@end

@interface AddUnitView : UIView

//@property (nonatomic, strong) UIViewController *baseVC;

@property (nonatomic , strong) UITextField  *unitTxt;

@property (nonatomic, assign) id<AddUnitViewDelegate>delegate;

@property (nonatomic , assign) NSInteger type;


- (void)showinView:(UIView *)view;
- (void)dismiss;

@end
