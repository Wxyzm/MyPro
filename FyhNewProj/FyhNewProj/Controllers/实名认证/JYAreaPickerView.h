//
//  JYAreaPickerView.h
//  JYAreaPickerView
//
//  Created by nixinyue on 14-8-13.
//  Copyright (c) 2014年 nixinyue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JYLocation.h"
#define AreaWithBuXian     10
#define AreaNoBuXian       20
#define AreaNoAreas        30

@class JYAreaPickerView;

@protocol JYAreaPickerDelegate <NSObject>

@optional
//代理
- (void)pickerDidChaneStatus:(JYAreaPickerView *)picker;
- (void)finishPickingLocation:(JYAreaPickerView *)picker;

@end

@interface JYAreaPickerView : UIView

@property (assign, nonatomic) id <JYAreaPickerDelegate> delegate;
@property (strong, nonatomic) JYLocation *locate;//地区数据类
@property (strong, nonatomic) UIPickerView *areaPicker;
@property (assign, nonatomic) NSInteger type;
@property (strong, nonatomic) NSMutableArray *provinces;
@property (strong, nonatomic) NSMutableArray *cities;
@property (strong, nonatomic) NSMutableArray *areas;

@property(assign, nonatomic) NSInteger provinceIndex;
@property(assign, nonatomic) NSInteger cityIndex;
@property(assign, nonatomic) NSInteger districtIndex;
@property(assign, nonatomic) int numberOfComponents;

- (id)initWithFrame:(CGRect)frame type:(NSInteger)type;
- (id)initWithFrame:(CGRect)frame type:(NSInteger)type includeContory:(BOOL)includeContory;

- (void)showInView:(UIView *) view;
- (void)cancelPicker;
- (void)selectRowOf:(NSString*)province city:(NSString*)city district:(NSString*)district;

@end
