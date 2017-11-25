//
//  ParaMeterSelectCell.h
//  FyhNewProj
//
//  Created by yh f on 2017/11/1.
//  Copyright © 2017年 fyh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ParaMeterModel;

@interface ParaMeterSelectCell : UITableViewCell


@property (nonatomic,strong) UILabel         *nameLab;      //属性名称

@property (nonatomic,strong) UILabel         *valueLab;     //属性值

@property (nonatomic,strong) ParaMeterModel  *model;        //model

@property (nonatomic,strong) UIImageView     *rightImageView;   //右侧图片
@end
