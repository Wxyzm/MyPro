//
//  MakeSureSentView.h
//  FyhNewProj
//
//  Created by yh f on 2017/7/18.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SellerOrderModel;

@protocol MakeSureSentViewDelegate <NSObject>

- (void)DidSelectedMakeSureSentViewMakeSureBtnWithModel:(SellerOrderModel*)model;

@end

@interface MakeSureSentView : UIView

@property (nonatomic , strong) SellerOrderModel *model;

@property (nonatomic , assign) id<MakeSureSentViewDelegate> delegate;

@property (nonatomic , strong) UITextField *traNametxt;

@property (nonatomic , strong) UITextField *traNumbertxt;


- (void)showinView:(UIView *)view;
- (void)dismiss;

@end
