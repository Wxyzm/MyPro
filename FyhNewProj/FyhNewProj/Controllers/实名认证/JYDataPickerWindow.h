//
//  JYDataPickerWindow.h
//  Pindai
//
//  Created by admin on 16/7/18.
//  Copyright © 2016年 jytec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JYDataPickerWindow;

@protocol JYDataPickerDelegate <NSObject>

- (void)DataPickerWindowbaocunBtnCilck;
- (void)DataPickerWindowtimebaocunBtnCilck;



@end

@interface JYDataPickerWindow : UIWindow

@property (strong, nonatomic) UIPickerView *picker;


@property (nonatomic,assign) id<JYDataPickerDelegate>delegate;


@property (strong, nonatomic, readonly) NSString *selectedYear;
@property (strong, nonatomic, readonly) NSString *selectedMonth;
@property (strong, nonatomic, readonly) NSString *selectedDay;


@property(assign, nonatomic) NSInteger yearIndex;
@property(assign, nonatomic) NSInteger mouthIndex;
@property(assign, nonatomic) NSInteger dateIndex;
//@property(assign, nonatomic) NSInteger timeIndex;


@property (nonatomic,strong) UILabel *dateLab;
@property (nonatomic,strong) UILabel *timeLab;


- (void)show;

- (void)cancelPicker;


@end
