//
//  OfferView.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/19.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OfferViewDelegate <NSObject>


- (void)didSelectedsubmitBtn;

@end


@interface OfferView : UIView

@property (nonatomic , strong) UILabel      *unitLabl;      //规格lab


@property (nonatomic, strong) UIViewController *baseVC;

@property (nonatomic , strong) UITextField  *moneyTxt;

@property (nonatomic , strong) UITextView   *remarkTxt;

@property (nonatomic, assign) id<OfferViewDelegate>delegate;

- (void)showinView:(UIView *)view;
- (void)dismiss;

- (void)setthetxtpLa:(NSString *)str;

@end
