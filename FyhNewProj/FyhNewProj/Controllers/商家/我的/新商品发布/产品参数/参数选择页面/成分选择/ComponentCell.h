//
//  ComponentCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/8.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>

#define COMPENTVALUE  @"chenfenValue"

#define COMPENTUNIT   @"chenfenunit"

@class ParaMeterModel;

@interface ComponentCell : UITableViewCell

@property (nonatomic,strong) UILabel         *nameLab;      //属性名称

@property (nonatomic,strong) UITextField     *valueTxt;     //属性值

@property (nonatomic,strong) UILabel         *unitLab;     //单位

@property (nonatomic,strong) ParaMeterModel  *model;        //model


- (void)setModel:(ParaMeterModel *)model andIndex:(NSInteger)index;

@end
