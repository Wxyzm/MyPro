//
//  AdressPickerView.h
//  FyhNewProj
//
//  Created by yh f on 2017/5/4.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AdressPickerView;


@protocol AdressPickerDelegate <NSObject>

//代理
- (void)pickerDidChaneStatus:(AdressPickerView *)picker;
- (void)finishPickingLocation:(AdressPickerView *)picker;

@end



@interface AdressPickerView : UIView
@property (assign, nonatomic) id <AdressPickerDelegate> delegate;

@property (strong, nonatomic) UIPickerView *areaPicker;

@property (strong, nonatomic) NSMutableArray *provinces;
@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) NSMutableArray *areas;

@property (nonatomic , strong) NSDictionary *provinceDic;
@property (nonatomic , strong) NSDictionary *cityDic;
@property (nonatomic , strong) NSDictionary *areaDic;


@property(assign, nonatomic) NSInteger provinceIndex;
@property(assign, nonatomic) NSInteger cityIndex;
@property(assign, nonatomic) NSInteger districtIndex;

- (void)showInView:(UIView *) view;
- (void)cancelPicker;

@end
