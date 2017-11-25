//
//  ShopTypeView.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/10.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ShopTypeViewDelegate <NSObject>

@optional
//代理
- (void)didSelectedcancelPickerBtn;

- (void)didSelectedtableviewRow:(NSInteger)index;

- (void)didSelectedunitRow:(NSInteger)index;


@end


@interface ShopTypeView : UIView

@property (nonatomic , assign)  id <ShopTypeViewDelegate> delegate;

@property (nonatomic , strong) NSMutableArray *dataArr;

@property (nonatomic , assign) NSInteger  shoptype;
@property (nonatomic , copy) NSString  *nameStr;


- (void)showInView:(UIView *) view;

- (void)cancelPicker;

- (void)UserWantshowInView:(UIView *)view withFrame:(CGRect )frame;

- (void)UserWantcancelPicker;

@end
